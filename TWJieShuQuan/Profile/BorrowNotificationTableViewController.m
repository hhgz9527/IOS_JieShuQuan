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
    BorrowRecord *borrowRecord = self.borrowBookNotifications[indexPath.row];
    
    BorrowNotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BorrowNotificationTableViewCell" forIndexPath:indexPath];
    cell.tag = indexPath.row;
    cell.agreeButton.tag = indexPath.row;
    cell.notAgreeButton.tag = indexPath.row;
    
    cell.notificationLabel.text = [NSString stringWithFormat:@"%@ 向你借阅《%@》", borrowRecord.fromUsername, borrowRecord.bookName];
    
    tableView.tableFooterView = [[UIView alloc] init];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
