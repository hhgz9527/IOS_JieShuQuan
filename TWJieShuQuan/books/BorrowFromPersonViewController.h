//
//  BorrowFromPersonViewController.h
//  TWJieShuQuan
//
//  Created by Jianning Zheng on 6/13/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BorrowFromPersonViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *avaliableBookEntities;

@end
