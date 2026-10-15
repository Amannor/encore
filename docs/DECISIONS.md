# Decisions

Architecture Decision Records for this continuation. Newest first within each ID; do not silently reverse these in later slices.

## ADR-013 — In-app updates wait for Developer ID

**Status:** accepted  
**Date:** 2026-10-15

Encore does not check for updates while the build is ad-hoc. An updater that installs code into an unsigned Accessibility app is the Sparkle risk ADR-004 already rejects.

The shipping original, Spectacle 1.2, is signed `Developer ID Application: Eric Czarny (P8TAT4Q25S)` on 2016-12-22. The git tree is ad-hoc. The zip has no stapled notarization ticket. Its Sparkle feed is `https://spectacleapp.com/updates/appcast.xml`, which this project does not own.

When the maintainer has an Apple Developer Program membership, the update path is Developer ID, notarization, then Sparkle 2 with an appcast hosted by this project. Forum posts wait for that notarized build.

## ADR-012 — Menu-bar mark is a new template

**Status:** accepted  
**Date:** 2026-10-14

The menu-bar image is the only icon Encore shows. It is now a black spotlight silhouette named `Encore Status Item`, drawn in new files, with `setTemplate:YES`. Eric Czarny’s glasses stay in `Spectacle Status Item.imageset` and are not loaded. The Finder icon is unchanged. This supersedes the menu-bar half of ADR-001. A new build changes the signature hash, so Accessibility must be granted again for that binary.

## ADR-011 — Maintenance checks stay operational

**Status:** accepted  
**Date:** 2026-10-14

Slice 7 adds a weekly obsolescence issue and Dependabot for GitHub Actions tags. The issue covers the SDK, Sparkle’s continued absence, deprecated APIs, and the Actions runner image. It does not re-enable Sparkle, notarize, or add a Homebrew cask. Distribution outreach stays a separate consult and is not started from the weekly issue.

The schedule and Dependabot read config from the default branch (`main`). Landing the files on `cursor/build-and-xctest` does not start the schedule.

## ADR-010 — Debug may disable library validation

**Status:** accepted  
**Date:** 2026-09-29

Release entitlements are `allow-jit` and `apple-events` only. Debug adds `com.apple.security.cs.disable-library-validation` so the ad-hoc `SpectacleSpecs` bundle can load into the hardened test host. Ad-hoc signatures have no team, and library validation treats them as different teams. Do not copy the Debug key into Release.

## ADR-009 — Warnings stay errors

**Status:** accepted  
**Date:** 2026-09-29

`GCC_TREAT_WARNINGS_AS_ERRORS` stays `YES`. Do not turn it off to get a green build.

Renames that keep the same values are allowed (modifier masks, control states, alert styles, status-item button). Calls whose replacement would change behavior stay on the old API with a local `-Wdeprecated-declarations` ignore until the slice that replaces them: `LSSharedFileList` (Slice 3, `SMAppService`), `NSKeyedArchiver` secure coding, and `NSColor.windowFrameColor`.

## ADR-001 — Product name

**Status:** accepted  
**Date:** 2026-09-10, finalized 2026-09-30

The public name is **Encore**. It is not “Spectacle.” The menu bar, bundle name, and `Encore.app` use that name. The Finder icon stays the original. The menu-bar template is ADR-012.

## ADR-002 — Bundle identifier

**Status:** accepted  
**Date:** 2026-09-10, finalized 2026-09-30

The bundle ID is `com.amannor.Encore`. Do not ship as `com.divisiblebyzero.Spectacle`. Shortcuts live in `~/Library/Application Support/Encore/`. A one-shot importer reads the old JSON file or the old defaults domain and does not write back to them. Quit original Spectacle before launching Encore.

## ADR-003 — Minimum macOS version

**Status:** accepted  
**Date:** 2026-09-10

Target **macOS 13+**. That is required for `SMAppService` login-item replacement (Slice 3). Revisit only if a human explicitly wants older releases; that would keep a deprecated login-item API in play.

The imported Xcode project still declares 10.9. Slice 2 applies 13+ to the project file.

## ADR-004 — Sparkle / auto-update

**Status:** accepted  
**Date:** 2026-09-10

- Do not point Sparkle at `https://spectacleapp.com/updates/appcast.xml` (this project does not own that feed).
- Do not keep Sparkle enabled while shipping unsigned builds.
- Unsigned / ad-hoc GitHub releases are acceptable for the first public cut. Notarization comes later.
- Slice 2 may stub or disable Sparkle rather than “fix” updates. Slice 3 removes the DSA public key from the shipping path and either compiles Sparkle 2 out of unsigned builds or deletes Sparkle until Slice 6.

## ADR-005 — Keep Objective-C and the JavaScript geometry engine

**Status:** accepted  
**Date:** 2026-09-10

Option A: keep the original Objective-C architecture and JavaScript calculators. Do not rewrite in Swift. Existing Apple Silicon forks that only recompile for arm64, or that rewrite in Swift, are not this project.

The JS files under `Spectacle/Resources/Window Position Calculations/` are the behavior spec. Do not change window math because a test looks old. If Specta cannot be revived, port specs to XCTest **without changing expected frames**.

## ADR-006 — Rectangle is an oracle, not a source

**Status:** accepted  
**Date:** 2026-09-10

Use [rxhanson/Rectangle](https://github.com/rxhanson/Rectangle) only as a reference for modern macOS quirks. Do not copy Rectangle features (drag-to-snap, extra actions, thirds redesign). Do not paste Rectangle source. Slice 4 records differences in COMPATIBILITY.md; intentional differences should be empty or only OS-forced.

## ADR-007 — License and copyright

**Status:** accepted  
**Date:** 2026-09-10

Original license is MIT ([LICENSE.md](../LICENSE.md)). Keep Eric Czarny’s copyright on original files. New source files added by this continuation are also MIT and should carry the current maintainer’s copyright in addition to the MIT terms. Maintainer legal name on new files is set when product identity is finalized (Slice 5), not invented in Slice 0.

## ADR-008 — AI is not the product story

**Status:** accepted  
**Date:** 2026-09-10

This is a minimal, secure, reproducibly built macOS window manager that preserves original Spectacle behavior. Do not market it as “modernized by Cursor.” AI is a maintainer tool.
