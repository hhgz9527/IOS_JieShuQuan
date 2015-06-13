//
//  AddToLibraryViewController.h
//  TWJieShuQuan
//
//  Created by Jianning Zheng on 5/26/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Book;

@protocol AddToLibraryDelegate <NSObject>

- (void)didAddToLibraryForBook:(Book *)book;

@end

@interface AddToLibraryViewController : UIViewController
@property (nonatomic, strong) Book *book;
@property (nonatomic, weak) id delegate;
@end
