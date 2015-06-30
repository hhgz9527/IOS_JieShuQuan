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

@end
