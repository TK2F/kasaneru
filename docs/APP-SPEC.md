# Kasaneru App Spec

**Version**: 5.0 (2026-04-05)
**Scope**: External app developers / AI agents building `apps/*` for Kasaneru.

## 0. Three Surfaces Model

Apps operate across two primary surfaces:

| Surface | File | Where | Audience | Purpose |
|---------|------|-------|----------|---------|
| **Display** | `index.html` | overlay iframe | Viewers | Visual output on stream — NO controls |
| **Control** | `ctrl.html` (or `?ctrl=1&dock=1`) | dock panel / pop-out | Streamer | Operator controls — ALL interaction here |

> **Design principle**: All app operation happens through the dock control panel or pop-out window. The broadcast screen (overlay) shows only the visual output that viewers see. OBS Browser Source does not forward mouse events from the preview panel — the only way to click is via OBS "Interact" window (right-click → Interact), which is not practical for live operation.
>
> **Legacy**: `interactionMode='interactive'` is preserved for advanced OBS Interact usage but is NOT recommended. overlay.html always appends `noctrl=1` to display URLs regardless of this setting.

### File Separation (Optional)

Apps MAY provide a separate control file for full design freedom:

```
apps/
  timer.html              ← Display (overlay)
  timer-ctrl.html         ← Control (dock) — independent design

  dice/
    index.html            ← Display
    ctrl.html             ← Control
```

The control file:
- Has **full design freedom** (not constrained by Kasaneru theme)
- Communicates with display via BroadcastChannel (same channel name)
- May use any CSS framework, layout, or design system
- Receives `dock=1` as URL param when loaded in dock panel
- Gets full panel height in dock control mode (not limited to a small iframe)

If no separate control file is specified, the display file is loaded with `?ctrl=1&dock=1` (backward compatible).

### Dock Registration

| Field | Purpose | Default |
|-------|---------|---------|
| `url` | Display URL | Required |
| `ctrlUrl` | Control URL (new) | Empty → `url + '?ctrl=1&dock=1'` |

### Three-Axis Settings (Dock Registration)

Each app has three independent settings axes:

**Display Mode** (`displayMode`):
| Value | Behavior |
|-------|----------|
| `widget` (default) | Positioned at a 9-point anchor with custom size |
| `fullscreen` | Fills 1920×1080 canvas |
| `hidden` | Runs in background (audio/data only, not visible) |

**Design Mode** (`designMode`):
| Value | Behavior |
|-------|----------|
| `app` (default) | App's own design, no Kasaneru CSS override |
| `accent` | Only accent color (`--acc`) synced from Kasaneru |
| `theme` | Full theme sync (accent + theme name) |

**Interaction Mode** (`interactionMode`):
| Value | Behavior |
|-------|----------|
| `display` (default) | Display only, no click-through (pointer-events: none) |
| `interactive` | Clickable on stream (pointer-events: auto) |

### 9-Point Positioning

Widget-mode apps use a 9-point anchor grid:

```
[TL] [TC] [TR]
[CL] [CC] [CR]
[BL] [BC] [BR]
```

- **Base margin**: 0px (offset is from the edge/center directly)
- **Offset X/Y**: Pixel offset from the anchor point
- Center anchors (TC, CC, BC, CL, CR) use CSS `calc(50% + offset)`

### Design Philosophy

**Apps own their design.** The default `designMode` is `app` — Kasaneru does NOT override app styling. Apps are meant to add unique functionality and visual character to streams. Only opt-in to accent/theme sync when consistency with the overlay theme is desired.

**Apps own their controls.** The `ctrl.html` file can use any design system, framework, or layout. It runs in the dock's full panel height or a pop-out window.

## 0.1 Broadcast Display Design Principles

The broadcast display (overlay) is what viewers see. Design for maximum visual quality:

1. **NO controls on stream** — `noctrl=1` hides all buttons, inputs, toggles. overlay.html auto-appends this.
2. **No accent bar by default** — The left border-left accent is a Chapter/TitleCard design language. Apps should NOT use it unless intentionally matching the overlay theme.
3. **Semi-transparent background** — `rgba(8,8,16,0.78)` or similar. Blends with stream content.
4. **High contrast text** — White on dark semi-transparent. Readable over any video content.
5. **Minimal UI chrome** — No unnecessary borders, shadows, or decorations. Every pixel should serve the viewer.
6. **No toggle buttons on stream** — The ⚙ toggle is for browser testing only. Hidden with `noctrl=1`.
7. **Smooth state transitions** — CSS transitions for color changes (warning/danger), no jarring updates.

**Reference implementation**: `apps/timer.html`

## 1. Contract Summary

A Kasaneru app is an HTML page loaded in an iframe by `overlay.html`.

- Must run standalone in browser.
- Must run inside OBS Browser Source.
- Must support display-only mode (`?noctrl=1`) and dock-control mode (`?ctrl=1&dock=1`).
- Should not require understanding `dock.html` internals.

## 2. Runtime Model

- App executes in iframe sandbox: `allow-scripts allow-same-origin`.
- App visibility/placement is controlled by dock/overlay.
- Core control channel for app logic is `BroadcastChannel`.
- Style bridge is received via `window.postMessage` (see Section 6).
- **overlay.html always appends `noctrl=1`** to display URLs (dock-only operation principle).
- dock.html appends `ctrl=1&dock=1` to control URLs.

### 2.1 Two-Surface URL Design

| Surface | URL Params | Who Adds | Behavior |
|---------|-----------|----------|----------|
| **Display** | `?noctrl=1` | overlay.html (always) | Visual only. No controls. No toggle. Broadcast-ready. |
| **Control** | `?ctrl=1&dock=1` | dock.html | Full control panel. All settings visible. |

Apps MUST handle these params:
```javascript
var params = new URLSearchParams(location.search);
var showCtrl = false;  // default: controls hidden (safe for broadcast)
if (params.get('ctrl') === '1') showCtrl = true;    // dock → show all controls
if (params.get('noctrl') === '1') {
  showCtrl = false;
  // Also hide toggle button — nothing clickable on broadcast
}
```

## 3. Required Baseline

```css
html, body {
  margin: 0;
  padding: 0;
  background: transparent;
  overflow: hidden;
}
```

Rules:
- Do not depend on CDN for critical rendering paths.
- Handle missing channel/messages gracefully.
- Ignore unknown commands safely.
- **MUST** handle `noctrl=1` URL param to hide control UI (overlay auto-appends this).
- **MUST** broadcast UI actions via BroadcastChannel so dock ctrl ↔ overlay display stay in sync.
- **MUST** listen for `window.postMessage` with `lt_overlay_config` for theme sync (see Section 6).

## 4. Recommended URL Params

| Param | Meaning |
|---|---|
| `noctrl=1` | Hide app control panel (overlay display mode) |
| `ctrl=1` | Force show control panel |
| `dock=1` | Hint for dock-embedded mode |
| `visual=none` | Keep logic/audio running with no visuals |

Apps should still work if none of these params are provided.

## 4.1 App Registration Path (Dock)

For portable distribution (different install locations), register app URLs as paths relative to `overlay.html`:

- Recommended: `apps/{appname}.html` or `apps/{appname}/index.html`
- Avoid absolute local paths for shared packs (for example `C:/...`)
- Keep app-local assets relative to app file (for example `images/avatar.png`, `./theme.css`)

Rationale:
- OBS environments differ per operator machine.
- Relative paths survive folder relocation of the whole Kasaneru directory.

## 5. BroadcastChannel

Channel naming:

```text
lt_app_{appname}
```

Minimal listener pattern:

```javascript
var ch = null;
try { ch = new BroadcastChannel('lt_app_yourapp'); } catch (e) {}
if (ch) {
  ch.onmessage = function (ev) {
    var d = ev && ev.data;
    if (!d || !d.cmd) return;
    if (d.cmd === 'config') {
      if (d.accent) document.documentElement.style.setProperty('--acc', d.accent);
    }
  };
}
```

### 5.1 Dock ↔ Overlay Sync Pattern (MUST)

When a user interacts with controls in the dock (ctrl iframe), the action must be broadcast over BroadcastChannel so the display iframe in the overlay stays in sync. BroadcastChannel delivers to all other same-origin contexts except the sender.

```javascript
/* Helper: broadcast command to sync other instances */
function bcSend(msg) { if (ch) try { ch.postMessage(msg); } catch(e) {} }

/* Button handler pattern: execute locally + broadcast */
document.getElementById('btn-start').addEventListener('click', function() {
  start();                          /* Execute locally */
  bcSend({ cmd: 'start' });         /* Sync other instances */
});
```

**Why this matters**: dock.html loads your app in a ctrl iframe (`?ctrl=1&dock=1`), and overlay.html loads it in a display iframe (`?noctrl=1`). These are separate instances. Without broadcasting, button clicks in the dock ctrl panel have zero effect on the overlay display.

**Reference implementation**: `apps/timer.html`

### 5.2 State Sync Protocol (MUST for stateful apps)

Apps with running state (timers, players, counters) MUST synchronize across instances. When dock's ctrl panel is closed and re-opened, the new instance must recover the running state from the overlay display instance.

**Protocol**:
1. On startup, send `{ cmd: 'getState' }` via BC
2. Running instances respond with `{ cmd: 'state', elapsed, running, ... }`
3. Every tick/update, broadcast `{ cmd: 'tick', elapsed, running, ... }`
4. New instances receive `state`/`tick` and sync their display

```javascript
/* In tick/update function: broadcast current state */
bcSend({ cmd: 'tick', elapsed: elapsed, running: true, totalSeconds: totalSeconds, mode: mode });

/* In BC message handler: respond to state requests */
if (d.cmd === 'getState') {
  bcSend({ cmd: 'state', elapsed: elapsed, running: running, totalSeconds: totalSeconds, mode: mode });
}
if (d.cmd === 'state' || d.cmd === 'tick') {
  elapsed = d.elapsed;
  if (d.cmd === 'state' && d.running && !running) start();
  render();
}

/* On init: request state from any running instance */
setTimeout(function() { bcSend({ cmd: 'getState' }); }, 100);
```

**Why**: dock.html destroys and recreates ctrl iframes when entering/exiting ctrl mode. Without this protocol, the new instance shows stale state (elapsed=0, stopped) while the overlay continues running.

## 6. Theme Sync Bridge

When dock app setting `themeSync=true`, overlay may forward config:

```javascript
window.postMessage({
  cmd: 'lt_overlay_config',
  accentColor: '#e8002d',
  theme: 'gameui',  /* legacy — theme selector removed, default styling embedded */
  themeSync: true
}, '*');
```

Recommended handler:

```javascript
window.addEventListener('message', function (ev) {
  var d = ev && ev.data;
  if (!d || d.cmd !== 'lt_overlay_config' || d.themeSync === false) return;
  if (d.accentColor) document.documentElement.style.setProperty('--acc', d.accentColor);
  if (d.theme) document.documentElement.setAttribute('data-lt-theme', d.theme);
});
```

If your app has strict custom branding, keep `themeSync=false`.

### 6.1 Skin (Kisekae / きせかえ)

When `designMode='theme'`, the overlay may also include a `skin` field with custom CSS variables and texture URLs provided by the user. This allows users to customize the visual atmosphere of apps with their own images and textures.

Payload extension:

```javascript
window.postMessage({
  cmd: 'lt_overlay_config',
  accentColor: '#e8002d',
  theme: 'gameui',  /* legacy — theme selector removed, default styling embedded */
  themeSync: true,
  skin: {
    name: 'my-theme',
    vars: {
      '--skin-bg': 'url(themes/my-theme/bg.png)',
      '--skin-card-bg': 'rgba(20,20,40,0.85)',
      '--skin-card-texture': 'url(themes/my-theme/card-texture.png)',
      '--skin-border-img': 'url(themes/my-theme/border.png) 8 round',
      '--skin-text-primary': '#f0f0f0',
      '--skin-text-secondary': 'rgba(255,255,255,0.65)'
    }
  }
}, '*');
```

Recommended handler (extends the theme handler above):

```javascript
// Inside the lt_overlay_config handler:
if (d.skin && d.skin.vars) {
  var root = document.documentElement;
  var vars = d.skin.vars;
  for (var key in vars) {
    if (vars.hasOwnProperty(key) && key.indexOf('--') === 0) {
      root.style.setProperty(key, vars[key]);
    }
  }
}
```

Apps **SHOULD** use CSS custom properties for backgrounds, borders, and text colors to support skinning:

```css
.my-card {
  background: var(--skin-card-bg, rgba(8,8,16,0.78));
  background-image: var(--skin-card-texture, none);
  border-image: var(--skin-border-img, none);
  color: var(--skin-text-primary, #fff);
}
```

Skin CSS variable naming convention:
- `--skin-bg` — Full-page background
- `--skin-card-bg` — Card/panel background color
- `--skin-card-texture` — Card/panel texture image
- `--skin-border-img` — CSS border-image for cards
- `--skin-text-primary` — Primary text color
- `--skin-text-secondary` — Secondary text color
- `--skin-accent` — Skin-specific accent (overrides `--acc` if present)

## 7. Control Patterns

### Pattern A: Built-in UI
- App includes its own controls.
- Best for timer / draw / roulette style apps.

### Pattern B: Channel-driven display
- No local controls, fully external driven.
- Best for display widgets.

### Pattern C: Hybrid
- Local controls + channel commands.
- Best for music player / clock style apps.

## 8. Interop Checklist (Required for New Apps)

1. Works with `?noctrl=1` (overlay auto-appends this — controls must hide).
2. Works with `?ctrl=1&dock=1` (dock appends this — show full controls).
3. Handles BroadcastChannel `config` command.
4. **Broadcasts UI actions via BroadcastChannel** (dock ctrl ↔ overlay display sync).
5. Handles `lt_overlay_config` postMessage bridge (theme/accent sync).
6. Uses transparent background.
7. Fails safe in offline/blocked network conditions.

## 9. Current Built-in Apps (Reference)

| App | Primary Pattern | Channel |
|---|---|---|
| `timer.html` | A | `lt_app_timer` |
| `clock.html` | C | `lt_app_clock` |
| `now-playing.html` | B | `lt_app_nowplaying` |
| `banner.html` | A | `lt_app_banner` |
| `draw.html` | A | `lt_app_draw` |
| `roulette.html` | A | `lt_app_roulette` |
| `youtube-chat.html` | B/C | `lt_app_ytchat` |
| `music-player.html` | C | `lt_app_music` |
| `ai-chat.html` | A | `lt_app_aichat` |
| `dice/dice.html` | A/C | `lt_app_dice` |

## 10. External API / Server Integration

Apps that connect to external servers (LLM APIs, etc.) **MUST** follow these rules:

### 10.1 Specification-First Development
- Read the **official API documentation** (Swagger/OpenAPI) before writing any fetch/XHR code.
- Do NOT rely on AI training data or blog posts for API parameters — verify against the running server's `/docs` or `/openapi.json`.
- Document the API version and endpoints used in a code comment at the top of the integration section.

### 10.2 Connection Testing
- Provide a **Test Connection** button or equivalent in the control panel.
- Test should verify: server reachable → API responds → a minimal operation succeeds.
- Display results in the control panel only (never on overlay).

### 10.3 Timeout & Error Policy
- Set timeouts appropriate for the service (e.g., first-call model loading may take 10-15s).
- Error messages must include HTTP status + response body for debugging.
- **配信画面にエラーを絶対に出さない** — errors go to control panel + console only.
- Implement graceful degradation / fallback when the external service is unavailable.

### 10.4 Known External Services

| Service | Default URL | Doc Endpoint | Notes |
|---|---|---|---|
| (Reserved for future AI voice integration) | — | — | Voicevox/TTS removed from dice in v18 |

## 11. Validation Before Merge

- Syntax check app script.
- Manual run in browser (standalone).
- Manual run in dock + overlay with app visibility flow.
- Confirm no blocking errors when BroadcastChannel unavailable.

## 12. App Manifest (`apps/manifest.json`) — v2

The manifest declares all bundled apps and their metadata for dock preset selection and automated tooling.

### 12.1 Format

```json
{
  "version": 2,
  "apps": [ { /* AppEntry */ }, ... ]
}
```

**Backward compatibility**: v1 (a plain JSON array) is still accepted — the dock detects the format automatically.

### 12.2 AppEntry Schema

| Field | Type | Required | Default | Description |
|---|---|---|---|---|
| `id` | string | MUST | — | Unique identifier (kebab-case). Used as BroadcastChannel suffix. |
| `name` | string | MUST | — | Display name. Bilingual recommended: `"日本語 / English"`. |
| `path` | string | MUST | — | URL relative to `overlay.html`. E.g. `"apps/timer.html"`. |
| `icon` | string | SHOULD | `""` | Emoji or short text for the preset picker. |
| `description` | string | SHOULD | `""` | One-line description of the app. |
| `displayMode` | `"widget"\|"fullscreen"\|"hidden"` | MAY | `"widget"` | Recommended display mode. |
| `designMode` | `"app"\|"accent"\|"theme"` | MAY | `"app"` | Recommended design mode. |
| `defaultSize` | `{ width: number, height: number }` | MAY | `{ width: 480, height: 320 }` | Recommended initial pixel size. |
| `features` | string[] | MAY | `[]` | Capabilities: `"broadcastChannel"`, `"stateSync"`, `"postMessage"`, `"themeable"`. |
| `requirements` | object | MAY | `{}` | External dependencies. `{ externalService: "LLM API" }` etc. |

### 12.3 Usage by Dock

When the user selects an app from the preset picker:

1. `path` → app URL field
2. `name` → app name field (if blank)
3. `defaultSize.width` / `defaultSize.height` → size fields (v2 only)
4. Other fields are informational — the user can override any value before adding.

### 12.4 Extending the Manifest

Third-party apps can be added to the manifest array. All fields except `id`, `name`, and `path` are optional — the dock applies sensible defaults for missing fields.
