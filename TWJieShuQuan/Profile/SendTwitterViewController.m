//
//  SendTwitterViewController.m
//  TWJieShuQuan
//
//  Created by GaoYu on 15/6/14.
//  Copyright (c) 2015年 Jianing. All rights reserved.
//

#import "SendTwitterViewController.h"

@interface SendTwitterViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation SendTwitterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _textView.layer.borderWidth = 0.5;

    self.title = @"发信息";
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)sendTwitter:(id)sender {
    
}
@end
