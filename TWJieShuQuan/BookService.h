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

@interface BookService : NSObject

+ (void)addBookToLibrary:(Book *)book availability:(BOOL)availability succeeded:(void (^)())succeededBlock;
+ (void )fetchBookEntitiesForCurrentUserWithSucceedCallback:(void (^)(NSArray *))succeededBlock;
+ (void)fetchAllBooksWithSucceedCallback:(void (^)(NSArray *))succeededBlock;
+ (void)fetchRecoBooksWithSucceedCallback:(void (^)(NSArray *))succeededBlock;
+ (void)fetchAvaliabilityForBook:(Book *)book withSucceedCallback:(void (^)(NSArray *))succeededBlock;
+ (void)fetchOwnersFromBookEntities:(NSArray *)bookEntities withSucceedCallback:(void (^)(NSArray *))succeededBlock;

@end
