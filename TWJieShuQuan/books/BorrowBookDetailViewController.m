//
//  BorrowBookDetailViewController.m
//  TWJieShuQuan
//
//  Created by Jianning Zheng on 6/13/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import "BorrowBookDetailViewController.h"
#import "BookService.h" 
#import "BorrowFromPersonViewController.h"

@interface BorrowBookDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *bookNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bookAvaliablityLabel;

@property (nonatomic, strong) NSArray *avaliableBooksEntities;
@end

@implementation BorrowBookDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 获取所有可借的 BookEntity 数组, 将该数组传入“借阅该书”点击后的页面
    [BookService fetchAvaliabilityForBook:self.book withSucceedCallback:^(NSArray *avaliableBooksEntities) {
        self.bookNameLabel.text = self.book.bookName;
        self.avaliableBooksEntities = avaliableBooksEntities;
        
        if (avaliableBooksEntities.count > 0) {
            self.bookAvaliablityLabel.text = @"可借";
        } else {
            self.bookAvaliablityLabel.text = @"不可借";
        }
    }];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"BorrowFromPersonSegue"]) {
        BorrowFromPersonViewController *borrowFromPersonViewController = (BorrowFromPersonViewController *)segue.destinationViewController;
        borrowFromPersonViewController.avaliableBookEntities = self.avaliableBooksEntities;
    }
}

@end
