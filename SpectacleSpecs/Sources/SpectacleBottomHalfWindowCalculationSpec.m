#import <XCTest/XCTest.h>
#import "SpectacleWindowPositionCalculationResult.h"
#import "SpectacleWindowPositionCalculator.h"

@interface SpectacleBottomHalfWindowCalculationTests : XCTestCase
@end

@implementation SpectacleBottomHalfWindowCalculationTests
{
  CGRect visibleFrameSourceScreen;
  CGRect visibleFrameDestinationScreen;
  SpectacleWindowPositionCalculator *windowPositionCalculator;
}

- (void)setUp
{
  [super setUp];
  visibleFrameSourceScreen = CGRectMake(0.0f, 4.0f, 1440.0f, 873.0f);
  visibleFrameDestinationScreen = CGRectMake(0.0f, 4.0f, 1440.0f, 873.0f);
  windowPositionCalculator = [[SpectacleWindowPositionCalculator alloc] initWithErrorHandler:^(NSString *message) {
      XCTFail(@"%@", message);
    }];
}

- (void)testShouldCalculateAWindowSCGRectInTheBottomHalfOfTheScreen
{

    SpectacleWindowPositionCalculationResult *result = [windowPositionCalculator calculateWindowRect:CGRectMake(165.0f, 245.0f, 564.0f, 384.0f)
                                                                          visibleFrameOfSourceScreen:visibleFrameSourceScreen
                                                                     visibleFrameOfDestinationScreen:visibleFrameDestinationScreen
                                                                                              action:kSpectacleWindowActionBottomHalf];
    XCTAssertTrue(CGRectEqualToRect(result.windowRect, CGRectMake(0.0f, 4.0f, 1440.0f, 436.0f)));
}

- (void)testShouldCalculateAWindowSCGRectInTheBottom23OfTheScreen
{

    SpectacleWindowPositionCalculationResult *result = [windowPositionCalculator calculateWindowRect:CGRectMake(0.0f, 4.0f, 1440.0f, 436.0f)
                                                                          visibleFrameOfSourceScreen:visibleFrameSourceScreen
                                                                     visibleFrameOfDestinationScreen:visibleFrameDestinationScreen
                                                                                              action:kSpectacleWindowActionBottomHalf];
    XCTAssertTrue(CGRectEqualToRect(result.windowRect, CGRectMake(0.0f, 4.0f, 1440.0f, 582.0f)));
}

- (void)testShouldCalculateAWindowSCGRectInTheBottom13OfTheScreen
{

    SpectacleWindowPositionCalculationResult *result = [windowPositionCalculator calculateWindowRect:CGRectMake(0.0f, 4.0f, 1440.0f, 582.0f)
                                                                          visibleFrameOfSourceScreen:visibleFrameSourceScreen
                                                                     visibleFrameOfDestinationScreen:visibleFrameDestinationScreen
                                                                                              action:kSpectacleWindowActionBottomHalf];
    XCTAssertTrue(CGRectEqualToRect(result.windowRect, CGRectMake(0.0f, 4.0f, 1440.0f, 291.0f)));
}

@end
