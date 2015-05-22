#import <UIKit/UIKit.h>

@interface CustomAlert : UIWindow

- (void)showAlertWithMessage:(NSString *)message;

+ (CustomAlert *)sharedAlert;


@end
