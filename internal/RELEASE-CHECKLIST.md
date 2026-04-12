# Kasaneru Release Checklist

## Before merging dev → main

- [ ] `internal/` ディレクトリが main に入らないことを確認
- [ ] `CLAUDE.md`, `codex.md` が main に入らないことを確認
- [ ] main の `.gitignore` が strict 版であることを確認
- [ ] `git diff main..dev -- .gitignore` で差分を確認

## Security scan

- [ ] `grep -r "tk2lab\|tsuba\|okamura\|/home/" --include="*.md" --include="*.html"` — 個人情報なし
- [ ] `grep -r "Co-Authored-By" .git/` — AI 署名なし（コミットメッセージ）
- [ ] `.env`, `*.key`, `credentials.*` がリポに含まれない

## Quality checks

- [ ] APP-SPEC.md Section 9 のアプリ一覧が公開アプリのみ（7本）
- [ ] CSV テンプレートのヘッダーが dock.html の export と一致（16列）
- [ ] images/manifest.js の変数名が `window.__LT_IMAGE_MANIFEST__` であること
- [ ] JSON ファイルの構文チェック: `node -e "JSON.parse(require('fs').readFileSync('images/manifest.json','utf8'))"`
- [ ] README.md / README.en.md 内の全リンクが存在するファイルを指すこと

## Release

1. `git checkout main`
2. `git merge dev` (内部ドキュメントは .gitignore で除外されるため入らない)
   - **注意**: merge 後に `internal/` が含まれないか `git status` で確認
3. `git archive --format=zip --prefix=kasaneru/ -o kasaneru-vX.Y.Z.zip HEAD`
4. ZIP を展開して CLAUDE.md, CONTRIBUTING.md, internal/ が含まれないことを確認
5. `gh release create vX.Y.Z kasaneru-vX.Y.Z.zip --title "Kasaneru vX.Y.Z" --notes "..."`
6. `git push origin main`

## Post-release

- [ ] リリースページの ZIP をダウンロードして展開テスト
- [ ] OBS で dock.html / overlay.html を開いて基本動作確認
