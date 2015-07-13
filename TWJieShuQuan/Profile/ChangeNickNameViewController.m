//
//  ChangeNickNameViewController.m
//  TWJieShuQuan
//
//  Created by GaoYu on 15/7/13.
//  Copyright (c) 2015年 Jianing. All rights reserved.
//

#import "ChangeNickNameViewController.h"
#import <AVOSCloud.h>
#import "CustomAlert.h"

@interface ChangeNickNameViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;

@end

@implementation ChangeNickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)doneAction:(id)sender {
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
