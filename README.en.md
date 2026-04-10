# Kasaneru

**Simple overlay toolkit for OBS Studio**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
![Version](https://img.shields.io/badge/Version-1.0.0-green.svg)

> Japanese README: [README.md](README.md)

---

## What is Kasaneru?

**Kasaneru** (Japanese for "to layer/overlay") is a lightweight overlay toolkit for OBS Studio.

- No build tools, no CDN, no dependencies
- Works completely offline
- Just unzip and configure OBS — that's it

Perfect for online classes, lightning talks, TRPG sessions, and casual streaming.

---

## Tested Environment

- **Windows 11** (OBS 30+) — verified
- **macOS** — untested (cross-platform compatibility considered in code review)
- **Linux** — untested (same as above)

OBS Browser Source uses Chromium internally, so it should work across platforms. If you find issues on untested platforms, please open an [Issue](../../issues).

---

## Included Apps

| App | Description |
|-----|-------------|
| **Timer** | Countdown / count-up timer |
| **Clock** | Digital clock with time zone support |
| **Music Player** | BGM player with playlist and favorites |
| **Roulette** | Wheel and reel-style roulette |
| **Rakugaki Draw** | Screen annotation tool (pen, shapes, pins, text) |
| **Banner** | Scrolling or static text banner |
| **TRPG Dice** | Polyhedral dice (d4-d100) with rock-paper-scissors |

---

## Setup

### 1. Download

Download the latest `kasaneru-v*.zip` from the [Releases page](../../releases) and extract it.

### 2. Add Dock to OBS

1. Open OBS
2. **View > Docks > Custom Browser Docks**
3. Name: `Kasaneru`
4. URL: `file:///C:/.../kasaneru/dock.html` (use your actual path)
5. Click **Apply** and restart OBS

### 3. Add Browser Source

1. Click **+ > Browser** in the Sources panel
2. **Uncheck "Local file"** (important!)
3. URL: `file:///C:/.../kasaneru/overlay.html`
4. Width: **1920**, Height: **1080**
5. Custom CSS: `body{background-color:rgba(0,0,0,0)!important;}`

### Important Notes

- Dock and Browser Source URLs must point to the **same folder**
- **"Local file" must be unchecked** (required for BroadcastChannel communication)
- If changes don't appear, click **Refresh cache** in the Browser Source properties

---

## Customization

Customize the overlay appearance with CSS. See [CUSTOM-CSS-GUIDE.md](CUSTOM-CSS-GUIDE.md).

---

## Build Your Own App

Kasaneru supports custom apps. See `templates/app/hello-world.html` for a starter template and [docs/APP-SPEC.md](docs/APP-SPEC.md) for the development spec.

---

## License

MIT License. See [LICENSE](LICENSE).

### Rock-Paper-Scissors Images

Images in `apps/dice/images/` are AI-generated.

- Copyright: TK2LAB
- Generated with: Google Flow (NanoBanana Pro model)
- Licensed under MIT (free to use)

---

## Credits

- Developed by **TK2LAB**
- No external libraries (fully self-contained)
- System fonts only (no font files bundled)

See [THIRD-PARTY-NOTICES.md](THIRD-PARTY-NOTICES.md) for details.

---

## Contributing

Issues and Pull Requests are welcome. See [CONTRIBUTING.md](CONTRIBUTING.md).

---

## Support

We hope Kasaneru helps you.

Kasaneru is developed as a practical overlay toolkit for OBS with minimal setup.
The project focuses on usability, stability, documentation, and bundled apps.

If you want to help sustain ongoing improvements, you can support the project via [GitHub Sponsors](https://github.com/sponsors/tk2f).
