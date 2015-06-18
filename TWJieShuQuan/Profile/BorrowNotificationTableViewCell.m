//
//  BorrowNotificationTableViewCell.m
//  TWJieShuQuan
//
//  Created by Jianning Zheng on 6/18/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import "BorrowNotificationTableViewCell.h"

@implementation BorrowNotificationTableViewCell

- (void)awakeFromNib {
    self.agreeButton.layer.borderColor = [UIColor grayColor].CGColor;
    self.agreeButton.layer.borderWidth = 0.5f;
    
    self.notAgreeButton.layer.borderColor = [UIColor grayColor].CGColor;
    self.notAgreeButton.layer.borderWidth = 0.5f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
