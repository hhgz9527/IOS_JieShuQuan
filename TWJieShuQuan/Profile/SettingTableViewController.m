//
//  SettingTableViewController.m
//  TWJieShuQuan
//
//  Created by GaoYu on 15/6/27.
//  Copyright (c) 2015年 Jianing. All rights reserved.
//

#import "SettingTableViewController.h"

@interface SettingTableViewController ()

@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self submitFeedback:indexPath];
}

- (void)submitFeedback:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 1) {
        
    }
}

@end
