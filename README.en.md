# Kasaneru

**Simple overlay toolkit for OBS Studio**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
![Version](https://img.shields.io/badge/Version-1.0.0-green.svg)

> Japanese README: [README.md](README.md)

---

## What is Kasaneru?

**Kasaneru** (Japanese for "to layer/overlay") is a lightweight overlay toolkit for OBS Studio.

- No build tools, no CDN, no dependencies
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

## How to Use

Use the **LIVE / OFFLINE** toggle (top right of the dock) to control whether anything appears on stream. OFFLINE hides everything.

### Chapters

Cards that mark sections of your stream. Set a title and subtitle, then use the show button to display. Navigate with the left/right arrows.

### Telop Cards

Lower-third cards for speaker names or topic labels. Toggle with SHOW / HIDE.

### Images

Place images in the `images/` folder and add them from the dock. Useful for slides or logos. Each image group can have its own position and animation.

### Apps

Add apps from the "Apps" tab. Enter the relative path (e.g., `apps/timer.html`) as the URL.

### Bundled App Guide

| App | How to use |
|-----|-----------|
| **Timer** | Set duration in the control panel. Start / Pause / Reset. Supports countdown and count-up |
| **Clock** | Just add it — displays immediately. Change time zone (UTC offset) in the control panel |
| **Music Player** | Add music files to the playlist for BGM. Place files inside the kasaneru folder or use `file:///` paths |
| **Roulette** | Enter choices in the control panel, click Spin. Stop manually to pick a result. Wheel and reel modes |
| **Rakugaki Draw** | The control panel shows a drawing area. Use pen, shapes, pins, and text to annotate the screen. Enable OBS WebSocket to preview your stream output while drawing (see steps inside the control panel) |
| **Banner** | Display scrolling or static text. Set text, speed, and position in the control panel |
| **TRPG Dice** | Enter dice notation (e.g., `2d6+3`) and click Roll. Includes rock-paper-scissors mode |

For detailed instructions, see [docs/OPERATION-GUIDE.md](docs/OPERATION-GUIDE.md).

---

## Going Further with OBS

Once you've settled into using Kasaneru, you might start thinking: "What if I could show this?" or "I wish I had a widget for that." Here are a few ways to keep exploring.

### Create Your Own Style

A little CSS goes a long way. Change the accent color, swap the font, reshape the cards — small tweaks can completely change the feel of your stream. There's no right answer, so experiment until it looks like *yours*.

See [CUSTOM-CSS-GUIDE.md](CUSTOM-CSS-GUIDE.md) for details (currently in Japanese; CSS variable names and selectors are all in English).

### Build a Mini App

If you know some HTML and a bit of JavaScript, you can build your own stream tool. A counter, a random topic picker, a comment viewer — whatever you can imagine. Start by copying the template at `templates/app/hello-world.html` and making it do something small.

The full development spec is at [docs/APP-SPEC.md](docs/APP-SPEC.md).

### Explore OBS Plugins

OBS has a huge ecosystem of community plugins: scene transition effects, auto-captions, stream scheduling, and more. Once you're comfortable with the basics, browse the [OBS Forum Resources](https://obsproject.com/forum/resources/) or the plugin manager inside OBS. You'll be surprised at what's out there.

Customizing your stream setup is half the fun — enjoy the process.

---

## Quick Start (FAQ)

**Q: Nothing appears on stream**
A: Make sure "Local file" is **unchecked** in the Browser Source settings. The URL should start with `file:///`.

**Q: Changes don't take effect**
A: Open the Browser Source properties and click **Refresh cache**.

**Q: Dock and overlay are out of sync**
A: Both URLs must point to the **same folder**. Also confirm "Local file" is unchecked.

**Q: Does it work on macOS / Linux?**
A: Untested, but OBS Browser Source is Chromium-based, so it should work. Please open an [Issue](../../issues) if you find problems.

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
- No external libraries
- System fonts only (no font files bundled)

See [THIRD-PARTY-NOTICES.md](THIRD-PARTY-NOTICES.md) for details.

---

## Support

If you like Kasaneru, it would mean a lot if you could support the project via [GitHub Sponsors](https://github.com/sponsors/tk2f).
