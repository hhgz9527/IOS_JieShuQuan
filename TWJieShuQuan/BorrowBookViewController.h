//
//  BorrowBookViewController.h
//  TWJieShuQuan
//
//  Created by Jianning Zheng on 5/26/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LibzBar/Headers/ZBarSDK/ZBarSDK.h"

@interface BorrowBookViewController : UIViewController <ZBarReaderDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@end
