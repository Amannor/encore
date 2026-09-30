#import <Foundation/Foundation.h>

@interface SpectacleLegacyShortcutImporter : NSObject

+ (BOOL)importLegacyShortcutsIfNeeded:(NSError **)error;

+ (BOOL)importLegacyShortcutsAtDirectory:(NSURL *)legacyDirectory
                          legacyDefaults:(NSUserDefaults *)legacyDefaults
                           intoDirectory:(NSURL *)destinationDirectory
                                   error:(NSError **)error;

@end
