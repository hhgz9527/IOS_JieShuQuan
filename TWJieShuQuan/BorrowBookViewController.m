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
#import "BookService.h"
#import "MyBooksCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "BorrowBookDetailViewController.h"

@interface BorrowBookViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *recoBookImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *recoBookImageView2;
@property (weak, nonatomic) IBOutlet UIImageView *recoBookImageView3;
@property (weak, nonatomic) IBOutlet UIImageView *recoBookImageView4;

@property (weak, nonatomic) IBOutlet UIView *recoBooksSepatatorView;

@property (weak, nonatomic) IBOutlet UICollectionView *booksCollectionView;
@property (nonatomic, strong) NSMutableArray *books;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recoBooksTopConstraint;

@end

@implementation BorrowBookViewController

static NSString * const reuseIdentifier = @"MyBooksCollectionViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initNavBar];
    
    [self initSeparatorView];
    
    [self initCollectionView];
    
    // WIP
//    [BookService fetchRecoBooksWithSucceedCallback:^(NSArray *recoBooks) {
//        [self.recoBookImageView1 sd_setImageWithURL:[NSURL URLWithString:[(Book *)recoBooks[0] bookImageHref]]];
//        [self.recoBookImageView2 sd_setImageWithURL:[NSURL URLWithString:[(Book *)recoBooks[1] bookImageHref]]];
//        [self.recoBookImageView3 sd_setImageWithURL:[NSURL URLWithString:[(Book *)recoBooks[2] bookImageHref]]];
//        [self.recoBookImageView4 sd_setImageWithURL:[NSURL URLWithString:[(Book *)recoBooks[3] bookImageHref]]];
//    }];
    
    [BookService fetchAllBooksWithSucceedCallback:^(NSArray *myBooksObject) {
        self.books = [myBooksObject mutableCopy];
        
        [self.booksCollectionView reloadData];
    }];
}

- (void)initSeparatorView {
    self.recoBooksSepatatorView.backgroundColor = [UIColor redColor];
}

- (void)initCollectionView {
    self.booksCollectionView.delegate = self;
    self.booksCollectionView.dataSource = self;

    // Configure layout
    CGFloat screenWidth = self.view.frame.size.width;
    CGFloat cellWidth = screenWidth/3;
    [self.flowLayout setItemSize:CGSizeMake(cellWidth, 145)];
    [self.flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.flowLayout.minimumLineSpacing = 10.f;
    self.flowLayout.minimumInteritemSpacing = 0.0f;
    [self.booksCollectionView setCollectionViewLayout:self.flowLayout];
    
    self.booksCollectionView.bounces = YES;
    [self.booksCollectionView setShowsHorizontalScrollIndicator:NO];
    [self.booksCollectionView setShowsVerticalScrollIndicator:YES];
}

- (void)initNavBar {
    self.navigationItem.title = @"借书";

    UIButton *scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    scanButton.frame = CGRectMake(0, 0, 24, 24);
    [scanButton setBackgroundImage:[UIImage imageNamed:@"nav_scanIcon"] forState:UIControlStateNormal];
    [scanButton addTarget:self action:@selector(scanISBNWithBorrowBookViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *scanISBNButton = [[UIBarButtonItem alloc] initWithCustomView:scanButton];
    self.navigationItem.rightBarButtonItem = scanISBNButton;
}

- (void)scanISBNWithBorrowBookViewController {
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
        [DouBanService fetchingBookDetailWithISBN:barCode succeeded:^(NSDictionary *bookObject){
            [[CustomActivityIndicator sharedActivityIndicator] stopAsynchAnimating];

            NSLog(@"isbn succeed......%@", bookObject);

            Book *book = [[Book alloc] init];
            book.bookDoubanId = [bookObject valueForKey:@"id"];
            book.bookName = [bookObject valueForKey:@"title"];
            book.bookAuthor = [[bookObject valueForKey:@"author"] componentsJoinedByString:@","];
            book.bookImageHref = [bookObject valueForKey:@"image"];
            
            AddToLibraryViewController *addToLibraryVC = [[AddToLibraryViewController alloc] initWithNibName:@"AddToLibraryViewController" bundle:nil];
            addToLibraryVC.delegate = self;
            addToLibraryVC.book = book;
            [self presentViewController:addToLibraryVC animated:YES completion:nil];
        } failed:^{
            [[CustomActivityIndicator sharedActivityIndicator] stopAsynchAnimating];

            NSLog(@"isbn fail......");
        }];
    } else {
        [[CustomAlert sharedAlert] showAlertWithMessage:@"获取图书信息失败"];
    }

    [reader dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark <AddToLibraryDelegate>

- (void)didAddToLibraryForBook:(Book *)book {
    [self.books insertObject:book atIndex:0];

    [self.booksCollectionView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.books.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BookEntity *currentBook = self.books[indexPath.row];
    
    MyBooksCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    [cell refreshCellWithBookEntity:currentBook];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>


- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"borrowBookDetailSegue"]) {
        BorrowBookDetailViewController *borrowBookDetailViewController = (BorrowBookDetailViewController *)segue.destinationViewController;
        NSInteger row = [self.booksCollectionView indexPathForCell:sender].row;
        borrowBookDetailViewController.book = self.books[row];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > 10) {
        _recoBooksTopConstraint.constant = - 130;
    }
    if (scrollView.contentOffset.y <= 0) {
        _recoBooksTopConstraint.constant = 0;
    }
}

@end
