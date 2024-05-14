#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
@import Foundation;
@import UIKit;

@protocol SCColorPickerViewDelegate
@end

@interface ShadowSettingsViewController: UIViewController <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (strong,nonatomic) UITableView *table;
@end
