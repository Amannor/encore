#import <XCTest/XCTest.h>
#import <Carbon/Carbon.h>
#import <Cocoa/Cocoa.h>

#import "SpectacleShortcut.h"

@interface SpectacleShortcutTests : XCTestCase
@end

@implementation SpectacleShortcutTests
- (void)testShouldBeInitializedWithAKeyBinding
{
SpectacleShortcut *shortcut = [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToCenter"
                                                               shortcutKeyBinding:@"option+command+c"];
  XCTAssertEqual(shortcut.shortcutKeyCode, kVK_ANSI_C);
  XCTAssertEqual(shortcut.shortcutModifiers, optionKey | cmdKey);
}

- (void)testShouldBeCopiedWithANewShortcutAction
{
SpectacleShortcut *shortcut = [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToCenter"
                                                                  shortcutKeyCode:kVK_ANSI_C
                                                                shortcutModifiers:NSEventModifierFlagOption | NSEventModifierFlagCommand];
  XCTAssertNil(shortcut.shortcutAction);
  XCTAssertNotNil([shortcut copyWithShortcutAction:^(SpectacleShortcut *shortcut) {}].shortcutAction);
}

- (void)testShouldTriggerShortcutActions
{
__block BOOL shortcutActionTriggered;
SpectacleShortcut *shortcut = [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToCenter"
                                                                  shortcutKeyCode:kVK_ANSI_C
                                                                shortcutModifiers:NSEventModifierFlagOption | NSEventModifierFlagCommand
                                                                   shortcutAction:^(SpectacleShortcut *shortcut) {
                                                                     shortcutActionTriggered = YES;
                                                                   }];
[shortcut triggerShortcutAction];
  XCTAssertTrue(shortcutActionTriggered);
}

- (void)testShouldDetermineIfTheShortcutIsCleared
{
  XCTAssertTrue([[[SpectacleShortcut alloc] initWithShortcutName:nil shortcutKeyBinding:nil] isClearedShortcut]);
  XCTAssertTrue([[[SpectacleShortcut alloc] initWithShortcutName:nil shortcutKeyBinding:@""] isClearedShortcut]);
  XCTAssertTrue([[[SpectacleShortcut alloc] initWithShortcutName:nil shortcutKeyCode:-1 shortcutModifiers:0] isClearedShortcut]);
  XCTAssertTrue([[[SpectacleShortcut alloc] initWithShortcutName:@"MoveToCenter" shortcutKeyCode:-1 shortcutModifiers:0] isClearedShortcut]);
}

- (void)testShouldProvideADisplayString
{
  XCTAssertEqualObjects([[[SpectacleShortcut alloc] initWithShortcutName:@"MoveToCenter" shortcutKeyCode:kVK_ANSI_C shortcutModifiers:NSEventModifierFlagOption | NSEventModifierFlagCommand] displayString], @"⌥⌘C");
}

- (void)testShouldProvideAKeyBinding
{
SpectacleShortcut *shortcut = [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToCenter"
                                                               shortcutKeyBinding:@"alt+cmd+c"];
  XCTAssertEqualObjects(shortcut.shortcutKeyBinding, @"alt+cmd+c");
}

- (void)testShouldSupportEquality
{
SpectacleShortcut *shortcut1 = [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToCenter"
                                                                   shortcutKeyCode:kVK_ANSI_C
                                                                 shortcutModifiers:NSEventModifierFlagOption | NSEventModifierFlagCommand];
SpectacleShortcut *shortcut2 = [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToCenter"
                                                                   shortcutKeyCode:kVK_ANSI_C
                                                                 shortcutModifiers:NSEventModifierFlagOption | NSEventModifierFlagCommand];
SpectacleShortcut *shortcut3 = [[SpectacleShortcut alloc] initWithShortcutName:nil
                                                                   shortcutKeyCode:kVK_ANSI_C
                                                                 shortcutModifiers:NSEventModifierFlagOption | NSEventModifierFlagCommand];
  XCTAssertEqualObjects(shortcut1, shortcut2);
  XCTAssertEqualObjects(shortcut1, shortcut3);
  XCTAssertNotEqualObjects(shortcut1, [[SpectacleShortcut alloc] initWithShortcutName:nil shortcutKeyCode:-1 shortcutModifiers:0]);
}

- (void)testShouldDetermineIfTheShortcutIsContainsModifiers
{
SpectacleShortcut *shortcut = [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToCenter"
                                                                  shortcutKeyCode:kVK_ANSI_C
                                                                shortcutModifiers:NSEventModifierFlagOption | NSEventModifierFlagCommand];
  XCTAssertTrue([shortcut containsModifiers:NSEventModifierFlagOption]);
  XCTAssertTrue([shortcut containsModifiers:NSEventModifierFlagOption | NSEventModifierFlagCommand]);
  XCTAssertFalse([shortcut containsModifiers:NSEventModifierFlagControl]);
}

@end
