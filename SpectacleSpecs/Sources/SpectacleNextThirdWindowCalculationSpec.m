#import <XCTest/XCTest.h>
#import "SpectacleWindowPositionCalculationResult.h"
#import "SpectacleWindowPositionCalculator.h"

@interface SpectacleNextThirdWindowCalculationTests : XCTestCase
@end

@implementation SpectacleNextThirdWindowCalculationTests
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

- (void)testShouldCalculateAWindowSCGRectInTheFirstHorizontalThirdOfTheScreen
{

    SpectacleWindowPositionCalculationResult *result = [windowPositionCalculator calculateWindowRect:CGRectMake(165.0f, 245.0f, 564.0f, 384.0f)
                                                                          visibleFrameOfSourceScreen:visibleFrameSourceScreen
                                                                     visibleFrameOfDestinationScreen:visibleFrameDestinationScreen
                                                                                              action:kSpectacleWindowActionNextThird];
    XCTAssertTrue(CGRectEqualToRect(result.windowRect, CGRectMake(0.0f, 4.0f, 480.0f, 873.0f)));
}

- (void)testShouldCalculateAWindowSCGRectInTheSecondHorizontalThirdOfTheScreen
{

    SpectacleWindowPositionCalculationResult *result = [windowPositionCalculator calculateWindowRect:CGRectMake(0.0f, 4.0f, 480.0f, 873.0f)
                                                                          visibleFrameOfSourceScreen:visibleFrameSourceScreen
                                                                     visibleFrameOfDestinationScreen:visibleFrameDestinationScreen
                                                                                              action:kSpectacleWindowActionNextThird];
    XCTAssertTrue(CGRectEqualToRect(result.windowRect, CGRectMake(480.0f, 4.0f, 480.0f, 873.0f)));
}

- (void)testShouldCalculateAWindowSCGRectInTheLastHorizontalThirdOfTheScreen
{

    SpectacleWindowPositionCalculationResult *result = [windowPositionCalculator calculateWindowRect:CGRectMake(480.0f, 4.0f, 480.0f, 873.0f)
                                                                          visibleFrameOfSourceScreen:visibleFrameSourceScreen
                                                                     visibleFrameOfDestinationScreen:visibleFrameDestinationScreen
                                                                                              action:kSpectacleWindowActionNextThird];
    XCTAssertTrue(CGRectEqualToRect(result.windowRect, CGRectMake(960.0f, 4.0f, 480.0f, 873.0f)));
}

- (void)testShouldCalculateAWindowSCGRectInTheFirstVerticalThirdOfTheScreen
{

    SpectacleWindowPositionCalculationResult *result = [windowPositionCalculator calculateWindowRect:CGRectMake(960.0f, 4.0f, 480.0f, 873.0f)
                                                                          visibleFrameOfSourceScreen:visibleFrameSourceScreen
                                                                     visibleFrameOfDestinationScreen:visibleFrameDestinationScreen
                                                                                              action:kSpectacleWindowActionNextThird];
    XCTAssertTrue(CGRectEqualToRect(result.windowRect, CGRectMake(0.0f, 586.0f, 1440.0f, 291.0f)));
}

- (void)testShouldCalculateAWindowSCGRectInTheSecondVerticalThirdOfTheScreen
{

    SpectacleWindowPositionCalculationResult *result = [windowPositionCalculator calculateWindowRect:CGRectMake(0.0f, 586.0f, 1440.0f, 291.0f)
                                                                          visibleFrameOfSourceScreen:visibleFrameSourceScreen
                                                                     visibleFrameOfDestinationScreen:visibleFrameDestinationScreen
                                                                                              action:kSpectacleWindowActionNextThird];

    XCTAssertTrue(CGRectEqualToRect(result.windowRect, CGRectMake(0.0f, 295.0f, 1440.0f, 291.0f)));
}

- (void)testShouldCalculateAWindowSCGRectInTheLastVerticalThirdOfTheScreen
{

    SpectacleWindowPositionCalculationResult *result = [windowPositionCalculator calculateWindowRect:CGRectMake(0.0f, 295.0f, 1440.0f, 291.0f)
                                                                          visibleFrameOfSourceScreen:visibleFrameSourceScreen
                                                                     visibleFrameOfDestinationScreen:visibleFrameDestinationScreen
                                                                                              action:kSpectacleWindowActionNextThird];
    XCTAssertTrue(CGRectEqualToRect(result.windowRect, CGRectMake(0.0f, 4.0f, 1440.0f, 291.0f)));
}

@end
