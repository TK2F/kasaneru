#!/bin/bash
# verify-main.sh — Verify kasaneru main branch is clean for public release
#
# Run this on the main branch after cherry-picking commits, before pushing.
# The pre-push hook runs equivalent checks, but this gives earlier feedback.
#
# Usage:
#   git checkout main
#   git cherry-pick <sha>
#   bash internal/scripts/verify-main.sh   # (from dev worktree or stashed)
#   PUSH=1 PUSH_MAIN=1 git push origin main

set -euo pipefail

errors=0
warnings=0

echo "=== kasaneru main verification ==="
echo ""

# Check: correct branch
current_branch=$(git branch --show-current)
if [ "$current_branch" != "main" ]; then
  echo "WARN: Not on main branch (current: $current_branch)"
  warnings=$((warnings + 1))
fi

# Check 1: No internal/ files tracked
internal_files=$(git ls-tree -r --name-only HEAD | grep -E '^internal/' || true)
if [ -n "$internal_files" ]; then
  echo "FAIL [1/5]: internal/ files found in HEAD:"
  echo "$internal_files" | sed 's/^/  /'
  errors=$((errors + 1))
else
  echo "PASS [1/5]: No internal/ files"
fi

# Check 2: No CLAUDE.md tracked
if git ls-tree -r --name-only HEAD | grep -qE '^CLAUDE\.md$'; then
  echo "FAIL [2/5]: CLAUDE.md is tracked"
  errors=$((errors + 1))
else
  echo "PASS [2/5]: No CLAUDE.md"
fi

# Check 3: Strict .gitignore
if git show HEAD:.gitignore 2>/dev/null | grep -q '^CLAUDE\.md$'; then
  echo "PASS [3/5]: .gitignore is strict version"
else
  echo "FAIL [3/5]: .gitignore missing CLAUDE.md pattern (not strict version)"
  errors=$((errors + 1))
fi

# Check 4: No Co-Authored-By in recent commits
co_auth_count=$(git log origin/main..HEAD --format="%B" 2>/dev/null | grep -ci "co-authored-by" || true)
if [ "$co_auth_count" -gt 0 ] 2>/dev/null; then
  echo "FAIL [4/5]: Co-Authored-By found in $co_auth_count commit(s):"
  git log origin/main..HEAD --format="  %h %s" --grep="Co-Authored-By" -i 2>/dev/null
  errors=$((errors + 1))
else
  echo "PASS [4/5]: No Co-Authored-By in commits"
fi

# Check 5: No personal paths in tracked files
personal_hits=$(git ls-tree -r --name-only HEAD | xargs grep -rl '/home/tk2lab\|tsubasaoka' 2>/dev/null | head -5 || true)
if [ -n "$personal_hits" ]; then
  echo "FAIL [5/5]: Personal paths found:"
  echo "$personal_hits" | sed 's/^/  /'
  errors=$((errors + 1))
else
  echo "PASS [5/5]: No personal paths"
fi

echo ""
if [ $errors -gt 0 ]; then
  echo "=== FAILED: $errors check(s) failed ==="
  echo "Fix issues before pushing to main."
  exit 1
else
  echo "=== ALL CHECKS PASSED ==="
  if [ $warnings -gt 0 ]; then
    echo "($warnings warning(s) — review above)"
  fi
  echo ""
  echo "Ready to push:"
  echo "  PUSH=1 PUSH_MAIN=1 git push origin main"
  exit 0
fi
