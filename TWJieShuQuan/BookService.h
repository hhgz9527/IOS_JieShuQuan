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

@class BookEntity;

@interface BookService : NSObject

+ (void)addBookToLibrary:(Book *)book availability:(BOOL)availability succeeded:(void (^)())succeededBlock;
+ (void)fetchBookEntitiesForCurrentUserWithSucceedCallback:(void (^)(NSArray *))succeededBlock;
+ (void)updateBookAvailabilityWithBook:(Book *)book availbility:(BOOL)availability;

@end
