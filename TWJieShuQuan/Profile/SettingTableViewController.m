//
//  SettingTableViewController.m
//  TWJieShuQuan
//
//  Created by GaoYu on 15/6/27.
//  Copyright (c) 2015年 Jianing. All rights reserved.
//

#import "SettingTableViewController.h"
#import <AVOSCloud.h>
#import "AuthService.h"
#import "UserManager.h"
#import "LaunchViewController.h"

@interface SettingTableViewController ()

@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 0) {
        [self submitFeedback];
    }
    
    if (indexPath.section == 2 && indexPath.row == 0) {
        [self logout];
    }
}

- (void)submitFeedback {
    AVUserFeedbackAgent *agent = [AVUserFeedbackAgent sharedInstance];
    [agent showConversations:self title:@"feedback" contact:[AVUser currentUser].username];
}

- (void)logout {
    [AuthService logout];
    [UserManager removeCurrentUser];
    
    LaunchViewController *launch = [[LaunchViewController alloc] initWithNibName:@"LaunchViewController" bundle:nil];
    launch.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:launch animated:YES completion:nil];
}



@end
