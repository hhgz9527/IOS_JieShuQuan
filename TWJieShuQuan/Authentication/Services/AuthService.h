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

- (void)signUpWithEmail:(NSString *)email password:(NSString *)password succeeded:(void (^)())signUpSucceededBlock failed:(void (^)())signUpFailedBlock;

- (void)loginWithEmail:(NSString *)email password:(NSString *)password succeeded:(void (^)())loginSucceededBlock failed:(void (^)(NSString *errorMessage))loginFailedBlock;

- (void)logout;

@end
