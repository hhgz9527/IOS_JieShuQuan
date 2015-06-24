//
//  TWIconButton.h
//  TWJieShuQuan
//
//  Created by Haibin Wang on 6/11/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CallBack)();

@interface TWIconButton : UIView

@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, copy) CallBack callback;

- (instancetype)initWithTitle:(NSString *)title icon:(UIImage *)icon action:(CallBack)action;

@end
