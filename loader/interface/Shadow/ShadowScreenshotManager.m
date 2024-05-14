#import "ShadowScreenshotManager.h"

@implementation ShadowScreenshotManager
-(id)init{
    self = [super init];
    self.pending = NO;
    self.calls = [NSMutableArray new];
    return self;
}
+ (instancetype)sharedInstance{
    static ShadowScreenshotManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [ShadowScreenshotManager new];
    });
    return sharedInstance;
}

-(void)handle:(scblock)pass{
    if([ShadowData enabled:@"screenshotconfirm"]){
        [self.calls addObject: pass];
        if(!self.pending){
            [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(reset) userInfo:nil repeats:NO];
            self.pending = YES;
            [ShadowHelper popup: @"Screenshot" text: @"Should we notify the app that you took a screenshot?" yes: @"Suppress" no: @"Screenshot" action:^(BOOL suppress){
                if(!suppress){
                    for(scblock call in self.calls){
                        call();
                    }
                }
                self.calls = [NSMutableArray new];
                if([ShadowData enabled:@"showbanners"]){
                    if(suppress){
                        [ShadowHelper banner:@"Screenshot Suppressed! 🤫" color:@"00FF00"];
                    } else {
                        [ShadowHelper banner:@"Screenshot Taken! 📸" color:@"00FF00"];
                    }
                }
                NSLog(@"Screenshot: %@", suppress ? @"Suppressed" : @"Taken");
            }];
        }
    }else if(![ShadowData enabled:@"screenshot"]){
        pass();
    }
}
-(void)reset{
    self.pending = NO;
}
@end

//scimpalaprofileOnboardingView(Model)
//SIGActionSheet, SIGActionSheetCell
