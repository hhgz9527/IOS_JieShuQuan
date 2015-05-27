//
//  AddToLibraryViewController.m
//  TWJieShuQuan
//
//  Created by Jianning Zheng on 5/26/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import "AddToLibraryViewController.h"
#import "Book.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface AddToLibraryViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bookImageView;
@property (weak, nonatomic) IBOutlet UILabel *bookNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bookAuthorLabel;
@property (weak, nonatomic) IBOutlet UIButton *addToLibraryButton;

@end

@implementation AddToLibraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"添加入库";
    self.navigationController.navigationBar.translucent = NO;
    
    [self.bookImageView sd_setImageWithURL:[NSURL URLWithString:self.book.bookImageHref]];
    self.bookNameLabel.text = self.book.bookName;
    self.bookAuthorLabel.text = self.book.bookAuthor;
}

- (IBAction)addToLibraryButtonPressed:(id)sender {
    NSLog(@"adding to library.....");
}

@end
