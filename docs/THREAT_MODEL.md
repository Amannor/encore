# Threat model

Slice 3 record for the unsigned, hardened-runtime build. The app is still named Spectacle and still uses bundle ID `com.divisiblebyzero.Spectacle` until Slice 5.

## What the app is allowed to do

- Move other apps’ windows through the Accessibility API, after the user grants access.
- Read and write shortcut JSON under `~/Library/Application Support/Spectacle/` and `NSUserDefaults`.
- Register or remove itself as a login item through `SMAppService.mainAppService`.
- Run bundled JavaScript geometry with JavaScriptCore. JIT is allowed (`com.apple.security.cs.allow-jit`).
- Run one bundled AppleScript that opens Security & Privacy settings. Sending Apple Events is allowed (`com.apple.security.automation.apple-events`) and `NSAppleEventsUsageDescription` is set.

The app is not sandboxed. Sandboxing would block the Accessibility window moves this program exists to do.

## What it must not do

- Check for updates or contact `spectacleapp.com`. Sparkle is not linked. `SUFeedURL` is not in Info.plist. `dsa_public.pem` is not in the bundle. The status-item “Check for Updates…” item is gone.
- Load JavaScript from the network or from an arbitrary path. The only `evaluateScript:` call loads `Contents/Resources/Window Position Calculations/*.js` and rejects a path outside that directory.
- Open a network connection of its own. There is no `NSURLSession` or `NSURLConnection` in `Spectacle/Sources`.

`Credits.rtf` still contains a hyperlink to `https://twitter.com/spectacleapp`. That is credit text, not a client.

`AutomaticUpdateCheckEnabled` remains in `Defaults.plist` and is not read. It does not start a request.

## Signing

Release (`Spectacle.entitlements`), ad-hoc, hardened runtime, `CODE_SIGN_INJECT_BASE_ENTITLEMENTS = NO`:

- `com.apple.security.cs.allow-jit`
- `com.apple.security.automation.apple-events`

Debug (`Spectacle-Debug.entitlements`) adds `com.apple.security.cs.disable-library-validation` so the ad-hoc `SpectacleSpecs` bundle can load into the test host (ADR-010). Do not copy that key into Release.

## Analyzer

`xcodebuild analyze` on 2026-09-29 reported one warning: the unexpected-error alert in `SpectacleAppDelegate.m` is not a localized string. That is not a security defect. Left as-is.

## Left for later

- Bundle ID still matches original Spectacle (Slice 5).
- `NSKeyedArchiver` still uses the pre-secure API for shortcut defaults (ADR-009).
- Notarization and a real Developer ID are out of scope until a later release.
