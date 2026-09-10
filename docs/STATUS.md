# Status

**Last completed slice:** 0 — Bootstrap the repo and the handoff system  
**Current / next slice:** 1 — Freeze the archaeology (docs only)  
**Updated:** 2026-09-10

## Blockers / open questions for humans

- GitHub `origin` remote is not set. Add it when the continuation repository exists. `upstream` already points at the archived original.
- Final product name is not chosen. Working title: **Encore**. Alternatives recorded in ADR-001: Reprise, Revival, Afterpiece.
- Bundle ID is TBD until Slice 5. Do not ship as `com.divisiblebyzero.Spectacle`.

## Slice 0 outcome

Imported [eczarny/spectacle](https://github.com/eczarny/spectacle) **with git history** (not a file copy). `upstream` remains `https://github.com/eczarny/spectacle.git`.

**Import tip:** `e75c341ec2cba179c1bb8aa726a870c4132207df` (`Update README.md`), which is `upstream/master` at import and is an ancestor of `HEAD`. Original tags through `1.2` are present.

App behavior, Xcode project, Sparkle, bundle ID, and deployment target were **not** changed in this slice.

### Commands that passed

```sh
git remote get-url upstream
# https://github.com/eczarny/spectacle.git

git merge-base --is-ancestor e75c341ec2cba179c1bb8aa726a870c4132207df HEAD && echo "original history present"

git rev-parse upstream/master
# e75c341ec2cba179c1bb8aa726a870c4132207df

git log --oneline | wc -l
# 685 original commits at import (continuation commits sit on top)
```

No `xcodebuild` was run in Slice 0. That is Slice 1 (record the failure) and Slice 2 (make it build).

### What the next agent must not redo

- Do not re-import Spectacle or flatten / rewrite git history.
- Do not remove or retarget the `upstream` remote.
- Do not rewrite the README into AI marketing or a Rectangle clone pitch.
- Do not change app behavior, the Xcode project, Sparkle, login items, or bundle ID.
- Do not start Slice 2 until Slice 1 archaeology docs exist.

Slice 1 is **documentation only**: produce `docs/ARCHITECTURE.md` and `docs/INVENTORY.md`.
