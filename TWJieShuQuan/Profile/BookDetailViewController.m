//
//  BookDetailViewController.m
//  TWJieShuQuan
//
//  Created by Haibin Wang on 6/11/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "BookDetailViewController.h"
#import "TWIconButton.h"
#import "BookEntity.h"
#import "AppConstants.h"

@implementation BookDetailViewController


- (void)viewDidLoad {
    self.title = @"书籍详情";
    TWIconButton *statView = [[TWIconButton alloc] initWithFrame:_updateStatsView.frame];
    statView.icon = [UIImage imageNamed:@"stats.png"];
    statView.title = @"更新状态";
    [_updateStatsView addSubview:statView];

    TWIconButton *delView = [[TWIconButton alloc] initWithFrame:_deleteView.frame];
    delView.icon = [UIImage imageNamed:@"delete.png"];
    delView.title = @"删除";
    [_deleteView addSubview:delView];

    Book *currentBook = self.bookEntity[kBookEntity_Book];

    __weak typeof(self) weakSelf = self;
    [currentBook fetchIfNeededInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        weakSelf.bookAuthor.text = currentBook.bookAuthor;
        weakSelf.bookPress.text = currentBook.

    }];

    self.bookName.text = self.bookEntity.bookName;
    self.bookStatus.text = self.bookEntity.bookAvailability ? @"可借" : @"暂不可借";
    [self.bookImage sd_setImageWithURL:[NSURL URLWithString:self.bookEntity.bookImageHref]];


}


@end
