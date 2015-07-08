//
//  BorrowOutTableViewCell.m
//  TWJieShuQuan
//
//  Created by Jianning Zheng on 6/26/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import "BorrowOutTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface BorrowOutTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *bookNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bookImageView;
@property (weak, nonatomic) IBOutlet UILabel *borrowDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *lendToUserLabel;

@end


@implementation BorrowOutTableViewCell

- (void)awakeFromNib {
    self.returnButton.layer.borderColor = [UIColor colorWithRed:118.0/225.0 green:219.0/225.0 blue:125.0/225.0 alpha:1].CGColor;
    self.returnButton.layer.borderWidth = 1.0f;
    self.returnButton.layer.cornerRadius = 5.0f;
    
    [self.returnButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [self.returnButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
}

- (void)refreshUI {
    self.bookNameLabel.text = self.borrowRecord.bookName;
    [self.bookImageView sd_setImageWithURL:[NSURL URLWithString:self.borrowRecord.bookImageHref]];
    self.borrowDateLabel.text = [[[self.borrowRecord updatedAt] description] componentsSeparatedByString:@" "][0];
    self.lendToUserLabel.text = self.borrowRecord.fromUserName;
}

@end