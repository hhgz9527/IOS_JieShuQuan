//
//  DouBanService.h
//  TWJieShuQuan
//
//  Created by Jianning Zheng on 5/26/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DouBanService : NSObject

+ (void)fetchingBookDetailWithISBN:(NSString *)isbnCode succeeded:(void (^)(NSDictionary *bookObject))fetchSucceededBlock failed:(void (^)())fetchFailedBlock;
+ (void)fetchBookCommentWithBookID:(NSString *)bookID start:(NSInteger)start success:(void (^)(NSArray *comments))success failure:(void (^)(NSError *error))failure;
@end
