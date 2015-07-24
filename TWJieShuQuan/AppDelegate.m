//
//  AppDelegate.m
//  TWJieShuQuan
//
//  Created by Jianning Zheng on 5/18/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import "AppDelegate.h"
#import <AVOSCloud/AVOSCloud.h>
#import "Constants.h"
#import "LoginViewController.h"
#import "Book.h"
#import "BookEntity.h"
#import "Discover.h"
#import "BorrowNotificationTableViewController.h"
#import "BorrowRecord.h"
#import "LaunchViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // setup LeanCloud
    [Book registerSubclass];
    [BookEntity registerSubclass];
    [Discover registerSubclass];
    [BorrowRecord registerSubclass];
    
    [AVOSCloud setApplicationId:LeanCloud_AppId clientKey:LeanCloud_AppKey];

    // setup push notification
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
    } else {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    }
    
    // setup nav bar appearance
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav_background"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTranslucent:NO];

    
    
    // setup root viewcontroller
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

    if ([AVUser currentUser]) {
        UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"main" bundle:nil];
        self.window.rootViewController = mainSB.instantiateInitialViewController;
    } else {
        LaunchViewController *launch = [[LaunchViewController alloc] initWithNibName:@"LaunchViewController" bundle:nil];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:launch];
        //LoginViewController *rootViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        self.window.rootViewController = nav;
    }
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    AVInstallation *currentInstallation = [AVInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
    NSLog(@"===== didRegisterForRemoteNotificationsWithDeviceToken: %@", deviceToken);

}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"===== didFailToRegisterForRemoteNotificationsWithError: %@", error);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    int num=application.applicationIconBadgeNumber;
    if(num!=0){
        AVInstallation *currentInstallation = [AVInstallation currentInstallation];
        [currentInstallation setBadge:0];
        [currentInstallation saveEventually];
        application.applicationIconBadgeNumber=0;
    }
    [application cancelAllLocalNotifications];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
