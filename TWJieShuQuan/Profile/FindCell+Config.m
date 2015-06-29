//
//  FindCell+Config.m
//  TWJieShuQuan
//
//  Created by GaoYu on 15/6/13.
//  Copyright (c) 2015年 Jianing. All rights reserved.
//

#import "FindCell+Config.h"
#import "Discover.h"

@implementation FindCell (Config)

- (void)configFindCell:(Discover *)find {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.avatar.layer.cornerRadius = 15;
    self.avatar.layer.masksToBounds = YES;
    
    AVQuery *query = [AVUser query];
    [query whereKey:@"objectId" equalTo:find.user.objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error == nil) {
            find.twitter == nil ? [self isBookNotification:objects find:find] : [self isTwitter:objects find:find];
        } else {
            
        }
    }];
}

- (void)isTwitter:(NSArray *)objects find:(Discover *)find {
    [self createCell:objects find:find content:find.twitter];
}

- (void)isBookNotification:(NSArray *)objects find:(Discover *)find {
    NSString *str = [NSString stringWithFormat:@"我添加了一本新书《%@》。",find.bookName];
    [self createCell:objects find:find content:str];
}

- (void)createCell:(NSArray *)objects find:(Discover *)find content:(NSString *)content {
    AVUser *user = objects.firstObject;
    self.name.text = user.username;
    self.content.text = content;
    self.time.text = [self currentTime:find.createdAt];
    
    AVFile *file = [[objects.firstObject objectForKey:@"localData"] objectForKey:@"avatar"];
    AVFile *avatarFile = [AVFile fileWithURL:file.url];
    [avatarFile getThumbnail:YES width:30 height:30 withBlock:^(UIImage *image, NSError *error) {
        self.avatar.image = image;
    }];

}

- (NSString *)currentTime:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    return [formatter stringFromDate:date];
}

@end
