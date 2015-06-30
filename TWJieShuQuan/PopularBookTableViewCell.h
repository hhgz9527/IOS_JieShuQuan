//
//  PopularBookTableViewCell.h
//  TWJieShuQuan
//
//  Created by Jianning Zheng on 6/30/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"

@interface PopularBookTableViewCell : UITableViewCell
@property (nonatomic, strong) Book *book;
- (void)updateUI;
@end
