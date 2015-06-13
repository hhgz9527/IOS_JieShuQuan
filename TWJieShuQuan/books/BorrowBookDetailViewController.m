//
//  BorrowBookDetailViewController.m
//  TWJieShuQuan
//
//  Created by Jianning Zheng on 6/13/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import "BorrowBookDetailViewController.h"
#import "BookService.h" 

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
