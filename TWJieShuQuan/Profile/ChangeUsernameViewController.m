//
//  ChangeNickNameViewController.m
//  TWJieShuQuan
//
//  Created by GaoYu on 15/7/13.
//  Copyright (c) 2015年 Jianing. All rights reserved.
//

#import "ChangeUsernameViewController.h"
#import <AVOSCloud.h>
#import "CustomAlert.h"

@interface ChangeUsernameViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;

@end

@implementation ChangeUsernameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)doneAction:(id)sender {
    [_usernameTextField resignFirstResponder];
    [[AVUser currentUser] setObject:_usernameTextField.text forKey:@"username"];
    [[AVUser currentUser] saveEventually:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [[CustomAlert sharedAlert] showAlertWithMessage:@"网络错误"];
        }
    }];
}

@end
