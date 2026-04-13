## Security Policy

### Supported versions

This project is provided as-is. Security fixes may be published as updates, but there is no guaranteed support window.

### Threat model

Kasaneru runs as local HTML files loaded via `file://` protocol in OBS Browser Source. Understanding its trust boundaries helps you assess the risks for your environment.

**Architecture**:
```
[dock.html]  ←── BroadcastChannel ──→  [overlay.html]
     ↕ postMessage                           ↕ postMessage
 [ctrl iframe]                         [display iframe]
  (apps/*.html)                         (apps/*.html)
```

**Trust boundaries**:

| Boundary | Trust level | Notes |
|----------|------------|-------|
| Bundled apps (`apps/*`) | Trusted | Shipped with Kasaneru, reviewed by maintainer |
| User-added local apps | User's responsibility | Loaded in iframe with `allow-scripts allow-same-origin` — has full same-origin access |
| BroadcastChannel messages | Local only | Same-origin, same-process. No authentication. Any same-origin page can send messages |
| postMessage relay | Local only | Accepts `*` origin (required for `file://`). Messages are not authenticated |
| External network | Not used by default | No bundled app makes network requests. User-added apps with external APIs are the user's responsibility |

**What this means for users**:

1. **Only load apps you trust.** Apps run with `allow-same-origin` in their iframe sandbox, meaning a malicious app could access `localStorage`, send BroadcastChannel messages, or read other same-origin data.
2. **No remote control by default.** Kasaneru has no built-in server or WebSocket listener. The remote control templates (`templates/remote/`) are opt-in and require the user to set up their own WebSocket server.
3. **No authentication on message channels.** BroadcastChannel and postMessage have no auth layer. This is acceptable because all communication is local (same machine, same browser profile). If future versions add network-accessible control, authentication will be required.
4. **`file://` origin quirks.** On `file://`, all local HTML files may share the same origin depending on the browser. OBS CEF treats `file://` pages as same-origin. This is a browser-level behavior, not a Kasaneru choice.

**Out of scope**:
- OBS plugin vulnerabilities (report to OBS project)
- Chromium/CEF vulnerabilities (report to Chromium project)
- User-created apps with external API integrations

### Reporting a vulnerability

Please do **not** open public issues for security-sensitive reports.

Use one of the following private channels instead:
- GitHub Security Advisories: `Security` tab in this repository
- GitHub account contact: https://github.com/tk2f

Please include:
- A short description of the issue and impact
- Reproduction steps
- OBS version / OS info
- Any logs or screenshots that help

If you are unsure whether something is security-sensitive, report it privately.
