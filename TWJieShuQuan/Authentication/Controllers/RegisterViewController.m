//
//  RegisterViewController.m
//  TWJieShuQuan
//
//  Created by Jianning Zheng on 5/22/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import "RegisterViewController.h"
#import "AuthService.h"
#import "NSString+Extensions.h"
#import "CustomAlert.h"

@interface RegisterViewController ()
@property (nonatomic, strong) UITextField *activeTextField;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpUICommponents];
    
    _emailTextField.delegate = self;
    _passwordTextField.delegate = self;
}

- (void)setUpUICommponents {
    _registerButton.layer.borderColor = [UIColor whiteColor].CGColor;
    _registerButton.layer.borderWidth = 0.5f;
    _registerButton.layer.cornerRadius = 8;
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
        [self.confirmPasswordTextField becomeFirstResponder];
        return YES;
    }
    
    if (self.activeTextField == self.confirmPasswordTextField) {
        [self.activeTextField resignFirstResponder];
        return YES;
    }
    
    return NO;
}

- (IBAction)backgroundViewTouchDown:(id)sender {
    [self.activeTextField resignFirstResponder];
}

- (IBAction)registerButtonPressed:(id)sender {
    [self.activeTextField resignFirstResponder];
    
    if ([self.emailTextField.text isEmpty]) {
        [[CustomAlert sharedAlert] showAlertWithMessage:@"邮箱不能为空！"];
        return;
    }
    
    if ([self.passwordTextField.text isEmpty]) {
        [[CustomAlert sharedAlert] showAlertWithMessage:@"密码不能为空！"];
        return;
    }
    
    if ([self.confirmPasswordTextField.text isEmpty]) {
        [[CustomAlert sharedAlert] showAlertWithMessage:@"确认密码不能为空！"];
        return;
    }

    if (![self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text]) {
        [[CustomAlert sharedAlert] showAlertWithMessage:@"两次输入密码不一致！"];
        return;
    }

    [[AuthService sharedAuthManager] signUpWithEmail:self.emailTextField.text password:self.passwordTextField.text succeeded:^{
        [[CustomAlert sharedAlert] showAlertWithMessage:@"注册成功"];
    } failed:^(NSString *errorMessage) {
        [[CustomAlert sharedAlert] showAlertWithMessage:errorMessage];
    }];
}


- (IBAction)backToLoginPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
