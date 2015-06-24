//
//  BookDetailModel.h
//  TWJieShuQuan
//
//  Created by Haibin Wang on 6/24/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Book;
@class BookEntity;

@interface BookDetailModel : NSObject

@property (copy, nonatomic) NSString *name;
@property (assign, nonatomic) BOOL status;
@property (copy, nonatomic) NSString *author;
@property (copy, nonatomic) NSString *press;
@property (copy, nonatomic) NSString *avatarURL;
@property (copy, nonatomic) NSString *bookDoubanID;

@property (nonatomic, strong) Book *book;
@property (nonatomic, strong) BookEntity *bookEntity;
@property (nonatomic, strong, readonly) NSArray *availableBooks;

@property (nonatomic, copy) NSString *title;
@property (strong, nonatomic) UIView *updateStatsView;
@property (strong, nonatomic) UIView *deleteView;

- (void)updateInfoFromBookEntity:(BookEntity *)bookEntity;
- (void)updateInfoFromBook:(Book *)book;
- (void)updateAvailableStatusForBook:(Book *)book success:(void(^)(NSArray *bookEntities))success;

@end
