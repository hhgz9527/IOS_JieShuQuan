//
//  BookDetailModel.m
//  TWJieShuQuan
//
//  Created by Haibin Wang on 6/24/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import "BookDetailModel.h"
#import "Book.h"
#import "BookEntity.h"
#import "AppConstants.h"
#import "BookService.h"

@implementation BookDetailModel
- (void)updateInfoFromBookEntity:(BookEntity *)bookEntity {

    self.bookEntity = bookEntity;
    self.book = bookEntity[kBookEntity_Book];
    self.status = bookEntity.bookAvailability;

    NSError *error = nil;
    [self.book fetchIfNeeded:&error];

    [self updateInfoFromBook:self.book];
}

- (void)updateInfoFromBook:(Book *)book {
    self.author = book.bookAuthor;
    self.press = book.bookPress;
    self.name = book.bookName;
    self.avatarURL = book.bookImageHref;
    self.bookDoubanID = book.bookDoubanId;

}

- (void)updateAvailableStatusForBook:(Book *)book success:(void(^)(NSArray *bookEntities))success {
    // 获取所有可借的 BookEntity 数组, 将该数组传入“借阅该书”点击后的页面
    [BookService fetchAllAvaliableBookEntitiesForBook:book withSucceedCallback:^(NSArray *avaliableBooksEntities) {

        self.status = avaliableBooksEntities.count > 0;
        if (avaliableBooksEntities.count) {
            _availableBooks = avaliableBooksEntities;
            success(avaliableBooksEntities);
        }
    }];

}


@end
