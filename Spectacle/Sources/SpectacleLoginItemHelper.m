#import "SpectacleLoginItemHelper.h"

#import <ServiceManagement/ServiceManagement.h>

static SMAppService *mainAppServiceForBundle(NSBundle *bundle)
{
  if (![bundle.bundleURL isEqual:NSBundle.mainBundle.bundleURL]) {
    return nil;
  }
  return SMAppService.mainAppService;
}

@implementation SpectacleLoginItemHelper

+ (BOOL)isLoginItemEnabledForBundle:(NSBundle *)bundle
{
  SMAppService *service = mainAppServiceForBundle(bundle);
  if (!service) {
    return NO;
  }
  SMAppServiceStatus status = service.status;
  return status == SMAppServiceStatusEnabled || status == SMAppServiceStatusRequiresApproval;
}

+ (void)enableLoginItemForBundle:(NSBundle *)bundle
{
  SMAppService *service = mainAppServiceForBundle(bundle);
  NSError *error = nil;
  if (!service || ![service registerAndReturnError:&error]) {
    NSLog(@"Unable to register the login item. %@", error);
  }
}

+ (void)disableLoginItemForBundle:(NSBundle *)bundle
{
  SMAppService *service = mainAppServiceForBundle(bundle);
  NSError *error = nil;
  if (!service || ![service unregisterAndReturnError:&error]) {
    NSLog(@"Unable to remove the login item. %@", error);
  }
}

@end
