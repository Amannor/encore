# Status

**Last completed slice:** 7 — Maintenance workflow  
**Current / next slice:** none until a human names one. The distribution consult was skipped.  
**Updated:** 2026-10-15  
**Branch:** `cursor/build-and-xctest`. Tag `v0.1.0` is the release source. Do not return to `main` for this work. Do not push that tag. In-app updates and forum posts wait on the Apple Developer Program (ADR-013).

## Next session

Do not redo Slice 7. Do not start the distribution consult unless asked. Do not enable Sparkle, notarize, or add a Homebrew cask. Do not change legacy expected frames, the JS window math, or the modern-display goldens. The live built-in screen is not that fixture.

Shortcut display tests need the ABC input source. Hebrew maps `kVK_ANSI_C` to ב. Switch the layout. Do not rewrite the expected shortcut strings.

The weekly `obsolete` workflow and Dependabot read their config from the default branch (`main`). Pushing this branch does not start them. Do not merge to `main` unless asked. Do not push tag `v0.1.0`. Do not enable Sparkle, notarize, or post to forums until the maintainer has a Developer ID (ADR-013).

### Icon change (done 2026-10-14)

The menu-bar image is a black spotlight, `Encore Status Item`, 20×20 and 40×40, loaded from `SpectacleAppDelegate.m` with `setTemplate:YES`. New files are `Spectacle/Resources/Images.xcassets/Encore Status Item.imageset/`. Eric Czarny’s glasses remain in `Spectacle Status Item.imageset` and are not loaded. The Finder icon was not swapped. ADR-012. Window math was not touched.

`/Applications/Encore.app` is still the old binary, so the menu bar keeps the glasses until that copy is quit and this build is the only one launched. The new build changes the signature hash. Accessibility then fails until the human removes Encore from Device Control and Data Access and adds the new build again. Do not launch a second copy beside the installed app.

```sh
xcodebuild -scheme Spectacle -destination 'platform=macOS' -configuration Debug test -derivedDataPath DerivedData ONLY_ACTIVE_ARCH=YES
# ** TEST SUCCEEDED ** (105 tests, 0 failures)
# DerivedData/Build/Products/Debug/Encore.app Assets.car contains "Encore Status Item"
```

The debug spotlight was confirmed on screen on 2026-10-15, with Accessibility granted for `DerivedData/Build/Products/Debug/Encore.app`. The archive copy at `build/Encore.xcarchive` was quit so only one menu-bar icon remained.

Do not redraw the spotlight. Do not delete the glasses files. Do not re-run the Slice 6 GUI checklist for this art change.

### Commands (2026-10-15)

```sh
xcodebuild -scheme Spectacle -destination 'platform=macOS' -configuration Debug test -derivedDataPath DerivedData ONLY_ACTIVE_ARCH=YES
# ** TEST SUCCEEDED ** (105 tests, 0 failures)

xcodebuild -scheme Spectacle -destination 'platform=macOS' -configuration Debug analyze -derivedDataPath DerivedData ONLY_ACTIVE_ARCH=YES
# ** ANALYZE SUCCEEDED **
# same localizability warning in SpectacleAppDelegate.m:101, not fixed
```

Sparkle was not added. No release tag was pushed. Forum posts were not made.

### Slice 6 GUI checklist (complete 2026-10-10)

Slice 7 is done. Do not re-run this checklist unless the app binary changes. Intel unit tests already passed. Do not install FreeDisplay.

The run used one copy, at `/Applications/Encore.app` (same archive binary). Opening that and `build/Encore.xcarchive/Products/Applications/Encore.app` together shows two menu-bar icons. Launch one copy. On macOS 27 the privacy pane is System Settings → Privacy & Security → Device Control and Data Access. A Debug or xcarchive row is a different binary. A stale TCC cdhash denies the running one; `tccutil reset Accessibility com.amannor.Encore`, then add the running app again.

Second screen, if needed again: on the other Mac, System Settings → General → AirDrop & Handoff → AirPlay Receiver → Everyone. On this Mac, menu bar Screen Mirroring (not the Menu Bar settings page) → that Mac → Extended Display. Same Wi-Fi, VPN off. If AirPlay Receiver is missing, [BetterDisplay](https://github.com/waydabber/BetterDisplay). Do not install FreeDisplay.

Tag `v0.1.0` is local only. Pushing it publishes the GitHub release. Do not push it unless asked. `.github/workflows/test-intel.yml` runs on every push to `cursor/build-and-xctest`. Commit `4755d62`’s message says the original bundle ID was left in place. The app bundle ID is `com.amannor.Encore`. Do not amend that commit.

## Blockers / open questions for humans

- None for compiling the app. Xcode 27.0 (27A266a) is selected at `/Applications/Xcode.app/Contents/Developer`. Host is macOS 27.0.1, arm64.

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
- Do not bring Carthage, Specta, Expecta, OCHamcrest, OCMockito, or Sparkle back.
- Do not put `disable-library-validation` on the Release entitlements (ADR-010).
- Do not rewrite the geometry specs’ expected frames.
- Do not start Slice 5 until Slice 4’s acceptance is met.

## Slice 3 outcome

Sparkle is gone from the binary, the menu, and the bundle (`dsa_public.pem` deleted). Login items use `SMAppService`. Release is ad-hoc with the hardened runtime. JavaScript still loads only bundled calculation scripts. Findings are in [THREAT_MODEL.md](THREAT_MODEL.md).

### Commands that passed (2026-09-29, Slice 3)

```sh
xcodebuild -scheme Spectacle -destination 'platform=macOS' -configuration Debug test -derivedDataPath DerivedData ONLY_ACTIVE_ARCH=YES
# ** TEST SUCCEEDED **

xcodebuild -scheme Spectacle -destination 'platform=macOS' -configuration Release build -derivedDataPath DerivedData ONLY_ACTIVE_ARCH=YES
# BUILD:0

xcodebuild -scheme Spectacle -destination 'platform=macOS' -configuration Debug analyze -derivedDataPath DerivedData ONLY_ACTIVE_ARCH=YES
# ANALYZE:0
# one localizability warning in SpectacleAppDelegate.m, not fixed
```

## Slice 4 outcome

`2560×1440` visible frame `(0, 4, 2560, 1413)` and notched visible frame `(0, 69, 1512, 878)` are golden in `SpectacleModernDisplayWindowCalculationSpec.m`. Legacy specs and JS calculators were not edited. [COMPATIBILITY.md](COMPATIBILITY.md) has one row per action; intentional differences versus original Spectacle are none. [MANUAL_TEST.md](MANUAL_TEST.md) is the E2E checklist. Rectangle was not used as a frame source (ADR-006).

### Commands that passed (2026-09-30, Slice 4)

```sh
# Input source com.apple.keylayout.ABC (English). Hebrew makes shortcut display
# tests expect "C" and get "ב". Do not change those expected strings.
xcodebuild -scheme Spectacle -destination 'platform=macOS' -configuration Debug test -derivedDataPath DerivedData ONLY_ACTIVE_ARCH=YES
# ** TEST SUCCEEDED ** (101 tests, 0 failures)
```

### What the next agent must not redo

- Do not change the legacy expected frames or the window JS.
- Do not retune the 2560×1440 or notched goldens.
- Do not copy Rectangle frames or features.
- Do not rewrite shortcut display expectations to match a Hebrew keyboard.

## Slice 5 outcome

Public name is Encore. Bundle ID is `com.amannor.Encore`. The built product is `Encore.app`. Menu copy says Encore. The original icon is unchanged (ADR-001). Shortcuts are stored under `~/Library/Application Support/Encore/`. `SpectacleLegacyShortcutImporter` copies original Spectacle JSON or defaults once and does not write back. Quit original Spectacle first (README, SECURITY.md).

### Commands that passed (2026-09-30, Slice 5)

```sh
# Input source com.apple.keylayout.ABC
xcodebuild -scheme Spectacle -destination 'platform=macOS' -configuration Debug test -derivedDataPath DerivedData ONLY_ACTIVE_ARCH=YES
# ** TEST SUCCEEDED **
# Built product: DerivedData/Build/Products/Debug/Encore.app
# CFBundleIdentifier com.amannor.Encore, CFBundleName Encore, no SUFeedURL
```

### What the next agent must not redo

- Do not ship as `com.divisiblebyzero.Spectacle` or write shortcuts back into Application Support/Spectacle.
- Do not change the window JS or golden frames.
- Do not enable Sparkle.

## Slice 6 outcome

`scripts/release.sh 0.1.0` archives a universal ad-hoc `Encore.app` (`x86_64 arm64`), writes `dist/Encore-0.1.0.zip`, `.sha256`, and `.sbom.txt`. Sparkle is not linked. No SPM packages. `spectacleapp.com` is absent from the binary. [RELEASE.md](RELEASE.md) is the install note. `.github/workflows/release.yml` publishes those files on a `v*` tag. The tag is local until it is pushed. Homebrew cask was not added.

Preferences window title uses `Encore` plus `CFBundleShortVersionString` (`0.1.0`). The built `CFBundleVersion` is still the existing git commit count.

### Manual test (2026-09-30)

Host: macOS 27.0.1 (26A434), arm64. One display, 1512×982, notch (`safeAreaInsets.top` 32). Live `visibleFrame` `(0, 81, 1512, 868)`. That is not the Slice 4 fixture.

Intel unit tests: pass on GitHub `macos-15-intel` (x86_64, macOS 15.7.9 24G830, Xcode 16.4 16F6). Run 36761960201, `** TEST SUCCEEDED **`. That is the automated suite only. The GUI checklist below was not run on Intel.

| Item | Result |
| --- | --- |
| First launch accessibility modal | pass. `tell application "Encore" to quit` returned user canceled (-128) while the modal was up. Process then killed. |
| Grant Accessibility, shortcut moves a window | pass. `/Applications/Encore.app` only. TextEdit left half `(0, 33)` size `756×869`. |
| Revoke Accessibility | pass. With the switch off, relaunch showed the accessibility modal and shortcuts did not move the window. Granting `/Applications/Encore.app` again made option-command-left work. |
| Each default shortcut once | pass. Next/previous display is the row below. |
| Left half cycles 1/2 → 2/3 → 1/3 | pass. |
| Undo / redo | pass. |
| Next / previous display | pass. Control-option-command-right centered the window on the AirPlay display. Control-option-command-left brought it back. |
| Window wider than destination fills `visibleFrame` | pass. A window wider than this Mac filled the work area below the menu bar and above the Dock. |
| Spaces | pass. Rect unchanged after switching away and back. Option-command-left on an empty desktop did nothing. |
| Full-screen app | pass. Green-button full screen ignored the shortcut. Left half worked after leaving it. |
| Chrome / Electron / Stage Manager | pass. Brave (Chromium) left half moved the front window. Cursor (Electron) left half moved; `AXEnhancedUserInterface` was not changed. Stage Manager moved the front window only. |
| Notch fullscreen and top half | pass. Option-command-F filled the work area below the menu bar and above the Dock. Top half started under the menu bar. |

### No Sparkle network

`lsof -nP -p <Encore pid>` on first launch showed no sockets. Linked libraries are system frameworks only (`dist/Encore-0.1.0.sbom.txt` after the tagged rebuild).

### Commands

```sh
scripts/release.sh 0.1.0
# ARCHIVE SUCCEEDED at tag v0.1.0 (4755d62)
# b5e0325d5efa3ff174117a9c9703c4a97ad9588a8018806940335355fbd8bb78  dist/Encore-0.1.0.zip
```

The GitHub workflow rebuilds that tag on `macos-15` and attaches its own `.sha256`. That file, not this local hash, is the check for the downloaded zip.

### What the next agent must not redo

- Do not enable Sparkle or add a Homebrew cask.
- Do not retune geometry to this machine’s live `visibleFrame`.
- Do not re-run the GUI checklist above. It passed on 2026-10-10. Do not mark a future run passed without running it.
- Do not rerun the Intel unit job unless the suite or the workflow changes. Run 36761960201 already passed on `macos-15-intel`.
- Do not install FreeDisplay. Use the other MacBook over AirPlay, then BetterDisplay.

## Slice 7 outcome

Maintenance is a weekly issue plus Dependabot for GitHub Actions tags. Playbook: [MAINTENANCE.md](MAINTENANCE.md). ADR-011.

- `.github/workflows/obsolete.yml` — Mondays 15:00 UTC, and `workflow_dispatch`. Records SDK, Sparkle scan, `-Wdeprecated-declarations` ignores, `xcodebuild analyze`, and `runs-on` images. Opens an `obsolete` issue, or comments if one is already open. Analyze failure is still filed, then the job exits with that status.
- `.github/ISSUE_TEMPLATE/obsolete.yml` — same headings for a person.
- `.github/dependabot.yml` — weekly `github-actions` updates.

Sparkle scan of `Spectacle/`, `SpectacleSpecs/`, and `Spectacle.xcodeproj/` is empty. Deployment target is still `13.0`. Distribution consult was not written. Sparkle was not enabled. No notarization. No Homebrew cask.

The schedule does not run from this branch. GitHub runs scheduled workflows and Dependabot from `main`.

### Commands (2026-10-14, Slice 7)

```sh
git grep -n -E 'Sparkle|SUFeedURL|dsa_public\.pem|spectacleapp\.com' -- Spectacle SpectacleSpecs Spectacle.xcodeproj
# exit 1, no hits

git grep -n 'Wdeprecated-declarations' -- '*.m' '*.h'
# five ignores, unchanged

grep MACOSX_DEPLOYMENT_TARGET Spectacle.xcodeproj/project.pbxproj | sort -u
# MACOSX_DEPLOYMENT_TARGET = 13.0
```

`xcodebuild` was not re-run. The app binary did not change. Do not re-run the Slice 6 GUI checklist.

### What the next agent must not redo

- Do not rebuild the weekly workflow, the issue template, or Dependabot.
- Do not write the distribution consult unless asked.
- Do not enable Sparkle, notarize, or add a Homebrew cask.
- Do not merge to `main` or push `v0.1.0` unless asked.
