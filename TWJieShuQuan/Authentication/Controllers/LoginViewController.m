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
    _emailTextField.borderStyle = UITextBorderStyleNone;
    _passwordTextField.borderStyle = UITextBorderStyleNone;
    _loginButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [_emailTextField setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_emailTextField setValue:[UIFont systemFontOfSize:20] forKeyPath:@"_placeholderLabel.font"];
    
    [_passwordTextField setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_passwordTextField setValue:[UIFont systemFontOfSize:20] forKeyPath:@"_placeholderLabel.font"];
    
    _loginButton.layer.borderWidth = 1.f;
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
    [[CustomAlert sharedAlert] showAlertWithMessage:@"忘记密码"];
}

@end
