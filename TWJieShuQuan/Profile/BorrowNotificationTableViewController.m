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

@interface BorrowNotificationTableViewController ()
@property (nonatomic, strong) NSMutableArray *fromUsers;
@property (nonatomic, strong) NSMutableArray *bookEntities;
@end

@implementation BorrowNotificationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.fromUsers = [NSMutableArray array];
    self.bookEntities = [NSMutableArray array];
    
    [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];
    [self fetchIfNeededInBackgroundWithArray:self.borrowBookNotifications index:0];
}

- (void)fetchIfNeededInBackgroundWithArray:(NSArray *)arr index:(NSInteger)index
{
    BorrowRecord *currentNotification = arr[index];
    index ++;
    AVUser *fromUser = [currentNotification objectForKey:@"fromUser"];
    [fromUser fetchIfNeededInBackgroundWithBlock:^(AVObject *user, NSError *error) {
        [self.fromUsers addObject:user];
        
        BookEntity *targetBookEntity = [currentNotification objectForKey:@"bookEntity"];
        [targetBookEntity fetchIfNeededInBackgroundWithBlock:^(AVObject *bookEntity, NSError *error) {
            [self.bookEntities addObject:bookEntity];

            if (index == self.borrowBookNotifications.count) {
                [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
                [self.tableView reloadData];
            } else {
                [self fetchIfNeededInBackgroundWithArray:arr index:index];
            }
        }];
    }];
}
- (IBAction)agreeToBorrow:(id)sender {
    
}

- (IBAction)rejectToBorrow:(id)sender {
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.fromUsers.count > 0) {
        return self.borrowBookNotifications.count;
    } else {
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.fromUsers.count > 0) {
        AVUser *currentFromUser = self.fromUsers[indexPath.row];
        BookEntity *currentBookEntity = self.bookEntities[indexPath.row];
        
        BorrowNotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BorrowNotificationTableViewCell" forIndexPath:indexPath];
        
        cell.notificationLabel.text = [NSString stringWithFormat:@"%@ 向你借阅《%@》", [currentFromUser username], [currentBookEntity bookName]];
        
        tableView.tableFooterView = [[UIView alloc] init];
        return cell;
    } else {
        return nil;
    }
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
