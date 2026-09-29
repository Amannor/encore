#import <XCTest/XCTest.h>

#import "SpectacleAccessibilityElement.h"
#import "SpectacleScreenDetectionResult.h"
#import "SpectacleScreenDetector.h"
#import "SpectacleWindowPositionCalculationResult.h"
#import "SpectacleWindowPositionCalculator.h"
#import "SpectacleWindowPositionManager.h"

@interface SpectacleSpecElement : SpectacleAccessibilityElement
@property (nonatomic, assign) CGRect stubRect;
@property (nonatomic, assign) BOOL stubSheet;
@property (nonatomic, assign) BOOL stubSystemDialog;
@property (nonatomic, assign) NSUInteger rectCalls;
@property (nonatomic, assign) NSUInteger sheetCalls;
@property (nonatomic, assign) NSUInteger systemDialogCalls;
@property (nonatomic, assign) NSUInteger setRectCalls;
@end

@implementation SpectacleSpecElement

- (CGRect)rectOfElement
{
  self.rectCalls += 1;
  return self.stubRect;
}

- (BOOL)isSheet
{
  self.sheetCalls += 1;
  return self.stubSheet;
}

- (BOOL)isSystemDialog
{
  self.systemDialogCalls += 1;
  return self.stubSystemDialog;
}

- (void)setRectOfElement:(CGRect)rect
{
  self.setRectCalls += 1;
}

@end

@interface SpectacleSpecScreenDetector : SpectacleScreenDetector
@property (nonatomic, strong) SpectacleScreenDetectionResult *stubResult;
@end

@implementation SpectacleSpecScreenDetector

- (SpectacleScreenDetectionResult *)screenWithAction:(SpectacleWindowAction *)action
                              frontmostWindowElement:(SpectacleAccessibilityElement *)frontmostWindowElement
                                             screens:(NSArray<NSScreen *> *)screens
                                          mainScreen:(NSScreen *)mainScreen
{
  return self.stubResult;
}

@end

@interface SpectacleSpecCalculator : SpectacleWindowPositionCalculator
@property (nonatomic, assign) NSUInteger calculateCalls;
@property (nonatomic, strong) SpectacleWindowPositionCalculationResult *stubResult;
@end

@implementation SpectacleSpecCalculator

- (SpectacleWindowPositionCalculationResult *)calculateWindowRect:(CGRect)windowRect
                                       visibleFrameOfSourceScreen:(CGRect)visibleFrameOfSourceScreen
                                  visibleFrameOfDestinationScreen:(CGRect)visibleFrameOfDestinationScreen
                                                           action:(SpectacleWindowAction *)action
{
  self.calculateCalls += 1;
  return self.stubResult;
}

@end

@interface SpectacleSpecResult : SpectacleWindowPositionCalculationResult
@property (nonatomic, assign) NSUInteger actionReads;
@property (nonatomic, assign) NSUInteger rectReads;
@end

@implementation SpectacleSpecResult

- (SpectacleWindowAction *)action
{
  self.actionReads += 1;
  return [super action];
}

- (CGRect)windowRect
{
  self.rectReads += 1;
  return [super windowRect];
}

@end

@interface SpectacleSpecRunningApplication : NSObject
@property (nonatomic, copy) NSString *bundleIdentifier;
@end

@implementation SpectacleSpecRunningApplication
@end

@interface SpectacleSpecWorkspace : NSObject
@property (nonatomic, strong) SpectacleSpecRunningApplication *frontmostApplication;
@end

@implementation SpectacleSpecWorkspace
@end

@interface SpectacleWindowPositionManagerTests : XCTestCase
@end

@implementation SpectacleWindowPositionManagerTests
{
  SpectacleSpecScreenDetector *_screenDetector;
  SpectacleSpecCalculator *_calculator;
  SpectacleWindowPositionManager *_manager;
  NSScreen *_mainScreen;
}

- (void)setUp
{
  [super setUp];
  _mainScreen = [NSScreen mainScreen];
  _screenDetector = [SpectacleSpecScreenDetector new];
  _screenDetector.stubResult = [SpectacleScreenDetectionResult resultWithSourceScreen:_mainScreen
                                                                    destinationScreen:_mainScreen];
  _calculator = [[SpectacleSpecCalculator alloc] initWithErrorHandler:^(NSString *message) {
    XCTFail(@"%@", message);
  }];
  SpectacleSpecRunningApplication *application = [SpectacleSpecRunningApplication new];
  application.bundleIdentifier = @"com.divisiblebyzero.SpectacleSpecs";
  SpectacleSpecWorkspace *workspace = [SpectacleSpecWorkspace new];
  workspace.frontmostApplication = application;
  _manager = [[SpectacleWindowPositionManager alloc] initWithScreenDetector:_screenDetector
                                                    windowPositionCalculator:_calculator
                                                             sharedWorkspace:(NSWorkspace *)workspace
                                                             failureFeedback:^{}
                                                                 windowMover:nil];
}

- (SpectacleSpecElement *)elementWithRect:(CGRect)rect sheet:(BOOL)sheet systemDialog:(BOOL)systemDialog
{
  SpectacleSpecElement *element = [SpectacleSpecElement new];
  element.stubRect = rect;
  element.stubSheet = sheet;
  element.stubSystemDialog = systemDialog;
  return element;
}

- (void)testShouldDoNothingIfTheFrontmostWindowIsASheet
{
  CGRect frontmostWindowRect = CGRectMake(165.0f, 245.0f, 564.0f, 384.0f);
  SpectacleSpecElement *element = [self elementWithRect:frontmostWindowRect sheet:YES systemDialog:NO];
  [_manager moveFrontmostWindowElement:element
                                action:kSpectacleWindowActionNone
                               screens:@[_mainScreen]
                            mainScreen:_mainScreen];
  XCTAssertEqual(element.rectCalls, 1);
  XCTAssertEqual(element.sheetCalls, 1);
  XCTAssertEqual(element.systemDialogCalls, 0);
  XCTAssertEqual(_calculator.calculateCalls, 0);
}

- (void)testShouldDoNothingIfTheFrontmostWindowIsASystemDialog
{
  CGRect frontmostWindowRect = CGRectMake(165.0f, 245.0f, 564.0f, 384.0f);
  SpectacleSpecElement *element = [self elementWithRect:frontmostWindowRect sheet:NO systemDialog:YES];
  [_manager moveFrontmostWindowElement:element
                                action:kSpectacleWindowActionNone
                               screens:@[_mainScreen]
                            mainScreen:_mainScreen];
  XCTAssertEqual(element.rectCalls, 1);
  XCTAssertEqual(element.sheetCalls, 1);
  XCTAssertEqual(element.systemDialogCalls, 1);
  XCTAssertEqual(_calculator.calculateCalls, 0);
}

- (void)testShouldDoNothingIfTheFrontmostWindowRectIsUnavailable
{
  SpectacleSpecElement *element = [self elementWithRect:CGRectNull sheet:NO systemDialog:YES];
  [_manager moveFrontmostWindowElement:element
                                action:kSpectacleWindowActionNone
                               screens:@[_mainScreen]
                            mainScreen:_mainScreen];
  XCTAssertEqual(element.rectCalls, 1);
  XCTAssertEqual(element.sheetCalls, 1);
  XCTAssertEqual(element.systemDialogCalls, 1);
  XCTAssertEqual(_calculator.calculateCalls, 0);
}

- (void)testShouldDoNothingIfScreenDetectionFails
{
  CGRect frontmostWindowRect = CGRectMake(165.0f, 245.0f, 564.0f, 384.0f);
  SpectacleSpecElement *element = [self elementWithRect:frontmostWindowRect sheet:NO systemDialog:YES];
  [_manager moveFrontmostWindowElement:element
                                action:kSpectacleWindowActionNone
                               screens:@[_mainScreen]
                            mainScreen:_mainScreen];
  XCTAssertEqual(element.rectCalls, 1);
  XCTAssertEqual(element.sheetCalls, 1);
  XCTAssertEqual(element.systemDialogCalls, 1);
  XCTAssertEqual(_calculator.calculateCalls, 0);
}

- (void)testShouldDoNothingIfTheWindowPositionCalculationReturnsTheSameResults
{
  XCTAssertNotNil(_mainScreen);
  CGRect frontmostWindowRect = CGRectMake(165.0f, 245.0f, 564.0f, 384.0f);
  SpectacleSpecElement *element = [self elementWithRect:frontmostWindowRect sheet:NO systemDialog:NO];
  SpectacleSpecResult *result = [[SpectacleSpecResult alloc] initWithAction:kSpectacleWindowActionCenter
                                                                  windowRect:frontmostWindowRect];
  _calculator.stubResult = result;
  [_manager moveFrontmostWindowElement:element
                                action:kSpectacleWindowActionCenter
                               screens:@[_mainScreen]
                            mainScreen:_mainScreen];
  XCTAssertEqual(result.actionReads, 1);
  XCTAssertEqual(result.rectReads, 1);
  XCTAssertEqual(element.setRectCalls, 0);
}

@end
