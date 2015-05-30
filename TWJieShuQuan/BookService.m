//
//  BookService.m
//  TWJieShuQuan
//
//  Created by Jianning Zheng on 5/28/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import "BookService.h"
#import "CustomAlert.h"
#import "BookEntity.h"
#import "UserManager.h"
#import "AVQuery+Extensions.h"

static const NSString *kBook_DouBanId = @"bookDoubanId";

static const NSString *kBookEntity_Book = @"doubanBook";
static const NSString *kBookEntity_User = @"bookOwner";

@implementation BookService

+ (void)addBookToLibrary:(Book *)book succeeded:(void (^)())succeededBlock {
    if (![AVUser currentUser]) {
        [[CustomAlert sharedAlert] showAlertWithMessage:@"请登录"];
        return;
    }
    
    AVQuery *query = [AVQuery queryForBook];
    [query whereKey:(NSString *)kBook_DouBanId equalTo:book.bookDoubanId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            [[CustomAlert sharedAlert] showAlertWithMessage:@"添加失败！"];
            return;
        }
        
        // no Book, create Book and BookEntity
        if (objects.count == 0) {
            [book saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error) {
                    [[CustomAlert sharedAlert] showAlertWithMessage:@"添加失败！"];
                    return;
                }
                
                AVQuery *query = [AVQuery queryForBook];
                [query whereKey:(NSString *)kBook_DouBanId equalTo:book.bookDoubanId];
                [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
                    // create BookEntity
                    [self createBookEntityWithBook:(Book *)object succeeded:succeededBlock];
                }];
            }];
            return;
        }
        
        // already has Book, create only BookEntity if needed
        AVQuery *query = [AVQuery queryForBook];
        [query whereKey:(NSString *)kBook_DouBanId equalTo:book.bookDoubanId];
        [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
            [self createBookEntityIfNeededWithBook:(Book *)object succeeded:succeededBlock];
        }];
    }];
}

+ (void )fetchBookEntitiesForCurrentUserWithSucceedCallback:(void (^)(NSArray *))succeededBlock {
    AVQuery *q = [AVQuery queryForBookEntity];
    [q whereKey:(NSString *)kBookEntity_User equalTo:[AVUser currentUser]];
    [q findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            [[CustomAlert sharedAlert] showAlertWithMessage:@"获取失败！"];
            return;
        }
        
        succeededBlock(objects);
    }];
}

#pragma mark - private methods

+ (void)createBookEntityIfNeededWithBook:(Book *)book succeeded:(void (^)())succeededBlock {
    AVQuery *query = [AVQuery queryForBookEntity];
    [query whereKey:(NSString *)kBookEntity_User equalTo:[AVUser currentUser]];
    [query whereKey:(NSString *)kBookEntity_Book equalTo:book];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            [[CustomAlert sharedAlert] showAlertWithMessage:@"添加失败！"];
            return;
        }
        
        if (objects.count > 0) {
            [[CustomAlert sharedAlert] showAlertWithMessage:@"您的书库已存在！"];
            return;
        }
        
        [self createBookEntityWithBook:book succeeded:succeededBlock];
    }];
}

+ (void)createBookEntityWithBook:(Book *)book succeeded:(void (^)())succeededBlock {
    BookEntity *bookEntity = [[BookEntity alloc] init];
    bookEntity.bookAvailability = YES;
    [bookEntity setObject:[AVUser currentUser] forKey:(NSString *)kBookEntity_User];
    [bookEntity setObject:book forKey:(NSString *)kBookEntity_Book];
    [bookEntity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            [[CustomAlert sharedAlert] showAlertWithMessage:@"入库失败！"];
            return;
        }
        
        succeededBlock();
    }];
}
@end
