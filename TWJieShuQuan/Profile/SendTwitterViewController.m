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
#import "OfficeTableViewController.h"

@interface SendTwitterViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation SendTwitterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"发信息";
    [_textView becomeFirstResponder];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)sendTwitter:(id)sender {
    if (_textView.text.length <= 140 && ![_textView.text isEqualToString:@""]) {
        AVObject *obj = [AVObject objectWithClassName:@"Find"];
        [obj setObject:[AVUser currentUser] forKey:@"user"];
        [obj setObject:_textView.text forKey:@"twitter"];
        [obj saveEventually:^(BOOL succeeded, NSError *error) {
            if (succeeded == YES) {
                NSLog(@"发布成功");
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    } else {
        [[CustomAlert alloc] showAlertWithMessage:@"字数限制"];
    }
}

- (void)keyboardDidShow:(NSNotification *)nofi {
    NSDictionary *dic = [nofi userInfo];
    NSValue *value = [dic objectForKey:@"UIKeyboardFrameEndUserInfoKey"];
    CGRect rect = [value CGRectValue];

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, rect.origin.y - 44, rect.size.width, 44)];
    view.backgroundColor = [UIColor colorWithRed:243.f/255.f green:243.f/255.f blue:243.f/255.f alpha:1];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(0, 0, 44, 44);
    btn.center = CGPointMake(20, 22);
    [btn setTitle:@"@" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:25];
    [btn addTarget:self action:@selector(selectNotification) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    
    [self.view addSubview:view];
}

- (void)selectNotification {
    OfficeTableViewController *office = [[OfficeTableViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:office];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

@end
