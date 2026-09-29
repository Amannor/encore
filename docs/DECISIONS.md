# Decisions

Architecture Decision Records for this continuation. Newest first within each ID; do not silently reverse these in later slices.

## ADR-010 — Debug may disable library validation

**Status:** accepted  
**Date:** 2026-09-29

Release entitlements are `allow-jit` and `apple-events` only. Debug adds `com.apple.security.cs.disable-library-validation` so the ad-hoc `SpectacleSpecs` bundle can load into the hardened test host. Ad-hoc signatures have no team, and library validation treats them as different teams. Do not copy the Debug key into Release.

## ADR-009 — Warnings stay errors

**Status:** accepted  
**Date:** 2026-09-29

`GCC_TREAT_WARNINGS_AS_ERRORS` stays `YES`. Do not turn it off to get a green build.

Renames that keep the same values are allowed (modifier masks, control states, alert styles, status-item button). Calls whose replacement would change behavior stay on the old API with a local `-Wdeprecated-declarations` ignore until the slice that replaces them: `LSSharedFileList` (Slice 3, `SMAppService`), `NSKeyedArchiver` secure coding, and `NSColor.windowFrameColor`.

## ADR-001 — Product name (provisional)

**Status:** accepted (provisional; finalize in Slice 5)  
**Date:** 2026-09-10

The public name will not be “Spectacle.” Working title until a human picks: **Encore**. Alternatives: Reprise, Revival, Afterpiece.

Slice 5 finalizes name, icon, and menu-bar copy. Until then, docs and the README may say “Encore (working title).”

## ADR-002 — Bundle identifier

**Status:** accepted (value TBD in Slice 5)  
**Date:** 2026-09-10

Do not ship as `com.divisiblebyzero.Spectacle`. A fresh install must not collide with original Spectacle’s Sparkle feed, defaults, or bundle ID. The new identifier is chosen in Slice 5 together with the settings importer.

The Xcode project still uses the original ID until Slice 5. Do not change it early “to get it out of the way.”

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
