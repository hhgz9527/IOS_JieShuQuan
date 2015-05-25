//
//  AuthService.h
//  TWJieShuQuan
//
//  Created by Jianning Zheng on 5/19/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>

@interface AuthService : NSObject

+ (instancetype)sharedAuthManager;

- (void)signUpWithEmail:(NSString *)email password:(NSString *)password succeeded:(void (^)())signUpSucceededBlock failed:(void (^)(NSString *errorMessage))signUpFailedBlock;

- (void)loginWithEmail:(NSString *)email password:(NSString *)password succeeded:(void (^)())loginSucceededBlock failed:(void (^)(NSString *errorMessage))loginFailedBlock;

- (void)logout;

- (void)resetPasswordForEmail:(NSString *)email succeeded:(void (^)())resetSucceededBlock failed:(void (^)(NSString *errorMessage))resetFailedBlock;

@end
