# Manual test

About 20 minutes. Geometry is already locked by XCTest. This checks Accessibility, shortcuts, and macOS cases the unit tests do not launch.

Build the Release app with `scripts/release.sh 0.1.0` and open `dist` after unzipping `Encore-0.1.0.zip`, or open `build/Encore.xcarchive/Products/Applications/Encore.app`. Quit original Spectacle first if it is running.

Mark each box pass or fail. Note the macOS version and whether the machine is Apple silicon or Intel.

## Accessibility

- [ ] First launch shows the Accessibility prompt (not when `XCTestConfigurationFilePath` is set).
- [ ] After granting access in System Settings → Privacy & Security → Accessibility, a shortcut moves a normal window.
- [ ] Revoke access, relaunch: shortcuts do not move windows. Grant it again.

## Shortcuts

One resizable window (TextEdit). Defaults from `SpectacleDefaultShortcutHelpers`:

| Action | Shortcut |
| --- | --- |
| Left / right half | option-command-left / right |
| Top / bottom half | option-command-up / down |
| Upper left / upper right | control-command-left / right |
| Lower left / lower right | control-shift-command-left / right |
| Center | option-command-C |
| Fullscreen | option-command-F |
| Next / previous third | control-option-right / left |
| Larger / smaller | control-option-shift-right / left |
| Next / previous display | control-option-command-right / left |
| Undo / redo | option-command-Z / option-shift-command-Z |

- [ ] Each shortcut above moves that window once.
- [ ] Left half three times cycles half → two thirds → one third, then half again.
- [ ] Undo restores the previous rect. Redo reapplies it.

## Multi-display

- [ ] Next display centers the window on the other screen's work area (below the menu bar, above the Dock).
- [ ] Previous display brings it back.
- [ ] A window wider than the destination screen fills that screen's `visibleFrame`, not the full panel.

## Spaces

- [ ] Move a window, switch Space, switch back: the rect is unchanged.
- [ ] Shortcut on a Space with no Spectacle-targetable window does nothing harmful.

## Full-screen apps

- [ ] A full-screen app does not get a tiled rect while it owns the Space.
- [ ] After leaving full screen, halves work on that window again.

## Chrome / Electron

- [ ] Chrome: left half moves the front window.
- [ ] If an Electron app does not move, set `AXEnhancedUserInterface` off for that app (or use a build that does). Record the app name. Do not change Spectacle's frames to compensate.
- [ ] Stage Manager: the shortcut affects the front window only.

## Notched built-in display

Skip if this Mac has no notch.

- [ ] Fullscreen leaves the menu bar and notch clear, and sits above the Dock.
- [ ] Top half's top edge is the bottom of the menu bar, not the top of the panel.
