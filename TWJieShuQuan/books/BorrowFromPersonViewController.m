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
    // send push notification to the selected user
    AVUser *currentUser = self.colleagues[indexPath.row];
    [NotificationManager sendBorrowBookNotificationToUser:currentUser];
}

@end
