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
#import "ResetPasswordViewController.h"
#import "UserManager.h"
#import "NotificationManager.h"

@interface LoginViewController ()
@property (nonatomic, strong) UITextField *activeTextField;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;

    [self setUpUICommponents];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(loginCancel)];
    _emailTextField.delegate = self;
    _passwordTextField.delegate = self;
}

- (void)loginCancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setUpUICommponents {
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
    
    [AuthService loginWithEmail:self.emailTextField.text password:self.passwordTextField.text succeeded:^{
        [[CustomAlert sharedAlert] showAlertWithMessage:@"登录成功"];
        
        // save login user to UserDefaults
        [UserManager saveCurrentUser];
        
        // save login user to AVInstallation for push notification
        [NotificationManager saveLoginUsers];
        
        UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"main" bundle:nil];
        UIViewController *rootVC = (UIViewController *)mainSB.instantiateInitialViewController;
        rootVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:rootVC animated:YES completion:nil];
    } failed:^(NSString *errorMessage) {
        [[CustomAlert sharedAlert] showAlertWithMessage:errorMessage];
    }];
}

- (IBAction)forgetPasswordPressed:(id)sender {
    ResetPasswordViewController *resetPasswordViewController = [[ResetPasswordViewController alloc] initWithNibName:@"ResetPasswordViewController" bundle:nil];
    resetPasswordViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:resetPasswordViewController animated:YES completion:nil];
}

- (IBAction)registerButtonPressed:(id)sender {
    RegisterViewController *registerVC = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
    registerVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:registerVC animated:YES completion:nil];
}

@end
