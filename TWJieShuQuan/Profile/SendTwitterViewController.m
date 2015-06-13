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

@interface SendTwitterViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation SendTwitterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"发信息";
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)sendTwitter:(id)sender {
    if (_textView.text.length <= 140) {
        AVObject *obj = [AVObject objectWithClassName:@"Find"];
        [obj setObject:[AVUser currentUser] forKey:@"user"];
        [obj setObject:_textView.text forKey:@"twitter"];
        [obj saveEventually:^(BOOL succeeded, NSError *error) {
            if (succeeded == YES) {
                NSLog(@"发布成功");
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    }
}

@end
