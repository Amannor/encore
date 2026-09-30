#import "SpectacleLegacyShortcutImporter.h"

#import <Cocoa/Cocoa.h>

#import "SpectacleShortcut.h"
#import "SpectacleShortcutUserDefaultsStorage.h"

static NSString * const kLegacyBundleIdentifier = @"com.divisiblebyzero.Spectacle";
static NSString * const kShortcutsFileName = @"Shortcuts.json";

@implementation SpectacleLegacyShortcutImporter

+ (BOOL)importLegacyShortcutsIfNeeded:(NSError **)error
{
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSURL *applicationSupport = [fileManager URLForDirectory:NSApplicationSupportDirectory
                                                  inDomain:NSUserDomainMask
                                         appropriateForURL:nil
                                                    create:NO
                                                     error:error];
  if (!applicationSupport) {
    return NO;
  }
  for (NSRunningApplication *application in [NSWorkspace sharedWorkspace].runningApplications) {
    if ([application.bundleIdentifier isEqualToString:kLegacyBundleIdentifier]) {
      NSLog(@"Quit Spectacle before using Encore. Hotkeys conflict while both are running.");
      break;
    }
  }
  return [self importLegacyShortcutsAtDirectory:[applicationSupport URLByAppendingPathComponent:@"Spectacle"]
                                 legacyDefaults:[[NSUserDefaults alloc] initWithSuiteName:kLegacyBundleIdentifier]
                                  intoDirectory:[applicationSupport URLByAppendingPathComponent:@"Encore"]
                                          error:error];
}

+ (BOOL)importLegacyShortcutsAtDirectory:(NSURL *)legacyDirectory
                          legacyDefaults:(NSUserDefaults *)legacyDefaults
                           intoDirectory:(NSURL *)destinationDirectory
                                   error:(NSError **)error
{
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSURL *destinationFile = [destinationDirectory URLByAppendingPathComponent:kShortcutsFileName];
  if ([fileManager fileExistsAtPath:destinationFile.path]) {
    return NO;
  }
  NSURL *legacyFile = [legacyDirectory URLByAppendingPathComponent:kShortcutsFileName];
  if ([fileManager fileExistsAtPath:legacyFile.path]) {
    if (![fileManager createDirectoryAtURL:destinationDirectory withIntermediateDirectories:YES attributes:nil error:error]) {
      return NO;
    }
    return [fileManager copyItemAtURL:legacyFile toURL:destinationFile error:error];
  }
  NSArray<NSDictionary *> *shortcuts = shortcutsFromLegacyDefaults(legacyDefaults);
  if (shortcuts.count == 0) {
    return NO;
  }
  NSData *contents = [NSJSONSerialization dataWithJSONObject:shortcuts options:NSJSONWritingPrettyPrinted error:error];
  if (!contents) {
    return NO;
  }
  if (![fileManager createDirectoryAtURL:destinationDirectory withIntermediateDirectories:YES attributes:nil error:error]) {
    return NO;
  }
  return [contents writeToURL:destinationFile options:NSDataWritingAtomic error:error];
}

static NSArray<NSDictionary *> *shortcutsFromLegacyDefaults(NSUserDefaults *legacyDefaults)
{
  [SpectacleShortcutUserDefaultsStorage class];
  NSMutableArray<NSDictionary *> *shortcuts = [NSMutableArray new];
  for (NSString *shortcutName in legacyShortcutNames()) {
    NSData *shortcutData = [legacyDefaults dataForKey:shortcutName];
    if (!shortcutData) {
      continue;
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    SpectacleShortcut *shortcut = [NSKeyedUnarchiver unarchiveObjectWithData:shortcutData];
#pragma clang diagnostic pop
    if (!shortcut.shortcutName) {
      continue;
    }
    [shortcuts addObject:@{
      @"shortcut_name" : shortcut.shortcutName,
      @"shortcut_key_binding" : shortcut.shortcutKeyBinding ?: [NSNull null],
    }];
  }
  return shortcuts;
}

static NSArray<NSString *> *legacyShortcutNames(void)
{
  return @[
    @"MoveToCenter",
    @"MoveToFullscreen",
    @"MoveToLeftHalf",
    @"MoveToRightHalf",
    @"MoveToTopHalf",
    @"MoveToBottomHalf",
    @"MoveToUpperLeft",
    @"MoveToLowerLeft",
    @"MoveToUpperRight",
    @"MoveToLowerRight",
    @"MoveToNextDisplay",
    @"MoveToPreviousDisplay",
    @"MoveToNextThird",
    @"MoveToPreviousThird",
    @"MakeLarger",
    @"MakeSmaller",
    @"UndoLastMove",
    @"RedoLastMove",
  ];
}

@end
