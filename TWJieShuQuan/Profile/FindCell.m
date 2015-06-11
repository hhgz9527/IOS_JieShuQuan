//
//  FindCell.m
//  TWJieShuQuan
//
//  Created by GaoYu on 15/6/11.
//  Copyright (c) 2015年 Jianing. All rights reserved.
//

#import "FindCell.h"

@implementation FindCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _avatar.layer.cornerRadius = 15;
        _avatar.layer.masksToBounds = YES;
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
