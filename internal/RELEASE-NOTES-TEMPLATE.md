# Release Notes Template

Use this template when creating a new GitHub Release.

```markdown
## Kasaneru vX.Y.Z

一行の概要。

### 変更点
- **新機能**: ...
- **修正**: ...
- **改善**: ...

### 破壊的変更
- なし（または具体的な変更点）

### アップグレード方法
1. 新しい ZIP をダウンロードして展開
2. OBS の Browser Source で「キャッシュ更新」を実行
3. （必要に応じて）設定の移行手順

### 動作環境

| 環境 | ステータス |
|------|----------|
| Windows 11 + OBS 30.x | **動作確認済み** |
| macOS + OBS | 未検証 |
| Linux + OBS | 未検証 |

### 安定性

| 機能 | ステータス |
|------|----------|
| コア (チャプター / テロップカード / 画像) | 安定 |
| 同梱アプリ | 安定 |
| Draw (ラクガキ) | 安定（注釈永続化なし） |
| 外部制御 (WebSocket) | 実験的 |
| きせかえ (Skin) | 実験的 |

### 既知の制限
- [KNOWN-ISSUES.md](https://github.com/TK2F/kasaneru/blob/main/docs/KNOWN-ISSUES.md) を参照

### チェックサム

\```
SHA-256: <hash>  kasaneru-vX.Y.Z.zip
\```
```

## チェックサム生成手順

```bash
sha256sum kasaneru-vX.Y.Z.zip
```
