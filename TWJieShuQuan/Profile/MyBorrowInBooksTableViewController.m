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
#import "Constants.h"
#import "CustomAlert.h"

@interface MyBorrowInBooksTableViewController ()
@property (nonatomic, strong) NSMutableArray *borrowedInBookRecords;
@end

@implementation MyBorrowInBooksTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] init];

    [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];
    [BookService fetchAllBorrowedInRecordsWithSucceedCallback:^(NSArray *recoreds) {
        [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];

        self.borrowedInBookRecords = [recoreds mutableCopy];
        [self.tableView reloadData];
    }];
}

- (IBAction)returnButtonPressed:(UIButton *)sender {
    BorrowRecord *selectedRecord = self.borrowedInBookRecords[sender.tag];
    
    [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];
    [BookService changeBorrowRecordStatusTo:kReturnedStatus forBorrowRecord:selectedRecord succeeded:^{
        [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
        [[CustomAlert sharedAlert] showAlertWithMessage:@"您已归还此书"];
        
        [self.borrowedInBookRecords removeObjectAtIndex:sender.tag];
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:sender.tag inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
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
    
    cell.tag = indexPath.row;
    cell.returnButton.tag = indexPath.row;
    
    cell.borrowRecord = currentRecord;
    [cell refreshUI];
    
    return cell;
}


@end
