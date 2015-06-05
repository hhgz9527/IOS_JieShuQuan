//
//  MyBooksCollectionViewCell.m
//  TWJieShuQuan
//
//  Created by Jianning Zheng on 6/3/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import "MyBooksCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "QuartzCore/CALayer.h"

@implementation MyBooksCollectionViewCell

- (void)awakeFromNib {
    [self applyShadowOn:self.bookImageView];
}

- (void)refreshCellWithBookEntity:(BookEntity *)bookEntity {
    self.bookNameLabel.text = bookEntity.bookName;
    [self.bookImageView sd_setImageWithURL:[NSURL URLWithString:bookEntity.bookImageHref]];
}

#pragma mark - private

- (void)applyShadowOn:(UIImageView *)someImageView {
    someImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    someImageView.layer.shadowOffset = CGSizeMake(0, 2);
    someImageView.layer.shadowOpacity = 0.5;
    someImageView.clipsToBounds = NO;
}

@end
