//
//  AppDelegate.m
//  FactObjective
//
//  Created by Nilesh Prajapati on 21/11/17.
//  Copyright © 2017 Nilesh Prajapati. All rights reserved.
//

#import "AppDelegate.h"
#import "FactsListViewController.h"

@interface AppDelegate ()
@end

@implementation AppDelegate

#pragma mark - ==================================
#pragma mark Application Life-cycle events
#pragma mark ==================================

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //-- Initalize a rootview controller for navigation controller
    FactsListViewController *obj_factViewController = [[FactsListViewController alloc] init];
    
    //-- To create an instance of navigation controller to make it as an intiate view controller of window
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:obj_factViewController];

    //-- To create an instance of a window for an application
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    
    //-- Initialize a navigation controller as a key viewcontroller to a window
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - ==================================
#pragma mark User-defined functions
#pragma mark ==================================

- (void)displayAnAlertWith:(NSString *)title andMessage:(NSString *)message {
    if (@available(iOS 9.0, *)) {
        UIAlertController *alertController = [[UIAlertController alloc] init];
        [alertController setTitle:title];
        [alertController setMessage:message];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alertController dismissViewControllerAnimated:TRUE completion:nil];
        }]];
        [self.window.rootViewController presentViewController:alertController animated:TRUE completion:nil];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

@end
