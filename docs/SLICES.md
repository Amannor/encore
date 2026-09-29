# Slices

Work proceeds one slice per agent session. Split a slice here if it is too large; finish the first half rather than absorbing the next slice.

## Slice 0 — Bootstrap the repo and the handoff system

**Status:** complete (see [STATUS.md](STATUS.md))

**Goal:** A new agent can clone this repo and know what to do without the original planning chat.

**Work**

- Import [eczarny/spectacle](https://github.com/eczarny/spectacle) with git history. Keep `upstream` pointing at the archived original.
- Add `AGENTS.md`, `docs/STATUS.md`, `docs/SLICES.md`, `docs/DECISIONS.md`, `docs/HANDOFF.md`, and `.cursor/rules/continuation.mdc` without changing app behavior.
- Rewrite the README as a working README: unofficial continuation, MIT + original author credit, “not Rectangle,” no AI marketing, not yet a release.
- Record provisional name **Encore**, min macOS **13+**, new bundle ID TBD.

**Acceptance**

- `git log` still contains original Spectacle history.
- STATUS.md says Slice 0 complete, Slice 1 is next.
- A stranger can follow HANDOFF.md without asking anything except GitHub remote + final product name.

## Slice 1 — Freeze the archaeology (docs only)

**Status:** complete (see [STATUS.md](STATUS.md))

**Goal:** A complete map before anyone “fixes” anything. **No functional code changes.**

Produce [ARCHITECTURE.md](ARCHITECTURE.md) and [INVENTORY.md](INVENTORY.md) covering:

- Every external dependency (Cartfile: Sparkle 1.22.0, plus test-only Specta/Expecta/OCHamcrest/OCMockito)
- Privileged / sensitive surfaces: Accessibility (`SpectacleAccessibilityElement`), JavaScriptCore (`SpectacleJavaScriptEnvironment` + bundled JS), filesystem (shortcut JSON), login items (`SpectacleLoginItemHelper`), Sparkle network + DSA key, IPC if any
- Window pipeline: JS calculations → `SpectacleWindowPositionCalculator` → `SpectacleWindowPositionManager` → mover chain (`Standard` / `Quantized` / `BestEffort`) → AX write
- Existing tests in `SpectacleSpecs` (already one spec per action, plus shortcuts)
- Compiler/SDK baseline: try a dry `xcodebuild` and record the exact failure, warnings, and architectures
- Recommended static tools for later: `clang-analyzer` / Xcode analyze, later `codesign -d --entitlements`, SBOM once Sparkle is gone or upgraded

**Acceptance**

- INVENTORY.md lists every network, filesystem, AX, JS, and launch path with file paths.
- ARCHITECTURE.md is enough that Slice 2 does not have to rediscover the JS engine.
- Still no behavior change.

## Slice 2 — Make the app build on current Xcode

**Status:** complete (see [STATUS.md](STATUS.md))

**Goal:** Universal `Spectacle.app` on a current Mac. Still no intentional behavior change.

**Done**

- Deployment target 13.0, `ARCHS = $(ARCHS_STANDARD)` (`arm64` + `x86_64`).
- Sparkle unlinked. `SUFeedURL` and the other Sparkle Info.plist keys removed.
- Deprecated constants with the same values renamed. Login items, keyed archives, and `windowFrameColor` still use the old calls under a local deprecation ignore (ADR-009). Slice 3 replaces login items.

**Acceptance**

- `xcodebuild -scheme Spectacle -destination 'platform=macOS' build` succeeds.
- The Debug binary is `x86_64 arm64`.
- STATUS.md records the Xcode version and that Sparkle is disabled.

## Slice 2b — Tests and CI

**Status:** complete (see [STATUS.md](STATUS.md))

**Goal:** `SpectacleSpecs` green, without Carthage.

**Work**

- Specta, Expecta, OCHamcrest, and OCMockito do not build here (no `Carthage/Build`). Port the existing spec files to XCTest. Keep the expected frames. `SpectacleWindowPositionManagerSpec` uses OCMockito and needs a hand port.
- Drop Carthage (`Cartfile`, `Cartfile.resolved`) once nothing links those frameworks.
- GitHub Actions: `macos-15` (or latest), `xcodebuild test`, no Travis.
- Remove `.travis.yml` when CI replaces it.

**Acceptance**

- `xcodebuild -scheme Spectacle -destination 'platform=macOS' test` passes on Apple Silicon.
- CI runs that command.

Do not start Slice 3 until Slice 2b’s test acceptance is met. Do not change expected frames while porting specs.

## Slice 3 — Security hardening without new features

**Goal:** A trustworthy unsigned app, not a Sparkle attack surface.

**Work**

- **Disable auto-update** until there is a feed you control and (later) signing. Remove DSA public key from the shipping path. Do not leave `SUFeedURL` pointing at spectacleapp.com.
- If Sparkle remains in the tree, upgrade to Sparkle 2 via SPM and keep it compiled out of unsigned builds; otherwise delete it until Slice 6/notarization.
- Hardened runtime + entitlements appropriate for an Accessibility menu-bar app. Privacy strings (`NSAppleEventsUsageDescription` if needed).
- Replace `LSSharedFileList` login items with `SMAppService` (macOS 13+).
- Confirm JavaScriptCore only loads **bundled** calculation scripts (no user JS, no network JS).
- Cross-check the Slice 1 inventory with Xcode Analyze. File findings in [THREAT_MODEL.md](THREAT_MODEL.md); fix high-confidence issues; leave disputed ones as ADRs.

**Acceptance**

- `strings` / `otool` / `codesign -d --entitlements` notes in INVENTORY.md match the built `.app`.
- No network client in the default unsigned build except what you explicitly document (ideally none).
- Existing geometry/shortcut tests still pass.

## Slice 4 — Behavior lock and Rectangle as oracle

**Goal:** Prove “this is still Spectacle,” and know where modern macOS / Rectangle differ.

**Work**

- Turn existing `SpectacleSpecs` into a **golden** suite: given display `2560×1440` (and a notched / menu-bar visible-frame case), action X ⇒ frame Y. Keep the JS files as the source of truth.
- Write [COMPATIBILITY.md](COMPATIBILITY.md): one row per Spectacle action (halves, corners, thirds cycling, larger/smaller, center, fullscreen, next/prev display, undo/redo) with columns: original spec, this app, Rectangle, modern macOS notes (Stage Manager, visibleFrame vs frame, AXEnhancedUserInterface / Electron).
- [MANUAL_TEST.md](MANUAL_TEST.md): Accessibility grant, shortcuts, multi-display, Spaces, full-screen apps, Chrome/Electron. This is the E2E stand-in until notarized UI automation is worth it.

**Acceptance**

- Automated geometry tests cover every JS calculator.
- COMPATIBILITY.md states **intentional** differences (should be empty or only OS-forced).
- Manual checklist is runnable in ~20 minutes.

## Slice 5 — Product identity (new name, new ID, migrate settings)

**Goal:** Ship as a continuation, not an impostor of `com.divisiblebyzero.Spectacle`.

**Work**

- Finalize name (Encore or your pick), bundle ID, icon, menu-bar copy.
- One-shot importer: read old Spectacle defaults / shortcut JSON if present; do not fight a still-running original Spectacle (document “quit Spectacle first”).
- README for humans: “If you loved Spectacle, this is that app, maintained. It is not Rectangle.” Credit eczarny. Link differences.
- SECURITY.md: how to report issues; unsigned-build caveats (Gatekeeper, no Sparkle).

**Acceptance**

- Fresh install does not collide with original Sparkle / bundle ID.
- Documented migration path from original Spectacle shortcuts.
- Tests still pass; new importer has unit tests on fixture defaults.

## Slice 6 — First public (unsigned) release and E2E

**Goal:** A GitHub Release someone can download, plus evidence it corresponds to a git tag.

**Work**

- Script: `xcodebuild` archive → ad-hoc or Developer ID-unsigned zip, SHA-256, SBOM-lite (embedded Sparkle/SPM versions).
- Tag `v0.1.0`. GitHub Actions publishes the zip + checksums.
- Run MANUAL_TEST.md on current macOS (and note Intel if you have it).
- [RELEASE.md](RELEASE.md): Gatekeeper right-click-open instructions; “no auto-update”; how to verify checksum.

Homebrew cask is **out of scope** until notarization (Homebrew will not want unsigned Accessibility apps).

**Acceptance**

- Tag, zip, checksum, and source tree are documented as corresponding.
- Manual E2E checklist filled in STATUS.md (pass/fail per item).
- No Sparkle network on first launch (tcpdump / Little Snitch / `log` — pick one and record it).

## Slice 7 — Maintenance workflow (and later, spreading the word)

**Goal:** The project can be kept alive in small agent sessions.

**Work**

- Dependabot / GitHub Action: weekly “what is obsolete” issue template (SDK, Sparkle, deprecated APIs, GitHub Actions image).
- Playbook: issue → investigate → patch → tests → analyze → human review → release.
- After Slice 6 exists, a **separate** consult (not implementation work in that session) on distribution: HN “Show HN”, r/macapps, MacRumors, “Spectacle unmaintained” search intercept, AlternativeTo, direct outreach to people still linking spectacleapp.com. Do not spend implementation quota on marketing copy until the app is real.
