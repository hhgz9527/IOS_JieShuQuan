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

static NSInteger kStart = 1;
static NSInteger kPageLoadCount = 20;

@interface FindViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *findList;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, retain) UIRefreshControl *refreshControl;

@end

@implementation FindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _findList.rowHeight = UITableViewAutomaticDimension;
    _findList.estimatedRowHeight = 44.0;
    
    // pull to refresh
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
    [self.refreshControl addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventValueChanged];
    [_findList addSubview:self.refreshControl];
    
    [_findList addInfiniteScrollingWithActionHandler:^{
        [self refreshFindList:kPageLoadCount*(kStart++ + 1)];
        [_findList.infiniteScrollingView stopAnimating];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:@"DidAddToLibraryForBook" object:nil];

}

- (void)viewWillAppear:(BOOL)animated {
    [self refreshFindList:20];
}

- (void)refreshData:(UIRefreshControl *)refresh {
    kStart = 0;
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"更新数据中..."];
    
    [self refreshFindList:20];
}

#pragma mark - Refresh List

- (void)refreshFindList:(NSUInteger)number {
    AVQuery *query = [AVQuery queryForFind];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    query.limit = number;
    query.maxCacheAge = 24*3600;
    [query addDescendingOrder:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [_refreshControl endRefreshing];
            _dataArray = [NSMutableArray arrayWithArray:objects];
            [_findList reloadData];
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
    Discover *find = _dataArray[indexPath.row];
    static NSString *iden = @"cell";
    FindCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    [cell configFindCell:find];
    tableView.tableFooterView = [[UIView alloc] init];
    return cell;
}

@end
