#import <Foundation/Foundation.h>
#include "../relicwrapper.m"
#include "SCNMessagingMessage.h"
#include <stdbool.h>
#import <objc/runtime.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define _Bool bool
#define typeof __typeof__
#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import <CoreFoundation/CoreFoundation.h>
#import <Social/SLComposeViewController.h>
#import <AVFoundation/AVFoundation.h>
#include <MediaAccessibility/MediaAccessibility.h>
#import <Social/SLServiceTypes.h>
#import "SpringBoard/SpringBoard.h"
#import <CoreLocation/CoreLocation.h>
#import "SCContextV2ActionMenuViewController.h"
#import "SCNMessagingMessage.h"
#import "SIGActionSheetCell.h"
#import "SIGHeaderTitle.h"
#import "SIGHeaderItem.h"
#import "SIGLabel.h"
#import "SCGrowingButton.h"
#import "SCContextV2SwipeUpViewController.h"
#import "SCContextActionMenuOperaDataSource.h"
#import "SCContextV2SwipeUpGestureTracker.h"
#import "SCOperaPageViewController.h"
#import "SCMainCameraViewController.h"
#import "SCContextV2Presenter.h"
#import "SIGAlertDialog.h"
#import "SIGAlertDialogAction.h"
#import "SCNMessagingUUID.h"
#import "SCStatusBarOverlayLabelWindow.h"
#import "SIGPullToRefreshGhostView.h"
#import "SCOperaViewController.h"
#import "SCSwipeViewContainerViewController.h"
#import "SCOperaActionMenuV2Option.h"
#import "SCMapBitmojiCluster.h"
#import "SCManagedRecordedVideo.h"
#import "SCFuture.h"
#import "util.h"
#import "ShadowData.h"
#import "ShadowHelper.h"
#import "ShadowAssets.h"
#import "ShadowSettingsViewController.h"
#import "ShadowImportUtil.h"
#import "RainbowRoad.h"
#import "ShadowOptionsManager.h"
#import "LocationPicker.h"
#import "XLLogerManager.h"
#import "ShadowButton.h"
#import "ShadowScreenshotManager.h"
#import "ShadowServerData.h"
#import "SCChatConversationViewModelV3.h"
#import "SCArroyoMessageActionHandler.h"
#import "SCMediaChatViewModel.h"
#import "SCChatMessageCellViewModel.h"
#import "SCChatActionMenuButtonViewModel.h"
#import "AudioPickerController.h"
#import "SCPreviewPresenterImpl.h"
#import "SCCameraViewController.h"
#import "SCManagedRecordedVideo.h"
#import "SCFuture.h"
#import "UIImage+Snapchat.h"
#import "SCVideoAssetUtils.h"
#import "SCMainCameraViewController.h"
#import "SCCameraVerticalToolbar.h"
#import "IotaChatActions.h"
#import <objc/runtime.h>
#import "SCNMessagingMessage.h"
#import "SCNMessagingUUID.h"
#import "SCNMessagingMessageDescriptor.h"
#import "SCNMessagingMessageContent.h"
#import "SCNMessagingMessageMetadata.h"
#import "SCNMessagingMessageAnalytics.h"
#import "SCChatSenderLineViewModel.h"
#import "SCUserIdToSnapchatterFetcherImpl.h"
#import "SCNMessagingSnapManager.h"
#import "SCFriendingFriendsAddRequest.h"
@import UIKit;
@import Foundation;
@import CoreLocation;

static void (*orig_tap)(id self, SEL _cmd, id arg1);
static void tap(id self, SEL _cmd, id arg1){
    [ShadowHelper dialogWithTitle:@"Notice" text:@"iota's settings have been moved to the settings icon in the top right corner of the main camera view. I will remove this message in the next update."];
}

static BOOL (*orig_savehax)(SCNMessagingMessage *self, SEL _cmd);
static BOOL savehax(SCNMessagingMessage *self, SEL _cmd){
    if([ShadowData enabled: @"savehax"]){
        if([self isSnapMessage]) return YES;
    }
    return orig_savehax(self, _cmd);
}

static BOOL (*orig_savehax2)(SCNMessagingMessage *self, SEL _cmd, id arg1);
static BOOL savehax2(SCNMessagingMessage *self, SEL _cmd, id arg1){
    if([ShadowData enabled: @"savehax"]){
        return YES;
    }
    return orig_savehax2(self, _cmd, arg1);
}

static void (*orig_storyghost)(id self, SEL _cmd, id arg1);
static void storyghost(id self, SEL _cmd, id arg1){
    if(![ShadowData enabled: @"seenbutton"])
        orig_storyghost(self, _cmd, arg1);
    if([ShadowData sharedInstance].seen == TRUE){
        orig_storyghost(self, _cmd, arg1);
        [ShadowData sharedInstance].seen = FALSE;
    }
}

static void (*orig_snapghost)(id self, SEL _cmd, long long arg1, id arg2, long long arg3, void * arg4);
static void snapghost(id self, SEL _cmd, long long arg1, id arg2, long long arg3, void * arg4){
    if(![ShadowData enabled: @"seenbutton"])
        orig_snapghost(self, _cmd, arg1, arg2, arg3, arg4);
    if([ShadowData sharedInstance].seen == TRUE){
        orig_snapghost(self, _cmd, arg1, arg2, arg3, arg4);
        [ShadowData sharedInstance].seen = FALSE;
    }
}

static void save(SCOperaPageViewController* self, SEL _cmd){
    NSArray *mediaArray = [self shareableMedias];
    if(mediaArray.count == 1){
        SCOperaShareableMedia *mediaObject = (SCOperaShareableMedia *) [mediaArray firstObject];
        if(mediaObject.mediaType == 0){
            UIImage *snapImage = [mediaObject image];
            UIImageWriteToSavedPhotosAlbum(snapImage, nil, nil, nil);
            if([ShadowData enabled:@"showbanners"]){
                [ShadowHelper banner:@"Saved Image to Camera Roll! 💾" color:@"#00FF00"];
            }
            NSLog(@"Saved Image to Camera Roll! 💾");
        } else {
            if([ShadowData enabled:@"showbanners"]){
                [ShadowHelper banner:@"Failed to save image to Camera Roll! ❌" color:@"#FF0000"];
            }
            NSLog(@"Failed to save image to Camera Roll! ❌");
        }
    } else {
        for (SCOperaShareableMedia *mediaObject in mediaArray){
            if ((mediaObject.mediaType == 1) && (mediaObject.videoAsset) && (mediaObject.videoURL == nil)){
                AVURLAsset *asset = (AVURLAsset *)(mediaObject.videoAsset);
                NSURL *assetURL = asset.URL;
                NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
                NSURL *tempVideoFileURL = [documentsURL URLByAppendingPathComponent:[assetURL lastPathComponent]];
                AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetHighestQuality];
                exportSession.outputURL = tempVideoFileURL;
                exportSession.outputFileType = AVFileTypeQuickTimeMovie;
                [exportSession exportAsynchronouslyWithCompletionHandler:^{
                    UISaveVideoAtPathToSavedPhotosAlbum(tempVideoFileURL.path, [%c(ShadowHelper) new], @selector(video:didFinishSavingWithError:contextInfo:), nil);
                    if([ShadowData enabled:@"showbanners"]){
                        [ShadowHelper banner:@"Saved video to Camera Roll! 💾" color:@"#00FF00"];
                    }
                    NSLog(@"Saved video to Camera Roll! 💾");
                }];
            } else if (mediaObject.mediaType == 1 && mediaObject.videoURL && mediaObject.videoAsset == nil){
                UISaveVideoAtPathToSavedPhotosAlbum(mediaObject.videoURL.path, [%c(ShadowHelper) new], @selector(video:didFinishSavingWithError:contextInfo:), nil);
                if([ShadowData enabled:@"showbanners"]){
                    [ShadowHelper banner:@"Saved video to Camera Roll! 💾" color:@"#00FF00"];
                }
                NSLog(@"Saved video to Camera Roll! 💾");
            }
        }
    }
}

static void (*orig_markheader)(id self, SEL _cmd, NSUInteger arg1);
static void markheader(id self, SEL _cmd, NSUInteger arg1){
    orig_markheader(self, _cmd, arg1);
    @try{
        SIGHeaderTitle *headerTitle = (SIGHeaderTitle *)[[[[(UIView *)self subviews] lastObject].subviews lastObject].subviews firstObject];
        //UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:headerTitle action:@selector(_titleTapped:)];
        SIGLabel * label = [headerTitle.subviews firstObject];
        //[label addGestureRecognizer:singleFingerTap];
        if([ShadowData enabled: @"hideshadow"]) return;
        if(![[label class] isEqual: %c(SIGLabel)])return;
        SIGLabel *subtitle = headerTitle.subviews[1];
        for(int i = 2; i < headerTitle.subviews.count; i++) [headerTitle.subviews[i] removeFromSuperview]; //remove indicators
        id user = [%c(User) performSelector:@selector(createUser)];
        NSString *dispname = (NSString *)[user performSelector:@selector(usernameDisplayOnly_LEGACY_DO_NOT_USE)];

        if(![ShadowData enabled: @"hideshadow"]){
            if([ShadowData enabled: @"customtitle"]){
                ((SIGHeaderItem*)[self performSelector:@selector(currentHeaderItem)]).title = [ShadowData sharedInstance].settings[@"customtitle"];
            }else{
                ((SIGHeaderItem*)[self performSelector:@selector(currentHeaderItem)]).title = @"iota";
            }
        }

        if(![ShadowData enabled: @"subtitle"]){
            [subtitle setHidden: NO];
            
            //subtitle.text = [[ShadowData sharedInstance].server[@"subtext"] stringByReplacingOccurrencesOfString:@"NAME" withString: [[dispname componentsSeparatedByString:@" "] firstObject]];
            if([ShadowData enabled:@"ransubtitle"]){
                NSArray *subtitles = @[@"RAID: Shadow Legends", @"Private Internet Access", @"War Thunder", @"Genshin Impact", @"Ridge Wallet", @"ANKER", @"KiwiCo", @"Corsair", @"Cablemod", @"iFixit", @"Govee", @"Micro Center", @"NZXT", @"Build Redux", @"Ting Mobile", @"FreshBooks", @"NordPass", @"Glasswire", @"Linode", @"Squarespace", @"MANSCAPED", @"HelloFresh"];
                NSString *randomSubtitle = subtitles[arc4random_uniform(subtitles.count)];
                subtitle.text = randomSubtitle;
            } else {
                NSString *subtitleText = [NSString stringWithFormat:@"Welcome, %@! 👋", dispname];
                subtitle.text = subtitleText;
            }

            NSLayoutConstraint *horiz = [NSLayoutConstraint constraintWithItem:subtitle attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:headerTitle attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
            NSLayoutConstraint *vert = [NSLayoutConstraint constraintWithItem:subtitle attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:headerTitle attribute:NSLayoutAttributeCenterY multiplier:2.0 constant:-1];
            [headerTitle addConstraint:horiz];
            [headerTitle addConstraint:vert];
        }else{
            [subtitle setHidden: YES];
        }
        
        if([ShadowData enabled: @"rgb"]){
            if(label.tag == 0){
                RainbowRoad *effect = [[RainbowRoad alloc] initWithLabel:(UILabel *)label];
                label.tag = 1;
                [effect resume];
            }
        }
    } @catch(id anException){
        [ShadowHelper banner:@"[-] iota | Header Modification Error!" color:@"#FF0000"];
        [ShadowHelper dialogWithTitle:@"Header Modification Error" text:[NSString stringWithFormat:@"This could be caused by a Snapchat update. It could have broken how the subtitle, title, or RGB header works. Hide the title/subtitle to temporarily hide this message.\n\nPlease report this to Sema#1000.\n\n%@", anException]];
        NSLog(@"Header Modification Error: %@", anException);
    }
}

static void (*orig_loaded2)(id self, SEL _cmd);
static void loaded2(SCOperaPageViewController* self, SEL _cmd){
    orig_loaded2(self, _cmd);
    [ShadowData sharedInstance].seen = FALSE;
    
    if([ShadowData enabled:@"looping"]){
        [self updatePropertiesWithLooping: YES];
    }
    
    long btnsz = [ShadowData enabled: @"buttonsize"] ? [[ShadowData sharedInstance].settings[@"buttonsize"] intValue] : 40;
    NSDictionary* properties = (NSDictionary*)[[self performSelector:@selector(page)] performSelector:@selector(properties)];
    if([ShadowData enabled: @"markfriends"] && properties[@"discover_story_composite_id"] != nil){
        [ShadowData sharedInstance].seen = TRUE;
    }
    
    if([ShadowData enabled: @"screenshotbtn"]){
        UIImage *scIcon = [[ShadowAssets sharedInstance].screenshot imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
        ShadowButton *screenshot = [[ShadowButton alloc] initWithPrimaryImage:scIcon secondaryImage:nil identifier:@"sc" target:%c(ShadowHelper) action:@selector(screenshot)];
        [screenshot addToVC: self];
    }
    if([ShadowData enabled: @"savebutton"]){
        UIImage *save1 = [ShadowAssets sharedInstance].save;
        UIImage *save2 = [ShadowAssets sharedInstance].saved;
        ShadowButton *save = [[ShadowButton alloc] initWithPrimaryImage:save1 secondaryImage:save2 identifier:@"save" target:self action:@selector(saveSnap)];
        [save addToVC: self];
    }
}

static void (*orig_loaded)(id self, SEL _cmd);
static void loaded(id self, SEL _cmd){
    
    orig_loaded(self, _cmd);

    if([ShadowData isFirst]) {
        [ShadowHelper dialogWithTitle:@"Hello and Welcome!" text: @"iota successfully loaded! ✅\n\nFor the best experiences of not being locked/banned, make sure you only inject \"iota\" in Snapchat via Choicy.\n\nHave fun and remember to report bugs to: Bad Access#1000 on Discord. 👻"];
        [[ShadowData sharedInstance] save];
        NSLog(@"First Launch");
    }

    if([ShadowData enabled: @"upload"]){
        if(![MSHookIvar<NSString *>(self, "_debugName") isEqual: @"Camera"]){
            return;
        }
        UIImage *upload = [ShadowAssets sharedInstance].upload;
        ShadowButton *uploadButton = [[ShadowButton alloc] initWithPrimaryImage:upload secondaryImage:nil identifier:@"upload" target:self action:@selector(upload)];
        [uploadButton addToVC: self];
    }
    
    if(![ShadowAssets sharedInstance].settingsicon){
        [ShadowHelper banner:@"Error Loading Theme Assets! 😱" color:@"#FF0000"];
        [ShadowHelper dialogWithTitle:@"Theme Error" text:@"Looks like there was an issue loading theme assets.\n\nYou might have a theme selected but is no longer installed.\n\nPlease select a new theme in iota's settings panel."];
    }
}

static void uploadhandler(id self, SEL _cmd){
    SCMainCameraViewController *cam = [((UIViewController*)self).childViewControllers firstObject];
    ShadowImportUtil* util = [ShadowImportUtil new];
    [util pickMediaWithImageHandler:^(NSURL *url){
        dispatch_async(dispatch_get_main_queue(), ^{
            [util dismissViewControllerAnimated:NO completion:nil];
            [cam _handleDeepLinkShareToPreviewWithImageFile:url];
            [ShadowHelper banner:@"Uploaded Image! 📸" color:@"#00FF00"];
        });
        
    } videoHandler:^(NSURL *url){
        dispatch_async(dispatch_get_main_queue(), ^{
            [util dismissViewControllerAnimated:NO completion:nil];
            [cam _handleDeepLinkShareToPreviewWithVideoFile:url];
            [ShadowHelper banner:@"Uploaded Video! 🎥" color:@"#00FF00"];
        });
        
    }];
}

static void (*orig_hidebtn)(id self, SEL _cmd);
static void hidebtn(id self, SEL _cmd){
    orig_hidebtn(self, _cmd);
    if(![ShadowData enabled: @"hidenewchat"]) return;
    [self performSelector:@selector(removeFromSuperview)];
}

static id (*orig_noemojis)(id self,SEL _cmd,NSAttributedString *arg1, struct CGSize arg2, id arg3, struct CGSize arg4, BOOL arg5);
static id noemojis(id self,SEL _cmd,NSAttributedString *arg1, struct CGSize arg2, id arg3, struct CGSize arg4, BOOL arg5){
    orig_noemojis(self, _cmd, arg1, arg2, arg3, arg4, arg5);
    if(![ShadowData enabled: @"friendmoji"])
        return orig_noemojis(self, _cmd, arg1, arg2, arg3, arg4, arg5);
    if([arg1.string rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].location != NSNotFound)
        return orig_noemojis(self, _cmd, arg1, arg2, arg3, arg4, arg5);
    return orig_noemojis(self, _cmd, [[NSAttributedString new] initWithString:@""], arg2, arg3, arg4, arg5);
}

static void (*orig_scramblefriends)(id self, SEL _cmd, NSArray *arg1);
static void scramblefriends(id self, SEL _cmd, NSArray *arg1){
    if(![ShadowData enabled: @"scramble"]){
        orig_scramblefriends(self, _cmd, arg1);
        return;
    }
    NSMutableArray *viewModel = [arg1 mutableCopy];
    NSUInteger count = [viewModel count];
    if (count <= 1) return;
    for (NSUInteger i = 0; i < count - 1; ++i) {
        NSInteger remainingCount = count - i;
        NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t )remainingCount);
        [viewModel exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
    }
    orig_scramblefriends(self, _cmd, [viewModel copy]);
}

static unsigned long long (*orig_views)(id self, SEL _cmd);
static unsigned long long views(id self, SEL _cmd){
    if(![ShadowData enabled: @"spoofviews"])
        return orig_views(self, _cmd);
    return [[ShadowData sharedInstance].settings[@"spoofviews"] intValue];
}

static unsigned long long (*orig_screenshots)(id self, SEL _cmd);
static unsigned long long screenshots(id self, SEL _cmd){
    if(![ShadowData enabled: @"spoofsc"])
        return orig_screenshots(self, _cmd);
    return [[ShadowData sharedInstance].settings[@"spoofsc"] intValue];
}

static bool noads(id self, SEL _cmd){
    if([ShadowData enabled: @"noads"]){
        return FALSE;
    }
    return TRUE;
}

static void (*orig_updateghost)(id self, SEL _cmd, long arg1);
static void updateghost(id self, SEL _cmd, long arg1){
    orig_updateghost(self, _cmd, arg1);
    if([ShadowData enabled: @"pulltorefresh"]){
        id ghost = MSHookIvar<id>(self,"_ghost");
        UIImageView *normal = MSHookIvar<UIImageView *>(ghost, "_defaultBody");
        UIImageView *wink = MSHookIvar<UIImageView *>(ghost, "_winkBody");
        UIImageView *shocked = MSHookIvar<UIImageView *>(ghost, "_shockedBody");
        UIImageView *rainbow = MSHookIvar<UIImageView *>(ghost, "_rainbowBody");
        UIImageView *hands = MSHookIvar<UIImageView *>(self,"_hands");
        
        if(UIImage *image = [ShadowAssets sharedInstance].pull_rainbow)  rainbow.image = image;
        if(UIImage *image = [ShadowAssets sharedInstance].pull_normal)  normal.image = image;
        if(UIImage *image = [ShadowAssets sharedInstance].pull_wink)  wink.image = image;
        if(UIImage *image = [ShadowAssets sharedInstance].pull_shocked)  shocked.image = image;
        if(UIImage *image = [ShadowAssets sharedInstance].pull_hands)  hands.image = image;
        
        NSArray *ghostConstraints = MSHookIvar<NSArray *>(self,"_normalGhostConstraints");
        NSLayoutConstraint *bottom = [ghostConstraints lastObject];
        bottom.constant = -1 * normal.image.size.height;
    }
}

static void (*orig_settingstext)(id self, SEL _cmd);
static void settingstext(id self, SEL _cmd){
    if([ShadowData enabled:@"iotabrand"]){
        orig_settingstext(self, _cmd);
        UITableView * table = MSHookIvar<UITableView *>(self, "_scrollView");
        if(!table) return;
        if(![table respondsToSelector:@selector(paddedTableFooterView)]) return;
        UILabel * label = (UILabel *)[table performSelector:@selector(paddedTableFooterView)];
        if(label.tag != 1){
            if([ShadowData enabled:@"rgb"]){
                RainbowRoad *effect = [[RainbowRoad alloc] initWithLabel:(UILabel *)label];
                [effect resume];
            }
            //NSString *snapVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
            NSString *text = [NSString stringWithFormat: @"\n%s v%s | %s v%s", IOTA_PROJECT, IOTA_VERSION, NULL_PROJECT, NULL_VERSION];
            //label.text = text;
            label.text = [[label.text componentsSeparatedByString:@"\n"][0] stringByAppendingString: text];
            label.tag = 1;
            [table reloadData];
        }
    }
}

id (*orig_location)(id self, SEL _cmd);
id location(id self, SEL _cmd){
    if(![ShadowData enabled: @"location"]) return orig_location(self, _cmd);
    double longitude = [[ShadowData sharedInstance].location[@"Longitude"] doubleValue];
    double latitude = [[ShadowData sharedInstance].location[@"Latitude"] doubleValue];
    CLLocation * newlocation = [[CLLocation alloc]initWithLatitude: latitude longitude: longitude];
    return newlocation;
}

void (*orig_openurl)(id self, SEL _cmd, id arg1, id arg2);
void openurl(id self, SEL _cmd, id arg1, id arg2){
    if([ShadowData enabled: @"openurl"]){
        [[UIApplication sharedApplication] openURL:(NSURL *)arg1 options:@{} completionHandler:nil];
    }else{
        orig_openurl(self, _cmd, arg1, arg2);
    }
}

void (*orig_openurl2)(id self, SEL _cmd, id arg1, long arg2, id arg3, id arg4, id arg5);
void openurl2(id self, SEL _cmd, id arg1, long arg2, id arg3, id arg4, id arg5){
    NSLog(@"Opening URL: %@ ext:%ld ",arg1, arg2);
    if([ShadowData enabled: @"openurl"]){
        [[UIApplication sharedApplication] openURL:(NSURL *)arg1 options:@{} completionHandler:nil];
    }else{
        orig_openurl2(self, _cmd, arg1, arg2, arg3, arg4, arg5);
    }
}

long (*orig_nomapswipe)(id self, SEL _cmd, id arg1);
long nomapswipe(id self, SEL _cmd, id arg1){
    NSString *pageName = MSHookIvar<NSString *>(self, "_debugName");
    if([ShadowData enabled: @"nomapswiping"]){
        if([pageName isEqualToString:@"Friend Feed"]){
            ((SCSwipeViewContainerViewController*)self).allowedDirections = 1;
        }
    }
    return orig_nomapswipe(self, _cmd, arg1);
}

void confirmshot(id self, SEL _cmd){
    if(sel_getName(_cmd) )
    [[ShadowScreenshotManager sharedInstance] handle:^{
        void (*orig)(id self, SEL _cmd) = (typeof(orig))class_getMethodImplementation([self class], _cmd);
        orig(self, _cmd);
    }];
}

%hook NSNotificationCenter
- (void)addObserver:(NSObject*)arg1 selector:(SEL)arg2 name:(NSString *)data object:(id)arg4 {
    if([data isEqual: @"UIApplicationUserDidTakeScreenshotNotification"]){
        RelicHookMessage([arg1 class], arg2, (void *)confirmshot);
    }
    if([data isEqual: @"SCUserDidScreenRecordContentNotification"]){
        if([ShadowData enabled: @"screenshot"]){
            return;
        }
    }
    %orig;
}
%end

void markSeen(SCOperaViewController *self, SEL _cmd){
    if([ShadowData enabled: @"closeseen"]){
        [ShadowHelper banner:@"Marked as Seen 👀" color:@"#00FF00"];
        [ShadowData sharedInstance].seen = TRUE;
        [self _advanceToNextPage:YES];
    }else{
        if([ShadowData sharedInstance].seen == FALSE){
            [ShadowHelper banner:@"Marked as Seen 👀" color:@"#00FF00"];
            [ShadowData sharedInstance].seen = TRUE;
        }else{
            [ShadowHelper banner:@"Marked as Uneen 🙈" color:@"#00FF00"];
            [ShadowData sharedInstance].seen = FALSE;
        }
    }
    
}

uint64_t (*orig_nohighlights)(id self, SEL _cmd, id arg1, BOOL arg2);
uint64_t nohighlights(id self, SEL _cmd, id arg1, BOOL arg2){
    if([ShadowData enabled: @"highlights"]){
        NSArray* items = (NSArray*)arg1;
        if(![[items[0] performSelector:@selector(accessibilityIdentifier)] isEqualToString:@"arbar_create"])
            return orig_nohighlights(self, _cmd, @[items[0],items[1],items[2],items[3]], arg2);
    }
    return orig_nohighlights(self, _cmd, arg1, arg2);
}

id (*orig_nodiscover)(id self, SEL _cmd);
id nodiscover(UIView* self, SEL _cmd){
    if([ShadowData enabled: @"discover"]){
        if(self.superview.class != %c(SCHorizontalOneBounceCollectionView)) [self removeFromSuperview];
    }
    return orig_nodiscover(self, _cmd);
}

id (*orig_nodiscover2)(id self, SEL _cmd);
id nodiscover2(UIView* self, SEL _cmd){
    if([ShadowData enabled: @"discover"]){
        if(self.superview.class != %c(SCHorizontalOneBounceCollectionView)) [self removeFromSuperview];
    }
    return orig_nodiscover2(self, _cmd);
}

void (*orig_noquickadd)(id self, SEL _cmd);
void noquickadd(id self, SEL _cmd){
    orig_noquickadd(self, _cmd);
    if([ShadowData enabled: @"quickadd"]){
        NSString *identifier = [self performSelector:@selector(accessibilityIdentifier)];
        if([identifier isEqual:@"quick_add_item"]) [self performSelector:@selector(removeFromSuperview)];
    }
}

void (*orig_teleport)(id self, SEL _cmd, id arg1, BOOL arg2);
void teleport(id self, SEL _cmd, id arg1, BOOL arg2){
    orig_teleport(self, _cmd, arg1, arg2);
    if([ShadowData enabled: @"teleport"]){
        NSString *selected = [self performSelector:@selector(selectedUserId)];
        if(selected){
            NSDictionary<NSString*, id> *locations = [self performSelector:@selector(bitmojiClustersByUserId)];
            SCMapBitmojiCluster *location = locations[selected];
            if(location){
                CLLocationCoordinate2D coord = location.centerCoordinate;
                [ShadowData sharedInstance].location[@"Latitude"] = [NSString stringWithFormat:@"%f", coord.latitude];
                [ShadowData sharedInstance].location[@"Longitude"] = [NSString stringWithFormat:@"%f", coord.longitude];
                [[ShadowData sharedInstance] save];
            }
        }
    }
}

void (*orig_callstart)(id self, SEL _cmd, long arg1);
void callstart(id self, SEL _cmd, long arg1){
    if(![ShadowData enabled: @"callconfirm"]){
        orig_callstart(self, _cmd, arg1);
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [ShadowHelper popup: @"Woah!" text: @"Did you mean to start a call?" yes: @"Yes" no: @"No" action:^(BOOL startcall){
            if(startcall){
                orig_callstart(self, _cmd, arg1);
            } else {
                // do nothing
            }
        }];
    }); 
}

BOOL (*orig_cellswipe)(id self, SEL _cmd);
BOOL cellswipe(id self, SEL _cmd){
    if([ShadowData enabled: @"cellswipe"]){
        return YES;
    }else{
        return orig_cellswipe(self, _cmd);
    }
}

long (*orig_longupload)(id self, SEL _cmd, id arg1, CGSize arg2, id arg3, id arg4);
long longupload(id self, SEL _cmd, id arg1, CGSize arg2, id arg3, id arg4){
    if(![ShadowData enabled:@"longupload"]){
        return orig_longupload(self, _cmd, arg1, arg2, arg3, arg4);
    }
    NSString *path = [ShadowData fileWithName: @"upload.mp4"];
    NSURL *url = [NSURL fileURLWithPath: path];
    UIImage *image = [UIImage new];
    SCManagedRecordedVideo *capture = [[%c(SCManagedRecordedVideo) alloc] initWithVideoURL: url rawVideoDataFileURL: url videoDuration: 1 placeholderImage: image isFrontFacingCamera:1 codecType:1];
    SCFuture *future = [[%c(SCFuture) alloc] _init];
    [future _completeWithValue: capture];
    return orig_longupload(self, _cmd, future, arg2, image, arg4);
}

NSString *(*orig_experimentcontrol)(id self, SEL _cmd, NSString *arg1, id arg2);
NSString *experimentcontrol(id self, SEL _cmd, NSString *arg1, id arg2){
    NSArray *blacklist = @[
        @"CAMERA_IOS_FINGER_DOWN_CAPTURE",
        @"SNAPADS_IOS_PRE_ROLL_AD",
        @"SNAPADS_COMMERCIAL_WHITELIST_IOS",
        @"IOS_SNAP_AD_BACKFILL",
        @"ADS_HOLDOUT_01",
        @"SNAPADS_IOS_CI_PREFETCH",
        @"CAMERA_IOS_ULTRAWIDE_CAPTURE",
        @"SNAP_TEAM_SNAPCHAT_V2_IOS"
    ];
    if([ShadowData enabled: @"sctesting"] && ![blacklist containsObject: arg1]){
        return @"True";
    }
    return orig_experimentcontrol(self, _cmd, arg1, arg2);
}

// TESTING AREA

NSString *(*orig_streakExpiry)(id self, SEL _cmd, NSInteger arg1, CGFloat arg2, id arg3, BOOL arg4, BOOL arg5);
NSString *streakExpiry(id self, SEL _cmd, NSInteger arg1, CGFloat arg2, id arg3, BOOL arg4, BOOL arg5){
    // arg1 = streak count // arg2 = streak expire time // arg3 = friendUserID // arg4 = bool for shouldDisplayStreakCounter // arg5 = bool for showExpiryTimeForDebugging

    if(![ShadowData enabled:@"showstreaktimer"]){
        return orig_streakExpiry(self, _cmd, arg1, arg2, arg3, arg4, arg5);
    }
    arg5 = YES;

    if(![ShadowData enabled:@"spoofstreak"]){
        return orig_streakExpiry(self, _cmd, arg1, arg2, arg3, arg4, arg5);
    }
    arg1 = [[ShadowData sharedInstance].settings[@"spoofstreak"] intValue];
    return orig_streakExpiry(self, _cmd, arg1, arg2, arg3, arg4, arg5);
}

void (*orig_presence)(id self, SEL _cmd);
void presence(id self, SEL _cmd){
  if ([ShadowData enabled: @"chatghost"] || [ShadowData enabled: @"bitmojispoof"]){return;}
  orig_presence(self,_cmd);
}

void (*orig_chatghost_autosave)(id self, SEL _cmd,id arg1,NSInteger arg2, SCChatConversationViewModelV3 *arg3);
void chatghost_autosave(id self, SEL _cmd,id arg1,NSInteger arg2, SCChatConversationViewModelV3 *arg3){
  if([ShadowData enabled: @"chatghost"]){
    return;
  }

  if ([ShadowData enabled: @"autosavechat"]){
    for (id model in arg3.messageViewModels){
      //Normal chats
      if ([model isMemberOfClass:[%c(SCChatMessageCellViewModel) class]]){
          SCChatMessageCellViewModel *model2 = (SCChatMessageCellViewModel *)model;
        if (![model2 shouldShowSavedLabel]){
          [(SCArroyoMessageActionHandler *)self saveMessageInConversationId:arg1 messageId:model2.identifier source:0];
        }
      }
      //Media chats
      if ([model isMemberOfClass:[%c(SCMediaChatViewModel) class]]){
          SCMediaChatViewModel *model2 = (SCMediaChatViewModel *)model;
        if (![model2 shouldShowSavedLabel]){
          [(SCArroyoMessageActionHandler *)self saveMessageInConversationId:arg1 messageId:model2.identifier source:0];
        }
      }
    }
  }
  orig_chatghost_autosave(self,_cmd,arg1,arg2,arg3);
}

void (*orig_typing)(id self, SEL _cmd,id arg1,id arg2);
void typing(id self, SEL _cmd,id arg1,id arg2){
  if([ShadowData enabled: @"typing"]){
    return;
  }
  orig_typing(self,_cmd,arg1,arg2);
}

//[SCChatInputAudioNoteController didDeselectInputItem:]
bool (*orig_audio_note)(id self, SEL _cmd, id arg1);
bool audio_note(id self, SEL _cmd, id arg1){
  bool orig = orig_audio_note(self, _cmd, arg1);
    if ([ShadowData enabled:@"audio_note"]){
        UIViewController *vc = MSHookIvar<UIViewController *>(self,"_inputController");
        [vc performSelector:@selector(resignFirstResponder)];
        AudioPickerController *audioController = [[AudioPickerController alloc]initWithController:self];
        [ShadowHelper popupaction: @"Upload Voice Note" text: @"Are you sure you want to upload a voice note?" yes: @"Yes" no: @"No" target: vc.parentViewController action:^(bool uploadaudio){
            if(uploadaudio){
                //present document picker
                UIDocumentPickerViewController* documentPicker =
                [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[@"public.mp3"]
                                                                   inMode:UIDocumentPickerModeImport];
                documentPicker.allowsMultipleSelection = NO;
                documentPicker.delegate = audioController;
                [vc.parentViewController presentViewController: documentPicker animated: YES completion:nil];
            }
      }];
    }
    return orig;
}

void (*orig_setuptoolbar)(id self, SEL _cmd, BOOL arg1, BOOL arg2, BOOL arg3);
void setuptoolbar(id self, SEL _cmd, BOOL arg1, BOOL arg2, BOOL arg3){
    orig_setuptoolbar(self, _cmd, arg1,arg2,arg3);
    UIView* containerView = (UIView*)[self valueForKey:@"_containerView"];
    UIView *toolbarView = (UIView *)[self performSelector:@selector(toolbarView)];
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    CGFloat factor = height/20;
    if (toolbarView.transform.ty != factor){
        [toolbarView setTransform:CGAffineTransformMakeTranslation(0, factor)];
        UIImage *image = [ShadowAssets sharedInstance].settingsicon;
        UIButton *button = [UIButton new];
        [button setImage:image forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(10,7,10,7);
        UITapGestureRecognizer *singleFingerTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(settingsbtn)];
        [button addGestureRecognizer:singleFingerTap];

        button.translatesAutoresizingMaskIntoConstraints = false;
        [containerView addSubview:button];
        [button.topAnchor constraintEqualToAnchor:containerView.topAnchor].active = YES;
        [button.bottomAnchor constraintEqualToAnchor:toolbarView.topAnchor  constant: factor*2].active = YES;
        [button.trailingAnchor constraintEqualToAnchor:toolbarView.trailingAnchor].active = YES;
        [button.leadingAnchor constraintEqualToAnchor:toolbarView.leadingAnchor].active = YES;
    }
}
void toolbarpressed(id self, SEL _cmd, id arg1){
    ShadowSettingsViewController *vc = [ShadowSettingsViewController new];
    [vc setModalPresentationStyle: UIModalPresentationPageSheet];
    UIViewController *topVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    while (topVC.presentedViewController) topVC = topVC.presentedViewController;
    vc.preferredContentSize = CGRectInset(topVC.view.bounds, 20, 20).size;
    [topVC presentViewController: vc animated: true completion:nil];
}

extern void (*orig_deleted)(id self, SEL _cmd, id arg1, id arg2, id arg3, id arg4);
void deleted(id self, SEL _cmd, id arg1, id arg2, NSArray<SCNMessagingMessage*>* arg3, id arg4);

extern SCNMessagingMessage* (*orig_delmsg)(__attribute__((ns_consumed)) SCNMessagingMessage* self, SEL _cmd, SCNMessagingMessageDescriptor *descriptor, SCNMessagingUUID *senderId, SCNMessagingMessageContent *content, SCNMessagingMessageMetadata *metadata, NSInteger releasePolicy, NSInteger state, SCNMessagingMessageAnalytics *messageAnalytics, NSInteger orderKey) __attribute__((ns_returns_retained));
SCNMessagingMessage* delmsg(__attribute__((ns_consumed)) SCNMessagingMessage* self, SEL _cmd, SCNMessagingMessageDescriptor *descriptor, SCNMessagingUUID *senderId, SCNMessagingMessageContent *content, SCNMessagingMessageMetadata *metadata, NSInteger releasePolicy, NSInteger state, SCNMessagingMessageAnalytics *messageAnalytics, NSInteger orderKey) __attribute__((ns_returns_retained));

extern id (*orig_delcolor)(id self, SEL _cmd);
id delcolor(id self, SEL _cmd);

NSMutableArray <NSString *> *tempar = [NSMutableArray new];
NSMutableArray <SCNMessagingMessage *>*messages = [NSMutableArray new];
SCNMessagingMessage* (*orig_delmsg)(__attribute__((ns_consumed)) SCNMessagingMessage* self, SEL _cmd, SCNMessagingMessageDescriptor *descriptor, SCNMessagingUUID *senderId, SCNMessagingMessageContent *content, SCNMessagingMessageMetadata *metadata, NSInteger releasePolicy, NSInteger state, SCNMessagingMessageAnalytics *messageAnalytics, NSInteger orderKey) __attribute__((ns_returns_retained));
SCNMessagingMessage* delmsg(__attribute__((ns_consumed)) SCNMessagingMessage* self, SEL _cmd, SCNMessagingMessageDescriptor *descriptor, SCNMessagingUUID *senderId, SCNMessagingMessageContent *content, SCNMessagingMessageMetadata *metadata, NSInteger releasePolicy, NSInteger state, SCNMessagingMessageAnalytics *messageAnalytics, NSInteger orderKey) __attribute__((ns_returns_retained)){
    NSInteger contentType = [(SCNMessagingMessageContent *)content contentType];
    NSInteger messageId = [(SCNMessagingMessageDescriptor *)descriptor messageId];
    NSString *conversationId = [[(SCNMessagingMessageDescriptor *)descriptor conversationId] toString];
    if(!messages) messages = [NSMutableArray new];

    if([ShadowData enabled:@"deleted"]){
        if (contentType != 7){
            [messages addObject:self];
        } else {
            for (SCNMessagingMessage *message in messages){
                NSInteger matchMessageId = [(SCNMessagingMessageDescriptor *)[message descriptor] messageId];
                NSString *matchConversationId = [[(SCNMessagingMessageDescriptor *)[message descriptor] conversationId] toString];
                if ([matchConversationId isEqualToString:conversationId] && matchMessageId == messageId){
                    [tempar addObject:[(SCNMessagingMessageAnalytics *)messageAnalytics analyticsMessageId]];
                    return message;
                }
            }
        }
    }

    self = orig_delmsg(self, _cmd, descriptor, senderId, content, metadata, releasePolicy, state, messageAnalytics, orderKey);
    return self;
}
id (*orig_delcolor)(id self, SEL _cmd);
id delcolor(id self, SEL _cmd){
    SCChatSenderLineViewModel *orig = orig_delcolor(self, _cmd);
    NSString *str = [self performSelector:@selector(analyticsMessageId)];
    for (NSString *an in tempar){
        if ([str isEqualToString:an]){
            NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"deleted_color"];
            UIColor *color = (colorData) ? [NSKeyedUnarchiver unarchiveObjectWithData:colorData] : [UIColor blackColor];
            return [[%c(SCChatSenderLineViewModel) alloc] initWithColor:color height:[orig height] width:[orig width] * 3 cornerMask:[orig cornerMask]];
        }
    }
    return orig;
}

struct GhostRequest {
    SCNMessagingSnapManager *__manager;
    id __conversationId;
    long long __messageId;
};
extern GhostRequest snapSeenRequest;
extern SCUserIdToSnapchatterFetcherImpl *userIDFetcherInstance;
GhostRequest snapSeenRequest = (GhostRequest){nil, nil, 0};
SCUserIdToSnapchatterFetcherImpl *userIDFetcherInstance = nil;


void (*orig_chatactiontap)(id self, SEL _cmd, id arg1);
void chatactiontap(id self, SEL _cmd, id arg1){
    SCChatActionMenuButtonViewModel *model = [self performSelector:@selector(viewModel)];
    if(NSDictionary *item = IotaChatActions.sharedInstance.items[model.karmaIdentifier]){
        ((Action)item[@"block"])(self);
    }else{
        NSLog(@"invalid karma ID: %@, %@",model.karmaIdentifier, IotaChatActions.sharedInstance.items[model.karmaIdentifier]);
    }
    orig_chatactiontap(self, _cmd, arg1);
}

void (*orig_hidecallbtns)(id self, SEL _cmd, id arg1);
void hidecallbtns(id self, SEL _cmd, id arg1){
    if(![ShadowData enabled:@"hidecallbtns"]){
        orig_hidecallbtns(self, _cmd, arg1);
        return;
    }
    [((UIView *)arg1) setHidden:YES];
}

%ctor{
    [[XLLogerManager manager] prepare];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        // Test Area
        RelicHookMessageEx(%c(SCChatTypingHandler), @selector(updateTypingStateWithState:conversationViewModel:), (void *)typing, &orig_typing);
        RelicHookMessageEx(%c(SCFriendmojiPresenter), @selector(_streakStringWithLength:expiration:friendUserId:shouldDisplayStreakCounter:showExpiryTimeForDebugging:), (void *)streakExpiry, &orig_streakExpiry);

        // Chat
        RelicHookMessageEx(%c(SCChatViewHeader), @selector(attachCallButtonsPane:), (void *)hidecallbtns, &orig_hidecallbtns);
        RelicHookMessageEx(%c(SCActionMenuButtonView), @selector(_didTap:), (void *)chatactiontap, &orig_chatactiontap);
        RelicHookMessageEx(%c(SCNMessagingMessage), @selector(initWithDescriptor:senderId:messageContent:metadata:releasePolicy:state:messageAnalytics:orderKey:), (void *)delmsg, &orig_delmsg);
        RelicHookMessageEx(%c(SCChatMessageCellViewModel), @selector(senderLine), (void *)delcolor, &orig_delcolor);
        RelicHookMessageEx(%c(SCChatInputAudioNoteController), @selector(didDeselectInputItem:), (void *)audio_note, &orig_audio_note);

        // Toolbar
        RelicHookMessageEx(%c(SCCameraVerticalToolbar), @selector(setAllItemsHidden:includingAlwaysShowItems:animated:), (void *)setuptoolbar, &orig_setuptoolbar);
        RelicHookMessage(%c(SCCameraVerticalToolbar), @selector(settingsbtn), (void *)toolbarpressed);

        //URL opening
        RelicHookMessageEx(%c(SCURLAttachmentHandler),@selector(openURL:baseView:), (void *)openurl, &orig_openurl);
        RelicHookMessageEx(%c(SCContextV2BrowserPresenter),@selector(presentURL:preferExternal:metricParams:fromViewController:completion:), (void *)openurl2, &orig_openurl2);
        
        //Ghost
        RelicHookMessageEx(%c(TCV3PresenceSession), @selector(activate), (void *)presence, &orig_presence);
        RelicHookMessageEx(%c(SCArroyoMessageActionHandler), @selector(markMessagesAsReadForConversationId:chatPageSource:conversationViewModel:), (void *)chatghost_autosave, &orig_chatghost_autosave);
        RelicHookMessageEx(%c(SIGPullToRefreshView), @selector(setHeight:), (void *)updateghost, &orig_updateghost);
        RelicHookMessageEx(%c(SCSingleStoryViewingSession), @selector(_markStoryAsViewedWithStorySnap:), (void *)storyghost, &orig_storyghost);
        RelicHookMessageEx(%c(SCNMessagingSnapManager),@selector(onSnapInteraction:conversationId:messageId:callback:), (void *)snapghost, &orig_snapghost);
        
        //Spoofing + stuff
        RelicHookMessageEx(%c(SCFriendsFeedFriendmojiViewModel), @selector(initWithFriendmojiText:friendmojiTextSize:expiringStreakFriendmojiText:expiringStreakFriendmojiTextSize:hasStreak:), (void *)noemojis, &orig_noemojis);
        RelicHookMessageEx(%c(SCUnifiedProfileMyStoriesHeaderDataModel), @selector(totalViewCount), (void *)views, &orig_views);
        RelicHookMessageEx(%c(SCUnifiedProfileMyStoriesHeaderDataModel), @selector(totalScreenshotCount), (void *)screenshots, &orig_screenshots);
        RelicHookMessageEx(%c(SCUnifiedProfileSquadmojiView), @selector(setViewModel:), (void *)scramblefriends, &orig_scramblefriends);
        
        //Media hooks
        RelicHookMessage(%c(SCSwipeViewContainerViewController), @selector(upload), (void *)uploadhandler);
        RelicHookMessage(%c(SCOperaPageViewController), @selector(saveSnap), (void *)save);
        RelicHookMessage(%c(SCOperaViewController), @selector(markSeen), (void *)markSeen);
        RelicHookMessage(%c(SCOperaViewController), @selector(saveSnap), (void *)save);
        RelicHookMessageEx(%c(SCFeatureCaptureComponentImpl), @selector(_capturerWillFinishRecordingWithRecordedVideoFuture:videoSize:placeholderImage:session:), (void *)longupload, &orig_longupload);
        
        //View loading
        RelicHookMessageEx(%c(SCSwipeViewContainerViewController), @selector(viewDidLoad), (void *)loaded, &orig_loaded);
        RelicHookMessageEx(%c(SCOperaPageViewController), @selector(viewDidLoad), (void *)loaded2, &orig_loaded2);
        
        //Features
        RelicHookMessageEx(%c(SCLocationManager), @selector(location), (void *)location, &orig_location);
        RelicHookMessageEx(%c(SCTalkChatSessionImpl), @selector(_composerCallButtonsOnViewCallWithMedia:), (void *)callstart, &orig_callstart);
        RelicHookMessageEx(%c(SCTalkChatSessionImpl), @selector(_composerCallButtonsOnStartCallMedia:), (void *)callstart, &orig_callstart);
        RelicHookMessageEx(%c(SCMapBitmojiLayerController), @selector(setSelectedUserId:animated:), (void *)teleport, &orig_teleport);
        
        //UI
        RelicHookMessageEx(%c(SIGHeader), @selector(_stylize:), (void *)markheader, &orig_markheader);
        //RelicHookMessageEx(%c(SIGHeaderTitle), @selector(_titleTapped:), (void *)tap, &orig_tap);
        RelicHookMessageEx(%c(SCFriendsFeedCreateButton), @selector(resetCreateButton), (void *)hidebtn, &orig_hidebtn);
        RelicHookMessageEx(%c(SCDiscoverFeedStoryCollectionViewCell), @selector(viewModel), (void *)nodiscover, &orig_nodiscover);
        RelicHookMessageEx(%c(SCDiscoverFeedPublisherStoryCollectionViewCell), @selector(viewModel), (void *)nodiscover2, &orig_nodiscover2);
        RelicHookMessageEx(%c(SCSwipeViewContainerViewController), @selector(isFullyVisible:), (void *)nomapswipe, &orig_nomapswipe);
        RelicHookMessageEx(%c(SIGNavigationBarView), @selector(initWithItems:leadingAligned:), (void *)nohighlights, &orig_nohighlights);
        RelicHookMessageEx(%c(SCSnapchatterTableViewCell), @selector(layoutSubviews), (void *)noquickadd, &orig_noquickadd);
        RelicHookMessageEx(%c(SCPanningGestureRecognizer), @selector(isEdgePan), (void *)cellswipe, &orig_cellswipe);
        
        //Ads
        RelicHookMessage(%c(SCAdsHoldoutExperimentContext), @selector(canShowShowsAds), (void *)noads);
        RelicHookMessage(%c(SCAdsHoldoutExperimentContext), @selector(canShowEmbeddedWebViewAds), (void *)noads);
        RelicHookMessage(%c(SCAdsHoldoutExperimentContext), @selector(canShowPublicStoriesAds), (void *)noads);
        RelicHookMessage(%c(SCAdsHoldoutExperimentContext), @selector(canShowDiscoverAds), (void *)noads);
        RelicHookMessage(%c(SCAdsHoldoutExperimentContext), @selector(canShowContentInterstitialAds), (void *)noads);
        RelicHookMessage(%c(SCAdsHoldoutExperimentContext), @selector(canShowCognacAds), (void *)noads);
        RelicHookMessage(%c(SCAdsHoldoutExperimentContext), @selector(canShowStoryAds), (void *)noads);
        RelicHookMessage(%c(SCAdsHoldoutExperimentContext), @selector(canShowUserStoriesAds), (void *)noads);
        RelicHookMessage(%c(SCAdsHoldoutExperimentContext), @selector(canShowAds), (void *)noads);
        
        //Misc
        RelicHookMessageEx(%c(SCExperimentPreferenceStore), @selector(_boolStringForStudy:forVariable:), (void *)experimentcontrol, &orig_experimentcontrol);
        RelicHookMessageEx(%c(SCNMessagingMessage), @selector(isSaved), (void *)savehax, &orig_savehax);
        RelicHookMessageEx(%c(SIGScrollViewKeyValueObserver),@selector(_contentOffsetDidChange), (void *)settingstext, &orig_settingstext);
    });
    NSLog(@"%s v%s | Loaded! ✅", IOTA_PROJECT, IOTA_VERSION);
    [ShadowData sharedInstance];

    if([ShadowData enabled: @"loadbanner"]){
        [ShadowHelper banner:[NSString stringWithFormat: @"%s v%s loaded successfully! 🚀", IOTA_PROJECT, IOTA_VERSION] color:@"#FF00FF"];
    }

    if([ShadowData enabled:@"eastereggs"]){
        [NSTimer scheduledTimerWithTimeInterval:300 repeats:YES block:^(NSTimer * _Nonnull timer) {
            NSArray *bannermessages = @[@"I like hotdogs.", @"Pizza Rolls are just Italian Gushers.", @"Hot dogs are an approved space food.", @"The most expensive hot dog costs $2,300.", @"There is a \"right way\" and a \"wrong way\" to eat a hot dog."];
            [ShadowHelper banner:[bannermessages objectAtIndex:arc4random_uniform((int)[bannermessages count])] color:@"#FF00FF"];
        }];
    }
}

%dtor {
    [[ShadowData sharedInstance] save];
    NSLog(@"%s v%s | Unloaded! 👋", IOTA_PROJECT, IOTA_VERSION);
}
