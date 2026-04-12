# Quality Audit Report — 2026-04-12

## Scope
Public kasaneru repo (TK2F/kasaneru) の全ファイルを対象にセキュリティ・品質・ユーザビリティの包括的監査を実施。

## Security: PASS

| Check | Result |
|-------|--------|
| .env / API keys / secrets | なし |
| 個人情報 (メール, Discord, Slack) | なし |
| 内部パス (/home/tk2lab, /mnt/c/, wsl$) | なし |
| HANDOFF/SESSION等の内部ドキュメント | 除外済み |
| Co-Authored-By (AI署名) | filter-branch で全削除済み |
| CLAUDE.md | 削除済み |

## Bugs Found & Fixed

| ID | Severity | File | Issue | Fix |
|----|----------|------|-------|-----|
| B1 | CRITICAL | APP-SPEC.md | 非公開アプリ3件 + 間違ったBC名2件 | 削除+修正 |
| B2 | CRITICAL | apps CSV template | ctrlUrl列欠落 + 非公開アプリ3行 | 16列に修正 |
| B3 | HIGH | images/manifest.js | 変数名 `IMAGE_MANIFEST` ≠ dock.html の `__LT_IMAGE_MANIFEST__` | 修正 |
| B4 | HIGH | images/manifest.json | `{"images":[]}` ≠ generator 出力 `{"version":1,"files":[]}` | 修正 |
| B5 | MEDIUM | CUSTOM-CSS-GUIDE.md | 存在しない `.ov-card::before` を記載 | 削除 |
| B6 | MEDIUM | hello-world.html | 無効な `<ctrl-btn>` カスタム要素 | `<button>` に修正 |
| B7 | LOW | CSV-TEMPLATES.md | Apps セクション完全欠落 | 追加 |

## Documentation Improvements

- README.md/en: 「もっとOBSを楽しむために」セクション新設
- README.md/en: 同梱アプリ使い方テーブル追加
- README.en.md: FAQ セクション追加
- OPERATION-GUIDE.md: 外部制御・キーボードに「開発中」注記
- Draw アプリ: preview-hint を JA/EN ステップバイステップに改善
- THIRD-PARTY-NOTICES.md: AI支援開発を明記

## External References: CLEAN

- 外部URL: GitHub (自プロジェクト) + OBS Forum (教育リンク) のみ
- 外部ライブラリ: なし (React, Tailwind, jQuery 等の痕跡ゼロ)
- クレジット: THIRD-PARTY-NOTICES.md で適切にカバー済み

## Recommendations (未実施)

1. CUSTOM-CSS-GUIDE の英語版作成
2. CSV export→import ラウンドトリップ自動テスト
3. Playwright による UI 自動テスト
4. OBS 実機テスト (v17-v21)
