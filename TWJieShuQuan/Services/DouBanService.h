//
//  DouBanService.h
//  TWJieShuQuan
//
//  Created by Jianning Zheng on 5/26/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DouBanService : NSObject

+ (instancetype)sharedDouBanService;

- (void)fetchingBookDetailWithISBN:(NSString *)isbnCode succeeded:(void (^)(NSDictionary *bookObject))fetchSucceededBlock failed:(void (^)())fetchFailedBlock;

@end
