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

@interface BookService : NSObject

+ (void)saveBookIfNeeded:(Book *)book succeeded:(void (^)())succeededBlock failed:(void (^)())failedBlock;

@end
