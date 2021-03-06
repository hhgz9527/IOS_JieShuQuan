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
#import "BookService.h"
#import "CustomAlert.h"
#import "CustomActivityIndicator.h"
#import "Discover.h"

@interface AddToLibraryViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bookImageView;
@property (weak, nonatomic) IBOutlet UILabel *bookNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bookAuthorLabel;
@property (weak, nonatomic) IBOutlet UIButton *addToLibraryButton;
@property (weak, nonatomic) IBOutlet UISwitch *availabilityStatusSwitch;

@end

@implementation AddToLibraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"添加入库";
    self.navigationController.navigationBar.translucent = NO;
    
    [self.bookImageView sd_setImageWithURL:[NSURL URLWithString:self.book.bookImageHref]];
    self.bookNameLabel.text = self.book.bookName;
    self.bookAuthorLabel.text = self.book.bookAuthor;
    [self setBookImageShadow];
}

- (void)setBookImageShadow {
    _bookImageView.layer.shadowOpacity = 2;
    _bookImageView.layer.shadowOffset = CGSizeMake(2, 2);
}

- (IBAction)addToLibraryButtonPressed:(id)sender {
    [BookService addBookToLibrary:self.book availability:self.availabilityStatusSwitch.on succeeded:^{
        [[CustomAlert sharedAlert] showAlertWithMessage:@"已成功添加进您的书库！"];
        [self.delegate didAddToLibraryForBook:self.book];
        if (self.availabilityStatusSwitch.on) {
            [self sendMessageToFindViewWith:self.book.bookName];
        }
    }];
}

- (void)sendMessageToFindViewWith:(NSString *)bookName {
    AVObject *obj = [AVObject objectWithClassName:@"Discover"];
    AVFile *file = [[AVUser currentUser] objectForKey:@"avatar"];
    [obj setObject:[AVUser currentUser] forKey:@"user"];
    [obj setObject:[[[AVUser currentUser] objectForKey:@"localData"] objectForKey:@"nickname"] forKey:@"nickname"];
    [obj setObject:file.url forKey:@"avatar"];
    [obj setObject:bookName forKey:@"bookName"];
    [obj setObject:[NSNumber numberWithInt:DISCOVERTYPE_ADDBOOK] forKey:@"type"];
    [obj saveEventually:^(BOOL succeeded, NSError *error) {
        if (succeeded == YES) {
            NSLog(@"发布成功");
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DidAddToLibraryForBook" object:self];
        }
    }];
}

- (IBAction)cancelButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
