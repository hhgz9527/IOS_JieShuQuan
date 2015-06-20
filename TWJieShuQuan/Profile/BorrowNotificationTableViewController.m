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

@interface BorrowNotificationTableViewController ()

@end

@implementation BorrowNotificationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.borrowBookNotifications.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BorrowRecord *currentNotification = self.borrowBookNotifications[indexPath.row];
    BorrowNotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BorrowNotificationTableViewCell" forIndexPath:indexPath];
    
    AVUser *fromUser = [currentNotification objectForKey:@"fromUser"];
    [fromUser fetchIfNeededInBackgroundWithBlock:^(AVObject *user, NSError *error) {
        
        BookEntity *targetBookEntity = [currentNotification objectForKey:@"bookEntity"];
        [targetBookEntity fetchIfNeededInBackgroundWithBlock:^(AVObject *bookEntity, NSError *error) {
            cell.notificationLabel.text = [NSString stringWithFormat:@"%@ 向你借阅《%@》", [(AVUser *)user username], [(BookEntity *)bookEntity bookName]];
        }];

    }];
    
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
