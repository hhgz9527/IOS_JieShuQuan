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
    
    [self setUpUICommponents];
}

- (void)setUpUICommponents {
    _emailTextField.borderStyle = UITextBorderStyleNone;
    _passwordTextField.borderStyle = UITextBorderStyleNone;
    _loginButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [_emailTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_emailTextField setValue:[UIFont systemFontOfSize:20] forKeyPath:@"_placeholderLabel.font"];
    
    [_passwordTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_passwordTextField setValue:[UIFont systemFontOfSize:20] forKeyPath:@"_placeholderLabel.font"];
    
    _loginButton.layer.borderWidth = 1.f;
    _loginButton.layer.cornerRadius = 8;
}


// UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return true;
}


//- (IBAction)registerButtonPressed:(id)sender {
//    [[AuthService sharedAuthManager] signUpWithUsername:@"Jia Ning" password:@"testpassword" email:@"jnzheng@thoughtworks.com" phoneNumber:@"15211112222" succeeded:^{
//        NSLog(@"------- sign up succeeded -------");
//    } failed:^{
//        NSLog(@"======== sign up failed ====== ");
//    }];
//}

- (IBAction)loginButtonPressed:(id)sender {
    [[AuthService sharedAuthManager] loginWithUsername:@"testuser" password:@"testpassword" succeeded:^{
        NSLog(@"------- login succeeded -------");
    } failed:^{
        NSLog(@"======== login failed ====== ");
    }];
}

- (IBAction)forgetPasswordPressed:(id)sender {
     NSLog(@"------- forget password -------");
}

//- (IBAction)logoutButtonPressed:(id)sender {
//    [[AuthService sharedAuthManager] logout];
//}


@end
