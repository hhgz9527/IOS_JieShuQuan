//
//  MyBooksCollectionViewCell.m
//  TWJieShuQuan
//
//  Created by Jianning Zheng on 6/3/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import "MyBooksCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation MyBooksCollectionViewCell

- (void)refreshCellWithBookEntity:(BookEntity *)bookEntity {
    self.bookNameLabel.text = bookEntity.bookName;
    [self.bookImageView sd_setImageWithURL:[NSURL URLWithString:bookEntity.bookImageHref]];
}

@end
