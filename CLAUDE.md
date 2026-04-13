# Kasaneru — Development Rules (dev branch only)

## Branch Strategy
- **main**: 公開用。`internal/`, `CLAUDE.md`, `codex.md` を含まない
- **dev**: 開発用。内部ドキュメント・AI設定を含む
- **dev を main に直接 merge しない** — tracked file (`internal/`, `CLAUDE.md`, 緩い `.gitignore`) が公開リポに漏洩する。`.gitignore` は tracked ファイルのマージを防げない
- main への変更は **cherry-pick のみ**。merge 前に `internal/scripts/verify-main.sh` で検証
- main へのマージ前に `internal/RELEASE-CHECKLIST.md` を確認

## Project Overview
OBS Studio 用の配信オーバーレイランタイム。HTML ミニアプリ対応。
- `dock.html` — 操作 UI（OBS カスタムブラウザドック）
- `overlay.html` — 配信映像表示（OBS Browser Source）
- `apps/` — ミニアプリ（各アプリは独立した HTML）

## Absolute Rules (dock.html / overlay.html)
- **ES5 構文のみ**: `var`, `function` 宣言のみ。`const/let`, アロー関数, テンプレートリテラル禁止
- **CDN 禁止**: Google Fonts 含む外部 URL 読み込み禁止。すべてローカル完結
- **`backdrop-filter` 禁止**: OBS Browser Source 非対応
- **`prompt()` / `alert()` 禁止**: OBS CEF で動作しない
- **i18n キーは ja/en 両方同時追記**

## Apps Rules (apps/*.html)
- **ES6+ 利用可**: アプリは iframe 内で動くので ES5 制約なし
- **CDN 禁止は同じ**: OBS CEF でブロックされるため
- **`background: transparent` 必須**: overlay 上で合成されるため

## Public Release Guards
- main ブランチの `.gitignore` は strict 版（CLAUDE.md, HANDOFF.md 等をブロック）
- コミットに `Co-Authored-By` を含めない（公開リポ）
- `internal/` ディレクトリは main に入れない
- 公開前に `internal/RELEASE-CHECKLIST.md` を実行

## OBS CEF Known Constraints
- BroadcastChannel はプロセス間不通。アプリ間通信は postMessage relay chain
- `new URL()` は file:// UNC パスで壊れる。URL 操作は文字列置換
- OBS Browser Source はキャッシュが強い。「プロパティ → キャッシュ更新」必須
- overlay.html にエラー表示を出さない（視聴者に見える）

## Key Documents
- `internal/HANDOFF.md` — セッション引き継ぎ
- `internal/RELEASE-CHECKLIST.md` — リリース手順
- `internal/scripts/verify-main.sh` — main ブランチ検証スクリプト
- `internal/AUDIT-REPORT-2026-04-12.md` — 品質監査結果
- `docs/APP-SPEC.md` — アプリ開発仕様（公開）
- `docs/ARCHITECTURE.md` — 構成図（公開）

## Commit Style
- 英語、変更の「なぜ」を 1-2 文で
- **Co-Authored-By を含めない**（公開リポのため）
