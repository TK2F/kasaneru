# カスタムCSS作成ガイド

Kasaneru のデザインを独自CSSでカスタマイズする方法を解説します。

---

## Dock（操作画面）と Overlay（配信映像）の違い

| 対象 | ファイル | スタイルの入れ方 |
|------|-----------|------------------|
| **配信にのるオーバーレイ** | `overlay.html` | Settings の Extra CSS / User styles（`<link href="…">` で読込）。レイアウトのルートは **`#lt-stage`（1920×1080 論理）** で、OBS の Browser Source 解像度に合わせ JS が **scale** します。 |
| **OBS ドックの操作 UI** | `dock.html` | 基本は `dock.html` 内の `<style>`。ブランド用に `--dock-acc`（JS で上書き）や `body.dock-light` 等 |

ストリーム用 **アクセント**（`s-accent`）と、ドックだけ変えたい **ドック強調色**（Settings → 外観）は別設定です。CSS の `:root { --acc }` は **overlay 側**のチャプター/テロップカードの見た目に効きます。

---

## カスタムCSSファイルの作成

### 手順
1. overlay.html と同じフォルダ、またはサブフォルダにCSSファイルを作成（例: `custom/override.css`）
2. dock.html の Settings → Theme & Colors → **Extra CSS** にファイルパスを入力（overlay.html からの相対パス）
3. または **User styles** → **Add path** で複数のCSSファイルを追加

### CSSファイルの構造

```css
/* custom/mytheme.css */

/* ── CSS変数でカラーパレットを上書き ── */
:root {
  --acc:      #ff6600;                /* アクセントカラー（バッジ、左バー、pips） */
  --card-bg:  rgba(20, 10, 0, 0.90);  /* カード背景色 */
  --text:     #ffffff;                /* タイトルテキスト色 */
  --sub:      rgba(255,255,255,0.5);  /* サブテキスト色 */
  --bar-w:    4px;                    /* 左バーの幅 */
  --pip-done: rgba(255,102,0,0.50);   /* 完了pipの色 */
  --pip-cur:  #ff6600;                /* 現在pipの色 */
}

/* ── バッジ（CH.1 表示部分） ── */
.ov-badge-tag {
  font-family: system-ui, sans-serif;
  font-size: 14px;
  font-weight: 800;
  letter-spacing: 0.15em;
  color: #fff;
  background: var(--acc);      /* 背景色付きバッジ */
  /* background: transparent;  背景なしの場合 */
  border: none;                /* border: 1px solid var(--acc); 枠線の場合 */
  padding: 4px 12px;
}

/* ── チャプターカード本体 ── */
.ov-card {
  background: var(--card-bg);
  border-left: var(--bar-w) solid var(--acc);
  padding: 20px 36px 18px 20px;
  /* box-shadow: 0 0 20px rgba(255,102,0,0.2); グロー効果 */
}

/* スキャンライン等のオーバーレイ（不要なら display:none） */
.ov-card::before { display: none; }

/* ── タイトル ── */
.ov-title {
  font-family: system-ui, sans-serif;
  font-size: 48px;
  font-weight: 900;
  color: var(--text);
  line-height: 1.2;
  /* text-shadow: 0 0 10px rgba(255,102,0,0.3); グロー */
}

/* ── サブタイトル ── */
.ov-sub {
  font-family: system-ui, sans-serif;
  font-size: 28px;
  font-weight: 400;
  color: var(--sub);
  margin-top: 8px;
}
```

### 利用可能なセレクタ一覧

| セレクタ | 要素 | 説明 |
|---|---|---|
| `.ov-badge-tag` | span | チャプター番号（CH.1等） |
| `.ov-card` | div | チャプターカード本体（背景・左バー付き） |
| `.ov-card::before` | pseudo | オーバーレイ効果用 |
| `.ov-title` | div | タイトルテキスト |
| `.ov-sub` | div | サブタイトルテキスト |
| `.ov-badge-wrap` | div | バッジ行全体のコンテナ |
| `.ov-badge-num` | span | 「1/5」等のカウンター |
| `.ov-pips` | span | 進行ドットのコンテナ |
| `.ov-pip` | span | 個別の進行ドット |
| `.ov-pip.done` | span | 完了済みのドット |
| `.ov-pip.cur` | span | 現在のドット |
| `.tc-card` | div | テロップカード本体 |
| `.tc-label-tag` | div | テロップカードラベル |
| `.tc-title` | div | テロップカードタイトル |

### CSS変数一覧

| 変数 | 用途 | デフォルト |
|---|---|---|
| `--acc` | アクセントカラー | `#e8002d` |
| `--card-bg` | カード背景 | `rgba(8,8,16,0.92)` |
| `--text` | テキスト色 | `#ffffff` |
| `--sub` | サブテキスト色 | `rgba(255,255,255,0.42)` |
| `--bar-w` | 左バー幅 | `4px` |
| `--pip-done` | 完了pip色 | `rgba(232,0,45,0.50)` |
| `--pip-cur` | 現在pip色 | `#e8002d` |

---

## OBS Browser Source のカスタムCSS

OBS の Browser Source 設定にある「カスタムCSS」欄に直接CSSを書く方法。

### 利点
- ファイルを編集せずにOBS側で完結
- テスト・調整が容易

### 注意点
- 透過背景の設定は維持すること: `body{background-color:rgba(0,0,0,0)!important;}`
- 追記例:
```css
body{background-color:rgba(0,0,0,0)!important;}
.ov-title{font-size:60px!important;color:#ffcc00!important;}
.ov-card{border-left-width:6px!important;}
```

---

## デザインTips

### フォント
- OBS CEFではCDNフォントが読み込めないため、**システムフォント**または**ローカルインストール済みフォント**のみ使用可能
- Windows標準: system-ui, 'Segoe UI', 'Yu Gothic UI', 'Meiryo', 'BIZ UDPGothic'
- ローカルインストール推奨: 'Noto Sans JP', 'M PLUS 1p', 'M PLUS Rounded 1c'

### パフォーマンス
- `backdrop-filter` はOBS Browser Sourceで非対応の場合あり（避ける）
- アニメーションは `transform` と `opacity` のみ使用（GPU accelerated）
- `box-shadow` は控えめに

### 配信映えのコツ
- タイトルはフォントサイズ48px以上で視認性確保
- サブタイトルは28px前後で階層感を出す
- 背景の透過度は0.85〜0.95が読みやすい
- コントラスト比4.5:1以上を目安に
- 左バーの色でテーマの印象が決まる
