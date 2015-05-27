//
//  UserManager.h
//  TWJieShuQuan
//
//  Created by Jianning Zheng on 5/27/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserManager : NSObject

+ (void)saveCurrentUser;
+ (void)removeCurrentUser;

+ (NSString *)currentUserName;
+ (NSString *)currentUserEmail;
+ (NSString *)currentUserSessionToken;

@end

