//
//  Discover.h
//  TWJieShuQuan
//
//  Created by GaoYu on 15/6/13.
//  Copyright (c) 2015年 Jianing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>
#import <AVObject+Subclass.h>

typedef NS_ENUM(NSInteger, DiscoverType) {
    DISCOVERTYPE_ADDBOOK,
    DISCOVERTYPE_TWITTER
};
@interface Discover : AVObject <AVSubclassing>

@property(nonatomic, strong) AVUser *user;
@property(nonatomic, copy) NSString *bookName;
@property(nonatomic, copy) NSString *twitter;
@property(nonatomic, assign) DiscoverType type;
@property(nonatomic, copy) NSString *userName;
@property(nonatomic, strong) AVFile *file;
@property(nonatomic, copy) NSString *avatar;
@property(nonatomic, copy) NSString *nickname;

@end
