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
#import "BookDetailModel.h"

static NSInteger kStart = 0;

@interface BookDetailViewController ()
@property(nonatomic, strong) Book *currentBook;
@property (nonatomic, strong) BookCommentCell *cellForCalcHeight;
@property (nonatomic, strong) NSMutableArray *comments;


@end


@implementation BookDetailViewController
- (instancetype)initWithBookDetailModel:(BookDetailModel *)model {
    self = [super init];
    if (self) {
        _bookDetailModel = model;
    }

    return self;
}


- (void)viewDidLoad {
    self.title = self.bookDetailModel.title;
    [self.activityView startAnimating];

    __weak typeof(self) weakSelf = self;

//    TWIconButton *statView = [[TWIconButton alloc] initWithFrame:_updateStatsView.frame];
//    statView.icon = [UIImage imageNamed:@"stats.png"];
//    statView.title = @"更新状态";
//    statView.callback = ^{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"更改状态"
//                                                               delegate:self
//                                                      cancelButtonTitle:@"取消"
//                                                 destructiveButtonTitle:nil
//                                                      otherButtonTitles:kUpdateStatsToCanBorrow, kUpdateStatsToCannotBorrow, nil];
//            sheet.tag = kUpdateStatsTag;
//            [sheet showInView:self.view];
//        });
//    };
    self.bookDetailModel.updateStatsView.frame = CGRectMake(0, 0, CGRectGetWidth(_updateStatsView.frame), CGRectGetHeight(_updateStatsView.frame));

    [_updateStatsView addSubview:self.bookDetailModel.updateStatsView];

//    TWIconButton *delView = [[TWIconButton alloc] initWithFrame:_deleteView.frame];
//    delView.icon = [UIImage imageNamed:@"delete.png"];
//    delView.title = @"删除";
//
//    delView.callback = ^{
//        [weakSelf.bookEntity deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//            if (succeeded) {
//                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
//            }
//        }];
//
//    };

    self.bookDetailModel.deleteView.frame = CGRectMake(0, 0, CGRectGetWidth(_deleteView.frame), CGRectGetHeight(_deleteView.frame));

    [_deleteView addSubview:self.bookDetailModel.deleteView];

    self.bookAuthor.text = self.bookDetailModel.author;
    self.bookPress.text = self.bookDetailModel.press;
    self.bookName.text = self.bookDetailModel.name;
    self.bookStatus.text = self.bookDetailModel.status ? @"可借" : @"暂不可借";
    [self.bookImage sd_setImageWithURL:[NSURL URLWithString:self.bookDetailModel.avatarURL]];


}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    kStart = 0;
    self.comments = nil;

    __weak typeof(self) weakSelf = self;
//
//    self.currentBook = self.bookEntity[kBookEntity_Book];
//
//    [self.currentBook fetchIfNeededInBackgroundWithBlock:^(AVObject *object, NSError *error) {
//        weakSelf.bookAuthor.text = weakSelf.currentBook.bookAuthor;
//        weakSelf.bookPress.text = weakSelf.currentBook.bookPress;
//
//
//    }];

    [DouBanService fetchBookCommentWithBookID:self.bookDetailModel.bookDoubanID
                                        start:kStart++
                                      success:^(NSArray *comments) {
                                          weakSelf.comments = [comments mutableCopy];
                                          [weakSelf.tableView reloadData];
                                          [self.activityView stopAnimating];
                                      } failure:nil];
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

    self.cellForCalcHeight.bounds = CGRectMake(0.f, 0.f, CGRectGetWidth(tableView.frame), tableView.rowHeight);

    CGFloat height = [self.cellForCalcHeight.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;

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
    [self.activityView startAnimating];
    [DouBanService fetchBookCommentWithBookID:self.bookDetailModel.bookDoubanID
                                        start:kStart++
                                      success:^(NSArray *comments) {
                                          [self.comments addObjectsFromArray:comments];
                                          [self.tableView reloadData];
                                          [self.activityView stopAnimating];
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
    [BookService updateBookAvailabilityWithBook:self.bookDetailModel.book
                                    availbility:isAvailable];
}

@end
