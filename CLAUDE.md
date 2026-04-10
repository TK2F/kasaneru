# Kasaneru — Development Rules

## Project Overview
OBS Studio 用の配信オーバーレイランタイム。HTML ミニアプリ対応のインタラクティブ・オーバーレイ実行基盤。
- `dock.html` — 操作 UI（OBS カスタムブラウザドック）
- `overlay.html` — 配信映像表示（OBS Browser Source）
- `apps/` — ミニアプリ（各アプリは独立した HTML）

## Absolute Rules (dock.html / overlay.html)
- **ES5 構文のみ**: `var`, `function` 宣言のみ。`const/let`, アロー関数, テンプレートリテラル禁止
- **CDN 禁止**: Google Fonts 含む外部 URL 読み込み禁止。すべてローカル完結
- **`@import url('https://...')` 禁止**: OBS CEF でブロックされる
- **`backdrop-filter` 禁止**: OBS Browser Source 非対応
- **`prompt()` / `alert()` 禁止**: OBS CEF で動作しない。カスタムモーダルを使う
- **i18n キーは ja/en 両方同時追記**: 片方忘れが起きやすい

## Apps Rules (apps/*.html)
- **ES6+ 利用可**: アプリは iframe 内で動くので ES5 制約なし
- **React/Vue 等利用可**: バンドル済みなら何でも OK
- **CDN 禁止は同じ**: OBS CEF でブロックされるため
- **`background: transparent` 必須**: overlay 上で合成されるため
- **BroadcastChannel**: `lt_app_{appname}` で通信。try-catch で囲む
- **仕様書**: `docs/APP-SPEC.md` に従う

## Architecture
- BroadcastChannel API (`lt_chapter`) で dock / overlay 通信
- Apps の BC (`lt_app_*`) は同一プロセス内でのみ動作。プロセス間は postMessage relay chain で中継
- localStorage `lt_ch_v5` に状態永続化
- デフォルトスタイル（CSS 変数）+ Custom CSS で外観カスタマイズ

## Key Documents
- `docs/APP-SPEC.md` — アプリ開発仕様（外部開発者向け）
- `docs/SPEC.md` — 座標系・解像度・スコープ
- `docs/ARCHITECTURE.md` — 構成図・ビューポートスケール
- `docs/OPERATION-GUIDE.md` — 操作説明

## OBS CEF Known Constraints
- BroadcastChannel はプロセス間不通（dock と overlay は別プロセス）。アプリ間通信は postMessage relay chain
- `new URL()` は file:// UNC パスで壊れる。URL 操作は文字列置換で行う
- OBS Browser Source はキャッシュが強い。ファイル更新後は「プロパティ → キャッシュ更新」が必須
- overlay.html に配信画面用エラー表示を出さない（視聴者に見える）。console.warn のみ

## Commit Style
- 英語、変更の「なぜ」を 1-2 文で。ファイルごとの詳細は body
