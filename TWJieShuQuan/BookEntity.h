//
//  BookEntity.h
//  TWJieShuQuan
//
//  Created by Jianning Zheng on 5/29/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>
#import <AVObject+Subclass.h>
#import "Book.h"

@interface BookEntity : AVObject <AVSubclassing>

@property (nonatomic, assign) BOOL bookAvailability;
@property (nonatomic, copy) NSString *bookName;
@property (nonatomic, copy) NSString *bookImageHref;

@end