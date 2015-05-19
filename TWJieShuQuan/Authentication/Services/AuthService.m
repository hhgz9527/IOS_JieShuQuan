//
//  AuthService.m
//  TWJieShuQuan
//
//  Created by Jianning Zheng on 5/19/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import "AuthService.h"

@implementation AuthService

+ (instancetype)sharedAuthManager {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)signUpWithUsername:(NSString *)username password:(NSString *)password email:(NSString *)email phoneNumber:(NSString *)phoneNumber succeeded:(void (^)())signUpSucceededBlock failed:(void (^)())signUpFailedBlock {
    AVUser *user = [AVUser user];
    user.username = username;
    user.password = password;
    user.email = email;
    [user setObject:phoneNumber forKey:@"phoneNumber"];
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            signUpSucceededBlock();
        } else {
            signUpFailedBlock();
        }
    }];
}

- (void)loginWithUsername:(NSString *)username password:(NSString *)password succeeded:(void (^)())loginSucceededBlock failed:(void (^)())loginFailedBlock {
    if ([AVUser currentUser] == nil) {
        [AVUser logInWithUsernameInBackground:username password:password block:^(AVUser *user, NSError *error) {
            if (user != nil) {
                loginSucceededBlock();
            } else {
                loginFailedBlock();
            }
        }];
    } else {
        NSLog(@"==== already login ====");
    }
}

- (void)logout {
    [AVUser logOut];
}

@end
