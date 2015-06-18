//
//  NotificationManager.m
//  TWJieShuQuan
//
//  Created by Jianning Zheng on 6/17/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import "NotificationManager.h"
#import "Constants.h"

@implementation NotificationManager

+ (void)saveLoginUsers {
    AVInstallation *installation = [AVInstallation currentInstallation];
    [installation setObject:[AVUser currentUser] forKey:kPushNotificationKeyOwner];
    [installation saveInBackground];
}

+ (void)sendBorrowBookNotificationToUser:(AVUser *)targetUser {
    // Create our Installation query
    AVQuery *pushQuery = [AVInstallation query];
    [pushQuery whereKey:kPushNotificationKeyOwner equalTo:targetUser];
    
    // Send push notification to query
    
    // will remove this before go to production
    [AVPush setProductionMode:NO];

    AVPush *push = [[AVPush alloc] init];
    [push setQuery:pushQuery];
    [push setMessage:@"someone想借你的书"];
    [push sendPushInBackground];
}

@end