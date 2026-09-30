# Security

Report vulnerabilities privately to the maintainer of [github.com/Amannor/encore](https://github.com/Amannor/encore). Do not open a public issue for an unfixed vulnerability.

## Unsigned builds

Releases are ad-hoc signed and not notarized. Gatekeeper will block a normal double-click. Control-click the app and choose Open, then confirm. There is no auto-update: Sparkle is not linked, and this project does not use `https://spectacleapp.com/updates/appcast.xml`.

Accessibility permission is required to move windows. Grant it only for this app, bundle ID `com.amannor.Encore`.

Quit original Spectacle (`com.divisiblebyzero.Spectacle`) before launching Encore so the two apps do not register the same hotkeys.
