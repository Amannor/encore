# Inventory

Privileged and sensitive surfaces. The tables below are the Slice 1 snapshot of the imported tree. The built-product notes are Slice 3 and match a Release build from 2026-09-29.

## Built product (Slice 3)

Release app, ad-hoc signature, hardened runtime. `otool -L` links only system libraries: Foundation, libobjc, libSystem, AppKit, ApplicationServices, Carbon, CoreFoundation, CoreGraphics, CoreServices, JavaScriptCore, QuartzCore, ServiceManagement. No Sparkle.

`codesign -d --entitlements :-` on Release:

- `com.apple.security.cs.allow-jit`
- `com.apple.security.automation.apple-events`

Debug adds `com.apple.security.cs.disable-library-validation` and the injected `com.apple.security.get-task-allow`. Release sets `CODE_SIGN_INJECT_BASE_ENTITLEMENTS = NO`, so it does not include `get-task-allow`.

Info.plist has `LSMinimumSystemVersion` 13.0, `LSUIElement` true, and `NSAppleEventsUsageDescription`. It has no `SUFeedURL` or other Sparkle keys. The bundle contains no `.pem`. The binary has no `spectacleapp.com` string. `Credits.rtf` still links to `https://twitter.com/spectacleapp`.

Login items use `SMAppService`. See [THREAT_MODEL.md](THREAT_MODEL.md).

## External dependencies

From `Cartfile` / `Cartfile.resolved`. Fetched with Carthage into `Carthage/Build` (gitignored).

| Dependency | Pin | Ships in `.app`? | Notes |
| --- | --- | --- | --- |
| [sparkle-project/Sparkle](https://github.com/sparkle-project/Sparkle) | 1.22.0 | Yes | Auto-update. DSA. Ancient. Network. ADR-004: disable for unsigned builds; do not keep `SUFeedURL` on spectacleapp.com. |
| [specta/specta](https://github.com/specta/specta) | v1.0.7 | No (tests) | `SpectacleSpecs` runner |
| [specta/expecta](https://github.com/specta/expecta) | v1.0.6 | No (tests) | |
| [hamcrest/OCHamcrest](https://github.com/hamcrest/OCHamcrest) | v7.1.2 | No (tests) | |
| [jonreid/OCMockito](https://github.com/jonreid/OCMockito) | v5.1.2 | No (tests) | |

No CocoaPods, no Swift Package Manager, no nested git submodules.

System frameworks used from source (not Carthage): AppKit, Foundation, Carbon, ApplicationServices/HIServices (AX), JavaScriptCore, ServiceManagement-era login-item API via `LSSharedFileList` (LaunchServices).

## Network

| What | Where | Detail |
| --- | --- | --- |
| Sparkle appcast | `Spectacle/Supporting Files/Info.plist` keys `SUFeedURL`, `SUEnableAutomaticChecks`, `SUAllowsAutomaticUpdates`, `SUPublicDSAKeyFile` | URL **`https://spectacleapp.com/updates/appcast.xml`**. Automatic checks **on**. Automatic *installs* off. |
| Sparkle runtime | `SpectacleAppDelegate.m` (`#import <Sparkle/Sparkle.h>`, `[[SUUpdater sharedUpdater] setAutomaticallyChecksForUpdates:]`) | Driven by UserDefaults `AutomaticUpdateCheckEnabled` (default **true** in `Defaults.plist`). |
| DSA public key | `Spectacle/Resources/Certificates/dsa_public.pem` | Sparkle 1 update signature. Remove from shipping path in Slice 3. |
| App-authored HTTP/S | *(none found)* | No `NSURLSession`, `NSURLConnection`, or custom `NSURLRequest` in `Spectacle/Sources`. All network is Sparkle. |

There is no first-party analytics or crash reporter in source.

## Filesystem

| Path / API | Where | Detail |
| --- | --- | --- |
| `~/Library/Application Support/Encore/Shortcuts.json` | `SpectacleShortcutJSONStorage.m` | Create dir + atomic write of shortcut name/key-binding JSON. Importer may copy from `Application Support/Spectacle/Shortcuts.json` once. |
| `NSUserDefaults` (suite = bundle ID `com.amannor.Encore`) | `SpectacleShortcutUserDefaultsStorage.m`, `SpectacleAppDelegate.m`, `SpectaclePreferencesController.m`, `SpectacleUtilities.m` | Legacy shortcut storage; `DisabledApplications`; `StatusItemEnabled`; `AutomaticUpdateCheckEnabled`; `BackgroundAlertSuppressed`; `BlacklistedApplications`. |
| Registered defaults | `Spectacle/Resources/Property Lists/Defaults.plist` loaded by `+[SpectacleUtilities registerDefaultsForBundle:]` | Blacklist includes Photoshop, Steam, and Spectacle itself. |
| Bundled JS (read-only) | `Spectacle/Resources/Window Position Calculations/*.js` | Loaded from the app bundle only (`NSBundle` `pathsForResourcesOfType:inDirectory:`). |
| Bundled AppleScript (read-only) | `Spectacle/Resources/Scripts/Security & Privacy System Preferences.scpt` (and `… Original.scpt`) | See Launch / AppleScript. |
| Preference pane lookup | `+[SpectacleUtilities pathForPreferencePaneNamed:]` | Reads `NSPreferencePanesDirectory` to find `Security.prefPane` as fallback if AppleScript fails. |

No writes outside Application Support + UserDefaults were found. No `NSTask` / `posix_spawn` / `system(` / `popen`.

## Accessibility

| API | Where | Detail |
| --- | --- | --- |
| `AXIsProcessTrustedWithOptions(NULL)` | `SpectacleAppDelegate.m` ~118 | Trust prompt at launch. `NULL` options means the system dialog is **not** requested via `kAXTrustedCheckOptionPrompt`; the app shows its own window. |
| `AXUIElementCreateApplication` | `SpectacleAccessibilityElement.m` | Frontmost app PID from `NSWorkspace`. |
| `kAXFocusedWindowAttribute` | same | Target window. |
| `kAXPositionAttribute` / `kAXSizeAttribute` get+set | `rectOfElement` / `setRectOfElement:` | The only AX writes. Size is set twice around position (legacy workaround). |
| `kAXRoleAttribute` / `kAXSubroleAttribute` | `isSheet` / `isSystemDialog` | Skip sheets and system dialogs. |

No `AXEnhancedUserInterface` toggle (Rectangle uses this for Electron; Slice 4 should note the gap). No other AX attributes are set.

## JavaScriptCore

| API | Where | Detail |
| --- | --- | --- |
| `JSContext` + `evaluateScript:` | `SpectacleJavaScriptEnvironment.m` | Scripts come only from bundled `*.js` via `stringWithContentsOfFile`. |
| `JSExport` registry | `SpectacleWindowPositionCalculationRegistry.h` | JS calls `registerWindowPositionCalculationWithAction`. |
| Host functions | `SpectacleWindowPositionCalculator.m` | CGRect helpers only. No `eval` of UserDefaults, no fetching URLs, no filesystem from JS. |

**Containment claim to verify in Slice 3:** JavaScriptCore only loads bundled calculation scripts. Source review supports that; confirm no other `evaluateScript` / `JSEvaluateScript` call sites (grep in this slice found only the environment + calculator).

JS files (all under `Spectacle/Resources/Window Position Calculations/`):

- Action calculators: `SpectacleLeftHalfWindowCalculation.js`, `RightHalf`, `TopHalf`, `BottomHalf`, `UpperLeft`, `UpperRight`, `LowerLeft`, `LowerRight`, `Center`, `Fullscreen`, `Larger`, `Smaller`, `NextThird`, `PreviousThird`, `NextDisplay`, `PreviousDisplay`
- Shared: `SpectacleWindowCalculationHelpers.js`, `SpectacleWindowSizeAdjuster.js`, `SpectacleNextOrPreviousThirds.js`, `SpectacleNextOrPreviousDisplay.js`

## Launch, login, AppleScript

| Mechanism | Where | Detail |
| --- | --- | --- |
| Session login items | `SpectacleLoginItemHelper.m` | `LSSharedFileListCreate(… kLSSharedFileListSessionLoginItems …)`, insert/remove the running `.app` URL. Deprecated; Slice 3 replaces with `SMAppService` (ADR-003, macOS 13+). |
| AppleScript | `SpectacleAppDelegate.m` `openSystemPreferences:` | `NSAppleScript` `initWithContentsOfURL:` on bundled `Security & Privacy System Preferences.scpt`, `executeAndReturnError:`. Fallback: `NSWorkspace openURL` on `Security.prefPane`. Intended to jump to Privacy → Accessibility. |
| `LSUIElement` | `Info.plist` | Accessory / background app. |

## Global hotkeys (not IPC, still privileged)

`SpectacleShortcutManager.m`: Carbon `InstallEventHandler` + `RegisterEventHotKey` / `UnregisterEventHotKey`. Hotkey signature `'ZERO'` (also `CFBundleSignature` in Info.plist). This is how shortcuts work when Spectacle is not focused. Not XPC, not distributed objects.

## IPC

No `NSXPCConnection`, `NSConnection`, `NSDistributedNotificationCenter`, or Mach ports in `Spectacle/Sources`. In-process `NSNotificationCenter` and `NSWorkspace` activation notifications only.

## Code signing / entitlements (as shipped in source)

| Setting | Where | Detail |
| --- | --- | --- |
| `CODE_SIGN_IDENTITY = "-"` | `project.pbxproj` Debug+Release | Ad-hoc. |
| Entitlements file | *(none in tree)* | No `.entitlements`. No hardened runtime flags in the pbxproj. |
| Architectures | pbxproj | No explicit `ARCHS` / `VALID_ARCHS`. `ONLY_ACTIVE_ARCH = YES` at project Debug level. Last official binary was Intel (`com.divisiblebyzero.Spectacle`). |
| Deployment | pbxproj + Info.plist | `MACOSX_DEPLOYMENT_TARGET = 10.9`. Slice 2 will set 13+ (ADR-003) in the project file. |

## Compiler / SDK baseline (this machine, 2026-09-10)

Host: macOS **26.6.2** (25G83), **arm64**.

```text
$ xcode-select -p
/Library/Developer/CommandLineTools

$ xcodebuild -version
xcode-select: error: tool 'xcodebuild' requires Xcode, but active developer directory
'/Library/Developer/CommandLineTools' is a command line tools instance

$ ls /Applications/Xcode*.app
(no matches)

$ clang --version
Apple clang version 21.0.0 (clang-2100.1.1.101)
Target: arm64-apple-darwin25.6.0

$ pkgutil --pkg-info=com.apple.pkg.CLTools_Executables
version: 26.6.0.0.1781586589
```

**Baseline result:** `xcodebuild` does not run. There is no Xcode.app. Carthage has not been bootstrapped (`Carthage/Build` absent). Warnings, architectures, and analyzer findings are therefore **not** available on this machine until full Xcode is installed.

The 2026-09-10 baseline above is historical. As of 2026-09-29, Xcode 27.0 is installed and `xcodebuild -scheme Spectacle build` succeeds (`x86_64 arm64`). See [STATUS.md](STATUS.md).

## Static tools for later slices

After Xcode exists:

1. `xcodebuild -scheme Spectacle -destination 'platform=macOS' build` then `analyze` (`clang static analyzer` / Product → Analyze).
2. `otool -L Spectacle.app/Contents/MacOS/Spectacle` — linked dylibs / Sparkle.
3. `codesign -d --entitlements :- -vv` on any `.app` produced.
4. `strings` on the binary for leftover `spectacleapp.com` / `SUFeedURL`.
5. SBOM once SPM/Sparkle 2 (or no Sparkle) is in play (Slice 3/6): list resolved package versions next to the tag.

Do not run those as a substitute for the missing Xcode baseline; they need a built product.
