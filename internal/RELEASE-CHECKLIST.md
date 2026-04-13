# Kasaneru Release Checklist

## Before promoting dev changes to main

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

1. 対象コミットを特定: `git log main..dev --oneline`
2. `git checkout main`
3. 公開対象のコミットを cherry-pick:
   ```
   git cherry-pick <sha1> <sha2> ...
   ```
   **NEVER run `git merge dev`** — internal/ と CLAUDE.md が main に漏洩する
   （.gitignore は tracked ファイルのマージを防げない）
4. 検証スクリプト実行:
   ```
   bash internal/scripts/verify-main.sh
   ```
   ※ スクリプトは dev にのみ存在。main checkout 前にコピーするか、
   dev worktree から実行: `git -C /path/to/dev-worktree show dev:internal/scripts/verify-main.sh | bash`
5. `git archive --format=zip --prefix=kasaneru/ -o kasaneru-vX.Y.Z.zip HEAD`
6. ZIP を展開して CLAUDE.md, CONTRIBUTING.md, internal/ が含まれないことを確認
7. `gh release create vX.Y.Z kasaneru-vX.Y.Z.zip --title "Kasaneru vX.Y.Z" --notes "..."`
8. `PUSH=1 PUSH_MAIN=1 git push origin main`
   （pre-push フックが自動で5項目チェックを実行）

## Post-release

- [ ] リリースページの ZIP をダウンロードして展開テスト
- [ ] OBS で dock.html / overlay.html を開いて基本動作確認
- [ ] `git checkout dev` に戻る
