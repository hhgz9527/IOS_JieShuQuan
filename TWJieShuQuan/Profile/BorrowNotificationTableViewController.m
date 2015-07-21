//
//  BorrowNotificationTableViewController.m
//  TWJieShuQuan
//
//  Created by Jianning Zheng on 6/18/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import "BorrowNotificationTableViewController.h"
#import "BorrowNotificationTableViewCell.h"
#import "BorrowRecord.h"
#import "BookEntity.h"
#import "CustomActivityIndicator.h"
#import "BookService.h"
#import "CustomAlert.h"
#import "Constants.h"

@interface BorrowNotificationTableViewController ()
@end

@implementation BorrowNotificationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)agreeToBorrow:(UIButton *)sender {
    BorrowRecord *currentNotification = self.borrowBookNotifications[sender.tag];
    
    [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];
    [BookService changeBorrowRecordStatusTo:kAgreedStatus forBorrowRecord:currentNotification succeeded:^{
        [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
        [[CustomAlert sharedAlert] showAlertWithMessage:@"您已同意此借书请求"];
        
        [BookService updateBookAvailabilityWithBorrowRecord:currentNotification availbility:NO];
        
        [BookService increaseBorrowCountForBorrowRecord:currentNotification];
        
        [self.borrowBookNotifications removeObjectAtIndex:sender.tag];
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:sender.tag inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
}

- (IBAction)rejectToBorrow:(UIButton *)sender {
    BorrowRecord *currentNotification = self.borrowBookNotifications[sender.tag];
    
    [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];
    [BookService changeBorrowRecordStatusTo:kRejectedStatus forBorrowRecord:currentNotification succeeded:^{
        [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
        [[CustomAlert sharedAlert] showAlertWithMessage:@"您已取消此借书请求"];
        
        [self.borrowBookNotifications removeObjectAtIndex:sender.tag];
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:sender.tag inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.borrowBookNotifications.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    BorrowRecord *borrowRecord = self.borrowBookNotifications[indexPath.row];
    
    BorrowNotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BorrowNotificationTableViewCell" forIndexPath:indexPath];
    cell.tag = indexPath.row;
    cell.agreeButton.tag = indexPath.row;
    cell.notAgreeButton.tag = indexPath.row;
    
    cell.notificationLabel.text = [NSString stringWithFormat:@"%@ 向你借阅《%@》", borrowRecord.fromUserName, borrowRecord.bookName];
    
    tableView.tableFooterView = [[UIView alloc] init];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
