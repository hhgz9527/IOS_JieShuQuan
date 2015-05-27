//
//  UserManager.m
//  TWJieShuQuan
//
//  Created by Jianning Zheng on 5/27/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import "UserManager.h"
#import "User.h"
#import <AVOSCloud/AVOSCloud.h>

static const NSString *kCurrentUserName = @"current_user_name";
static const NSString *kCurrentUserEmail = @"current_user_email";
static const NSString *kCurrentUserSessionToken = @"current_user_session_token";

@implementation UserManager

+ (void)saveCurrentUser
{
    AVUser *currentUser = [AVUser currentUser];
    [[NSUserDefaults standardUserDefaults] setObject:currentUser.username forKey:(NSString *)kCurrentUserName];
    [[NSUserDefaults standardUserDefaults] setObject:currentUser.email forKey:(NSString *)kCurrentUserEmail];
    [[NSUserDefaults standardUserDefaults] setObject:currentUser.sessionToken forKey:(NSString *)kCurrentUserSessionToken];
}

+ (void)removeCurrentUser
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:(NSString *)kCurrentUserName];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:(NSString *)kCurrentUserEmail];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:(NSString *)kCurrentUserSessionToken];
}

+ (NSString *)currentUserName {
    return [[NSUserDefaults standardUserDefaults] objectForKey:(NSString *)kCurrentUserName];
}

+ (NSString *)currentUserEmail {
    return [[NSUserDefaults standardUserDefaults] objectForKey:(NSString *)kCurrentUserEmail];
}

+ (NSString *)currentUserSessionToken {
    return [[NSUserDefaults standardUserDefaults] objectForKey:(NSString *)kCurrentUserSessionToken];
}

@end
