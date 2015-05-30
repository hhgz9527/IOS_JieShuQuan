//
//  AVQuery+Extensions.h
//  TWJieShuQuan
//
//  Created by Jianning Zheng on 5/29/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>

@interface AVQuery (Extensions)

+ (AVQuery *)queryForBook;
+ (AVQuery *)queryForBookEntity;

@end
