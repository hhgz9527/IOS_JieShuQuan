//
//  Book.h
//  TWJieShuQuan
//
//  Created by Jianning Zheng on 5/26/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>
#import <AVObject+Subclass.h>

@interface Book : AVObject <AVSubclassing>

@property (nonatomic, copy) NSNumber *bookDoubanId;
@property (nonatomic, copy) NSString *bookName;
@property (nonatomic, copy) NSString *bookAuthor;
@property (nonatomic, copy) NSString *bookImageHref;
@property (nonatomic, copy) NSString *bookPress;

@end
