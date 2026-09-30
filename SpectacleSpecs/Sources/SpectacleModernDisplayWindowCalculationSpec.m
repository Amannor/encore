#import <XCTest/XCTest.h>
#import "SpectacleWindowPositionCalculationResult.h"
#import "SpectacleWindowPositionCalculator.h"

@interface SpectacleModernDisplayWindowCalculationTests : XCTestCase
@end

@implementation SpectacleModernDisplayWindowCalculationTests
{
  SpectacleWindowPositionCalculator *windowPositionCalculator;
}

- (void)setUp
{
  [super setUp];
  windowPositionCalculator = [[SpectacleWindowPositionCalculator alloc] initWithErrorHandler:^(NSString *message) {
      XCTFail(@"%@", message);
    }];
}

- (void)expectAction:(SpectacleWindowAction *)action
                from:(CGRect)windowRect
              source:(CGRect)source
         destination:(CGRect)destination
                rect:(CGRect)expected
{
  SpectacleWindowPositionCalculationResult *result = [windowPositionCalculator calculateWindowRect:windowRect
                                                                    visibleFrameOfSourceScreen:source
                                                               visibleFrameOfDestinationScreen:destination
                                                                                        action:action];
  XCTAssertTrue(CGRectEqualToRect(result.windowRect, expected), @"%@ got %@", action, NSStringFromRect(result.windowRect));
}

// 2560x1440 display. Dock 4pt and menu bar 23pt match the legacy 1440x900 fixture
// (visible origin y=4, height 873). Visible height = 1440 - 23 - 4 = 1413.
- (void)test2560x1440VisibleFrame
{
  [self expectAction:kSpectacleWindowActionLeftHalf
                  from:CGRectMake(165.0f, 245.0f, 564.0f, 384.0f)
                source:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
           destination:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
                  rect:CGRectMake(0.0f, 4.0f, 1280.0f, 1413.0f)];
  [self expectAction:kSpectacleWindowActionLeftHalf
                  from:CGRectMake(0.0f, 4.0f, 1280.0f, 1413.0f)
                source:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
           destination:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
                  rect:CGRectMake(0.0f, 4.0f, 1706.0f, 1413.0f)];
  [self expectAction:kSpectacleWindowActionLeftHalf
                  from:CGRectMake(0.0f, 4.0f, 1706.0f, 1413.0f)
                source:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
           destination:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
                  rect:CGRectMake(0.0f, 4.0f, 853.0f, 1413.0f)];
  [self expectAction:kSpectacleWindowActionRightHalf
                  from:CGRectMake(165.0f, 245.0f, 564.0f, 384.0f)
                source:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
           destination:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
                  rect:CGRectMake(1280.0f, 4.0f, 1280.0f, 1413.0f)];
  [self expectAction:kSpectacleWindowActionRightHalf
                  from:CGRectMake(1280.0f, 4.0f, 1280.0f, 1413.0f)
                source:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
           destination:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
                  rect:CGRectMake(854.0f, 4.0f, 1706.0f, 1413.0f)];
  [self expectAction:kSpectacleWindowActionRightHalf
                  from:CGRectMake(854.0f, 4.0f, 1706.0f, 1413.0f)
                source:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
           destination:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
                  rect:CGRectMake(1707.0f, 4.0f, 853.0f, 1413.0f)];
  [self expectAction:kSpectacleWindowActionTopHalf
                  from:CGRectMake(165.0f, 245.0f, 564.0f, 384.0f)
                source:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
           destination:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
                  rect:CGRectMake(0.0f, 711.0f, 2560.0f, 706.0f)];
  [self expectAction:kSpectacleWindowActionTopHalf
                  from:CGRectMake(0.0f, 711.0f, 2560.0f, 706.0f)
                source:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
           destination:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
                  rect:CGRectMake(0.0f, 475.0f, 2560.0f, 942.0f)];
  [self expectAction:kSpectacleWindowActionTopHalf
                  from:CGRectMake(0.0f, 475.0f, 2560.0f, 942.0f)
                source:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
           destination:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
                  rect:CGRectMake(0.0f, 946.0f, 2560.0f, 471.0f)];
  [self expectAction:kSpectacleWindowActionBottomHalf
                  from:CGRectMake(165.0f, 245.0f, 564.0f, 384.0f)
                source:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
           destination:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
                  rect:CGRectMake(0.0f, 4.0f, 2560.0f, 706.0f)];
  [self expectAction:kSpectacleWindowActionBottomHalf
                  from:CGRectMake(0.0f, 4.0f, 2560.0f, 706.0f)
                source:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
           destination:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
                  rect:CGRectMake(0.0f, 4.0f, 2560.0f, 942.0f)];
  [self expectAction:kSpectacleWindowActionBottomHalf
                  from:CGRectMake(0.0f, 4.0f, 2560.0f, 942.0f)
                source:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
           destination:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
                  rect:CGRectMake(0.0f, 4.0f, 2560.0f, 471.0f)];
  [self expectAction:kSpectacleWindowActionUpperLeft
                  from:CGRectMake(165.0f, 245.0f, 564.0f, 384.0f)
                source:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
           destination:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
                  rect:CGRectMake(0.0f, 711.0f, 1280.0f, 706.0f)];
  [self expectAction:kSpectacleWindowActionUpperLeft
                  from:CGRectMake(0.0f, 711.0f, 1280.0f, 706.0f)
                source:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
           destination:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
                  rect:CGRectMake(0.0f, 711.0f, 1706.0f, 706.0f)];
  [self expectAction:kSpectacleWindowActionUpperLeft
                  from:CGRectMake(0.0f, 711.0f, 1706.0f, 706.0f)
                source:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
           destination:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
                  rect:CGRectMake(0.0f, 711.0f, 853.0f, 706.0f)];
  [self expectAction:kSpectacleWindowActionUpperRight
                  from:CGRectMake(165.0f, 245.0f, 564.0f, 384.0f)
                source:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
           destination:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
                  rect:CGRectMake(1280.0f, 711.0f, 1280.0f, 706.0f)];
  [self expectAction:kSpectacleWindowActionUpperRight
                  from:CGRectMake(1280.0f, 711.0f, 1280.0f, 706.0f)
                source:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
           destination:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
                  rect:CGRectMake(854.0f, 711.0f, 1706.0f, 706.0f)];
  [self expectAction:kSpectacleWindowActionUpperRight
                  from:CGRectMake(854.0f, 711.0f, 1706.0f, 706.0f)
                source:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
           destination:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
                  rect:CGRectMake(1707.0f, 711.0f, 853.0f, 706.0f)];
  [self expectAction:kSpectacleWindowActionLowerLeft
                  from:CGRectMake(165.0f, 245.0f, 564.0f, 384.0f)
                source:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
           destination:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
                  rect:CGRectMake(0.0f, 4.0f, 1280.0f, 706.0f)];
  [self expectAction:kSpectacleWindowActionLowerLeft
                  from:CGRectMake(0.0f, 4.0f, 1280.0f, 706.0f)
                source:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
           destination:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
                  rect:CGRectMake(0.0f, 4.0f, 1706.0f, 706.0f)];
  [self expectAction:kSpectacleWindowActionLowerLeft
                  from:CGRectMake(0.0f, 4.0f, 1706.0f, 706.0f)
                source:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
           destination:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
                  rect:CGRectMake(0.0f, 4.0f, 853.0f, 706.0f)];
  [self expectAction:kSpectacleWindowActionLowerRight
                  from:CGRectMake(165.0f, 245.0f, 564.0f, 384.0f)
                source:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
           destination:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
                  rect:CGRectMake(1280.0f, 4.0f, 1280.0f, 706.0f)];
  [self expectAction:kSpectacleWindowActionLowerRight
                  from:CGRectMake(1280.0f, 4.0f, 1280.0f, 706.0f)
                source:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
           destination:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
                  rect:CGRectMake(854.0f, 4.0f, 1706.0f, 706.0f)];
  [self expectAction:kSpectacleWindowActionLowerRight
                  from:CGRectMake(854.0f, 4.0f, 1706.0f, 706.0f)
                source:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
           destination:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
                  rect:CGRectMake(1707.0f, 4.0f, 853.0f, 706.0f)];
  [self expectAction:kSpectacleWindowActionCenter
                  from:CGRectMake(165.0f, 245.0f, 564.0f, 384.0f)
                source:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
           destination:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
                  rect:CGRectMake(998.0f, 519.0f, 564.0f, 384.0f)];
  [self expectAction:kSpectacleWindowActionFullscreen
                  from:CGRectMake(165.0f, 245.0f, 564.0f, 384.0f)
                source:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
           destination:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
                  rect:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)];
  [self expectAction:kSpectacleWindowActionLarger
                  from:CGRectMake(1760.0f, 300.0f, 800.0f, 500.0f)
                source:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
           destination:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
                  rect:CGRectMake(1730.0f, 285.0f, 830.0f, 530.0f)];
  [self expectAction:kSpectacleWindowActionSmaller
                  from:CGRectMake(1760.0f, 300.0f, 800.0f, 500.0f)
                source:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
           destination:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
                  rect:CGRectMake(1790.0f, 315.0f, 770.0f, 470.0f)];
  [self expectAction:kSpectacleWindowActionNextDisplay
                  from:CGRectMake(165.0f, 245.0f, 564.0f, 384.0f)
                source:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
           destination:CGRectMake(2560.0f, 4.0f, 2560.0f, 1413.0f)
                  rect:CGRectMake(3558.0f, 519.0f, 564.0f, 384.0f)];
  [self expectAction:kSpectacleWindowActionPreviousDisplay
                  from:CGRectMake(165.0f, 245.0f, 564.0f, 384.0f)
                source:CGRectMake(2560.0f, 4.0f, 2560.0f, 1413.0f)
           destination:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
                  rect:CGRectMake(998.0f, 519.0f, 564.0f, 384.0f)];
  [self expectAction:kSpectacleWindowActionNextDisplay
                  from:CGRectMake(0.0f, 0.0f, 4000.0f, 2000.0f)
                source:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
           destination:CGRectMake(2560.0f, 4.0f, 2560.0f, 1413.0f)
                  rect:CGRectMake(2560.0f, 4.0f, 2560.0f, 1413.0f)];
  [self expectAction:kSpectacleWindowActionNextThird
                  from:CGRectMake(165.0f, 245.0f, 564.0f, 384.0f)
                source:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
           destination:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
                  rect:CGRectMake(0.0f, 4.0f, 853.0f, 1413.0f)];
  [self expectAction:kSpectacleWindowActionNextThird
                  from:CGRectMake(0.0f, 4.0f, 853.0f, 1413.0f)
                source:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
           destination:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
                  rect:CGRectMake(853.0f, 4.0f, 853.0f, 1413.0f)];
  [self expectAction:kSpectacleWindowActionNextThird
                  from:CGRectMake(853.0f, 4.0f, 853.0f, 1413.0f)
                source:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
           destination:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
                  rect:CGRectMake(1706.0f, 4.0f, 853.0f, 1413.0f)];
  [self expectAction:kSpectacleWindowActionNextThird
                  from:CGRectMake(1706.0f, 4.0f, 853.0f, 1413.0f)
                source:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
           destination:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
                  rect:CGRectMake(0.0f, 946.0f, 2560.0f, 471.0f)];
  [self expectAction:kSpectacleWindowActionNextThird
                  from:CGRectMake(0.0f, 946.0f, 2560.0f, 471.0f)
                source:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
           destination:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
                  rect:CGRectMake(0.0f, 475.0f, 2560.0f, 471.0f)];
  [self expectAction:kSpectacleWindowActionNextThird
                  from:CGRectMake(0.0f, 475.0f, 2560.0f, 471.0f)
                source:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
           destination:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
                  rect:CGRectMake(0.0f, 4.0f, 2560.0f, 471.0f)];
  [self expectAction:kSpectacleWindowActionPreviousThird
                  from:CGRectMake(0.0f, 4.0f, 853.0f, 1413.0f)
                source:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
           destination:CGRectMake(0.0f, 4.0f, 2560.0f, 1413.0f)
                  rect:CGRectMake(0.0f, 4.0f, 2560.0f, 471.0f)];
}

// Notched 14-inch fixture, points. Screen frame 1512x982. visibleFrame excludes a
// 35pt menu bar (notch) and a 69pt Dock: origin y=69, height 878 (982 - 35 - 69).
- (void)testNotchedMenuBarVisibleFrame
{
  [self expectAction:kSpectacleWindowActionLeftHalf
                  from:CGRectMake(165.0f, 245.0f, 564.0f, 384.0f)
                source:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
           destination:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
                  rect:CGRectMake(0.0f, 69.0f, 756.0f, 878.0f)];
  [self expectAction:kSpectacleWindowActionLeftHalf
                  from:CGRectMake(0.0f, 69.0f, 756.0f, 878.0f)
                source:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
           destination:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
                  rect:CGRectMake(0.0f, 69.0f, 1008.0f, 878.0f)];
  [self expectAction:kSpectacleWindowActionLeftHalf
                  from:CGRectMake(0.0f, 69.0f, 1008.0f, 878.0f)
                source:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
           destination:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
                  rect:CGRectMake(0.0f, 69.0f, 504.0f, 878.0f)];
  [self expectAction:kSpectacleWindowActionRightHalf
                  from:CGRectMake(165.0f, 245.0f, 564.0f, 384.0f)
                source:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
           destination:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
                  rect:CGRectMake(756.0f, 69.0f, 756.0f, 878.0f)];
  [self expectAction:kSpectacleWindowActionRightHalf
                  from:CGRectMake(756.0f, 69.0f, 756.0f, 878.0f)
                source:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
           destination:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
                  rect:CGRectMake(504.0f, 69.0f, 1008.0f, 878.0f)];
  [self expectAction:kSpectacleWindowActionRightHalf
                  from:CGRectMake(504.0f, 69.0f, 1008.0f, 878.0f)
                source:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
           destination:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
                  rect:CGRectMake(1008.0f, 69.0f, 504.0f, 878.0f)];
  [self expectAction:kSpectacleWindowActionTopHalf
                  from:CGRectMake(165.0f, 245.0f, 564.0f, 384.0f)
                source:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
           destination:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
                  rect:CGRectMake(0.0f, 508.0f, 1512.0f, 439.0f)];
  [self expectAction:kSpectacleWindowActionTopHalf
                  from:CGRectMake(0.0f, 508.0f, 1512.0f, 439.0f)
                source:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
           destination:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
                  rect:CGRectMake(0.0f, 362.0f, 1512.0f, 585.0f)];
  [self expectAction:kSpectacleWindowActionTopHalf
                  from:CGRectMake(0.0f, 362.0f, 1512.0f, 585.0f)
                source:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
           destination:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
                  rect:CGRectMake(0.0f, 655.0f, 1512.0f, 292.0f)];
  [self expectAction:kSpectacleWindowActionBottomHalf
                  from:CGRectMake(165.0f, 245.0f, 564.0f, 384.0f)
                source:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
           destination:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
                  rect:CGRectMake(0.0f, 69.0f, 1512.0f, 439.0f)];
  [self expectAction:kSpectacleWindowActionBottomHalf
                  from:CGRectMake(0.0f, 69.0f, 1512.0f, 439.0f)
                source:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
           destination:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
                  rect:CGRectMake(0.0f, 69.0f, 1512.0f, 585.0f)];
  [self expectAction:kSpectacleWindowActionBottomHalf
                  from:CGRectMake(0.0f, 69.0f, 1512.0f, 585.0f)
                source:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
           destination:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
                  rect:CGRectMake(0.0f, 69.0f, 1512.0f, 292.0f)];
  [self expectAction:kSpectacleWindowActionUpperLeft
                  from:CGRectMake(165.0f, 245.0f, 564.0f, 384.0f)
                source:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
           destination:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
                  rect:CGRectMake(0.0f, 508.0f, 756.0f, 439.0f)];
  [self expectAction:kSpectacleWindowActionUpperLeft
                  from:CGRectMake(0.0f, 508.0f, 756.0f, 439.0f)
                source:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
           destination:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
                  rect:CGRectMake(0.0f, 508.0f, 1008.0f, 439.0f)];
  [self expectAction:kSpectacleWindowActionUpperLeft
                  from:CGRectMake(0.0f, 508.0f, 1008.0f, 439.0f)
                source:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
           destination:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
                  rect:CGRectMake(0.0f, 508.0f, 504.0f, 439.0f)];
  [self expectAction:kSpectacleWindowActionUpperRight
                  from:CGRectMake(165.0f, 245.0f, 564.0f, 384.0f)
                source:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
           destination:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
                  rect:CGRectMake(756.0f, 508.0f, 756.0f, 439.0f)];
  [self expectAction:kSpectacleWindowActionUpperRight
                  from:CGRectMake(756.0f, 508.0f, 756.0f, 439.0f)
                source:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
           destination:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
                  rect:CGRectMake(504.0f, 508.0f, 1008.0f, 439.0f)];
  [self expectAction:kSpectacleWindowActionUpperRight
                  from:CGRectMake(504.0f, 508.0f, 1008.0f, 439.0f)
                source:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
           destination:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
                  rect:CGRectMake(1008.0f, 508.0f, 504.0f, 439.0f)];
  [self expectAction:kSpectacleWindowActionLowerLeft
                  from:CGRectMake(165.0f, 245.0f, 564.0f, 384.0f)
                source:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
           destination:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
                  rect:CGRectMake(0.0f, 69.0f, 756.0f, 439.0f)];
  [self expectAction:kSpectacleWindowActionLowerLeft
                  from:CGRectMake(0.0f, 69.0f, 756.0f, 439.0f)
                source:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
           destination:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
                  rect:CGRectMake(0.0f, 69.0f, 1008.0f, 439.0f)];
  [self expectAction:kSpectacleWindowActionLowerLeft
                  from:CGRectMake(0.0f, 69.0f, 1008.0f, 439.0f)
                source:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
           destination:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
                  rect:CGRectMake(0.0f, 69.0f, 504.0f, 439.0f)];
  [self expectAction:kSpectacleWindowActionLowerRight
                  from:CGRectMake(165.0f, 245.0f, 564.0f, 384.0f)
                source:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
           destination:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
                  rect:CGRectMake(756.0f, 69.0f, 756.0f, 439.0f)];
  [self expectAction:kSpectacleWindowActionLowerRight
                  from:CGRectMake(756.0f, 69.0f, 756.0f, 439.0f)
                source:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
           destination:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
                  rect:CGRectMake(504.0f, 69.0f, 1008.0f, 439.0f)];
  [self expectAction:kSpectacleWindowActionLowerRight
                  from:CGRectMake(504.0f, 69.0f, 1008.0f, 439.0f)
                source:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
           destination:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
                  rect:CGRectMake(1008.0f, 69.0f, 504.0f, 439.0f)];
  [self expectAction:kSpectacleWindowActionCenter
                  from:CGRectMake(165.0f, 245.0f, 564.0f, 384.0f)
                source:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
           destination:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
                  rect:CGRectMake(474.0f, 316.0f, 564.0f, 384.0f)];
  [self expectAction:kSpectacleWindowActionFullscreen
                  from:CGRectMake(165.0f, 245.0f, 564.0f, 384.0f)
                source:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
           destination:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
                  rect:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)];
  [self expectAction:kSpectacleWindowActionLarger
                  from:CGRectMake(712.0f, 300.0f, 800.0f, 500.0f)
                source:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
           destination:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
                  rect:CGRectMake(682.0f, 285.0f, 830.0f, 530.0f)];
  [self expectAction:kSpectacleWindowActionSmaller
                  from:CGRectMake(712.0f, 300.0f, 800.0f, 500.0f)
                source:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
           destination:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
                  rect:CGRectMake(742.0f, 315.0f, 770.0f, 470.0f)];
  [self expectAction:kSpectacleWindowActionNextDisplay
                  from:CGRectMake(165.0f, 245.0f, 564.0f, 384.0f)
                source:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
           destination:CGRectMake(1512.0f, 69.0f, 1512.0f, 878.0f)
                  rect:CGRectMake(1986.0f, 316.0f, 564.0f, 384.0f)];
  [self expectAction:kSpectacleWindowActionPreviousDisplay
                  from:CGRectMake(165.0f, 245.0f, 564.0f, 384.0f)
                source:CGRectMake(1512.0f, 69.0f, 1512.0f, 878.0f)
           destination:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
                  rect:CGRectMake(474.0f, 316.0f, 564.0f, 384.0f)];
  [self expectAction:kSpectacleWindowActionNextDisplay
                  from:CGRectMake(0.0f, 0.0f, 4000.0f, 2000.0f)
                source:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
           destination:CGRectMake(1512.0f, 69.0f, 1512.0f, 878.0f)
                  rect:CGRectMake(1512.0f, 69.0f, 1512.0f, 878.0f)];
  [self expectAction:kSpectacleWindowActionNextThird
                  from:CGRectMake(165.0f, 245.0f, 564.0f, 384.0f)
                source:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
           destination:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
                  rect:CGRectMake(0.0f, 69.0f, 504.0f, 878.0f)];
  [self expectAction:kSpectacleWindowActionNextThird
                  from:CGRectMake(0.0f, 69.0f, 504.0f, 878.0f)
                source:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
           destination:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
                  rect:CGRectMake(504.0f, 69.0f, 504.0f, 878.0f)];
  [self expectAction:kSpectacleWindowActionNextThird
                  from:CGRectMake(504.0f, 69.0f, 504.0f, 878.0f)
                source:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
           destination:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
                  rect:CGRectMake(1008.0f, 69.0f, 504.0f, 878.0f)];
  [self expectAction:kSpectacleWindowActionNextThird
                  from:CGRectMake(1008.0f, 69.0f, 504.0f, 878.0f)
                source:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
           destination:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
                  rect:CGRectMake(0.0f, 655.0f, 1512.0f, 292.0f)];
  [self expectAction:kSpectacleWindowActionNextThird
                  from:CGRectMake(0.0f, 655.0f, 1512.0f, 292.0f)
                source:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
           destination:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
                  rect:CGRectMake(0.0f, 363.0f, 1512.0f, 292.0f)];
  [self expectAction:kSpectacleWindowActionNextThird
                  from:CGRectMake(0.0f, 363.0f, 1512.0f, 292.0f)
                source:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
           destination:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
                  rect:CGRectMake(0.0f, 71.0f, 1512.0f, 292.0f)];
  [self expectAction:kSpectacleWindowActionPreviousThird
                  from:CGRectMake(0.0f, 69.0f, 504.0f, 878.0f)
                source:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
           destination:CGRectMake(0.0f, 69.0f, 1512.0f, 878.0f)
                  rect:CGRectMake(0.0f, 71.0f, 1512.0f, 292.0f)];
}

@end
