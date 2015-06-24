//
//  BorrowInTableViewCell.m
//  TWJieShuQuan
//
//  Created by Jianning Zheng on 6/23/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import "BorrowInTableViewCell.h"

@interface BorrowInTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *bookNameLabel;

@end


@implementation BorrowInTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshUI {
    self.bookNameLabel.text = self.borrowRecord.bookName;
}

@end
