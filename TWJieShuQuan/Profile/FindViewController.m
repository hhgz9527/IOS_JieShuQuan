//
//  FindViewController.m
//  TWJieShuQuan
//
//  Created by Haibin Wang on 5/28/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import "FindViewController.h"
#import "FindCell.h"
#import "FindCell+Config.h"
#import <AVObject+Subclass.h>
#import "AVQuery+Extensions.h"
#import <SVPullToRefresh.h>
#import "Discover.h"

static NSInteger kPageLoadCount = 10;

@interface FindViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSInteger pageNum;
}

@property (weak, nonatomic) IBOutlet UITableView *findList;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, retain) UIRefreshControl *refreshControl;
@property (nonatomic, assign) BOOL loadedAllData;

@end

@implementation FindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    pageNum = 1;
    
    _dataArray = [NSMutableArray array];
    // Do any additional setup after loading the view.
    _findList.rowHeight = UITableViewAutomaticDimension;
    _findList.estimatedRowHeight = 68.0;

//    _findList.estimatedRowHeight = 44.0;
    _findList.tableFooterView = [[UIView alloc] init];

    // pull to refresh
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
    [self.refreshControl addTarget:self action:@selector(refreshDataWithControl:) forControlEvents:UIControlEventValueChanged];
    [_findList addSubview:self.refreshControl];
    
    [_findList addInfiniteScrollingWithActionHandler:^{
        [self pullRefresh];
        [_findList.infiniteScrollingView stopAnimating];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"DidAddToLibraryForBook" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"DidSendTwitter" object:nil];

}

- (void)viewWillAppear:(BOOL)animated {
    [self refreshFindList];
}

- (void)refreshDataWithControl:(UIRefreshControl *)refresh {
    pageNum = 1;
    _dataArray = [NSMutableArray array];
    _loadedAllData = NO;
    if (refresh) {
        refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"更新数据中..."];
    }
    
    [self refreshFindList];
}

- (void)refreshData {
    pageNum = 1;
    _dataArray = [NSMutableArray array];
    _loadedAllData = NO;
    
    [self refreshFindList];
}

#pragma mark - Refresh List

- (void)refreshFindList{
    if (_loadedAllData) {
        return;
    }
    AVQuery *query = [AVQuery queryForFind];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    query.limit = kPageLoadCount;
    query.maxCacheAge = 24*3600;
    [query addDescendingOrder:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [_refreshControl endRefreshing];
            [objects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [_dataArray addObject:obj];
            }];
            [_findList reloadData];
            _loadedAllData = YES;
        }
    }];
}

- (void)pullRefresh {
    AVQuery *query = [AVQuery queryForFind];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    query.skip = (pageNum-1)*kPageLoadCount;
    query.limit = kPageLoadCount;
    query.maxCacheAge = 24*3600;
    [query addDescendingOrder:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [_refreshControl endRefreshing];
            [objects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [_dataArray addObject:obj];
            }];
            [_findList reloadData];
            if (objects.count < kPageLoadCount) {
                _loadedAllData = YES;
            }
            pageNum++;
        }
    }];
}

#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    Discover *find = _dataArray[indexPath.row];
    static NSString *iden = @"cell";
    FindCell *cell = [tableView dequeueReusableCellWithIdentifier:iden forIndexPath:indexPath];
    [cell configFindCell:find];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
