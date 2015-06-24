//
//  BorrowBookNotification.m
//  TWJieShuQuan
//
//  Created by Jianning Zheng on 6/20/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import "BorrowRecord.h"

@implementation BorrowRecord

@dynamic status;
@dynamic fromUsername;
@dynamic toUsername;
@dynamic bookName;

+ (NSString *)parseClassName {
    return @"BorrowRecord";
}

@end
