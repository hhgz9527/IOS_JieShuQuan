//
//  ProfileTableViewController.h
//  TWJieShuQuan
//
//  Created by Haibin Wang on 5/28/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../LibzBar/Headers/ZBarSDK/ZBarSDK.h"
#import "AddToLibraryViewController.h"

@interface ProfileTableViewController : UITableViewController <ZBarReaderDelegate, AddToLibraryDelegate, UIImagePickerControllerDelegate>

@end
