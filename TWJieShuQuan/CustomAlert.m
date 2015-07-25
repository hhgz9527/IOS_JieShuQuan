#import "CustomAlert.h"

static const float fontSize = 15;
static const float fixedLabelHeight = 50;
static const float horizontalMargin = 15;

@interface CustomAlert ()

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIImageView *loadingImg;
@end

@implementation CustomAlert

+ (CustomAlert *)sharedAlert {
    static CustomAlert *sharedAlert = nil;
    if (!sharedAlert) {
        sharedAlert = [[super allocWithZone:nil] init];
    }
    return sharedAlert;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [self sharedAlert];
}

- (id)initWithFrame:(CGRect)frame {
    return [self init];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    return [self init];
}

- (id)init {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.windowLevel = UIWindowLevelAlert;
        [self addSubview:self.textLabel];
        self.hidden = YES;
    }
    return self;
}

- (UILabel *)textLabel {
    if (_textLabel != nil) {
        return _textLabel;
    }
    _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _textLabel.textColor = [UIColor colorWithWhite:1 alpha:1];
    _textLabel.font = [UIFont boldSystemFontOfSize:fontSize];
    return _textLabel;
}


- (void)showAlertWithMessage:(NSString *)message {
    self.hidden = NO;
    [self setAlertWithText:message];
    [self performSelector:@selector(dismissAlert) withObject:nil afterDelay:2.0];
}

#pragma mark - private methods

- (void)setAlertWithText:(NSString*)text {
    _textLabel.text = text;
    _textLabel.numberOfLines = 0;
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60);
    self.backgroundColor = [UIColor colorWithRed:29.f/255.f green:162.f/255.f blue:238.f/255.f alpha:1];
    self.layer.shadowOffset = CGSizeMake(0, 1);
    self.layer.shadowOpacity = 0.5;
    _textLabel.frame = CGRectMake(10, 15, self.frame.size.width, 15);
}

- (void)dismissAlert {
    self.hidden = YES;
}

@end
