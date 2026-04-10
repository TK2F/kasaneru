# Remote Control Templates

This folder contains ready-to-use payload samples for external control clients such as Stream Deck + Bitfocus Companion.

## Files

- `companion-actions.sample.json`
  - Action presets mapped to `dock.html` WebSocket control messages.
- `websocket-client.quickstart.md`
  - Minimal setup and test flow.

## Target protocol

See:

- `docs/ARCHITECTURE.md`

The dock expects JSON like:

```json
{
  "cmd": "control",
  "action": "chapter_next",
  "token": "optional_token",
  "requestId": "req-001"
}
```
