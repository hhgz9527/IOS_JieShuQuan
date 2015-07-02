//
//  SearchView.m
//  TWJieShuQuan
//
//  Created by Yu Gao on 7/2/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import "SearchView.h"
#import "BookService.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "BookDetailModel.h"
#import "TWIconButton.h"
#import "BookDetailViewController.h"
#import "BorrowFromPersonViewController.h"

@interface SearchView() <UISearchBarDelegate>

@property (nonatomic, strong) UIButton *bookButton;
@property (nonatomic, strong) UILabel *bookName;
@property (nonatomic, strong) UILabel *searchResultMessage;
@property (nonatomic, strong) Book *tempBook;

@end

@implementation SearchView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSearchBar];
        [self createBookView];
        [self createMessage];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)createSearchBar {
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
    searchBar.delegate = self;
    [self addSubview:searchBar];
}

- (void)createBookView {
    _bookButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _bookButton.frame = CGRectMake(0, 0, 90, 120);
    _bookButton.center = CGPointMake(65, 120);
    _bookButton.layer.shadowOffset = CGSizeMake(0, 2);
    _bookButton.layer.shadowOpacity = 0.5;
    _bookButton.clipsToBounds = NO;
    [_bookButton addTarget:self action:@selector(pushToBookDetailView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_bookButton];
    
    _bookName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90, 20)];
    _bookName.center = CGPointMake(65, 200);
    _bookName.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_bookName];
}

- (void)createMessage {
    _searchResultMessage = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
    _searchResultMessage.hidden = YES;
    _searchResultMessage.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, 90);
    _searchResultMessage.text = @"没有找到相关结果，请重新输入";
    _searchResultMessage.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_searchResultMessage];
}


#pragma mark - search delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [BookService searchBookWithName:searchBar.text callback:^(Book *book) {
        if (book != nil) {
            _searchResultMessage.hidden = YES;
            [_bookButton sd_setBackgroundImageWithURL:[NSURL URLWithString:book.bookImageHref] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"bookplacehoder"]];
            _bookName.text = book.bookName;
            _tempBook = book;
        } else {
            _searchResultMessage.hidden = NO;
        }
    }];
}


#pragma mark - push to detail

- (void)pushToBookDetailView {
    NSLog(@"pushToBookDetailView");
    if (_tempBook == nil) {
        return;
    }
    __block NSArray *array = nil;
    BookDetailModel *model = [[BookDetailModel alloc] init];
    model.title = @"书籍详情";
    [model updateInfoFromBook:_tempBook];
    [model updateAvailableStatusForBook:_tempBook
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
    
    
    BookDetailViewController *detailViewController = [_viewController.storyboard instantiateViewControllerWithIdentifier:@"BookDetailViewControllerIdentifier"];
    detailViewController.bookDetailModel = model;
    
    __weak TWIconButton *weakView = model.updateStatsView;
    weakView.callback = ^{
        weakView.title = @"借阅中...";
        BorrowFromPersonViewController *bpc = [_viewController.storyboard instantiateViewControllerWithIdentifier:@"BorrowFromPersonViewController"];
        bpc.avaliableBookEntities = model.availableBooks;
        [detailViewController.navigationController pushViewController:bpc animated:YES];
        
    };
    
    [_viewController.navigationController pushViewController:detailViewController animated:YES];

    
}

@end
