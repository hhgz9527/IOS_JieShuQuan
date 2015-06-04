//
//  MyBooksCollectionViewCell.h
//  TWJieShuQuan
//
//  Created by Jianning Zheng on 6/3/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookEntity.h"

@interface MyBooksCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bookImageView;
@property (weak, nonatomic) IBOutlet UILabel *bookNameLabel;

- (void)refreshCellWithBookEntity:(BookEntity *)bookEntity;

@end
