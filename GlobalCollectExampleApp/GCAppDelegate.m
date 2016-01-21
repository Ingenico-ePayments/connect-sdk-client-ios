//
//  IGCAppDelegate.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 10/04/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "SVProgressHUD.h"
#import "AFNetworkActivityLogger.h"

#import "GCAppDelegate.h"
#import "GCStartViewController.h"

@implementation GCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // Uncomment the following two statement to enable logging of requests and responses
    //[[AFNetworkActivityLogger sharedLogger] startLogging];
    //[[AFNetworkActivityLogger sharedLogger] setLevel:AFLoggerLevelDebug];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    [SVProgressHUD setBackgroundColor:[UIColor clearColor]];

    GCStartViewController *shop = [[GCStartViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:shop];

    self.window.rootViewController = nav;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    return YES;
}

@end
