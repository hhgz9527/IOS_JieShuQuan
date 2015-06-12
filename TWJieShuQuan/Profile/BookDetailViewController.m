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
#import "BookCommentCell.h"

@implementation BookDetailViewController


- (void)viewDidLoad {
    self.title = @"书籍详情";

    __weak typeof(self) weakSelf = self;

    TWIconButton *statView = [[TWIconButton alloc] initWithFrame:_updateStatsView.frame];
    statView.icon = [UIImage imageNamed:@"stats.png"];
    statView.title = @"更新状态";
    [_updateStatsView addSubview:statView];

    TWIconButton *delView = [[TWIconButton alloc] initWithFrame:_deleteView.frame];
    delView.icon = [UIImage imageNamed:@"delete.png"];
    delView.title = @"删除";

    delView.callback = ^{
        [weakSelf.bookEntity deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            }
        }];

    };
    [_deleteView addSubview:delView];

    Book *currentBook = self.bookEntity[kBookEntity_Book];

    [currentBook fetchIfNeededInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        weakSelf.bookAuthor.text = currentBook.bookAuthor;
        weakSelf.bookPress.text = currentBook.bookPress;

    }];

    self.bookName.text = self.bookEntity.bookName;
    self.bookStatus.text = self.bookEntity.bookAvailability ? @"可借" : @"暂不可借";
    [self.bookImage sd_setImageWithURL:[NSURL URLWithString:self.bookEntity.bookImageHref]];


}

#pragma mark - UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentTableCell"];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"commentTableCell"];
//        cell.textLabel.text = @"test";
//        cell.detailTextLabel.text = @"detail";
//    }

    BookCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentTableCell"];

    return cell;
}


@end
