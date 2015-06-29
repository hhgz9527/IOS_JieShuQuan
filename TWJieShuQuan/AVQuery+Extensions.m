//
//  AVQuery+Extensions.m
//  TWJieShuQuan
//
//  Created by Jianning Zheng on 5/29/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import "AVQuery+Extensions.h"
#import "BookEntity.h"
#import "Book.h"
#import "Discover.h"
#import "BorrowRecord.h"

@implementation AVQuery (Extensions)

+ (AVQuery *)queryForBook {
    return [AVQuery queryWithClassName:NSStringFromClass([Book class])];
}

+ (AVQuery *)queryForBookEntity {
    return [AVQuery queryWithClassName:NSStringFromClass([BookEntity class])];
}

+ (AVQuery *)queryForFind {
    return [AVQuery queryWithClassName:NSStringFromClass([Discover class])];
}

+ (AVQuery *)queryForBorrowRecord {
    return [AVQuery queryWithClassName:NSStringFromClass([BorrowRecord class])];
}

@end
