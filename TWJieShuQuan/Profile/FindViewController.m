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

@interface FindViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *findList;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation FindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _findList.rowHeight = UITableViewAutomaticDimension;
    _findList.estimatedRowHeight = 44.0;
    
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(refreshFindList) forControlEvents:UIControlEventValueChanged];
    [_findList addSubview:_refreshControl];
//    [_refreshControl beginRefreshing];
//    [self refreshFindList];
}

- (IBAction)unwindTest:(id)sender {
    
}

#pragma mark - Refresh List

- (void)refreshFindList {
    AVQuery *query = [AVQuery queryForFind];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"%@",objects);
        if (!error) {
            _dataArray = objects;
            [_findList reloadData];
        }
    }];
    [_refreshControl endRefreshing];
}


#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Find *find = _dataArray[indexPath.row];
    static NSString *iden = @"cell";
    FindCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    [cell configFindCell:find];
    tableView.tableFooterView = [[UIView alloc] init];
    return cell;
}

@end
