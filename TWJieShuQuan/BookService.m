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
#import "AppConstants.h"

@implementation BookService

+ (void)addBookToLibrary:(Book *)book availability:(BOOL)availability succeeded:(void (^)())succeededBlock {
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
                    [self createBookEntityWithBook:(Book *)object availability:availability succeeded:succeededBlock];
                }];
            }];
            return;
        }
        
        // already has Book, create only BookEntity if needed
        AVQuery *query = [AVQuery queryForBook];
        [query whereKey:(NSString *)kBook_DouBanId equalTo:book.bookDoubanId];
        [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
            [self createBookEntityIfNeededWithBook:(Book *)object availability:availability succeeded:succeededBlock];
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

+ (void)fetchAllBooksWithSucceedCallback:(void (^)(NSArray *))succeededBlock {
    AVQuery *q = [AVQuery queryForBook];
    [q orderByDescending:@"createdAt"];
    [q findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            [[CustomAlert sharedAlert] showAlertWithMessage:@"获取图书失败！"];
            return;
        }
        
        succeededBlock(objects);
    }];
}

+ (void)fetchRecoBooksWithSucceedCallback:(void (^)(NSArray *))succeededBlock {
    
    // WIP
    AVQuery *q = [AVQuery queryForBook];
    [q orderByDescending:@"createdAt"];
    [q findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            [[CustomAlert sharedAlert] showAlertWithMessage:@"获取图书失败！"];
            return;
        }
        
        succeededBlock(objects);
    }];
}

+ (void)fetchAllAvaliableBookEntitiesForBook:(Book *)book withSucceedCallback:(void (^)(NSArray *))succeededBlock {
    AVQuery *q = [AVQuery queryForBookEntity];
    [q whereKey:kBookEntity_Book equalTo:book];
    [q whereKey:@"bookAvailability" equalTo:@1];
    
    [q findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            [[CustomAlert sharedAlert] showAlertWithMessage:@"获取图书失败！"];
            return;
        }
        
        succeededBlock(objects);
    }];
}

+ (void)fetchOwnersFromBookEntities:(NSArray *)bookEntities withSucceedCallback:(void (^)(NSArray *))succeededBlock {
    NSMutableArray *users = [NSMutableArray array];
    [bookEntities enumerateObjectsUsingBlock:^(id bookEntity, NSUInteger idx, BOOL *stop) {
        AVUser *user = [bookEntity objectForKey:kBookEntity_User];
        [user fetchIfNeededInBackgroundWithBlock:^(AVObject *object, NSError *error) {
            if (error) {
                [[CustomAlert sharedAlert] showAlertWithMessage:@"获取用户失败！"];
                return;
            }
            
            [users addObject:object];
            succeededBlock(users);
        }];
    }];
}

+ (void)updateBookAvailabilityWithBook:(Book *)book availbility:(BOOL)availability {
    AVQuery *query = [AVQuery queryForBookEntity];
    [query whereKey:kBookEntity_User equalTo:[AVUser currentUser]];
    [query whereKey:kBookEntity_Book equalTo:book];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            [[CustomAlert sharedAlert] showAlertWithMessage:@"修改状态失败"];
            return;
        }

        if (objects.count) {
            BookEntity *bookEntity = (BookEntity *)objects[0];
            bookEntity.bookAvailability = availability;
            [bookEntity saveInBackground];
        }
    }];

}


#pragma mark - private methods

+ (void)createBookEntityIfNeededWithBook:(Book *)book availability:(BOOL)availability succeeded:(void (^)())succeededBlock {
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
        
        [self createBookEntityWithBook:book availability:availability succeeded:succeededBlock];
    }];
}

+ (void)createBookEntityWithBook:(Book *)book availability:(BOOL)availability succeeded:(void (^)())succeededBlock {
    BookEntity *bookEntity = [[BookEntity alloc] init];
    bookEntity.bookAvailability = availability;
    bookEntity.bookName = book.bookName;
    bookEntity.bookImageHref = book.bookImageHref;
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
