//
//  BorrowBookNotification.h
//  TWJieShuQuan
//
//  Created by Jianning Zheng on 6/20/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>
#import <AVObject+Subclass.h>

@interface BorrowRecord : AVObject <AVSubclassing>

// pending, agreed, rejected, returned
@property (nonatomic, strong) NSString *status;

@end
