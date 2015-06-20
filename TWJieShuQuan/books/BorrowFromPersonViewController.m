//
//  BorrowFromPersonViewController.m
//  TWJieShuQuan
//
//  Created by Jianning Zheng on 6/13/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import "BorrowFromPersonViewController.h"
#import "BorrowFromPersonTableViewCell.h"
#import "BookService.h"
#import "NotificationManager.h"
#import "CustomAlert.h"
#import "CustomActivityIndicator.h"

@interface BorrowFromPersonViewController ()
@property (weak, nonatomic) IBOutlet UITableView *colleaguesTableView;
@property (nonatomic, strong) NSArray *colleagues;

@end

@implementation BorrowFromPersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.colleaguesTableView.dataSource = self;
    self.colleaguesTableView.delegate = self;
    
    [BookService fetchOwnersFromBookEntities:self.avaliableBookEntities withSucceedCallback:^(NSArray *owners) {
        self.colleagues = owners;
        [self.colleaguesTableView reloadData];
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.colleagues.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AVUser *currentUser = self.colleagues[indexPath.row];
    
    static NSString *iden = @"BorrowFromPersonTableViewCell";
    BorrowFromPersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    cell.bookNameLabel.text = currentUser.username;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // send push notification to the selected user
    AVUser *targetUser = self.colleagues[indexPath.row];
    BookEntity *targetBookEntity = self.avaliableBookEntities[indexPath.row];
    
    [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];
    [BookService createBorrowRecordFromUser:[AVUser currentUser] toUser:targetUser forBookEntity:targetBookEntity succeeded:^{
        [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
        
        [NotificationManager sendBorrowBookNotificationToUser:targetUser forBookEntity:targetBookEntity];
        
        [[CustomAlert sharedAlert] showAlertWithMessage:@"借书申请已发，请等待确认"];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

@end
