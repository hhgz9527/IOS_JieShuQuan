//
//  LoginViewController.m
//  TWJieShuQuan
//
//  Created by Jianning Zheng on 5/19/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import "LoginViewController.h"
#import "AuthService.h"
#import "NSString+Extensions.h"
#import "CustomAlert.h"
#import "RegisterViewController.h"

@interface LoginViewController ()
@property (nonatomic, strong) UITextField *activeTextField;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpUICommponents];
    
    _emailTextField.delegate = self;
    _passwordTextField.delegate = self;
}

- (void)setUpUICommponents {
    _loginButton.layer.borderColor = [UIColor whiteColor].CGColor;
    _loginButton.layer.borderWidth = 0.5f;
    _loginButton.layer.cornerRadius = 8;
}


#pragma UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activeTextField = textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.activeTextField == self.emailTextField) {
        [self.passwordTextField becomeFirstResponder];
        return YES;
    }
    
    if (self.activeTextField == self.passwordTextField) {
        [self.activeTextField resignFirstResponder];
        return YES;
    }
    
    return NO;
}

- (IBAction)loginBackgroundViewTouchDown:(id)sender {
    [self.activeTextField resignFirstResponder];
}

- (IBAction)loginButtonPressed:(id)sender {
    [self.activeTextField resignFirstResponder];
    
    if ([self.emailTextField.text isEmpty]) {
        [[CustomAlert sharedAlert] showAlertWithMessage:@"邮箱不能为空！"];
        return;
    }
    
    if ([self.passwordTextField.text isEmpty]) {
        [[CustomAlert sharedAlert] showAlertWithMessage:@"密码不能为空！"];
        return;
    }
    
    [[AuthService sharedAuthManager] loginWithEmail:self.emailTextField.text password:self.passwordTextField.text succeeded:^{
        [[CustomAlert sharedAlert] showAlertWithMessage:@"登录成功"];
    } failed:^(NSString *errorMessage) {
        [[CustomAlert sharedAlert] showAlertWithMessage:errorMessage];
    }];
}

- (IBAction)forgetPasswordPressed:(id)sender {
    [[AuthService sharedAuthManager] resetPasswordForEmail:[AVUser currentUser].email succeeded:^{
        UIAlertView *successAlert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"重置密码的邮件已发送至%@，请登录邮箱进行重置", [AVUser currentUser].email] delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [successAlert show];
    } failed:^(NSString *errorMessage) {
        [[CustomAlert sharedAlert] showAlertWithMessage:@"重置密码邮件发送失败"];
    }];
}

- (IBAction)registerButtonPressed:(id)sender {
    RegisterViewController *registerVC = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
    registerVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:registerVC animated:YES completion:nil];
}

@end
