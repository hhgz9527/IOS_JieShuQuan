//
//  BookDetailViewController.m
//  TWJieShuQuan
//
//  Created by Haibin Wang on 6/11/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import <AVFoundation/AVFoundation.h>
#import "BookDetailViewController.h"
#import "TWIconButton.h"
#import "BookEntity.h"
#import "AppConstants.h"
#import "BookCommentCell.h"
#import "BookService.h"
#import "DouBanService.h"

static const int kUpdateStatsTag = 1001;
static NSString *const kUpdateStatsToCanBorrow = @"改为可借";
static NSString *const kUpdateStatsToCannotBorrow = @"改为不可借";
static NSInteger kStart = 0;

@interface BookDetailViewController ()
@property(nonatomic, strong) Book *currentBook;
@property (nonatomic, strong) BookCommentCell *cellForCalcHeight;


@end


@implementation BookDetailViewController


- (void)viewDidLoad {
    self.title = @"书籍详情";

    __weak typeof(self) weakSelf = self;

    TWIconButton *statView = [[TWIconButton alloc] initWithFrame:_updateStatsView.frame];
    statView.icon = [UIImage imageNamed:@"stats.png"];
    statView.title = @"更新状态";
    statView.callback = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"更改状态"
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                 destructiveButtonTitle:nil
                                                      otherButtonTitles:kUpdateStatsToCanBorrow, kUpdateStatsToCannotBorrow, nil];
            sheet.tag = kUpdateStatsTag;
            [sheet showInView:self.view];
        });
    };

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


}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    kStart = 0;
    self.comments = nil;

    __weak typeof(self) weakSelf = self;

    self.currentBook = self.bookEntity[kBookEntity_Book];

    [self.currentBook fetchIfNeededInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        weakSelf.bookAuthor.text = weakSelf.currentBook.bookAuthor;
        weakSelf.bookPress.text = weakSelf.currentBook.bookPress;


        [DouBanService fetchBookCommentWithBookID:weakSelf.currentBook.bookDoubanId
                                            start:kStart++
                                          success:^(NSArray *comments) {
                                              weakSelf.comments = [comments mutableCopy];
                                              [weakSelf.tableView reloadData];
                                          } failure:nil];
    }];

    self.bookName.text = self.bookEntity.bookName;
    self.bookStatus.text = self.bookEntity.bookAvailability ? @"可借" : @"暂不可借";
    [self.bookImage sd_setImageWithURL:[NSURL URLWithString:self.bookEntity.bookImageHref]];

}

#pragma mark - UITableViewDatasource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"评论列表";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.comments.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (!self.cellForCalcHeight) {
        self.cellForCalcHeight = [tableView dequeueReusableCellWithIdentifier:@"commentTableCell"];
    }

    [self.cellForCalcHeight setupCellWithInfo:self.comments[indexPath.row]];

    self.cellForCalcHeight.contentView.bounds = CGRectMake(0.f, 0.f, CGRectGetWidth(tableView.frame), tableView.rowHeight);

    NSLayoutConstraint *tempWidthConstraint =
            [NSLayoutConstraint constraintWithItem:self.cellForCalcHeight.contentView
                                         attribute:NSLayoutAttributeWidth
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:nil
                                         attribute:NSLayoutAttributeNotAnAttribute
                                        multiplier:1.0
                                          constant:CGRectGetWidth(tableView.frame)];
    [self.cellForCalcHeight.contentView addConstraint:tempWidthConstraint];



    CGFloat height = [self.cellForCalcHeight.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;

    [self.cellForCalcHeight.contentView removeConstraint:tempWidthConstraint];
//    NSLog(@"===title:%@ height:%f", self.cellForCalcHeight.userName.text, height);
//    NSLog(@"height:%f", [self.cellForCalcHeight calcCellHeight]);

    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    BookCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentTableCell"];
    [cell setupCellWithInfo:self.comments[indexPath.row]];

    return cell;
}

- (IBAction)loadMore:(UIButton *)sender {
    [DouBanService fetchBookCommentWithBookID:self.currentBook.bookDoubanId
                                        start:kStart++
                                      success:^(NSArray *comments) {
                                          [self.comments addObjectsFromArray:comments];
                                          [self.tableView reloadData];
                                      } failure:nil];

}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }

    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    BOOL isAvailable = [title isEqualToString:kUpdateStatsToCanBorrow] ? YES : NO;

    self.bookStatus.text = isAvailable ? @"可借" : @"暂不可借";
    [BookService updateBookAvailabilityWithBook:self.bookEntity[kBookEntity_Book]
                                    availbility:isAvailable];
}

@end
