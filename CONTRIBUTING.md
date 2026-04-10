## Contributing

Thanks for considering contributing.

### Constraints (important)

- **ES5 only** (`var` / `function`). Avoid modern syntax that may fail on OBS CEF.
- **No CDN** (including Google Fonts) and avoid `@import url(...)`.
- Prefer GPU-friendly animations (`transform` + `opacity`).

### How to test

- Open `dock.html` and `overlay.html` in OBS as documented in `README.md`.
- Verify basic dock / overlay sync works as described in `docs/OPERATION-GUIDE.md`.

### Pull requests

- Keep changes small and reviewable.
- Update docs when behavior changes.
- If you touch the protocol, update `docs/ARCHITECTURE.md`.

