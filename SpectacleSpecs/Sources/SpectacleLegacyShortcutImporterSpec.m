#import <XCTest/XCTest.h>
#import "SpectacleLegacyShortcutImporter.h"
#import "SpectacleShortcut.h"

@interface SpectacleLegacyShortcutImporterTests : XCTestCase
@end

@implementation SpectacleLegacyShortcutImporterTests

- (void)testCopiesLegacyJSONWithoutChangingIt
{
  NSURL *root = [self temporaryRoot];
  NSURL *legacy = [root URLByAppendingPathComponent:@"Spectacle"];
  NSURL *destination = [root URLByAppendingPathComponent:@"Encore"];
  NSError *error = nil;
  XCTAssertTrue([[NSFileManager defaultManager] createDirectoryAtURL:legacy withIntermediateDirectories:YES attributes:nil error:&error], @"%@", error);
  NSData *fixture = [@"[{\"shortcut_name\":\"MoveToLeftHalf\",\"shortcut_key_binding\":\"alt+cmd+left\"}]\n" dataUsingEncoding:NSUTF8StringEncoding];
  NSURL *legacyFile = [legacy URLByAppendingPathComponent:@"Shortcuts.json"];
  XCTAssertTrue([fixture writeToURL:legacyFile options:NSDataWritingAtomic error:&error], @"%@", error);
  XCTAssertTrue([SpectacleLegacyShortcutImporter importLegacyShortcutsAtDirectory:legacy legacyDefaults:[NSUserDefaults standardUserDefaults] intoDirectory:destination error:&error], @"%@", error);
  XCTAssertEqualObjects([NSData dataWithContentsOfURL:legacyFile], fixture);
  XCTAssertEqualObjects([NSData dataWithContentsOfURL:[destination URLByAppendingPathComponent:@"Shortcuts.json"]], fixture);
}

- (void)testDoesNotOverwriteAnExistingEncoreFile
{
  NSURL *root = [self temporaryRoot];
  NSURL *legacy = [root URLByAppendingPathComponent:@"Spectacle"];
  NSURL *destination = [root URLByAppendingPathComponent:@"Encore"];
  NSError *error = nil;
  XCTAssertTrue([[NSFileManager defaultManager] createDirectoryAtURL:destination withIntermediateDirectories:YES attributes:nil error:&error], @"%@", error);
  NSData *existing = [@"existing" dataUsingEncoding:NSUTF8StringEncoding];
  NSURL *destinationFile = [destination URLByAppendingPathComponent:@"Shortcuts.json"];
  XCTAssertTrue([existing writeToURL:destinationFile options:NSDataWritingAtomic error:&error], @"%@", error);
  XCTAssertTrue([[NSFileManager defaultManager] createDirectoryAtURL:legacy withIntermediateDirectories:YES attributes:nil error:&error], @"%@", error);
  NSData *fixture = [@"legacy" dataUsingEncoding:NSUTF8StringEncoding];
  XCTAssertTrue([fixture writeToURL:[legacy URLByAppendingPathComponent:@"Shortcuts.json"] options:NSDataWritingAtomic error:&error], @"%@", error);
  XCTAssertFalse([SpectacleLegacyShortcutImporter importLegacyShortcutsAtDirectory:legacy legacyDefaults:[NSUserDefaults standardUserDefaults] intoDirectory:destination error:&error]);
  XCTAssertEqualObjects([NSData dataWithContentsOfURL:destinationFile], existing);
}

- (void)testImportsFixtureDefaultsWhenJSONIsAbsent
{
  NSURL *root = [self temporaryRoot];
  NSURL *legacy = [root URLByAppendingPathComponent:@"Spectacle"];
  NSURL *destination = [root URLByAppendingPathComponent:@"Encore"];
  NSString *suiteName = [@"com.amannor.Encore.ImporterTests." stringByAppendingString:[NSUUID UUID].UUIDString];
  NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:suiteName];
  SpectacleShortcut *shortcut = [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToLeftHalf" shortcutKeyBinding:@"alt+cmd+left"];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
  [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:shortcut] forKey:@"MoveToLeftHalf"];
#pragma clang diagnostic pop
  NSError *error = nil;
  XCTAssertTrue([SpectacleLegacyShortcutImporter importLegacyShortcutsAtDirectory:legacy legacyDefaults:defaults intoDirectory:destination error:&error], @"%@", error);
  NSArray *json = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:[destination URLByAppendingPathComponent:@"Shortcuts.json"]] options:0 error:&error];
  XCTAssertEqual(json.count, 1);
  XCTAssertEqualObjects(json[0][@"shortcut_name"], @"MoveToLeftHalf");
  XCTAssertEqualObjects(json[0][@"shortcut_key_binding"], @"alt+cmd+left");
  XCTAssertFalse([[NSFileManager defaultManager] fileExistsAtPath:legacy.path]);
  [defaults removePersistentDomainForName:suiteName];
}

- (void)testFreshInstallWritesNothing
{
  NSURL *root = [self temporaryRoot];
  NSURL *destination = [root URLByAppendingPathComponent:@"Encore"];
  NSString *suiteName = [@"com.amannor.Encore.ImporterTests." stringByAppendingString:[NSUUID UUID].UUIDString];
  NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:suiteName];
  NSError *error = nil;
  XCTAssertFalse([SpectacleLegacyShortcutImporter importLegacyShortcutsAtDirectory:[root URLByAppendingPathComponent:@"Spectacle"] legacyDefaults:defaults intoDirectory:destination error:&error]);
  XCTAssertFalse([[NSFileManager defaultManager] fileExistsAtPath:[destination URLByAppendingPathComponent:@"Shortcuts.json"].path]);
  [defaults removePersistentDomainForName:suiteName];
}

- (NSURL *)temporaryRoot
{
  NSURL *root = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:[NSUUID UUID].UUIDString] isDirectory:YES];
  [[NSFileManager defaultManager] createDirectoryAtURL:root withIntermediateDirectories:YES attributes:nil error:nil];
  return root;
}

@end
