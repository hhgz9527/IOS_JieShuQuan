//
//  ChangePasswordViewController.m
//  TWJieShuQuan
//
//  Created by GaoYu on 15/7/13.
//  Copyright (c) 2015年 Jianing. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import <AVOSCloud.h>
#import "CustomAlert.h"

@interface ChangePasswordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *oldPassword;
@property (weak, nonatomic) IBOutlet UITextField *comfirPassword;
@property (weak, nonatomic) IBOutlet UITextField *resetPassword;

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)changePasswordDoneAction:(id)sender {
    [_oldPassword resignFirstResponder];
    [_comfirPassword resignFirstResponder];
    [_resetPassword resignFirstResponder];
    if (![_resetPassword.text isEqualToString:_comfirPassword.text]) {
        [[CustomAlert sharedAlert] showAlertWithMessage:@"两次输入密码不一致"];
        return;
    }
    
    if (_resetPassword.text.length < 6 || _resetPassword.text.length > 20) {
        [[CustomAlert sharedAlert] showAlertWithMessage:@"密码必须为6-20位"];
        return;

    }
    
    [[AVUser currentUser] updatePassword:_oldPassword.text newPassword:_resetPassword.text block:^(id object, NSError *error) {
        if (error.code == 210) {
            [[CustomAlert sharedAlert] showAlertWithMessage:@"旧密码错误"];
        }
        
        if (!error) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

@end
