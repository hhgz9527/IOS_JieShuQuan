//
//  LaunchViewController.m
//  TWJieShuQuan
//
//  Created by GaoYu on 15/7/25.
//  Copyright (c) 2015年 Jianing. All rights reserved.
//

#import "LaunchViewController.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"

@interface LaunchViewController ()
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation LaunchViewController

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)loginAction:(id)sender {
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil]];
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)registerAction:(id)sender {
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil]];
    [self presentViewController:nav animated:YES completion:nil];
}

@end
