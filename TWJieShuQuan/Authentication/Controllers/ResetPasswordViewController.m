//
//  ResetPasswordViewController.m
//  TWJieShuQuan
//
//  Created by Jianning Zheng on 5/25/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "CustomAlert.h"
#import "NSString+Extensions.h"
#import "AuthService.h"

@interface ResetPasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *resetEmailTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendResetButton;

@end

@implementation ResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpUICommponents];
    
    _resetEmailTextField.delegate = self;
}

- (void)setUpUICommponents {
    _sendResetButton.layer.borderColor = [UIColor whiteColor].CGColor;
    _sendResetButton.layer.borderWidth = 0.5f;
    _sendResetButton.layer.cornerRadius = 8;
}


- (IBAction)sendResetEmailButtonPressed:(id)sender {
    if (![self isValidEmailAddress:self.resetEmailTextField.text]) {
        [[CustomAlert sharedAlert] showAlertWithMessage:@"请输入正确的重置邮箱地址"];
        return;
    }
    
    [self.resetEmailTextField resignFirstResponder];
    
    [[AuthService sharedAuthManager] resetPasswordForEmail:self.resetEmailTextField.text succeeded:^{
        UIAlertView *successAlert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"重置密码的邮件已发送至%@，请登录邮箱进行重置", self.resetEmailTextField.text] delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [successAlert show];
    } failed:^(NSString *errorMessage) {
        [[CustomAlert sharedAlert] showAlertWithMessage:@"重置密码邮件发送失败"];
    }];
}

- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.resetEmailTextField resignFirstResponder];
    return YES;
}

- (IBAction)backgroundPressed:(id)sender {
    [self.resetEmailTextField resignFirstResponder];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - private

- (BOOL)isValidEmailAddress:(NSString *)email {
    NSString *regex = @"[A-Z0-9a-z._%+-]+@thoughtworks.com";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return ![email isEmpty] && [predicate evaluateWithObject:email];
}

@end
