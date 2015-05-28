//
//  BookService.m
//  TWJieShuQuan
//
//  Created by Jianning Zheng on 5/28/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import "BookService.h"

@implementation BookService

+ (void)saveBookIfNeeded:(Book *)book succeeded:(void (^)())succeededBlock failed:(void (^)())failedBlock {
    [book saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            failedBlock();
        } else {
            succeededBlock();
        }
    }];
}

@end
