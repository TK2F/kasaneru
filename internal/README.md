# Kasaneru Internal Documents

This directory exists only on the `dev` branch. It is **not** included in the public `main` branch or release ZIPs.

## Branch Strategy

| Branch | Purpose | Push target |
|--------|---------|-------------|
| `main` | Public release. GitHub Pages / ZIP download 向け | `origin/main` |
| `dev` | Development. 内部ドキュメント・実験的機能を含む | `origin/dev` |

### Workflow

1. 開発は `dev` で行う
2. 公開する変更のみ `main` に **cherry-pick** で反映
   ```
   git checkout main
   git cherry-pick <sha1> <sha2> ...
   ```
   **NEVER run `git merge dev`** — internal/ と CLAUDE.md が漏洩する
3. 検証: `bash internal/scripts/verify-main.sh`
4. リリース: `main` から `git archive` で ZIP 生成 → `gh release create`
5. Push: `PUSH=1 PUSH_MAIN=1 git push origin main`

### What goes where

| Content | Branch |
|---------|--------|
| dock.html / overlay.html / apps/ | both |
| docs/ (public specs) | both |
| internal/ | dev only |
| CLAUDE.md / codex.md | dev only |
| .gitignore (relaxed) | dev only |
| .gitignore (strict) | main only |

## Files in this directory

- `HANDOFF.md` — Session handoff and current execution state
- `RELEASE-CHECKLIST.md` — Steps for public release
- `AUDIT-REPORT-2026-04-12.md` — Quality audit findings
- `scripts/verify-main.sh` — Automated verification for main branch cleanliness
