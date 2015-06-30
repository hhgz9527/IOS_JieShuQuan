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
#import "Constants.h"

static NSInteger kStart = 20;

@interface FindViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *findList;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation FindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _findList.rowHeight = UITableViewAutomaticDimension;
    _findList.estimatedRowHeight = 44.0;
    
    [_findList addPullToRefreshWithActionHandler:^{
        [self refreshFindList:20];
        [_findList.pullToRefreshView stopAnimating];
    }];
    
    [_findList addInfiniteScrollingWithActionHandler:^{
        [self refreshFindList:kPageLoadCount*(kStart++ + 1)];
        [_findList.infiniteScrollingView stopAnimating];
    }];}


#pragma mark - Refresh List

- (void)refreshFindList:(NSUInteger)number {
    AVQuery *query = [AVQuery queryForFind];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    query.limit = number;
    query.maxCacheAge = 24*3600;
    [query addDescendingOrder:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            _dataArray = objects;
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
