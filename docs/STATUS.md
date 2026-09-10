# Status

**Last completed slice:** 1 — Freeze the archaeology (docs only)  
**Current / next slice:** 2 — Make it build and test on current Xcode  
**Updated:** 2026-09-10

## Blockers / open questions for humans

- **Full Xcode is not installed.** `xcode-select -p` is `/Library/Developer/CommandLineTools`. `xcodebuild` refuses to run. Slice 2 cannot start compiling until Xcode is installed and selected. See [INVENTORY.md](INVENTORY.md) compiler baseline.
- Final product name is not chosen. Working title: **Encore**. Alternatives in ADR-001: Reprise, Revival, Afterpiece.
- Bundle ID is TBD until Slice 5. Do not ship as `com.divisiblebyzero.Spectacle`.

## Remotes

- `origin`: `git@github.com:Amannor/encore.git` — https://github.com/Amannor/encore
- `upstream`: `https://github.com/eczarny/spectacle.git` (archived original; do not force-push)

## Slice 1 outcome

Docs only. App sources, Xcode project, Sparkle, bundle ID, and deployment target were **not** changed.

- [ARCHITECTURE.md](ARCHITECTURE.md) — process, JS geometry engine, mover chain, shortcuts, existing specs.
- [INVENTORY.md](INVENTORY.md) — Carthage deps, Sparkle/network, AX, JS containment, filesystem, login items, AppleScript, hotkeys, signing, `xcodebuild` baseline.

### Commands that ran

```sh
git remote get-url origin
# git@github.com:Amannor/encore.git

xcode-select -p
# /Library/Developer/CommandLineTools

xcodebuild -version
# xcode-select: error: tool 'xcodebuild' requires Xcode, but active developer directory
# '/Library/Developer/CommandLineTools' is a command line tools instance

ls /Applications/Xcode*.app
# no matches

clang --version
# Apple clang version 21.0.0 (clang-2100.1.1.101)
# Target: arm64-apple-darwin25.6.0

sw_vers
# ProductVersion: 26.6.2
```

No `xcodebuild` compile was possible. That is the recorded baseline, not a skipped step.

### What the next agent must not redo

- Do not re-import Spectacle or flatten git history.
- Do not re-write ARCHITECTURE.md / INVENTORY.md from scratch; amend if Slice 2 discovers a missed call site.
- Do not change window JS, Sparkle feed, login items, or bundle ID as a side effect of “making it build” without documenting it (Slice 2 may **disable/stub Sparkle** if it blocks the build — that is allowed and must be noted in STATUS).
- Do not start Slice 3 until Slice 2’s `xcodebuild test` acceptance is met (or explicitly split).

Slice 2 needs Xcode, then modernize the project for a universal binary and green `SpectacleSpecs` without intentional behavior change.
