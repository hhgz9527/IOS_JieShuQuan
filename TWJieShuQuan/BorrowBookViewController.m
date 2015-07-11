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
#import "BookDetailViewController.h"
#import "BookDetailModel.h"
#import "TWIconButton.h"
#import "BorrowFromPersonViewController.h"
#import "Constants.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "SearchView.h"
#import <SVPullToRefresh.h>
#import "UIScrollView+SVPullToRefresh.h"

static NSInteger kStart = 0;

@interface BorrowBookViewController () <UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *booksCollectionView;
@property (nonatomic, strong) NSMutableArray *books;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *leftBarButton;

@property (nonatomic, retain) UIRefreshControl *refreshControl;
@property (nonatomic, strong) SearchView *searchView;

@end

@implementation BorrowBookViewController

static NSString * const reuseIdentifier = @"MyBooksCollectionViewCell";

- (void)viewDidLoad {
    kStart = 0;

    [super viewDidLoad];

    [self initNavBar];
    
    [self initCollectionView];
    
    // pull to refresh
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
    [self.refreshControl addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventValueChanged];
    [self.booksCollectionView addSubview:self.refreshControl];
    
    [self.booksCollectionView addInfiniteScrollingWithActionHandler:^{
        kStart = kStart + 1;
        [self loadMore:kPageLoadCount*kStart];
        [self.booksCollectionView.infiniteScrollingView stopAnimating];
    }];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshData:nil];
}

- (void)loadMore:(NSUInteger)number {
    [BookService fetchAllBooksWithStart:number succeeded:^(NSArray *myBooksObject) {
        [myBooksObject enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [self.books addObject:obj];
        }];
//        self.books = [myBooksObject mutableCopy];
        
        [self.booksCollectionView reloadData];
    }];
}

- (void)refreshData:(UIRefreshControl *)refresh {
    kStart = 0;
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"更新数据中..."];

    [BookService fetchAllBooksWithStart:kStart succeeded:^(NSArray *myBooksObject) {
        self.books = [myBooksObject mutableCopy];
        
        [self.booksCollectionView reloadData];
        
        [refresh endRefreshing];
    }];
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
    scanButton.frame = CGRectMake(0, 0, 22, 20);
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
            book.bookPress = bookObject[@"publisher"];
            book.bookDescription = bookObject[@"summary"];
            
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
    [self pushToDetails:self.books[indexPath.row]];
}

#pragma mark - search

- (IBAction)searchButton:(id)sender {
    if ([_leftBarButton.title isEqualToString:@"搜索"]) {
        _searchView = [[SearchView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        _searchView.viewController = self;
        [self.view addSubview:_searchView];
        _leftBarButton.title = @"取消";
    } else {
        _leftBarButton.title = @"搜索";
        [_searchView removeFromSuperview];

    }
}


- (void)pushToDetails:(Book *)book {
    __block NSArray *array = nil;
    BookDetailModel *model = [[BookDetailModel alloc] init];
    model.title = @"书籍详情";
    [model updateInfoFromBook:book];

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

    __weak typeof(model) weakModel = model;
    [model updateAvailableStatusForBook:book
                                success:^(NSArray *bookEntities) {
                                    array = bookEntities;

                                    BookDetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BookDetailViewControllerIdentifier"];
                                    detailViewController.bookDetailModel = weakModel;

                                    __weak TWIconButton *weakView = weakModel.updateStatsView;

                                    if (weakModel.status) {
                                        weakView.callback = ^{
                                            BorrowFromPersonViewController *bpc = [self.storyboard instantiateViewControllerWithIdentifier:@"BorrowFromPersonViewController"];
                                            bpc.avaliableBookEntities = model.availableBooks;
                                            [detailViewController.navigationController pushViewController:bpc animated:YES];

                                        };
                                    }

                                    [self.navigationController pushViewController:detailViewController animated:YES];

                                }];

}

@end
