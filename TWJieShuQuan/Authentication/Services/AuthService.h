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

- (void)signUpWithUsername:(NSString *)username password:(NSString *)password email:(NSString *)email phoneNumber:(NSString *)phoneNumber succeeded:(void (^)())signUpSucceededBlock failed:(void (^)())signUpFailedBlock;
- (void)loginWithUsername:(NSString *)username password:(NSString *)password succeeded:(void (^)())loginSucceededBlock failed:(void (^)())loginFailedBlock;
- (void)logout;

@end
