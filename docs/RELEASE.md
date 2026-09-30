# Release

Encore `v0.1.0` is an ad-hoc signed, unnotarized build. There is no auto-update. Sparkle is not in the app, and this project does not use `https://spectacleapp.com/updates/appcast.xml`.

Homebrew cask is out of scope until the app is notarized.

## Install

1. Download `Encore-0.1.0.zip` and `Encore-0.1.0.sha256` from the GitHub Release for tag `v0.1.0`. That tag is the source tree the workflow archived.
2. Verify the zip:

```sh
shasum -a 256 -c Encore-0.1.0.sha256
```

3. Unzip. Gatekeeper blocks a normal double-click. Control-click `Encore.app`, choose Open, then confirm.
4. Quit original Spectacle before the first launch. Both apps use the same shortcuts.
5. Grant Accessibility when asked. System Settings → Privacy & Security → Accessibility.

`Encore-0.1.0.sbom.txt` lists linked libraries. Sparkle and Swift Package Manager versions are none.

## Local archive

```sh
scripts/release.sh 0.1.0
```

Outputs under `dist/` are not committed. The checksum belongs to that zip. A later archive of the same tag can differ by signature and zip timestamps; use the checksum published next to the zip.
