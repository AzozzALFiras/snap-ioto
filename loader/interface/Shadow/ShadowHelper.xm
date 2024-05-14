#import "ShadowHelper.h"

@implementation ShadowHelper: NSObject
+(void)screenshot{
    [[ShadowData sharedInstance] disable:@"screenshot"];
     [[NSNotificationCenter defaultCenter] postNotification: [NSNotification notificationWithName:UIApplicationUserDidTakeScreenshotNotification object:nil]];
    [[ShadowData sharedInstance] enable:@"screenshot"];
}

+(void)banner:(NSString*)text color:(NSString *)color alpha:(float)alpha{
    if([ShadowData enabled: @"showbanners"]){
        unsigned rgbValue = 0;
        NSScanner *scanner = [NSScanner scannerWithString:color];
        [scanner setScanLocation:1];
        [scanner scanHexInt:&rgbValue];
        UIColor * bannerColor = [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:alpha];
        [%c(SCStatusBarOverlayLabelWindow) showMessageWithText:text backgroundColor:bannerColor];
    }
}
+(void)banner:(NSString*)text color:(NSString *)color{
    if([ShadowData enabled: @"showbanners"]){
        [self banner:text color:color alpha:.75];
    }
}
+(void)debug{
    [[XLLogerManager manager] showOnWindow];
}
+(void)picklocation{
    UIViewController *topVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    while (topVC.presentedViewController) topVC = topVC.presentedViewController;
    [[LocationPicker new] pickLocationWithCallback:^(NSDictionary *location){
        NSLog(@"Location: %@", location);
        [ShadowData sharedInstance].location = [location mutableCopy];
        [ShadowHelper banner:@"Setting saved pin as your location! 📍" color:@"#00FF00"];
    } from:topVC];
}
+(void)theme{
    SIGActionSheetCell *footer = [%c(SIGActionSheetCell) destructiveOptionCellWithText:@"Cancel"];
    SIGActionSheet *sheet;
    NSMutableArray *cells = [NSMutableArray new];
    for(NSString *option in [ShadowData getThemes]){
        SIGActionSheetCell *cell = [%c(SIGActionSheetCell) optionCellWithText:option];
        [cell block: ^{
            [ShadowData sharedInstance].theme = option;
            [[ShadowData sharedInstance] save];
            [sheet dismissViewControllerAnimated:YES completion:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
                exit(0);
            });
        }];
        [cells addObject:cell];
    }
    
    sheet = [[%c(SIGActionSheet) alloc] initWithHeader:nil title:@"Select A Theme" actionSheetCells:cells footer:footer];
    
    sheet.view.backgroundColor = [UIColor colorWithRed: 0.00 green: 0.00 blue: 0.00 alpha: 0.50];
    [footer block:^{
        [sheet dismissViewControllerAnimated:YES completion:nil];
    }];
    
    UIViewController *topVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    while (topVC.presentedViewController) topVC = topVC.presentedViewController;
    [topVC presentViewController: sheet animated: true completion:nil];
}
 
+(void)check4updates{
    NSString *contents = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"https://iota.pagekite.me"] encoding:NSUTF8StringEncoding error:nil];
    if(contents){
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[contents dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        if(json){
            NSString *ver = [json objectForKey:@"ver"];
            NSString *changelogchanges = [json objectForKey:@"changelog"];
            if(ver){
                if(![ver isEqualToString:@IOTA_VERSION]){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [ShadowHelper banner:[NSString stringWithFormat: @"iota v%@ is available! ⚠️ | Please update!", ver] color:@"#eed202"];
                    });
                    NSLog(@"Update available: %@", ver);
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [ShadowHelper banner:@"iota is up to date! ✅" color:@"#00FF00"];
                        if(changelogchanges){
                            [ShadowHelper dialogWithTitle:[NSString stringWithFormat:@"New in iota v%@:", ver] text:[NSString stringWithFormat:@"%@", changelogchanges]];
                        }
                    });
                }
            }
        }
    }
}

+(void)changelog{
    dispatch_async(dispatch_get_main_queue(), ^{
        [ShadowHelper dialogWithTitle:@"The History of iota" text:@"• iota v2.2 - Removed 'Long Uploads' (its broken and I just don't want to deal with it at the moment).\nFixed 'Chat Ghost' + 'No Typing Notification' to work with the latest Snapchat version (as on Dec. 26th 2022).\n\n• iota v2.1 - Fixed an issue where the upload button would break after using it once. Fixed an issue with assets not loading when resetting settings.\n\n• iota v2.0 - Optimized themes more. Added a feature to see the streak expiry time. Fixed assets.\n\n• iota v1.9 - Optimized themes to no longer depend on their own settings json and assets. Removed the 'more' page in the iota settings.\n\n• iota v1.8.2 - Fixed an issue with screenshot suppression not working.\n\n• iota v1.8.1 - Added the option to view the entire changelog history of iota.\n\n• iota v1.8 - Added 'Ignore Deleted Chats' and a features to color the deleted chats. Moved settings to the top right corner of the main camera view. Old method to open settings no longer works. Re-organized settings. Updated null to handle more arguments.\n\n• iota v1.7 - Added 'Chat Ghost' and more chat specific features.\n\n• iota v1.6 - Fixed an issue with the 'Check for updates' option as well as add a primitive version of the 'Streak Expiry Timer' feature.\n\n• iota v1.5 - Hot fix for the 'Check for updates' feature.\n\n• iota v1.4 - iota no longer connects to a server on launch.\n\n• iota v1.3 - Fixed the 'Call Confirm' feature. Added and fixed 'Hide Friendmoji' feature. Fixed the 'Chat Swipe' feature. Added and fixed the 'Teleport to Friends' feature. Changed server connection address.\n\n• iota v1.2 - Changes for this version are undocumented.\n\n• iota v1.1 - Organized settings. Added a fun feature to randomize the subtitle text. Added a server conntection. Moved themes to be internal rather than external packages."];
    });
}

+(void)reset{
    dispatch_async(dispatch_get_main_queue(), ^{
        [ShadowHelper popup: @"Reset iota Settings" text: @"This will reset all settings to default and close the App. Is that okay?" yes: @"yes, reset" no: @"no, don't reset" action:^(BOOL resetsettings){
            if(resetsettings){
                [ShadowData resetSettings];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
                    exit(0);
                });
            } else {
                // do nothing
            }
        }];
    });
}

+(void)resetlayout{
    [ShadowHelper popup: @"Reset Button Layout" text: @"This will reset button positions to default. Is that okay?" yes: @"yes, reset" no: @"no, don't reset" action:^(BOOL resetbutton){
        if(resetbutton){
            [[ShadowData sharedInstance].positions assignData: [ShadowLayout defaultLayout]];
            [[ShadowData sharedInstance] save];
        } else {
            // Do nothing
        }
    }];
}
-(void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    [[NSFileManager defaultManager] removeItemAtPath:videoPath error:nil];
}

+(void)managesettings{
    dispatch_async(dispatch_get_main_queue(), ^{
        [ShadowHelper popup: @"Settings Manager" text: @"Export and Import settings via pasteboard.\nThis is dangerous be careful!" yes: @"Import" no: @"Export" action:^(BOOL settingsman){
            if(settingsman){
                @try{
                    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                    NSData *jsonData = [pasteboard.string dataUsingEncoding:NSUTF8StringEncoding];
                    NSError *error;
                    NSDictionary * parsedData = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
                    [ShadowData sharedInstance].settings = [parsedData mutableCopy];
                    [[ShadowData sharedInstance] save];
                    [ShadowHelper banner:@"Settings imported! 📥" color:@"#00FF00"];
                } @catch(id importerr){
                    [ShadowHelper dialogWithTitle:@"Import Error" text:[NSString stringWithFormat:@"Looks like there was an issue importing settings.\n\n%@", importerr]];
                }
            } else {
                @try{
                    NSError *error;
                    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[ShadowData sharedInstance].settings options:0 error:&error];
                    if(!jsonData){
                        NSLog(@"JSON error while managing settings: %@", error);
                        [ShadowHelper banner:@"Error exporting settings! 📤" color:@"#FF0000"];
                    } else {
                        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                        pasteboard.string = jsonString;
                        [ShadowHelper banner:@"Settings exported! 📤" color:@"#00FF00"];
                    }
                } @catch(id exporterr){
                    [ShadowHelper dialogWithTitle:@"Export Error" text:[NSString stringWithFormat:@"Looks like there was an issue exporting settings.\n\n%@", exporterr]];
                }
            }
        }];
    });
}

+(void)dialogWithTitle:(NSString*)title text:(NSString*)text{
    UIViewController *alert = [%c(SIGAlertDialog) _alertWithTitle:title description:text];
    if([ShadowData enabled:@"rgb"]){
        UILabel *titleLabel = MSHookIvar<UILabel*>(alert,"_titleLabel");
        RainbowRoad *effect = [[RainbowRoad alloc] initWithLabel:(UILabel *)titleLabel];
        [effect resume];
    }
    UIViewController *topVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    while (topVC.presentedViewController) topVC = topVC.presentedViewController;
    [topVC presentViewController: alert animated: true completion:nil];
}
+(void)popupaction:(NSString*)title text:(NSString*)text yes:(NSString*)yes no:(NSString*)no target:(id)target action:(void (^)(BOOL))action{
    SIGAlertDialog *alert = [%c(SIGAlertDialog) _alertWithTitle:title description:text];
    if([ShadowData enabled:@"rgb"]){
        UILabel *titleLabel = MSHookIvar<UILabel*>(alert,"_titleLabel");
        RainbowRoad *effect = [[RainbowRoad alloc] initWithLabel:(UILabel *)titleLabel];
        [effect resume];
    }
    
    SIGAlertDialogAction *opt1 = [%c(SIGAlertDialogAction) alertDialogActionWithTitle:yes actionBlock:^(){
        [alert dismissViewControllerAnimated:YES completion:nil];
        action(YES);
    }];
    SIGAlertDialogAction *opt2 = [%c(SIGAlertDialogAction) alertDialogActionWithTitle:no actionBlock:^(){
        [alert dismissViewControllerAnimated:YES completion:nil];
        action(NO);
    }];
    
    [alert _setActions: @[opt1,opt2]];
    if (!target){
      UIViewController *topVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
      while (topVC.presentedViewController) topVC = topVC.presentedViewController;
      [topVC presentViewController: alert animated: true completion:nil];
    }else{
      [target presentViewController: alert animated: true completion:nil];
    }
}
 
+(void)popup:(NSString*)title text:(NSString*)text yes:(NSString*)yes no:(NSString*)no action:(void (^)(BOOL))action{
    SIGAlertDialog *alert = [%c(SIGAlertDialog) _alertWithTitle:title description:text];
    if([ShadowData enabled:@"rgb"]){
        UILabel *titleLabel = MSHookIvar<UILabel*>(alert,"_titleLabel");
        RainbowRoad *effect = [[RainbowRoad alloc] initWithLabel:(UILabel *)titleLabel];
        [effect resume];
    }
    
    SIGAlertDialogAction *opt1 = [%c(SIGAlertDialogAction) alertDialogActionWithTitle:yes actionBlock:^(){
        action(YES);
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    SIGAlertDialogAction *opt2 = [%c(SIGAlertDialogAction) alertDialogActionWithTitle:no actionBlock:^(){
        action(NO);
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert _setActions: @[opt1,opt2]];
    UIViewController *topVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    while (topVC.presentedViewController) topVC = topVC.presentedViewController;
    [topVC presentViewController: alert animated: true completion:nil];
}
@end

