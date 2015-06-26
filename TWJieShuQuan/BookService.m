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
#import "Constants.h"

@implementation BookService

// 往书库增加图书
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

// 获取 “我的书籍” 图书
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

// 获取所有人的图书，“借书”主页
+ (void)fetchAllBooksWithStart:(NSInteger)start succeeded:(void (^)(NSArray *))succeededBlock {
    AVQuery *q = [AVQuery queryForBook];
    [q orderByDescending:@"createdAt"];
    [q setLimit:kPageLoadCount];
    [q setSkip:start];
    [q findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            [[CustomAlert sharedAlert] showAlertWithMessage:@"获取图书失败！"];
            return;
        }
        
        succeededBlock(objects);
    }];
}

// 获取图书排名
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

// 获取所有“可借”的 bookentity for a book
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

// 遍历数组bookentities，获取每一本书的owner，返回数组，用在点击“申请借阅”后的页面
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

// 改变图书可借状态
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

// 创建借阅申请
+ (void)createBorrowRecordFromUser:(AVUser *)fromUser toUser:(AVUser *)toUser forBookEntity:(BookEntity *)bookEntity succeeded:(void (^)())succeededBlock {
    BorrowRecord *borrowBookNotification = [[BorrowRecord alloc] init];
    
    borrowBookNotification.fromUsername = fromUser.username;
    borrowBookNotification.toUsername = toUser.username;
    borrowBookNotification.bookName = bookEntity.bookName;
    borrowBookNotification.bookImageHref = bookEntity.bookImageHref;
    borrowBookNotification.status = kPendingStatus;
    
    [borrowBookNotification setObject:fromUser forKey:(NSString *)@"fromUser"];
    [borrowBookNotification setObject:toUser forKey:(NSString *)@"toUser"];
    [borrowBookNotification setObject:bookEntity forKey:(NSString *)@"bookEntity"];
    [borrowBookNotification saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            [[CustomAlert sharedAlert] showAlertWithMessage:@"发送失败！"];
            return;
        }
        
        succeededBlock();
    }];
}

//获取所有的借书通知（status = Borrow_Book_Pending）
+ (void)fetchAllPendingBorrowRecordsWithSucceedCallback:(void (^)(NSArray *))succeededBlock {
    AVQuery *q = [AVQuery queryForBorrowRecord];
    [q whereKey:@"status" equalTo:kPendingStatus];
    [q whereKey:@"toUser" equalTo:[AVUser currentUser]];
    [q orderByDescending:@"createdAt"];
    [q findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            [[CustomAlert sharedAlert] showAlertWithMessage:@"获取借书通知失败！"];
            return;
        }
        
        succeededBlock(objects);
    }];
}

// 改变借书申请的状态
+ (void)changeBorrowRecordStatusTo:(NSString *)newStatus forBorrowRecord:(BorrowRecord *)borrowRecord succeeded:(void (^)())succeededBlock {
    AVQuery *q = [AVQuery queryForBorrowRecord];
    [q whereKey:@"objectId" equalTo:borrowRecord.objectId];

    [q getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        if (error) {
            [[CustomAlert sharedAlert] showAlertWithMessage:@"更改借书状态失败！"];
            return;
        }

        [object setObject:newStatus forKey:@"status"];
        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                [[CustomAlert sharedAlert] showAlertWithMessage:@"更改借书状态失败！"];
                return;
            }

            succeededBlock();
        }];
    }];
}

// 获取“我借入的书”清单
+ (void)fetchAllBorrowedInRecordsWithSucceedCallback:(void (^)(NSArray *))succeededBlock {
    AVQuery *q = [AVQuery queryForBorrowRecord];
    [q whereKey:@"toUser" equalTo:[AVUser currentUser]];
    [q whereKey:@"status" equalTo:kAgreedStatus];
    [q orderByDescending:@"createdAt"];
    [q findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            [[CustomAlert sharedAlert] showAlertWithMessage:@"获取清单失败！"];
            return;
        }
        
        succeededBlock(objects);
    }];
}


// 获取“我借出的书”清单
+ (void)fetchAllBorrowedOutRecordsWithSucceedCallback:(void (^)(NSArray *))succeededBlock {
    AVQuery *q = [AVQuery queryForBorrowRecord];
    [q whereKey:@"fromUser" equalTo:[AVUser currentUser]];
    [q whereKey:@"status" equalTo:kAgreedStatus];
    [q orderByDescending:@"createdAt"];
    [q findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            [[CustomAlert sharedAlert] showAlertWithMessage:@"获取清单失败！"];
            return;
        }
        
        succeededBlock(objects);
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
