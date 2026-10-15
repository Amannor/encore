# Maintenance

Keep Encore alive in small sessions. One concern at a time. Distribution outreach is a separate consult and is not part of this playbook.

The weekly check and Dependabot read their config from the repository default branch (`main`). These files land on `cursor/build-and-xctest` first. The schedule starts after they are on `main`. Until then, run the `obsolete` workflow with `workflow_dispatch` only once that file is on `main` (GitHub shows the workflow from the default branch).

## 1. Issue

A report already exists, or you open one.

- Every Monday, `.github/workflows/obsolete.yml` records the SDK, a Sparkle scan, deprecated-API ignores plus `xcodebuild analyze`, and the pinned runner images. It opens an issue labeled `obsolete`, or comments on the open one.
- Dependabot (`.github/dependabot.yml`) opens pull requests when a GitHub Action tag is stale. Those PRs are the action-tag half. The runner image (`macos-15`, `macos-15-intel`) is the issue’s job.
- A person can file the same headings with `.github/ISSUE_TEMPLATE/obsolete.yml`.

Read the issue before editing. Sparkle staying absent is the healthy result. A hit under `Spectacle/`, `SpectacleSpecs/`, or `Spectacle.xcodeproj/` is the bug.

## 2. Investigate

Read [STATUS.md](STATUS.md), the slice you were asked to do in [SLICES.md](SLICES.md), [DECISIONS.md](DECISIONS.md), and [AGENTS.md](../AGENTS.md).

Stay on the concern in the issue. Leave window math, legacy expected frames, and the modern-display goldens alone. Shortcut display tests need the ABC input source.

## 3. Patch

Smallest change that answers the issue. One concern per commit.

- Do not enable Sparkle, put `SUFeedURL` back, or point an updater at spectacleapp.com (ADR-004).
- Do not notarize, and do not add a Homebrew cask.
- Do not turn warnings off (ADR-009). A deprecated call whose replacement would change behavior stays, with the local ignore, until a slice replaces it.
- Do not rewrite the app in Swift.

## 4. Tests

Shortcut display tests need input source `com.apple.keylayout.ABC`.

```sh
xcodebuild -scheme Spectacle -destination 'platform=macOS' -configuration Debug test -derivedDataPath DerivedData ONLY_ACTIVE_ARCH=YES
```

## 5. Analyze

```sh
xcodebuild -scheme Spectacle -destination 'platform=macOS' -configuration Debug analyze -derivedDataPath DerivedData ONLY_ACTIVE_ARCH=YES
```

## 6. Human review

A person reviews the patch before any tag. Do not push a `v*` tag unless asked. Pushing one runs `.github/workflows/release.yml` and publishes the zip. Tag `v0.1.0` is already the first release; do not move it.

## 7. Release

When a human asks for a new version, follow [RELEASE.md](RELEASE.md):

```sh
scripts/release.sh <version>
```

The build stays ad-hoc and unnotarized. There is no auto-update.
