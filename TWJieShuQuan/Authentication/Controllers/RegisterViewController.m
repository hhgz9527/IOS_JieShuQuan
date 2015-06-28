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
#import <AVOSCloud.h>

@interface RegisterViewController ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *officePickerView;
@property (nonatomic, strong) UITextField *activeTextField;
@property (nonatomic, strong) NSMutableArray *officeArray;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpUICommponents];
    
    _emailTextField.delegate = self;
    _passwordTextField.delegate = self;
    _confirmPasswordTextField.delegate = self;
    
    AVQuery *query = [AVQuery queryWithClassName:@"Office"];
    [query addDescendingOrder:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"%@", objects);
        _officeArray = [NSMutableArray array];
        for (AVObject *item in objects) {
            [_officeArray addObject:[[item objectForKey:@"localData"] objectForKey:@"name"]];
        }
        [_officePickerView reloadAllComponents];
    }];
}

- (void)setUpUICommponents {
    _registerButton.layer.borderColor = [UIColor whiteColor].CGColor;
    _registerButton.layer.borderWidth = 0.5f;
    _registerButton.layer.cornerRadius = 8;
}

#pragma mark - UITextFieldDelegate

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
    
    if (![self isValidEmailAddress:self.emailTextField.text]) {
        [[CustomAlert sharedAlert] showAlertWithMessage:@"请使用thoughtworks邮箱注册！"];
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
    
    if (self.passwordTextField.text.length < 6 || self.passwordTextField.text.length > 20) {
        [[CustomAlert sharedAlert] showAlertWithMessage:@"密码必须为6-20位！"];
        return;
    }

    if (![self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text]) {
        [[CustomAlert sharedAlert] showAlertWithMessage:@"两次输入密码不一致！"];
        return;
    }

    [AuthService signUpWithEmail:self.emailTextField.text password:self.passwordTextField.text succeeded:^{
        UIAlertView *successAlert = [[UIAlertView alloc] initWithTitle:nil message:@"注册成功，请登录邮箱进行验证，并重新登录" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [successAlert show];
    } failed:^(NSString *errorMessage) {
        [[CustomAlert sharedAlert] showAlertWithMessage:errorMessage];
    }];
}

- (IBAction)backToLoginPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [AuthService logout];
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - private

- (BOOL)isValidEmailAddress:(NSString *)email {
    NSString *regex = @"[A-Z0-9a-z._%+-]+@thoughtworks.com";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:email];
}


#pragma mark - picker view delegate

- (IBAction)selectOfficeBase:(id)sender {
    [self textFieldShouldReturn:nil];
    _officePickerView.hidden = NO;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _officeArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%@", _officeArray[row]];
}

@end
