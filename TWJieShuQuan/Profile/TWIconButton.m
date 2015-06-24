//
//  TWIconButton.m
//  TWJieShuQuan
//
//  Created by Haibin Wang on 6/11/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import "TWIconButton.h"

@interface TWIconButton()
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIView *centerView;

@end

@implementation TWIconButton

- (instancetype)init{
    NSAssert(1, @"Please invoke initWithFrame instead");
    return nil;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:CGRectMake(0.f, 0.f, frame.size.width, frame.size.height)];
    if (self) {
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self addGestureRecognizer:tapRecognizer];

        _iconView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _label = [[UILabel alloc] initWithFrame:CGRectZero];
        _centerView = [[UIView alloc] initWithFrame:CGRectZero];
        _centerView.backgroundColor = [UIColor clearColor];
        [_centerView addSubview:_iconView];
        [_centerView addSubview:_label];

        [self addSubview:_centerView];
    }
    
    return self;
}


- (void)handleTap:(UITapGestureRecognizer *)recognizer{
    if (self.callback) {
        self.callback();
    }
}

- (void)setIcon:(UIImage *)icon{
    self.iconView.image = icon;
    [self refreshSubviews];
}

- (void)refreshSubviews {
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setTitle:(NSString *)title{
    self.label.text = title;
    [self refreshSubviews];
}

- (instancetype)initWithTitle:(NSString *)title icon:(UIImage *)icon action:(CallBack)action {
    self = [self initWithFrame:CGRectZero];
    if (self) {
        _label.text = title;
        _iconView.image = icon;
        _callback = action;
    }

    return self;
}


- (void)layoutSubviews{
    CGFloat xOffset = 0.f;
    CGFloat yOffset = 0.f;

    _iconView.frame = CGRectMake(xOffset, yOffset, 15.f, 20.f);
    xOffset += _iconView.bounds.size.width + 10.f;

    [_label sizeToFit];
    CGRect rect = _label.frame;
    rect.origin.x = xOffset;
    _label.frame = rect;
    xOffset += _label.bounds.size.width;

    _centerView.frame = CGRectMake(0.f, 0.f, xOffset, MAX(_iconView.bounds.size.height, _label.bounds.size.height));
    _centerView.center = CGPointMake(self.bounds.size.width*0.5f, self.bounds.size.height*0.5f);
}


@end
