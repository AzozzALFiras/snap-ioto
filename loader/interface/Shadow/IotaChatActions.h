@import Foundation;
@import UIKit;

typedef void (^Action)(id obj);

@interface IotaChatActions: NSObject
@property NSMutableDictionary *items;
+(instancetype)sharedInstance;
-(void)addOptionWithTitle:(NSString*)title subtitle:(NSString* )subtitle icon:(UIImage*)icon identifier:(NSString*)identifier type:(NSString*)type block:(Action)action;
-(void)clear;
@end
