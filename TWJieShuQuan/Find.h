//
//  Find.h
//  TWJieShuQuan
//
//  Created by GaoYu on 15/6/13.
//  Copyright (c) 2015年 Jianing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>
#import <AVObject+Subclass.h>

@interface Find : AVObject <AVSubclassing>

@property (nonatomic, copy) AVUser *user;
@property (nonatomic, copy) NSString *book;
@property (nonatomic, copy) NSString *twitter;

@end
