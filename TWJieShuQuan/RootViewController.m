//
//  RootViewController.m
//  TWJieShuQuan
//
//  Created by Jianning Zheng on 5/25/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import "RootViewController.h"
#import "AuthService.h"
#import "LoginViewController.h"
#import "BorrowBookViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"首页";
}

- (IBAction)gotoBorrowBooksButtonPressed:(id)sender {
    BorrowBookViewController *borrowBookVC = [[BorrowBookViewController alloc] initWithNibName:@"BorrowBookViewController" bundle:nil];
    [self.navigationController pushViewController:borrowBookVC animated:YES];
}

- (IBAction)logoutPressed:(id)sender {
    [[AuthService sharedAuthManager] logout];
    
    LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    loginViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:loginViewController animated:YES completion:nil];
}

@end
