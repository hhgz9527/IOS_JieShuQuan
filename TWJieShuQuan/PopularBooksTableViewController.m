//
//  PopularBooksTableViewController.m
//  TWJieShuQuan
//
//  Created by Jianning Zheng on 6/30/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import "PopularBooksTableViewController.h"
#import "PopularBookTableViewCell.h"
#import "BookService.h"
#import "Book.h"
#import "BookDetailModel.h" 
#import "TWIconButton.h"
#import "BookDetailViewController.h"
#import "BorrowFromPersonViewController.h"

@interface PopularBooksTableViewController ()
@property (nonatomic, strong) NSArray *popularBooks;
@end

@implementation PopularBooksTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [BookService fetchRecoBooksWithSucceedCallback:^(NSArray *recoBooks) {
        self.popularBooks = [recoBooks copy];
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.popularBooks.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PopularBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PopularBookTableViewCell" forIndexPath:indexPath];
    cell.book = self.popularBooks[indexPath.row];
    [cell updateUI];
    
    tableView.tableFooterView = [[UIView alloc] init];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    __block NSArray *array = nil;
    BookDetailModel *model = [[BookDetailModel alloc] init];
    model.title = @"书籍详情";
    [model updateInfoFromBook:self.popularBooks[indexPath.row]];

    model.updateStatsView = [[TWIconButton alloc] initWithTitle:@"申请借阅"
                                                           icon:nil
                                                         action:^{
                                                             //TODO add request borrow action
                                                         }];

    model.deleteView = [[TWIconButton alloc] initWithTitle:@"取消借阅"
                                                      icon:nil
                                                    action:^{
                                                        //TODO add request to cancel borrow action
                                                    }];

    [model updateAvailableStatusForBook:self.popularBooks[indexPath.row]
                                success:^(NSArray *bookEntities) {
                                    array = bookEntities;

                                    BookDetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BookDetailViewControllerIdentifier"];
                                    detailViewController.bookDetailModel = model;

                                    __weak TWIconButton *weakView = model.updateStatsView;

                                    if (model.status) {
                                        weakView.callback = ^{
                                            BorrowFromPersonViewController *bpc = [self.storyboard instantiateViewControllerWithIdentifier:@"BorrowFromPersonViewController"];
                                            bpc.avaliableBookEntities = model.availableBooks;
                                            [detailViewController.navigationController pushViewController:bpc animated:YES];
                                        };

                                    }

                                    [self.navigationController pushViewController:detailViewController animated:YES];

                                }];
    
}

@end
