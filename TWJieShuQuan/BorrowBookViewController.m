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
#import "BookDetailViewController.h"
#import "BookDetailModel.h"
#import "TWIconButton.h"
#import "BorrowFromPersonViewController.h"
#import "Constants.h"

static NSInteger kStart = 0;

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

@property (weak, nonatomic) IBOutlet UIView *loadMoreView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activitiView;
@property (weak, nonatomic) IBOutlet UIButton *loadMoreButton;


@property (nonatomic, retain) UIRefreshControl *refreshControl;
@end

@implementation BorrowBookViewController

static NSString * const reuseIdentifier = @"MyBooksCollectionViewCell";

- (void)viewDidLoad {
    kStart = 0;

    [super viewDidLoad];

    [self initNavBar];
    
    [self initSeparatorView];
    
    [self initCollectionView];
    
    // pull to refresh
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
    [self.refreshControl addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventValueChanged];
    [self.booksCollectionView addSubview:self.refreshControl];

    
    // WIP
//    [BookService fetchRecoBooksWithSucceedCallback:^(NSArray *recoBooks) {
//        [self.recoBookImageView1 sd_setImageWithURL:[NSURL URLWithString:[(Book *)recoBooks[0] bookImageHref]]];
//        [self.recoBookImageView2 sd_setImageWithURL:[NSURL URLWithString:[(Book *)recoBooks[1] bookImageHref]]];
//        [self.recoBookImageView3 sd_setImageWithURL:[NSURL URLWithString:[(Book *)recoBooks[2] bookImageHref]]];
//        [self.recoBookImageView4 sd_setImageWithURL:[NSURL URLWithString:[(Book *)recoBooks[3] bookImageHref]]];
//    }];
    
    [self refreshData:nil];
}

- (void)refreshData:(UIRefreshControl *)refresh {
    [self.activitiView startAnimating];

    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"更新数据中..."];

    kStart = 0;
    [BookService fetchAllBooksWithStart:kStart succeeded:^(NSArray *myBooksObject) {
        self.books = [myBooksObject mutableCopy];
        
        [self.booksCollectionView reloadData];
        
        [refresh endRefreshing];
        [self.activitiView stopAnimating];
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

- (IBAction)loadMore:(id)sender {
    [self.activitiView startAnimating];
    [BookService fetchAllBooksWithStart:kPageLoadCount*(kStart++ + 1) succeeded:^(NSArray *myBooksObject) {
        [myBooksObject enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [self.books addObject:obj];
        }];
        
        [self.booksCollectionView reloadData];
        
        [self.activitiView stopAnimating];
    }];
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
            book.bookPress = bookObject[@"publisher"];
            
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
//    [self performSegueWithIdentifier:@"borrowBookDetailSegue" sender:[collectionView cellForItemAtIndexPath:indexPath]];

    __block NSArray *array = nil;
    BookDetailModel *model = [[BookDetailModel alloc] init];
    model.title = @"书籍详情";
    [model updateInfoFromBook:self.books[indexPath.row]];
    [model updateAvailableStatusForBook:self.books[indexPath.row]
                                success:^(NSArray *bookEntities) {
                                    array = bookEntities;
                                }];

    model.updateStatsView = [[TWIconButton alloc] initWithTitle:@"申请借阅"
                                                           icon:nil
                                                         action:^{
                                                             //TODO add request borrow action
                                                         }];

    model.deleteView = [[TWIconButton alloc] initWithTitle:@"取消借阅"
                                                      icon:nil
                                                    action:^{
                                                        //TODO add request to cancel borrow action
                                                    }];


    BookDetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BookDetailViewControllerIdentifier"];
    detailViewController.bookDetailModel = model;

    __weak TWIconButton *weakView = model.updateStatsView;
    weakView.callback = ^{
        weakView.title = @"借阅中...";
        BorrowFromPersonViewController *bpc = [self.storyboard instantiateViewControllerWithIdentifier:@"BorrowFromPersonViewController"];
        bpc.avaliableBookEntities = model.availableBooks;
        [detailViewController.navigationController pushViewController:bpc animated:YES];

    };

    [self.navigationController pushViewController:detailViewController animated:YES];

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
