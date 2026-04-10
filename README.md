# Kasaneru

**OBS で使える、かんたんオーバーレイセット**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
![Version](https://img.shields.io/badge/Version-1.0.0-green.svg)

> **English summary below** — [Jump to English](#english)

---

## Kasaneru って何？

**Kasaneru**（重ねる）は、OBS Studio の配信画面に「重ねて」表示できるオーバーレイツールです。

- ビルド不要、インストール不要
- インターネット接続不要（完全オフライン動作）
- ZIP を展開して OBS に設定するだけで使えます

授業配信、勉強会の LT、TRPG オンラインセッション、ゲーム実況など、さまざまな場面で使えます。

---

## 動作確認環境

- **Windows 11** — 動作確認済み（OBS 30+）
- **macOS** — 未検証（コードレビューにより互換性を考慮していますが、実機テストは行っていません）
- **Linux** — 未検証（同上）

OBS の Browser Source は内部的に Chromium を使用しているため、基本的にはクロスプラットフォームで動作するはずですが、上記未検証環境で問題が見つかった場合は [Issue](../../issues) でお知らせください。

---

## 同梱アプリ

| アプリ | 説明 |
|--------|------|
| **タイマー** | カウントダウン・カウントアップタイマー |
| **時計** | デジタル時計（タイムゾーン変更可） |
| **ミュージックプレイヤー** | BGM 再生（プレイリスト・お気に入り対応） |
| **ルーレット** | ホイール＆リール式ルーレット |
| **ラクガキ Draw** | 画面への書き込み・注釈ツール（ペン・図形・ピン・テキスト） |
| **バナー** | スクロール・固定テキストバナー |
| **TRPG ダイス** | 多面体ダイス（d4〜d100）・じゃんけん機能付き |

---

## セットアップ

### 1. ダウンロード

[Releases ページ](../../releases) から最新の `kasaneru-v*.zip` をダウンロードし、お好きな場所に展開してください。

### 2. OBS にドックを追加

1. OBS を開く
2. **表示 → ドック → カスタムブラウザドック**
3. ドック名に「Kasaneru」と入力
4. URL に `file:///C:/.../kasaneru/dock.html`（展開した場所の実際のパスに置き換え）
5. **適用** → OBS を再起動

### 3. OBS に Browser Source を追加

1. ソース欄の **＋ → ブラウザ** をクリック
2. **「ローカルファイル」のチェックを外す**（重要）
3. URL に `file:///C:/.../kasaneru/overlay.html`
4. 幅: **1920**、高さ: **1080**
5. カスタム CSS に以下を入力:
   ```
   body{background-color:rgba(0,0,0,0)!important;}
   ```

### 注意点

- ドックと Browser Source の URL は **同じフォルダ** を指すようにしてください
- **「ローカルファイル」のチェックは必ず外してください**（BroadcastChannel 通信に必要です）
- 設定変更が反映されない場合は、Browser Source のプロパティで **キャッシュを更新** してください

---

## 使い方（かんたんガイド）

### チャプター

配信の進行を区切るカード。タイトルとサブタイトルを設定して、表示ボタンで切り替えます。

### テロップカード

画面下部に表示されるテロップ。発表者名やトピック名の表示に。

### 画像

`images/` フォルダに画像を入れ、ドックから追加。スライド資料の表示などに使えます。

### アプリ

ドックの「Apps」タブからアプリを追加。URL には `apps/timer.html` のようにアプリの相対パスを入力します。

### ミュージックプレイヤー

自分の音楽ファイルをプレイリストに追加して BGM として流せます。ファイルパスは `file:///` 形式で指定するか、音楽ファイルを kasaneru フォルダ内に置いて相対パスで指定してください。

詳しい操作方法は [docs/OPERATION-GUIDE.md](docs/OPERATION-GUIDE.md) を参照してください。

---

## カスタマイズ

CSS でオーバーレイの見た目をカスタマイズできます。詳しくは [CUSTOM-CSS-GUIDE.md](CUSTOM-CSS-GUIDE.md) を参照してください。

---

## CSV インポート・エクスポート

チャプター・テロップカード・画像・設定を CSV で一括管理できます。Google スプレッドシートとの連携も可能です。テンプレートは `templates/csv/` にあります。

詳しくは [docs/CSV-TEMPLATES.md](docs/CSV-TEMPLATES.md) を参照してください。

---

## よくある質問

**Q: OBS に表示されません**
A: Browser Source の「ローカルファイル」のチェックが**外れている**ことを確認してください。URL が `file:///...` で始まっていることも確認してください。

**Q: 設定を変更したのに反映されません**
A: Browser Source のプロパティを開き、「キャッシュを更新」ボタンをクリックしてください。

**Q: ドックとオーバーレイが同期しません**
A: 両方の URL が同じフォルダを指していることを確認してください。「ローカルファイル」のチェックが外れていることも重要です。

**Q: macOS / Linux で動きますか？**
A: 未検証ですが、OBS の Browser Source は Chromium ベースなので動作する可能性が高いです。問題があれば Issue でお知らせください。

---

## トラブルシューティング

詳しくは [docs/OPERATION-GUIDE.md](docs/OPERATION-GUIDE.md) を参照してください。

---

## 既知の制限事項

- macOS / Linux は未検証です
- Draw アプリはタッチデバイス未対応です（マウス操作のみ）
- 詳しくは [docs/KNOWN-ISSUES.md](docs/KNOWN-ISSUES.md) を参照してください

---

## アプリを自作する

Kasaneru は独自のアプリを作って追加できます。テンプレートは `templates/app/hello-world.html` にあります。

開発仕様は [docs/APP-SPEC.md](docs/APP-SPEC.md) を参照してください。

---

## ライセンス

MIT License — 詳しくは [LICENSE](LICENSE) を参照してください。

### じゃんけん画像について

`apps/dice/images/` 内のじゃんけん画像（rock.png, paper.png, scissors.png）は **AI 生成画像** です。

- 著作権: TK2LAB
- 生成ツール: Google Flow (NanoBanana Pro モデル)
- ライセンス: MIT License に含まれます（自由に使用可能）

---

## クレジット

- 開発: **TK2LAB**
- 外部ライブラリ: なし（完全自己完結）
- 使用フォント: システムフォントのみ（フォントファイルは同梱していません）

詳しくは [THIRD-PARTY-NOTICES.md](THIRD-PARTY-NOTICES.md) を参照してください。

---

## Contributing

Issue や Pull Request を歓迎します。詳しくは [CONTRIBUTING.md](CONTRIBUTING.md) を参照してください。

---

## サポート / Support

Kasaneru が少しでもお役に立てれば嬉しいです。

TK2LAB では「学びを楽しみ、発見を共有する」をモットーに、ツールを作っています。
Kasaneru もそうした取り組みのひとつです。

もしこの活動に共感いただけたら、[GitHub Sponsors](https://github.com/sponsors/tk2f) で応援いただけると励みになります。

---

<a id="english"></a>

## English

**Kasaneru** is a lightweight overlay toolkit for OBS Studio. No build tools, no CDN, no internet connection required — just unzip and add to OBS.

### Features

- 7 built-in apps: Timer, Clock, Music Player, Roulette, Draw, Banner, TRPG Dice
- Chapter cards and title cards with animations
- Image display with positioning and layering
- CSV/JSON import and export
- Fully offline — works with `file://` protocol
- Customizable via CSS

### Quick Start

1. Download the latest release ZIP
2. Extract to any folder
3. In OBS: **View > Docks > Custom Browser Docks** → URL: `file:///path/to/kasaneru/dock.html`
4. Add Browser Source → uncheck "Local file" → URL: `file:///path/to/kasaneru/overlay.html` → 1920x1080

### Tested Environment

- Windows 11 (OBS 30+) — verified
- macOS / Linux — untested (should work via Chromium-based Browser Source)

### License

MIT License. See [LICENSE](LICENSE).
