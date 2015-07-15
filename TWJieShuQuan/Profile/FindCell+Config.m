//
//  FindCell+Config.m
//  TWJieShuQuan
//
//  Created by GaoYu on 15/6/13.
//  Copyright (c) 2015年 Jianing. All rights reserved.
//

#import "FindCell+Config.h"
#import "Discover.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation FindCell (Config)

- (void)configFindCell:(Discover *)find {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.avatar.layer.cornerRadius = 15;
    self.avatar.layer.masksToBounds = YES;
    find.twitter == nil ? [self isBookNotificationWithFind:find] : [self isTwitterWithFind:find];
}

- (void)isTwitterWithFind:(Discover *)find {
    [self createCellWithFind:find content:find.twitter];
}

- (void)isBookNotificationWithFind:(Discover *)find {
    NSString *str = [NSString stringWithFormat:@"我添加了一本新书《%@》。",find.bookName];
    [self createCellWithFind:find content:str];
}

- (NSString *)currentTime:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    return [formatter stringFromDate:date];
}


- (void)createCellWithFind:(Discover *)find content:(NSString *)content {
    self.name.text = find.userName;
    self.content.text = content;
    self.time.text = [self currentTime:find.createdAt];
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:find.avatar] placeholderImage:[UIImage imageNamed:@"avatar"]];
}


@end
