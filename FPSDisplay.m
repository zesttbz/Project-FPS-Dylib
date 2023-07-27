//Custom by HHNiOS
//Website: https://hhnios.site

#import <UIKit/UIKit.h>
#import "FPSDisplay.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
@interface FPSDisplay ()
@property (strong, nonatomic) UILabel *displayLabel;
@property (strong, nonatomic) CADisplayLink *link;
@property (assign, nonatomic) NSInteger count;
@property (assign, nonatomic) NSTimeInterval lastTime;
@property (strong, nonatomic) UIFont *font;
@property (strong, nonatomic) UIFont *subFont;
@end
@implementation FPSDisplay
+(void)load
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [self shareFPSDisplay];
    });
}
+ (instancetype)shareFPSDisplay {
    static FPSDisplay *shareDisplay;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareDisplay = [[FPSDisplay alloc] init];
    });
    return shareDisplay;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initDisplayLabel];
    }
    return self;
}

- (void)initDisplayLabel {





    //CGRect frame = CGRectMake(width/2-100, 0, 260, 15);
        //CGRect frame = CGRectMake(SCREEN_WIDTH-300, 0, 350, 30);

CGRect frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 4 - 4,  -1, [UIScreen mainScreen].bounds.size.width / 2  + 10, 16);

    self.displayLabel = [[UILabel alloc] initWithFrame: frame];
    self.displayLabel.layer.cornerRadius = 11;
    self.displayLabel.clipsToBounds = YES;
    self.displayLabel.textAlignment = NSTextAlignmentLeft;
        self.displayLabel.textAlignment = NSTextAlignmentCenter;
    self.displayLabel.userInteractionEnabled = NO;



//set backgroud
 self.displayLabel.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.3];




    _font = [UIFont fontWithName:@"Menlo" size:14];
    if (_font) {
        _subFont = [UIFont fontWithName:@"Menlo" size:4];
    } else {
        _font = [UIFont fontWithName:@"Courier" size:14];
        _subFont = [UIFont fontWithName:@"Courier" size:4];
    }

    [self initCADisplayLink];

    [[UIApplication sharedApplication].keyWindow addSubview:self.displayLabel];
}

- (void)initCADisplayLink {
    self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick:)];
    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)tick:(CADisplayLink *)link
{
    if(self.lastTime == 0){
        self.lastTime = link.timestamp;
        return;
    }
    self.count += 1;
    NSTimeInterval delta = link.timestamp - _lastTime;
    if(delta >= 1.f){
        self.lastTime = link.timestamp;
        float fps = self.count / delta;
        self.count = 0;
        [self updateDisplayLabelText: fps];
    }
}

- (void)updateDisplayLabelText: (float) fps
{


    self.displayLabel.font = [UIFont systemFontOfSize:11];
    NSMutableString *mustr = [[NSMutableString alloc] init];
    [mustr appendFormat:@"%@",self.getSystemDate];
[[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
    double batLeft = (float)[[UIDevice currentDevice] batteryLevel] * 100;
    CGFloat progress = fps / 60.0;
    UIColor *color = [UIColor colorWithHue:0.27 * (progress - 0.2) saturation:0.2 brightness:0.9 alpha:1];
    self.displayLabel.textColor = color;


        if ([[UIDevice currentDevice] batteryState] == UIDeviceBatteryStateCharging) {
            self.displayLabel.text = [NSString stringWithFormat:@"%@ zest🚬 %dFPS | 🔋%0.0f%%⚡️ ",mustr,(int)round(fps),batLeft];
        }else {
            self.displayLabel.text = [NSString stringWithFormat:@"%@ zest🚬 %dFPS | 🔋%0.0f%% ",mustr,(int)round(fps),batLeft];



        }
}

- (NSString *)getSystemDate
{
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];


      [dateFormatter setDateFormat:@"EEEE,dd/MM/yyyy | HH:mm:ss"];



    return [dateFormatter stringFromDate:currentDate];
}

@end

