//
//  AuthService.m
//  TWJieShuQuan
//
//  Created by Jianning Zheng on 5/19/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import "AuthService.h"

@implementation AuthService

+ (void)signUpWithEmail:(NSString *)email password:(NSString *)password office:(NSString *)office succeeded:(void (^)())signUpSucceededBlock failed:(void (^)(NSString *errorMessage))signUpFailedBlock {
    AVUser *user = [AVUser user];
    user.email = email;
    user.password = password;
    user.username = [self usernameFromEmail:email];
    [user setObject:office forKey:@"office"];
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            signUpSucceededBlock();
        } else {
            NSString *errorMessage = [error.userInfo objectForKey:@"error"];
            signUpFailedBlock(errorMessage);
        }
    }];
}

+ (void)loginWithEmail:(NSString *)email password:(NSString *)password succeeded:(void (^)())loginSucceededBlock failed:(void (^)(NSString *errorMessage))loginFailedBlock {
    if ([AVUser currentUser] == nil) {
        [AVUser logInWithUsernameInBackground:[self usernameFromEmail:email] password:password block:^(AVUser *user, NSError *error) {
            if (user != nil) {
                loginSucceededBlock();
            } else {
                NSString *errorMessage = [error.userInfo objectForKey:@"error"];
                loginFailedBlock(errorMessage);
            }
        }];
    } else {
        NSLog(@"==== already login ====");
    }
}

+ (void)logout {
    [AVUser logOut];
}

+ (void)resetPasswordForEmail:(NSString *)email succeeded:(void (^)())resetSucceededBlock failed:(void (^)(NSString *errorMessage))resetFailedBlock {
    [AVUser requestPasswordResetForEmailInBackground:email block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            resetSucceededBlock();
        } else {
            NSString *errorMessage = [error.userInfo objectForKey:@"error"];
            resetFailedBlock(errorMessage);
        }
    }];
}

// private methods

+ (NSString *)usernameFromEmail:(NSString *)email {
    return [email componentsSeparatedByString:@"@"][0];
}

@end
