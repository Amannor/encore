# Handoff

A new agent (or human) should be able to continue from a clone of this repository without the original planning chat.

You still need nothing from a human to keep building. The public name is **Encore** (`com.amannor.Encore`).

`origin` is `git@github.com:Amannor/encore.git` (https://github.com/Amannor/encore). `upstream` is the archived original. The app builds with Xcode 27 and `SpectacleSpecs` passes. Next work is Slice 7. Tag `v0.1.0` is the unsigned release; push it for GitHub Actions to publish the zip.

## What this project is

Bring Spectacle back as a **minimal, secure, reproducibly built macOS window manager that preserves original Spectacle behavior**.

- Unofficial continuation of [eczarny/spectacle](https://github.com/eczarny/spectacle) (archived January 2023, last release **1.2**).
- Keep original Objective-C + bundled JavaScript geometry. Do not rewrite in Swift.
- Do not copy Rectangle features. Rectangle is a reading reference for modern macOS quirks only.
- MIT license; keep Eric Czarny’s copyright.
- First public cut may be unsigned / ad-hoc. Notarization later. No Sparkle against spectacleapp.com.

## Start of every session

Read, in order:

1. [STATUS.md](STATUS.md) — current slice, last completed slice, blockers
2. [SLICES.md](SLICES.md) — acceptance criteria for the slice you are on
3. [DECISIONS.md](DECISIONS.md) — ADRs
4. [../AGENTS.md](../AGENTS.md) — conventions and stop conditions

Do **only** the current slice. If it is too big, split it in `SLICES.md` and finish the first half.

## End of every session

- Mark the slice done or partially done in `STATUS.md`
- Record any new ADR in `DECISIONS.md`
- List exact commands that pass (build, test, analysis)
- List what the next agent should **not** redo
- Do **not** start the next slice unless the user asks

## Git remotes

```sh
git remote get-url origin
# expected: git@github.com:Amannor/encore.git

git remote get-url upstream
# expected: https://github.com/eczarny/spectacle.git
```

`upstream` must keep pointing at the archived original so history and tags stay attributable. Do not force-push to `upstream`. Do not flatten original history.

## Verify original history is present

```sh
git merge-base --is-ancestor e75c341ec2cba179c1bb8aa726a870c4132207df HEAD && echo "original history present"
git log --oneline --max-count=5
git tag --list '1.*'
```

Import tip of archived `master` was `e75c341` (tag `1.2` is `eacf5bb`, an ancestor of that tip).

## What is intentionally unfinished

| Topic | When |
| --- | --- |
| App build on current Xcode / universal binary | Slice 2 (done) |
| `SpectacleSpecs` on XCTest, drop Carthage, CI | Slice 2b (done) |
| Sparkle disabled, hardened runtime, `SMAppService` | Slice 3 (done) |
| Golden geometry tests, compatibility notes | Slice 4 (done) |
| Final name, bundle ID, settings importer | Slice 5 (done) |
| GitHub Release zip + checksums | Slice 6 (done) |
| Maintenance automation / outreach | Slice 7 |

The app target builds on Xcode 27 as a universal binary (macOS 13+, Sparkle unlinked) and `SpectacleSpecs` runs on XCTest. Bundle ID is `com.amannor.Encore`. The built product is `Encore.app`.
