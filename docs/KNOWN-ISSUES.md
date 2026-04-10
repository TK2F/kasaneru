# Kasaneru — Known Issues

> Version: 1.0.0
> Updated: 2026-04-11

## Platform

### macOS / Linux 未検証

macOS および Linux（非 WSL2）環境では実機テストを行っていません。OBS Browser Source は Chromium ベースのため基本的に動作するはずですが、以下の潜在リスクがあります：

- フォントのフォールバック差異（Windows 固有フォントに依存していないことは確認済み）
- `file://` プロトコルの挙動差異

問題が見つかった場合は Issue でご報告ください。

## Apps

### Draw: タッチデバイス未対応

Draw アプリは `mousedown` / `mousemove` / `mouseup` イベントのみ対応しています。タブレットやタッチスクリーンでは動作しません。将来バージョンで Pointer Events API への移行を検討しています。

### Roulette / Dice: メモリ管理 (PARTIAL)

Roulette と Dice アプリは、一部のイベントリスナーが描画ごとに再登録される実装があります。長時間の連続使用でメモリ使用量が増加する可能性があります。通常の使用（数時間程度）では問題ありません。

### Draw: 注釈データの永続化なし

Draw アプリの注釈データ（ストローク、テキスト、ピン等）は BroadcastChannel 経由でのみ同期されます。dock と overlay の両方を閉じるとデータが失われます。将来バージョンで localStorage への保存を検討しています。

## OBS CEF

### GPU コンポジタ ゴースト問題

OBS の Browser Source（CEF / Chromium Embedded Framework）では、透明背景上の DOM 要素を配置後に移動すると、初回配置位置にゴーストが残る既知の問題があります。これは OBS / CEF 側のバグです。

Kasaneru ではこの問題を回避するため、要素の移動ではなく「削除して再作成」するパターンを採用しています。

### BroadcastChannel のプロセス間制約

OBS では dock（カスタムブラウザドック）と overlay（Browser Source）が別プロセスで動作します。アプリの BroadcastChannel はプロセス間では通信できないため、postMessage を経由する relay chain パターンで通信しています。

## その他

### Canvas エクスポート機能なし

Draw アプリで描いた内容を画像として保存する機能はありません（OBS CEF ではファイルダウンロードが動作しないため）。OBS 側のスクリーンショット機能をご利用ください。

### Undo 機能の制限

Draw アプリでピンやテキストを削除した場合、Undo（元に戻す）はできません。ストロークの Undo は対応しています。
