//
//  DouBanService.m
//  TWJieShuQuan
//
//  Created by Jianning Zheng on 5/26/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import "DouBanService.h"
#import "Constants.h"
#import "AppConstants.h"

@implementation DouBanService

+ (void)fetchingBookDetailWithISBN:(NSString *)isbnCode succeeded:(void (^)(NSDictionary *bookObject))fetchSucceededBlock failed:(void (^)())fetchFailedBlock {
    NSString *isbnUrlString = [NSString stringWithFormat:@"%@?apikey=%@", [kDouBanSearchIsbnCode stringByAppendingString:isbnCode], kDouBanAPIKey];
    NSString* encodedUrl = [isbnUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSLog(@"url: ======%@", isbnUrlString);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:encodedUrl]];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data != nil) {
                id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                if (object) {
                    fetchSucceededBlock(object);
                }
            } else {
                fetchFailedBlock();
            }
        });
    });

}

+ (void)fetchBookCommentWithBookID:(NSString *)bookID start:(NSInteger)start success:(void (^)(NSArray *comments))success failure:(void (^)(NSError *error))failure {
    NSString *url = [NSString stringWithFormat:@"%@%@/reviews?start=%i", kDoubanBaseURL, bookID, start*20];
    NSLog(@"==url:%@", url);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        dispatch_async(dispatch_get_main_queue(), ^{
            id object = [NSJSONSerialization JSONObjectWithData:data
                                                        options:NSJSONReadingAllowFragments
                                                          error:nil];
            if (object) {
                success(object[@"reviews"]);
            }
        });
    });
}


@end
