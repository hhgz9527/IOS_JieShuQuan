//
//  LoginViewController.m
//  TWJieShuQuan
//
//  Created by Jianning Zheng on 5/19/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import "LoginViewController.h"
#import "AuthService.h"

@interface LoginViewController ()


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)registerButtonPressed:(id)sender {
    [[AuthService sharedAuthManager] signUpWithUsername:@"testuser" password:@"testpassword" email:@"test@gmail.com" phoneNumber:@"15211112222" succeeded:^{
        NSLog(@"------- sign up succeeded -------");
    } failed:^{
        NSLog(@"======== sign up failed ====== ");
    }];
}

- (IBAction)loginButtonPressed:(id)sender {
    [[AuthService sharedAuthManager] loginWithUsername:@"testuser" password:@"testpassword" succeeded:^{
        NSLog(@"------- login succeeded -------");
    } failed:^{
        NSLog(@"======== login failed ====== ");
    }];
}

- (IBAction)logoutButtonPressed:(id)sender {
    [[AuthService sharedAuthManager] logout];
}


@end
