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

static NSInteger const kSetAvatarTag = 1001;

@interface ProfileTableViewController ()<UIGestureRecognizerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *borrowRequestNum;
@property (weak, nonatomic) IBOutlet UILabel *returnRequestNum;
@end

@implementation ProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createRightBarButtonItem];
    [self createLeftBarButtonItem];
    [self setupAvatar];
    
    // above will be removed later
        UITapGestureRecognizer *TGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setAvatar)];
    [self.avatar addGestureRecognizer:TGR];
    

}


- (void)createRightBarButtonItem {
    UIButton *scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    scanButton.frame = CGRectMake(0, 0, 22, 20);
    [scanButton setBackgroundImage:[UIImage imageNamed:@"nav_scanIcon"] forState:UIControlStateNormal];
    [scanButton addTarget:self action:@selector(scanISBN) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *scanISBNButton = [[UIBarButtonItem alloc] initWithCustomView:scanButton];
    self.navigationItem.rightBarButtonItem = scanISBNButton;
}

- (void)createLeftBarButtonItem {
    // will move logout function into settings page later
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"logout" style:UIBarButtonItemStyleDone target:self action:@selector(logout)];
    self.navigationItem.leftBarButtonItem = logoutButton;
}

- (void)setupAvatar {
    _avatar.layer.cornerRadius = _avatar.frame.size.width/2;
    _avatar.layer.masksToBounds = YES;
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
    Book *book = [[Book alloc] init];
    book.bookDoubanId = @111112;
    book.bookName = @"Head First 设计模式";
    book.bookAuthor = @"Freeman";
    book.bookImageHref = @"http://img4.douban.com/lpic/s2686916.jpg";
    
    AddToLibraryViewController *addToLibraryVC = [[AddToLibraryViewController alloc] initWithNibName:@"AddToLibraryViewController" bundle:nil];
    addToLibraryVC.book = book;
    [self presentViewController:addToLibraryVC animated:YES completion:nil];

}

#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *type = info[UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
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
        
//        filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        self.avatar.image = image;
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
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

- (void)logout {
    [AuthService logout];
    
    // remove login user from userdefaults
    [UserManager removeCurrentUser];
    
    LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    loginViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:loginViewController animated:YES completion:nil];
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