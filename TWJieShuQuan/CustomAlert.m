#import "CustomAlert.h"

static const float fontSize = 17;
static const float fixedLabelHeight = 50;
static const float horizontalMargin = 15;

@interface CustomAlert ()

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIImageView *loadingImg;
@end

@implementation CustomAlert

+ (CustomAlert *)sharedAlert
{
    static CustomAlert *sharedAlert = nil;
    if (!sharedAlert) {
        sharedAlert = [[super allocWithZone:nil] init];
    }
    return sharedAlert;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedAlert];
}

- (id)initWithFrame:(CGRect)frame
{
    return [self init];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    return [self init];
}

- (id)init
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.windowLevel = UIWindowLevelAlert;
        [self addSubview:self.textLabel];
        self.hidden = YES;
    }
    return self;
}

- (UILabel *)textLabel
{
    if (_textLabel != nil) {
        return _textLabel;
    }
    _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _textLabel.layer.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6].CGColor;
    _textLabel.layer.cornerRadius = 10.0;
    _textLabel.textColor = [UIColor colorWithWhite:0.8 alpha:1];
    _textLabel.font = [UIFont boldSystemFontOfSize:fontSize];
    return _textLabel;
}


- (void)showAlertWithMessage:(NSString *)message
{
    self.hidden = NO;
    [self setAlertWithText:message];
    [self performSelector:@selector(dismissAlert) withObject:nil afterDelay:1.0];
}

#pragma mark - private methods

- (void)setAlertWithText:(NSString*)text {
    _textLabel.text = text;
    _textLabel.numberOfLines = 0;
    _textLabel.textAlignment = NSTextAlignmentCenter;
    
    CGSize constrainedSize = CGSizeMake(MAXFLOAT, fixedLabelHeight);
    
    CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:constrainedSize];
    
    self.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-textSize.width-2*horizontalMargin)/2, ([UIScreen mainScreen].bounds.size.height)*2/3, textSize.width+2*horizontalMargin, fixedLabelHeight);
    _textLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

- (void)dismissAlert
{
    self.hidden = YES;
}





@end
