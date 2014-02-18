//
//  AppDelegate.m
//  Chef.me
//
//  Created by Kushan Shah on 2/10/14.
//  Copyright (c) 2014 Codepath. All rights reserved.
//

#import "AppDelegate.h"
//#import "LoginViewController.h"
//#import "PropertyConfigViewController.h"
//#import "Parse/Parse.h"
#import "MainViewController.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

//    [Parse setApplicationId:@"G0eP59QGmBZWO2v4klysid1aDMvkVcMwmoHbAd3U" clientKey:@"JYQQiB2CVxXS0olE122ZQbpnb00GmCJEO4nucrOI"];
//    
//    [PFFacebookUtils initializeFacebook];
//    
   // [PFFacebookUtils initializeWithApplicationId:@"1381929028741946" urlSchemeSuffix:@"fb1381929028741946"];

   // [PFTwitterUtils initializeWithConsumerKey:@"z39gMQFuVMjOCXrCxHXA"consumerSecret:@"0pvLD7D8R5vudQckJSwjT0EB2lcw4rg7sl1MR7Xa2tU"];
    // Override point for customization after application launch.
    //PropertyConfigViewController *loginViewController = [[PropertyConfigViewController alloc] init];
    //UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    //self.window.rootViewController = navController;
    
    MainViewController*mainVC = [[MainViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:mainVC];
    self.window.rootViewController = navController;
//    self.window.rootViewController = mainVC;

    [self.window makeKeyAndVisible];

    return YES;
}

// ****************************************************************************
// App switching methods to support Facebook Single Sign-On.
// ****************************************************************************
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
//    return [FBAppCall handleOpenURL:url
//                  sourceApplication:sourceApplication
//                        withSession:[PFFacebookUtils session]];
//}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    
    //[FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    //[[PFFacebookUtils session] close];
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskPortrait;
}

@end
