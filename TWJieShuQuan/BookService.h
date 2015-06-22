//
//  BookService.h
//  TWJieShuQuan
//
//  Created by Jianning Zheng on 5/28/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>
#import "Book.h"
#import "AVQuery+Extensions.h"
#import "BorrowRecord.h"

@class BookEntity;

@interface BookService : NSObject

+ (void)addBookToLibrary:(Book *)book availability:(BOOL)availability succeeded:(void (^)())succeededBlock;
+ (void )fetchBookEntitiesForCurrentUserWithSucceedCallback:(void (^)(NSArray *))succeededBlock;
+ (void)fetchAllBooksWithSucceedCallback:(void (^)(NSArray *))succeededBlock;
+ (void)fetchRecoBooksWithSucceedCallback:(void (^)(NSArray *))succeededBlock;
+ (void)fetchAllAvaliableBookEntitiesForBook:(Book *)book withSucceedCallback:(void (^)(NSArray *))succeededBlock;
+ (void)fetchOwnersFromBookEntities:(NSArray *)bookEntities withSucceedCallback:(void (^)(NSArray *))succeededBlock;
+ (void)updateBookAvailabilityWithBook:(Book *)book availbility:(BOOL)availability;

+ (void)createBorrowRecordFromUser:(AVUser *)fromUser toUser:(AVUser *)toUser forBookEntity:(BookEntity *)bookEntity succeeded:(void (^)())succeededBlock;
+ (void)fetchAllPendingBorrowRecordsWithSucceedCallback:(void (^)(NSArray *))succeededBlock;
+ (void)changeBorrowRecordStatusTo:(NSString *)newStatus forBorrowRecord:(BorrowRecord *)borrowRecord succeeded:(void (^)())succeededBlock;

@end
