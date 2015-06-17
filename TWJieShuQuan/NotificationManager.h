//
//  NotificationManager.h
//  TWJieShuQuan
//
//  Created by Jianning Zheng on 6/17/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>

@interface NotificationManager : NSObject

+ (void)saveLoginUsers;
+ (void)sendBorrowBookNotificationToUser:(AVUser *)targetUser;

@end
