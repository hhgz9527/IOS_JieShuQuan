//
//  FindViewController.m
//  TWJieShuQuan
//
//  Created by Haibin Wang on 5/28/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import "FindViewController.h"
#import "FindCell.h"
#import <AVObject+Subclass.h>

@interface FindViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation FindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *iden = @"cell";
    FindCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    cell.name.text = @"test name";
    cell.time.text = @"2015-5-1";
    cell.content.text = @"test";
    cell.avatar.image = [UIImage imageNamed:@"avatar"];
    tableView.tableFooterView = [[UIView alloc] init];
    return cell;
}

@end
