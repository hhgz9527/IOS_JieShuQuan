//
//  SendTwitterViewController.m
//  TWJieShuQuan
//
//  Created by GaoYu on 15/6/14.
//  Copyright (c) 2015年 Jianing. All rights reserved.
//

#import "SendTwitterViewController.h"
#import <AVObject.h>
#import <AVUser.h>
#import "CustomAlert.h"
#import <AVPush.h>

@interface SendTwitterViewController ()

@property (weak, nonatomic) IBOutlet UIView *selectView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectViewBottom;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *officeName;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end

@implementation SendTwitterViewController

- (void)viewWillAppear:(BOOL)animated {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"office"] != nil) {
        [self updateNotification];
    }
    [_textView becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"发信息";    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self removeOfficeUserDefaults];
}

- (IBAction)sendTwitter:(id)sender {
    if ([self textLength]) {
        AVObject *obj = [AVObject objectWithClassName:@"Find"];
        [obj setObject:[AVUser currentUser] forKey:@"user"];
        [obj setObject:_textView.text forKey:@"twitter"];
        [obj saveEventually:^(BOOL succeeded, NSError *error) {
            if (succeeded == YES) {
                NSLog(@"发布成功");
                [self isNotification];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }];

        [self removeOfficeUserDefaults];
    } else {
        [[CustomAlert alloc] showAlertWithMessage:@"字数限制"];
    }
}

- (BOOL)textLength {
    return _textView.text.length <= 140 && ![_textView.text isEqualToString:@""];
}

- (void)isNotification {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"office"] != nil) {
        AVPush *push = [[AVPush alloc] init];
        [push setChannel:[[NSUserDefaults standardUserDefaults] objectForKey:@"office"]];
        [push setMessage:_textView.text];
        [push sendPushInBackground];
     }
}

- (void)keyboardDidShow:(NSNotification *)nofi {
    if ([[[[AVUser currentUser] objectForKey:@"localData"] objectForKey:@"notification"] boolValue]) {
        NSDictionary *dic = [nofi userInfo];
        NSValue *value = [dic objectForKey:@"UIKeyboardFrameEndUserInfoKey"];
        CGRect rect = [value CGRectValue];
        _selectViewBottom.constant = rect.size.height;
        _selectView.hidden = NO;
    }
}

- (void)updateNotification {
    _officeName.hidden = NO;
    _cancelButton.hidden = NO;
    _officeName.text = [NSString stringWithFormat:@"推送至:%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"office"]];
}
- (IBAction)cancelNotification:(id)sender {
    [self removeOfficeUserDefaults];
    _officeName.hidden = YES;
    _cancelButton.hidden = YES;
}

- (void)removeOfficeUserDefaults {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"office"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
