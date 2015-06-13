//
//  BorrowFromPersonViewController.m
//  TWJieShuQuan
//
//  Created by Jianning Zheng on 6/13/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import "BorrowFromPersonViewController.h"
#import "BorrowFromPersonTableViewCell.h"

@interface BorrowFromPersonViewController ()
@property (weak, nonatomic) IBOutlet UITableView *colleaguesTableView;

@end

@implementation BorrowFromPersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.colleaguesTableView.dataSource = self;
    self.colleaguesTableView.delegate = self;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.avaliableBookEntities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *iden = @"BorrowFromPersonTableViewCell";
    BorrowFromPersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    cell.bookNameLabel.text = @"aa";
    return cell;
}
@end
