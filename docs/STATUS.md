# Status

**Last completed slice:** 2b — Tests and CI  
**Current / next slice:** 3 — Security hardening without new features  
**Updated:** 2026-09-29

## Blockers / open questions for humans

- None for compiling the app. Xcode 27.0 (27A266a) is selected at `/Applications/Xcode.app/Contents/Developer`. Host is macOS 27.0.1, arm64.
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

## Slice 2 outcome

App builds. Tests do not. Sparkle is not linked, and the spectacleapp.com feed keys are gone from `Info.plist`. `dsa_public.pem` is still copied into the bundle; Slice 3 removes it. Login items still use `LSSharedFileList` (deprecation ignored, ADR-009).

`SpectacleSpecs` is still Specta/Expecta/OCMockito and is not built for Run. `xcodebuild test` will fail until Slice 2b. Carthage has not been bootstrapped.

## Slice 2b outcome

Specs run as XCTest. Carthage, `Cartfile`, and Travis are gone. CI is `.github/workflows/test.yml` (`macos-15`, `xcodebuild test`). The accessibility modal is skipped when `XCTestConfigurationFilePath` is set, so the test host can launch.

`containsModifiers:` now treats the argument as modifiers the shortcut includes, after converting both sides to Carbon. The old equality check failed `SpectacleShortcutSpec`, which has required that since the method was added. A zero modifier mask still matches only a shortcut with no modifiers.

### Commands that passed (2026-09-29, Slice 2b)

```sh
xcodebuild -scheme Spectacle -destination 'platform=macOS' test CODE_SIGNING_ALLOWED=NO -derivedDataPath DerivedData
# ** TEST SUCCEEDED **
```

### Commands that passed (2026-09-29)

```sh
xcode-select -p
# /Applications/Xcode.app/Contents/Developer

xcodebuild -version
# Xcode 27.0
# Build version 27A266a

xcodebuild -scheme Spectacle -destination 'platform=macOS' -configuration Debug build CODE_SIGNING_ALLOWED=NO -derivedDataPath DerivedData
# ** BUILD SUCCEEDED **

lipo -archs DerivedData/Build/Products/Debug/Spectacle.app/Contents/MacOS/Spectacle
# x86_64 arm64
```

### What the next agent must not redo

- Do not re-import Spectacle or flatten git history.
- Do not re-write ARCHITECTURE.md / INVENTORY.md from scratch; amend if Slice 2 discovers a missed call site.
- Do not change window JS, Sparkle feed, login items, or bundle ID as a side effect of “making it build” without documenting it (Slice 2 may **disable/stub Sparkle** if it blocks the build — that is allowed and must be noted in STATUS).
- Do not re-enable Sparkle or put `SUFeedURL` back.
- Do not bring Carthage, Specta, Expecta, OCHamcrest, or OCMockito back.
- Do not rewrite the geometry specs’ expected frames.
- Do not start Slice 4 until Slice 3’s acceptance is met.
