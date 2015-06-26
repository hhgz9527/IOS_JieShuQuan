//
//  BorrowOutTableViewCell.h
//  TWJieShuQuan
//
//  Created by Jianning Zheng on 6/26/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BorrowRecord.h"

@interface BorrowOutTableViewCell : UITableViewCell

@property (nonatomic, strong) BorrowRecord *borrowRecord;
@property (weak, nonatomic) IBOutlet UIButton *returnButton;

- (void)refreshUI;

@end
