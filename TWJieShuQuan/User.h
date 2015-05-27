//
//  User.h
//  TWJieShuQuan
//
//  Created by Jianning Zheng on 5/27/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, copy) NSString *userEmail; // abc@thoughtworks.com
@property (nonatomic, copy) NSString *userName; // prefix of email, for example, abc
@property (nonatomic, copy) NSString *userNickname;  // user can provide nickname from settings

@end
