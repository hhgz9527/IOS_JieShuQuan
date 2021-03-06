//
//  ProfileTableViewController.m
//  TWJieShuQuan
//
//  Created by Haibin Wang on 5/28/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import "ProfileTableViewController.h"
#import "AuthService.h"
#import "UserManager.h"
#import "LoginViewController.h"
#import "Book.h"
#import "AddToLibraryViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "BookService.h"
#import "BorrowNotificationTableViewController.h"
#import "CustomAlert.h"
#import "DouBanService.h"
#import "CustomActivityIndicator.h"

static NSInteger const kSetAvatarTag = 1001;

@interface ProfileTableViewController ()<UIGestureRecognizerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UIButton *borrowBookNotificationButton;

@property (nonatomic, strong) NSArray *borrowBookNotifications;

@end

@implementation ProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createRightBarButtonItem];
    [self setupAvatar];
    
    // above will be removed later
    UITapGestureRecognizer *TGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setAvatar)];
    [self.avatar addGestureRecognizer:TGR];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [BookService fetchAllPendingBorrowRecordsWithSucceedCallback:^(NSArray *borrowBookNotifications) {
        self.borrowBookNotifications = borrowBookNotifications;
        [self updateBorrowBookNotificationCountWithCount:self.borrowBookNotifications];
    }];
}

- (void)updateBorrowBookNotificationCountWithCount:(NSArray *)borrowBookNotifications {
    if (borrowBookNotifications.count != 0) {
        _borrowBookNotificationButton.hidden = NO;
        [self.borrowBookNotificationButton setTitle:[NSNumber numberWithInteger:borrowBookNotifications.count].stringValue forState:UIControlStateNormal];
    } else {
        [self.borrowBookNotificationButton setTitle:@"0" forState:UIControlStateNormal];
        _borrowBookNotificationButton.hidden = YES;
    }
}

- (void)createRightBarButtonItem {
    UIButton *scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    scanButton.frame = CGRectMake(0, 0, 22, 20);
    [scanButton setBackgroundImage:[UIImage imageNamed:@"nav_scanIcon"] forState:UIControlStateNormal];
    [scanButton addTarget:self action:@selector(scanISBN) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *scanISBNButton = [[UIBarButtonItem alloc] initWithCustomView:scanButton];
    self.navigationItem.rightBarButtonItem = scanISBNButton;
}

- (void)setupAvatar {
    AVFile *file = [[[AVUser currentUser] objectForKey:@"localData"] objectForKey:@"avatar"];
    [_avatar sd_setImageWithURL:[NSURL URLWithString:file.url]];
    _avatar.layer.cornerRadius = _avatar.frame.size.width/2;
    _avatar.layer.masksToBounds = YES;
    _avatar.layer.borderWidth = 1;
    _avatar.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)setAvatar {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Set your avatar"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Camera", @"Album", nil];
    actionSheet.tag = kSetAvatarTag;
    [actionSheet showInView:self.view];
}

- (void)openAlbum {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)openCamera {
    UIImagePickerControllerSourceType type = UIImagePickerControllerSourceTypeCamera;
    
    if ([UIImagePickerController isSourceTypeAvailable:type]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = type;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

- (void)scanISBN {
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;

    ZBarImageScanner *scanner = reader.scanner;
    [scanner setSymbology: ZBAR_I25 config: ZBAR_CFG_ENABLE to: 0];

    [self presentViewController:reader animated:YES completion:nil];

}

#pragma mark - UIImagePickerController Delegate

- (void) imagePickerController: (UIImagePickerController*) picker didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    NSString *type = info[UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        // 上传头像
        UIImage *image = info[UIImagePickerControllerEditedImage];
        
        NSData *data = nil;
        if (UIImagePNGRepresentation(image)) {
            data = UIImagePNGRepresentation(image);
        } else {
            data = UIImageJPEGRepresentation(image, 0.8f);
        }
        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil];
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        self.avatar.image = image;
        
        [self uploadAvatar:data];
    } else {
        // 扫码入库
        id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
        ZBarSymbol *symbol = nil;
        for(symbol in results) {
            // EXAMPLE: just grab the first barcode
            break;
        }
        
        NSString *barCode = symbol.data;
        NSLog(@"---------- barcode:%@", barCode);
        
        if (barCode) {
            [[CustomActivityIndicator sharedActivityIndicator] startAsynchAnimating];
            [DouBanService fetchingBookDetailWithISBN:barCode succeeded:^(NSDictionary *bookObject){
                [[CustomActivityIndicator sharedActivityIndicator] stopAsynchAnimating];
                
                NSLog(@"isbn succeed......%@", bookObject);
                
                Book *book = [[Book alloc] init];
                book.bookDoubanId = [bookObject valueForKey:@"id"];
                book.bookName = [bookObject valueForKey:@"title"];
                book.bookAuthor = [[bookObject valueForKey:@"author"] componentsJoinedByString:@","];
                book.bookImageHref = [bookObject valueForKey:@"image"];
                book.bookPress = bookObject[@"publisher"];
                book.bookDescription = bookObject[@"summary"];
                
                AddToLibraryViewController *addToLibraryVC = [[AddToLibraryViewController alloc] initWithNibName:@"AddToLibraryViewController" bundle:nil];
                addToLibraryVC.delegate = self;
                addToLibraryVC.book = book;
                [self presentViewController:addToLibraryVC animated:YES completion:nil];
            } failed:^{
                [[CustomActivityIndicator sharedActivityIndicator] stopAsynchAnimating];
                
                NSLog(@"isbn fail......");
            }];
        } else {
            [[CustomAlert sharedAlert] showAlertWithMessage:@"获取图书信息失败"];
        }
        
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark <AddToLibraryDelegate>

- (void)didAddToLibraryForBook:(Book *)book {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)uploadAvatar:(NSData *)data {
    AVFile *imageFile = [AVFile fileWithName:@"image.png" data:data];
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded == YES) {
            [[AVUser currentUser] setObject:imageFile forKey:@"avatar"];
            [[AVUser currentUser] saveEventually:^(BOOL succeeded, NSError *error) {
                if (succeeded == YES) {
                    NSLog(@"save avatar success");
                }
            }];
        }
    }];
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row){
        case 0:
            break;
        case 1:
            break;
        case 2:
            break;
        default:
            break;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"borrowBookNotificationTableviewID"]) {
        BorrowNotificationTableViewController *borrowNotificationTableViewController = (BorrowNotificationTableViewController *)segue.destinationViewController;
        borrowNotificationTableViewController.borrowBookNotifications = self.borrowBookNotifications;
    }
    return;
}


#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag==kSetAvatarTag) {
        NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
        if ([title isEqualToString:@"Camera"]) {
            [self openCamera];
        } else if ([title isEqualToString:@"Album"]) {
            [self openAlbum];
        }
    }
}
@end
