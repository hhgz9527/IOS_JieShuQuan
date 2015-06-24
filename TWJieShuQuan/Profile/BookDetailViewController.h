//
//  BookDetailViewController.h
//  TWJieShuQuan
//
//  Created by Haibin Wang on 6/11/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import <UIKit/UIKit.h>

static const int kUpdateStatsTag = 1001;
static NSString *const kUpdateStatsToCanBorrow = @"改为可借";
static NSString *const kUpdateStatsToCannotBorrow = @"改为不可借";

@class BookEntity;
@class BookDetailModel;

@interface BookDetailViewController : UITableViewController<UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *footerView;
//@property (nonatomic, strong) BookEntity *bookEntity;
@property (strong, nonatomic) BookDetailModel *bookDetailModel;

@property (weak, nonatomic) IBOutlet UIView *updateStatsView;
@property (weak, nonatomic) IBOutlet UIView *deleteView;
@property (weak, nonatomic) IBOutlet UILabel *bookName;
@property (weak, nonatomic) IBOutlet UILabel *bookStatus;
@property (weak, nonatomic) IBOutlet UILabel *bookAuthor;
@property (weak, nonatomic) IBOutlet UILabel *bookPress;
@property (weak, nonatomic) IBOutlet UIImageView *bookImage;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
- (instancetype)initWithBookDetailModel:(BookDetailModel *)model;


@end
