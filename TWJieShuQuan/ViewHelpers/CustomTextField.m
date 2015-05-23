//
//  CustomTextField.m
//  TWJieShuQuan
//
//  Created by Jianning Zheng on 5/23/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField

- (void)awakeFromNib {
    self.borderStyle = UITextBorderStyleNone;
    
    [self setValue:[UIColor colorWithWhite:0.8 alpha:0.5] forKeyPath:@"_placeholderLabel.textColor"];
    [self setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];

}

@end
