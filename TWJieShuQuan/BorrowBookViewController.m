//
//  BorrowBookViewController.m
//  TWJieShuQuan
//
//  Created by Jianning Zheng on 5/26/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import "BorrowBookViewController.h"
#import "CustomAlert.h"
#import "DouBanService.h"
#import "CustomActivityIndicator.h"
#import "AddToLibraryViewController.h"
#import "Book.h"

@interface BorrowBookViewController ()

@end

@implementation BorrowBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"借书";
    
    UIBarButtonItem *scanISBNButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"test"] style:UIBarButtonItemStylePlain target:self action:@selector(scanISBN)];
    self.navigationItem.rightBarButtonItem = scanISBNButton;
}

- (void)scanISBN {
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = reader.scanner;
    [scanner setSymbology: ZBAR_I25 config: ZBAR_CFG_ENABLE to: 0];
    
    [self presentViewController:reader animated:YES completion:nil];
}

- (void) imagePickerController: (UIImagePickerController*) reader didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results) {
        // EXAMPLE: just grab the first barcode
        break;
    }
    
    NSString *barCode = symbol.data;
    NSLog(@"---------- barcode:%@", barCode);
    
    if (barCode) {
        [[CustomActivityIndicator sharedActivityIndicator] startAsynchAnimating];
        [[DouBanService sharedDouBanService] fetchingBookDetailWithISBN:barCode succeeded:^(NSDictionary *bookObject){
            [[CustomActivityIndicator sharedActivityIndicator] stopAsynchAnimating];

            NSLog(@"isbn succeed......%@", bookObject);

            Book *book = [[Book alloc] init];
            book.bookName = [bookObject valueForKey:@"title"];
            book.bookAuthor = [[bookObject valueForKey:@"author"] componentsJoinedByString:@","];
            book.bookImageHref = [bookObject valueForKey:@"image"];
            
            AddToLibraryViewController *addToLibraryVC = [[AddToLibraryViewController alloc] initWithNibName:@"AddToLibraryViewController" bundle:nil];
            addToLibraryVC.book = book;
            [self.navigationController pushViewController:addToLibraryVC animated:YES];

        } failed:^{
            [[CustomActivityIndicator sharedActivityIndicator] stopAsynchAnimating];

            NSLog(@"isbn fail......");
        }];
    } else {
        [[CustomAlert sharedAlert] showAlertWithMessage:@"获取图书信息失败"];
    }

    [reader dismissViewControllerAnimated:YES completion:nil];
}

@end
