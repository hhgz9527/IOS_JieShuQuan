//
//  BorrowInTableViewCell.m
//  TWJieShuQuan
//
//  Created by Jianning Zheng on 6/23/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import "BorrowInTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface BorrowInTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *bookNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bookImageView;
@property (weak, nonatomic) IBOutlet UILabel *borrowDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *bookOwnerLabel;

@end


@implementation BorrowInTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)refreshUI {
    self.bookNameLabel.text = self.borrowRecord.bookName;
    [self.bookImageView sd_setImageWithURL:[NSURL URLWithString:self.borrowRecord.bookImageHref]];
    self.borrowDateLabel.text = [[[self.borrowRecord updatedAt] description] componentsSeparatedByString:@" "][0];
    self.bookOwnerLabel.text = self.borrowRecord.fromUsername;
}

@end
