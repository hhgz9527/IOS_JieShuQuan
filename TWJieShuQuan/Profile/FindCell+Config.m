//
//  FindCell+Config.m
//  TWJieShuQuan
//
//  Created by GaoYu on 15/6/13.
//  Copyright (c) 2015年 Jianing. All rights reserved.
//

#import "FindCell+Config.h"
#import "Find.h"

@implementation FindCell (Config)

- (void)configFindCell:(Find *)find {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.avatar.layer.cornerRadius = 15;
    self.avatar.layer.masksToBounds = YES;
    
    AVQuery *query = [AVUser query];
    [query whereKey:@"objectId" equalTo:find.user.objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error == nil) {
            AVUser *user = objects.firstObject;
            self.name.text = user.username;
            self.content.text = [NSString stringWithFormat:@"我添加了一本新书《%@》。",find.book];
            self.time.text = [self currentTime:find.createdAt];
            
            AVFile *file = [[objects.firstObject objectForKey:@"localData"] objectForKey:@"avatar"];
            AVFile *avatarFile = [AVFile fileWithURL:file.url];
            [avatarFile getThumbnail:YES width:30 height:30 withBlock:^(UIImage *image, NSError *error) {
                self.avatar.image = image;
            }];
        } else {
            
        }
    }];
}

- (NSString *)currentTime:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    return [formatter stringFromDate:date];
}

@end