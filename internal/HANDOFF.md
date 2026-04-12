# Kasaneru Public Repo — HANDOFF

Last updated: 2026-04-12 (post-audit release)

## Current State

- **GitHub**: https://github.com/TK2F/kasaneru (currently **private**)
- **Release**: v1.0.0 — https://github.com/TK2F/kasaneru/releases/tag/v1.0.0
- **Branch**: `main` (public clean) / `dev` (development + internal docs)
- **Source**: `/home/tk2lab/code/kasaneru/`

## Relationship to lt-overlay

| Repo | Path | Purpose |
|------|------|---------|
| `lt-overlay` | `/home/tk2lab/code/lt-overlay/` | Private development — full history, all 11 apps, internal docs |
| `kasaneru` | `/home/tk2lab/code/kasaneru/` | Public release — clean copy, 7 public apps only |

### Internal protocol IDs (intentionally NOT renamed)
- `lt_chapter` (BroadcastChannel)
- `lt_app_*` (app BroadcastChannel)
- `lt_ch_v5` (localStorage key)
- `lt_overlay_config` / `lt_overlay_control` (postMessage commands)

## Session 2026-04-12 — Quality Audit & Release Fixes

### What was done

**Security & Privacy:**
- Removed `Co-Authored-By: Claude Opus 4.6` from all 4 git commit messages (filter-branch + force push)
- Deleted `CLAUDE.md` from public repo
- Deleted `CONTRIBUTING.md` (not ready for external contributors)
- Verified: no .env, personal paths, API keys, or internal logs in repo

**Documentation Fixes:**
- Removed "offline / no install" claims (confusing for beginners since OBS streaming is online)
- Removed Contributing sections from both JA/EN READMEs
- Added "Going Further with OBS" section: CSS customization, mini app dev, OBS plugin exploration
- Added bundled app usage guide (JA/EN table format)
- Added FAQ section to English README
- Added experimental/development notices to WebSocket control and keyboard shortcuts

**Bug Fixes (found in audit):**
- APP-SPEC.md Section 9: removed 3 non-public apps, fixed 2 wrong BroadcastChannel names (banner→lt_app_nagashi, roulette→lt_app_kurukuru)
- apps CSV template: added missing ctrlUrl column, removed non-public apps
- images/manifest.js: `var IMAGE_MANIFEST` → `window.__LT_IMAGE_MANIFEST__` (matching dock.html parser)
- images/manifest.json: `{"images":[]}` → `{"version":1,"files":[]}` (matching generator script)
- CUSTOM-CSS-GUIDE.md: removed non-existent `.ov-card::before` pseudo-element
- hello-world.html: `<ctrl-btn>` → `<button>` (invalid custom element)
- CSV-TEMPLATES.md: added missing Apps section with ctrlUrl docs

**Wording:**
- THIRD-PARTY-NOTICES.md: acknowledged AI-assisted development (Claude Code, Codex, Gemini CLI)
- Credits: "なし（完全自己完結）" → "なし"
- Support section: rewritten in natural, personal tone

**Infrastructure:**
- `.gitignore`: added guards against CLAUDE.md, CODEX.md, HANDOFF.md, SESSION*.md, etc.
- Created `dev` branch with relaxed .gitignore for internal docs
- ZIP and GitHub Release regenerated and replaced multiple times during session

### Learnings

1. **AI Co-Authored-By in public repos**: git filter-branch is effective for removal but requires force push. Decide upfront whether to include AI attribution.
2. **"Offline" claims are misleading**: OBS streaming is inherently online. Saying "offline capable" confuses beginners who think they need internet for OBS.
3. **BroadcastChannel names drift from docs**: banner uses `lt_app_nagashi`, roulette uses `lt_app_kurukuru` — internal naming conventions don't match app file names. Document actual values, not assumed ones.
4. **CSV template round-trip testing**: The apps CSV template was missing ctrlUrl for 7+ sessions. Automated export→import round-trip tests would catch this.
5. **Image manifest format mismatch**: The committed stub files didn't match the generator script output. Keep stubs generated, not hand-written.
6. **Contributing readiness**: Don't add CONTRIBUTING.md until you can actually review PRs in a reasonable timeframe.

## Next Steps

- [ ] Make repo public when ready
- [ ] OBS 実機テスト (v17-v21 の全変更)
- [ ] テスト自動化 (Playwright)
- [ ] CUSTOM-CSS-GUIDE 英語版
