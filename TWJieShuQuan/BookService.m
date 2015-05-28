//
//  BookService.m
//  TWJieShuQuan
//
//  Created by Jianning Zheng on 5/28/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import "BookService.h"
#import "CustomAlert.h"

@implementation BookService

+ (void)saveBookIfNeeded:(Book *)book succeeded:(void (^)())succeededBlock {
    AVQuery *query = [AVQuery queryWithClassName:NSStringFromClass([Book class])];
    [query whereKey:@"bookDoubanId" equalTo:book.bookDoubanId];
   
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            [[CustomAlert sharedAlert] showAlertWithMessage:@"添加失败！"];
            return;
        }
        
        if (objects.count > 0) {
            [[CustomAlert sharedAlert] showAlertWithMessage:@"书库已存在！"];
            return;
        }
        
        [book saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                [[CustomAlert sharedAlert] showAlertWithMessage:@"入库失败！"];
            } else {
                succeededBlock();
            }
        }];
    }];
}

@end
