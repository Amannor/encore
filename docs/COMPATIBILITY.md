# Compatibility

Slice 4 lock. Geometry is the bundled JavaScript calculators. Legacy expected frames in `SpectacleSpecs/Sources/*WindowCalculationSpec.m` are unchanged. `2560×1440` and notched visible-frame cases are in `SpectacleModernDisplayWindowCalculationSpec.m`.

Rectangle ([rxhanson/Rectangle](https://github.com/rxhanson/Rectangle)) is an oracle for macOS quirks only (ADR-006). Its frames were not copied. Drag-to-snap and Rectangle-only actions are not implemented.

## Intentional differences

None versus original Spectacle. The notes below are OS-forced.

## Displays under test

| Fixture | Screen frame | Visible frame | Why |
| --- | --- | --- | --- |
| Legacy | 1440×900 | `(0, 4, 1440, 873)` | Menu bar 23pt, Dock 4pt. Existing specs. |
| 2560×1440 | 2560×1440 | `(0, 4, 2560, 1413)` | Same chrome. Height `1440 - 23 - 4`. |
| Notched 14-inch | 1512×982 | `(0, 69, 1512, 878)` | Menu bar 35pt (notch), Dock 69pt. `982 - 35 - 69 = 878`. |

Calculators see `visibleFrame` only. The notch is a taller top inset, not a separate code path.

## Actions

| Action | Original spec | This app | Rectangle | Modern macOS |
| --- | --- | --- | --- | --- |
| Left half | Cycle 1/2 → 2/3 → 1/3 of `visibleFrame` width, left edge. | Same. | Not a frame source. Separate third commands exist; not copied. | `visibleFrame`, not `frame`. |
| Right half | Same cycle, right edge. | Same. | Not a frame source. | `visibleFrame`. |
| Top half | Same cycle on height. Odd heights keep the leftover row on the top half (`height % 2`). | Same. | Not a frame source. | `visibleFrame` top is below the menu bar / notch. |
| Bottom half | Same cycle on height, bottom edge. | Same. | Not a frame source. | `visibleFrame` bottom is above the Dock. |
| Upper left | Quarter, then wider 2/3, then 1/3. Top-left of `visibleFrame`. | Same. | Not a frame source. | Notch inset is already in `visibleFrame`. |
| Upper right | Same cycle, top-right. | Same. | Not a frame source. | Same. |
| Lower left | Same cycle, bottom-left. | Same. | Not a frame source. | Dock inset is `visibleFrame.origin.y`. |
| Lower right | Same cycle, bottom-right. | Same. | Not a frame source. | Same. |
| Next third | Six rects: three columns, then three rows. Unaligned window starts at column 1. | Same. | Not a frame source. | `visibleFrame`. |
| Previous third | Reverse of that cycle. From column 1, wraps to the bottom row. | Same. | Not a frame source. | `visibleFrame`. |
| Larger | Grow 30pt each side, pinned when already on an edge. Stops at `visibleFrame`. | Same. | Not a frame source. | Edges are `visibleFrame` edges. |
| Smaller | Shrink 30pt. No-op at or under 1/4 of `visibleFrame`. | Same. | Not a frame source. | Minimum uses `visibleFrame`, so a notch changes the floor. |
| Center | Center the current size in `visibleFrame` (`Math.round`). | Same. | Not a frame source. | Center of the work area, not the full panel. |
| Fullscreen | The destination `visibleFrame`. | Same. | Not a frame source. Maximize is not copied. | Does not cover the menu bar, notch, or Dock. |
| Next display | If the window fits, center it on the next `visibleFrame`; otherwise that `visibleFrame`. | Same. | Not a frame source. | Display order is the screen list, not Rectangle's. |
| Previous display | Same move, previous screen. | Same. | Not a frame source. | Same. |
| Undo | Replay `SpectacleHistory`. No JS calculator. | Same. | Not a frame source. | History stores the rect that was applied. |
| Redo | Replay forward. No JS calculator. | Same. | Not a frame source. | Same. |

## OS-forced

- **visibleFrame vs frame.** Menu bar, notch, and Dock are outside `NSScreen.visibleFrame`. The JS does not see them.
- **Stage Manager.** A window that is not the frontmost AX window is not moved. The set is an OS window list, not a geometry change.
- **Spaces and full-screen apps.** A full-screen Space often has no movable AX window for that app.
- **AXEnhancedUserInterface / Electron.** Chromium can ignore AX frame writes until `AXEnhancedUserInterface` is false. That is the app under test, not the calculator.
