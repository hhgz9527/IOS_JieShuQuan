//
//  Book.m
//  TWJieShuQuan
//
//  Created by Jianning Zheng on 5/26/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import "Book.h"

@implementation Book

@dynamic bookDoubanId;
@dynamic bookName;
@dynamic bookAuthor;
@dynamic bookImageHref;

+ (NSString *)parseClassName {
    return @"Book";
}

@end
