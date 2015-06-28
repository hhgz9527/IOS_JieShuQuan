//
//  NotificationManager.h
//  TWJieShuQuan
//
//  Created by Jianning Zheng on 6/17/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>
#import "BookEntity.h"

@interface NotificationManager : NSObject

+ (void)saveLoginUsers;
+ (void)sendBorrowBookNotificationToUser:(AVUser *)targetUser forBookEntity:(BookEntity *)targetBookEntity;
+ (void)sendTwitterNofitication:(NSString *)channel message:(NSString *)message;

+ (void)subscribeChannel:(NSString *)channel;

@end
