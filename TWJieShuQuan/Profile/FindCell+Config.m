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

- (void)createCellWithFind:(Discover *)find content:(NSString *)content {
    self.name.text = find.nickname;
    self.content.text = content;
    self.time.text = [self convertDateToDetailText:find.createdAt];
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:find.avatar] placeholderImage:[UIImage imageNamed:@"avatar"]];
}

- (NSString *)convertDateToDetailText:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyMMdd";
    NSInteger day = [formatter stringFromDate:date].integerValue - [formatter stringFromDate:[NSDate date]].integerValue;
    
    formatter.dateFormat = @"HH:mm";
    if (day == -2) {
        return [NSString stringWithFormat:@"前天 %@", [formatter stringFromDate:date]];
    }
    if (day == -1) {
        return [NSString stringWithFormat:@"昨天 %@", [formatter stringFromDate:date]];
    }
    if (day == 0) {
        return [NSString stringWithFormat:@"今天 %@", [formatter stringFromDate:date]];
    }
    
    formatter.dateFormat = @"yy-MM-dd HH:mm";
    return [formatter stringFromDate:date];
}

@end
