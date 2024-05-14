#import "ShadowAssets.h"
#import "IotaAssetDefines.h"
@interface UIImage (AddtionalFunctionalities)
- (UIImage *)sc_imageWithTintColor:(UIColor *)tintColor;
@end

@implementation ShadowAssets
- (id)init{
    self = [super init];
    NSString *theme = IotaAssetThemePath;
    if([ShadowData sharedInstance].theme){
        theme = [[IotaAssetThemePath stringByAppendingString:[ShadowData sharedInstance].theme] stringByAppendingString:@"/"];
        self.pull_normal = [UIImage imageWithContentsOfFile:[theme stringByAppendingString:@"pull.normal.png"]];
        self.pull_wink = [UIImage imageWithContentsOfFile:[theme stringByAppendingString:@"pull.wink.png"]];
        self.pull_shocked = [UIImage imageWithContentsOfFile:[theme stringByAppendingString:@"pull.shocked.png"]];
        self.pull_rainbow = [UIImage imageWithContentsOfFile:[theme stringByAppendingString:@"pull.rainbow.png"]];
        self.pull_hands = [UIImage imageWithContentsOfFile:[theme stringByAppendingString:@"pull.hands.png"]];
    }
    NSString *assetPath = IotaAssetPath;
    self.save = [UIImage imageNamed:@"save_button"];
    self.saved = [UIImage imageNamed:@"saved_button"];
    self.upload = [UIImage imageNamed:@"send_to_export"];
    self.seen = [UIImage imageWithContentsOfFile:[IotaAssetPath stringByAppendingString:@"seen.png"]];
    self.settingsicon = [UIImage imageWithContentsOfFile:[IotaAssetPath stringByAppendingString:@"settingsicon.png"]];
    self.seened = [self.seen sc_imageWithTintColor:[UIColor yellowColor]];
    self.screenshot = [UIImage imageNamed:@"simplified_feed_screenshot_new_chat"];

    return self;
}

+ (UIImage *)download:(NSString*)url{
    return [UIImage imageWithData: [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: url]]];
}

+ (instancetype)sharedInstance{
    static ShadowAssets *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ShadowAssets alloc] init];
    });
    return sharedInstance;
}

@end

