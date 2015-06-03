//
//  BookEntity.m
//  TWJieShuQuan
//
//  Created by Jianning Zheng on 5/29/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import "BookEntity.h"

@implementation BookEntity

@dynamic bookAvailability;
@dynamic bookName;
@dynamic bookImageHref;

+ (NSString *)parseClassName {
    return @"BookEntity";
}

@end
