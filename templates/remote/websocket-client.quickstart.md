# WebSocket Client Quickstart

## 1) Start dock with remote params

```text
file:///C:/.../kasaneru/dock.html?remoteWs=ws://127.0.0.1:9099&remoteEnabled=true&remoteToken=YOUR_TOKEN
```

## 2) Send test command from your client

```json
{
  "cmd": "control",
  "action": "chapter_next",
  "token": "YOUR_TOKEN",
  "requestId": "test-001"
}
```

## 3) Expect ACK

```json
{
  "cmd": "ack",
  "requestId": "test-001",
  "ok": true,
  "action": "chapter_next"
}
```

## Notes

- If token is configured in dock, token mismatch messages are ignored.
- Keep the WebSocket server local/LAN only for production safety.
