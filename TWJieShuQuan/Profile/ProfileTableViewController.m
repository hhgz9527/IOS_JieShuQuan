//
//  ProfileTableViewController.m
//  TWJieShuQuan
//
//  Created by Haibin Wang on 5/28/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import "ProfileTableViewController.h"

@interface ProfileTableViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *booksOwnedNum;
@property (weak, nonatomic) IBOutlet UILabel *booksBorrowedNum;
@end

@implementation ProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row){
        case 0:
            break;
        case 1:
            break;
        case 2:
            break;
        default:
            break;
    }
}
@end
