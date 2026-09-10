# Agent conventions

This repository is an unofficial continuation of [eczarny/spectacle](https://github.com/eczarny/spectacle). If you are starting a new session, begin with [docs/HANDOFF.md](docs/HANDOFF.md).

## Before you change anything

Read, in order:

1. [docs/STATUS.md](docs/STATUS.md) — current slice, last completed slice, blockers
2. [docs/SLICES.md](docs/SLICES.md) — acceptance criteria for the slice you are on
3. [docs/DECISIONS.md](docs/DECISIONS.md) — ADRs (name, bundle ID, min macOS, Sparkle)
4. This file — conventions and stop conditions

## Session size

One slice per agent instance. If a slice is too big, split it in `docs/SLICES.md` and finish the first half rather than silently absorbing the next slice. Do not start the next slice unless the user asks.

## Architecture (do not reverse)

- Keep the original Objective-C architecture and JavaScript geometry engine.
- Do not rewrite in Swift.
- Do not copy Rectangle features (drag-to-snap, extra actions, thirds redesign). Use [Rectangle](https://github.com/rxhanson/Rectangle) only as a reference oracle for modern macOS quirks.
- Keep the JS calculators; they are the behavior spec and already have specs.
- When in doubt, disable a modern-hostile subsystem (Sparkle) rather than rewrite window math.
- Prefer one reviewable commit per concern (for example project file vs Sparkle vs login items).

## Do not

- Market this as “modernized by Cursor” or make AI the product story.
- Point Sparkle at `https://spectacleapp.com/updates/appcast.xml`.
- Keep Sparkle enabled while shipping unsigned builds.
- Add Rectangle features “while we’re in there.”
- Change window math because a test looks old.
- Replace Eric Czarny’s MIT copyright on original files.

## Coding style

Match existing Spectacle style. Original contributors used two spaces for indentation in Objective-C; keep that in files you touch. New source files are MIT: keep Eric Czarny’s copyright on original files and add the current maintainer’s copyright on new source files (see ADR-007).

## End of every session (mandatory)

- Mark the slice done or partially done in `docs/STATUS.md`
- Record any new ADR in `docs/DECISIONS.md`
- List exact commands that pass (build, test, analysis)
- List what the next agent should **not** redo
- Do **not** start the next slice unless the user asks
