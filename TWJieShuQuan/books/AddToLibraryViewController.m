//
//  AddToLibraryViewController.m
//  TWJieShuQuan
//
//  Created by Jianning Zheng on 5/26/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import "AddToLibraryViewController.h"
#import "Book.h"

@interface AddToLibraryViewController ()
@property (weak, nonatomic) IBOutlet UILabel *bookNameLabel;

@end

@implementation AddToLibraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"添加入库";
    
    self.bookNameLabel.text = self.book.bookName;
}


@end
