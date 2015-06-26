//
//  MyBorrowOutTableViewController.m
//  TWJieShuQuan
//
//  Created by Jianning Zheng on 6/24/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import "MyBorrowOutTableViewController.h"
#import "BookService.h"
#import "CustomActivityIndicator.h"
#import "BorrowRecord.h"
#import "BorrowOutTableViewCell.h"

@interface MyBorrowOutTableViewController ()
@property (nonatomic, strong) NSArray *borrowedOutBookRecords;
@end

@implementation MyBorrowOutTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];
    [BookService fetchAllBorrowedOutRecordsWithSucceedCallback:^(NSArray *recoreds) {
        [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
        
        self.borrowedOutBookRecords = recoreds;
        [self.tableView reloadData];
    }];
}

//- (IBAction)pushToReturnButtonPressed:(UIButton *)sender {
//    BorrowRecord *selectedRecord = self.borrowedOutBookRecords[sender.tag];
//    
//    
//    
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.borrowedOutBookRecords.count;
}


- (BorrowOutTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BorrowRecord *currentRecord = self.borrowedOutBookRecords[indexPath.row];
    
    BorrowOutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BorrowOutTableViewCell" forIndexPath:indexPath];
    
    cell.tag = indexPath.row;
    cell.returnButton.tag = indexPath.row;
    
    cell.borrowRecord = currentRecord;
    [cell refreshUI];
    
    return cell;
}


@end
