# Kasaneru — CSV テンプレート

`dock.html` の **設定 → Data → CSV 種別** で対象を選び、**書き出し**で列見本付きファイルが得られます。ここにある `.template.csv` はリスト系の空入力行付きサンプルです。**UI・見た目**はドックの書き出し（`kasaneru-ui-settings.csv`）をテンプレにするのが確実です。

| ファイル | 列 |
|----------|-----|
| `kasaneru-chapters.template.csv` | group, title, subtitle |
| `kasaneru-titlecards.template.csv` | group, title, label, color, offsetX, offsetY |
| `kasaneru-images.template.csv` | group, name, path, scale, offsetX, offsetY, fit |
| `kasaneru-ui-settings.template.csv` | key, value |

- **fit**（画像のみ）: `default` / `fit` / `overflow`
- **path**: `overlay.html` からの相対パス、または `C:/...` 形式の絶対パス（`\\` も取り込み時に正規化されます）
- 文字コードは **UTF-8**（BOM 付き可）

詳細は [docs/CSV-TEMPLATES.md](../../docs/CSV-TEMPLATES.md) を参照してください。
