//
//  ChangeNickNameViewController.m
//  TWJieShuQuan
//
//  Created by GaoYu on 15/7/13.
//  Copyright (c) 2015年 Jianing. All rights reserved.
//

#import "ChangeNicknameViewController.h"
#import <AVOSCloud.h>
#import "CustomAlert.h"

@interface ChangeNicknameViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;

@end

@implementation ChangeNicknameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)doneAction:(id)sender {
    [_usernameTextField resignFirstResponder];
    [[AVUser currentUser] setObject:_usernameTextField.text forKey:@"nickname"];
    [[AVUser currentUser] saveEventually:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [[CustomAlert sharedAlert] showAlertWithMessage:@"网络错误"];
        }
    }];
}

@end
