//
//  BookCommentCell.m
//  TWJieShuQuan
//
//  Created by Haibin Wang on 6/12/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "BookCommentCell.h"

@implementation BookCommentCell
- (void)setupCellWithInfo:(NSDictionary *)info {
    NSDictionary *author = info[@"author"];
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:author[@"avatar"]]];
    self.userName.text = info[@"title"];
    [self.userName sizeToFit];
    self.comment.text = info[@"summary"];
    [self.comment sizeToFit];
    self.date.text = info[@"updated"];
    [self.date sizeToFit];

}

- (CGFloat)calcCellHeight {
    CGFloat height = CGRectGetHeight(self.userName.frame) + CGRectGetHeight(self.comment.frame) + CGRectGetHeight(self.date.frame) + 24;

    return height;
}


- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];

    self.comment.preferredMaxLayoutWidth = bounds.size.width - 70;
}

@end