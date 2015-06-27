//
//  OfficeViewController.h
//  TWJieShuQuan
//
//  Created by GaoYu on 15/6/27.
//  Copyright (c) 2015年 Jianing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol backNameDelegate <NSObject>

- (void)backName:(NSString *)name;

@end

@interface OfficeViewController : UIViewController

@property (nonatomic, weak) id <backNameDelegate> delegate;

@end
