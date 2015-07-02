//
//  PopularBookTableViewCell.m
//  TWJieShuQuan
//
//  Created by Jianning Zheng on 6/30/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import "PopularBookTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface PopularBookTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *bookNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bookImageView;
@property (weak, nonatomic) IBOutlet UILabel *authorName;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

@implementation PopularBookTableViewCell

- (void)updateUI {
    [self.bookImageView sd_setImageWithURL:[NSURL URLWithString:self.book.bookImageHref]];
    self.bookImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.bookImageView.layer.shadowOffset = CGSizeMake(0, 2);
    self.bookImageView.layer.shadowOpacity = 0.5;
    self.bookImageView.clipsToBounds = NO;
    
    self.bookNameLabel.text = self.book.bookName;
    self.authorName.text = self.book.bookAuthor;
    self.descriptionLabel.text = self.book.bookDescription;
}

@end
