# Encore (working title)

Unofficial continuation of [Spectacle](https://github.com/eczarny/spectacle), Eric Czarny’s macOS window manager.

This is **not** a release. There is no downloadable build yet. The app builds on current Xcode and `SpectacleSpecs` passes.

If you loved Spectacle, the goal is that app, maintained: same Objective-C architecture, same JavaScript window calculations, same actions. It is **not** [Rectangle](https://github.com/rxhanson/Rectangle). Rectangle is a different, actively maintained window manager; this project does not copy its features.

Spectacle itself is [no longer maintained](https://github.com/eczarny/spectacle#important-note). This repository keeps that history and continues the MIT-licensed source. It is not affiliated with Eric Czarny.

## Status

| | |
| --- | --- |
| Public name | TBD (working title **Encore**) |
| Last original release | Spectacle **1.2** |
| Intended min macOS | **13+** (set in the Xcode project) |
| Bundle ID | TBD (will not ship as `com.divisiblebyzero.Spectacle`) |
| Auto-update | Disabled for unsigned builds; will not use spectacleapp.com’s Sparkle feed |
| Repository | [github.com/Amannor/encore](https://github.com/Amannor/encore) |
| Current work | Tests pass (Slice 2b). Next is security hardening (Slice 3). See [docs/STATUS.md](docs/STATUS.md) |

Maintainers and agents: start at [docs/HANDOFF.md](docs/HANDOFF.md).

## What this is (and is not)

- A minimal, secure, reproducibly built macOS window manager that preserves original Spectacle behavior.
- MIT-licensed. Original code remains copyright Eric Czarny; see [LICENSE.md](LICENSE.md).
- Not a Swift rewrite. Not a Rectangle clone. Not “Spectacle, modernized by AI.”

## Keyboard shortcuts

These are Spectacle’s defaults (unchanged). A window action changes the size and/or position of the frontmost window. Shortcuts can be changed or cleared in preferences.

| Symbol | Key |
|:---:|:---:|
| ⌘ | Command |
| ⌃ | Control |
| ⌥ | Option |
| ⇧ | Shift |

### Basic window actions

- Center (size unchanged) — ⌥⌘C
- Maximize — ⌥⌘F
- Left / right / top / bottom half — ⌥⌘← ⌥⌘→ ⌥⌘↑ ⌥⌘↓
- Upper left / lower left / upper right / lower right — ⌃⌘← ⌃⇧⌘← ⌃⌘→ ⌃⇧⌘→

Repeating a half or corner shortcut cycles that region between 1/3, 2/3, and 1/2. Next / previous third: ⌃⌥→ / ⌃⌥←. Make larger / smaller: ⌃⌥⇧→ / ⌃⌥⇧←.

### Multiple displays

Next / previous display: ⌃⌥⌘→ / ⌃⌥⌘←.

### Undo / redo

Undo window action: ⌥⌘Z. Redo: ⌥⇧⌘Z.

## Accessibility

macOS requires Accessibility permission for an app to move other apps’ windows. The original Spectacle documentation still applies: grant access when prompted, or the window actions will do nothing.

Applications can also constrain window size. Spectacle (and this continuation) respects those constraints, which can make a “half screen” larger than half. Terminal-style apps that snap to character cells may jitter while the mover searches for a fitting size.

## Building

```sh
xcodebuild -scheme Spectacle -destination 'platform=macOS' test
```

Upstream remote (archived original):

```sh
git remote get-url upstream
# https://github.com/eczarny/spectacle.git
```

## License

Copyright (c) 2017 Eric Czarny.

Distributed under the MIT License. This repository should be accompanied by [LICENSE.md](LICENSE.md).
