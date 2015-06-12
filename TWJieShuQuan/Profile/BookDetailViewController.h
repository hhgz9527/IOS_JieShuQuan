//
//  BookDetailViewController.h
//  TWJieShuQuan
//
//  Created by Haibin Wang on 6/11/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BookEntity;


@interface BookDetailViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UIView *updateStatsView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (nonatomic, strong) BookEntity *bookEntity;
@property (weak, nonatomic) IBOutlet UIView *deleteView;
@property (weak, nonatomic) IBOutlet UILabel *bookName;
@property (weak, nonatomic) IBOutlet UILabel *bookStatus;
@property (weak, nonatomic) IBOutlet UILabel *bookAuthor;
@property (weak, nonatomic) IBOutlet UILabel *bookPress;
@property (weak, nonatomic) IBOutlet UIImageView *bookImage;


@end
