//
//  BorrowNotificationTableViewCell.h
//  TWJieShuQuan
//
//  Created by Jianning Zheng on 6/18/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BorrowNotificationTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *notificationLabel;
@property (weak, nonatomic) IBOutlet UIButton *agreeButton;
@property (weak, nonatomic) IBOutlet UIButton *notAgreeButton;

@end
