#import <Flutter/Flutter.h>
#import <FBSDKShareKit/FBSDKSharingContent.h>
#import <FBSDKShareKit/FBSDKShareLinkContent.h>
#import <FBSDKShareKit/FBSDKShareDialog.h>

@interface FacebookSdkPlugin : NSObject<FlutterPlugin, FBSDKSharingDelegate>
@end
