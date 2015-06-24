//
//  MyBorrowInBooksTableViewController.m
//  TWJieShuQuan
//
//  Created by Jianning Zheng on 6/23/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import "MyBorrowInBooksTableViewController.h"
#import "BookService.h"
#import "CustomActivityIndicator.h"
#import "BorrowRecord.h"
#import "BorrowInTableViewCell.h"

@interface MyBorrowInBooksTableViewController ()
@property (nonatomic, strong) NSArray *borrowedInBookRecords;
@end

@implementation MyBorrowInBooksTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] init];

    [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];
    [BookService fetchAllBorrowedInRecordsWithSucceedCallback:^(NSArray *recoreds) {
        [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];

        self.borrowedInBookRecords = recoreds;
        [self.tableView reloadData];
    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.borrowedInBookRecords.count;
}


- (BorrowInTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BorrowRecord *currentRecord = self.borrowedInBookRecords[indexPath.row];
    
    BorrowInTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BorrowInTableViewCell" forIndexPath:indexPath];
    
    cell.borrowRecord = currentRecord;
    [cell refreshUI];
    
    return cell;
}


@end
