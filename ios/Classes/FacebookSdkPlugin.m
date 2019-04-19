#import "FacebookSdkPlugin.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKSharingContent.h>
#import <FBSDKShareKit/FBSDKShareLinkContent.h>
#import <FBSDKShareKit/FBSDKShareDialog.h>


@implementation FacebookSdkPlugin {
    FBSDKLoginManager *loginManager;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"facebook_sdk"
            binaryMessenger:[registrar messenger]];
  FacebookSdkPlugin* instance = [[FacebookSdkPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}
- (instancetype)init {
    loginManager = [[FBSDKLoginManager alloc] init];
    return self;
}

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:
(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance]
                    application:application
                    openURL:url
                    sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                    annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    return handled;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    BOOL handled =
    [[FBSDKApplicationDelegate sharedInstance] application:application
                                                   openURL:url
                                         sourceApplication:sourceApplication
                                                annotation:annotation];
    return handled;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"login" isEqualToString:call.method]) {
        FBSDKLoginBehavior behavior = FBSDKLoginBehaviorNative;
        NSArray *permissions = call.arguments[@"permissions"];
        
        [self loginWithReadPermissions:behavior
                           permissions:permissions
                                result:result];
  } else if ([@"logout" isEqualToString:call.method]) {
        [self logOut:result];
  } else if ([@"shareLinkContent" isEqualToString:call.method]) {
      NSString *link = call.arguments[@"link"];
      [self shareLinkContent:link
                      result:result];
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)shareLinkContent:(NSString*)link
                  result:(FlutterResult)result {
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:link];
    
    [FBSDKShareDialog showFromViewController:nil
                                 withContent:content
                                    delegate:nil];
}

- (void)loginWithReadPermissions:(FBSDKLoginBehavior)behavior
   permissions:(NSArray *)permissions
        result:(FlutterResult)result {
    [loginManager setLoginBehavior:behavior];
    [loginManager
     logInWithReadPermissions:permissions
     fromViewController:nil
     handler:^(FBSDKLoginManagerLoginResult *loginResult,
               NSError *error) {
         [self handleLoginResult:loginResult
                          result:result
                           error:error];
     }];
}

- (void)logOut:(FlutterResult)result {
    [loginManager logOut];
    result(nil);
}

- (void)handleLoginResult:(FBSDKLoginManagerLoginResult *)loginResult
                   result:(FlutterResult)result
                    error:(NSError *)error {
    if (error == nil) {
        if (!loginResult.isCancelled) {
            NSDictionary *mappedToken = [self accessTokenToMap:loginResult.token];
            
            result(@{
                     @"status" : @"loggedIn",
                     @"accessToken" : mappedToken,
                     });
        } else {
            result(@{
                     @"status" : @"cancelledByUser",
                     });
        }
    } else {
        result(@{
                 @"status" : @"error",
                 @"errorMessage" : [error description],
                 });
    }
}

- (id)accessTokenToMap:(FBSDKAccessToken *)accessToken {
    if (accessToken == nil) {
        return [NSNull null];
    }
    
    NSString *userId = [accessToken userID];
    NSArray *permissions = [accessToken.permissions allObjects];
    NSArray *declinedPermissions = [accessToken.declinedPermissions allObjects];
    NSNumber *expires = [NSNumber
                         numberWithLong:accessToken.expirationDate.timeIntervalSince1970 * 1000.0];
    
    return @{
             @"token" : accessToken.tokenString,
             @"userId" : userId,
             @"expires" : expires,
             @"permissions" : permissions,
             @"declinedPermissions" : declinedPermissions,
             };
}

@end
