#include "ShadowSettingsViewController.h"
#include "ShadowData.h"
#include "ShadowInformationViewController.h"
#include "RainbowRoad.h"
#include "ShadowAssets.h"
#import "IotaAssetDefines.h"

@interface  SCColorPickerView : UIView
-(id)initWithColorPickerVersion:(NSUInteger)arg1 paletteType:(NSUInteger)arg2 orientation:(NSUInteger)arg3; 
-(void)moveDropletToColor:(UIColor *)color;
@property (nonatomic, weak, readwrite) id delegate;
@end

@interface ShadowSwitch: UISwitch
@property NSString *setting;
@end

@implementation ShadowSwitch
@end

@interface ShadowField: UITextField
@property NSString *setting;
@end

@implementation ShadowField
@end

@implementation ShadowSettingsViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    [self cofigureTableview];
    [[ShadowData sharedInstance] load];
    self.table.alwaysBounceVertical = NO;
    if([ShadowData enabled:@"darkmode"]){
        self.table.separatorColor = [UIColor colorWithRed: .235 green: .235 blue: .263 alpha: 1];
    }
}

-(void)cofigureTableview{
    NSInteger height = 67;
    
    UINavigationBar *nav = [self makeNav];
    
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, nav.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height - nav.bounds.size.height) style:UITableViewStylePlain];
    self.table.delegate = self;
    self.table.dataSource = self;
    if([ShadowData enabled: @"darkmode"]){
        self.table.backgroundColor = [UIColor colorWithRed: 30/255.0 green: 30/255.0 blue: 30/255.0 alpha: 1.00];
    }
    [self.view addSubview: nav];
    [self.view addSubview:self.table];
}

-(UINavigationBar*)makeNav{
    UINavigationBar *nav = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 56)];
    if([ShadowData enabled:@"darkmode"]){
        [nav setTitleTextAttributes: @{
            NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-Bold" size:19],
            NSForegroundColorAttributeName:[UIColor whiteColor]
        }];
    }else{
        [nav setTitleTextAttributes: @{
            NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-Bold" size:19]
        }];
    }
    UINavigationItem* navItem = [[UINavigationItem alloc] initWithTitle:@"Settings"];
    UIImage *backImage = [UIImage imageNamed:@"back_flat"];
    UIBarButtonItem* back = [[UIBarButtonItem alloc] initWithImage: backImage style:UIBarButtonItemStylePlain target:self action:@selector(backPressed:)];
    [back setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-Demibold" size:17]} forState:UIControlStateNormal];
    navItem.leftBarButtonItem = back;
    [nav setItems:@[navItem]];
    [nav layoutSubviews];
    
    if([ShadowData enabled: @"darkmode"]){
        nav.tintColor = [UIColor colorWithRed: 255/255.0 green: 252/255.0 blue: 0/255.0 alpha: 1.00];
        nav.barTintColor = [UIColor colorWithRed: 18/255.0 green: 18/255.0 blue: 18/255.0 alpha: 1.00];
    }
    return nav;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[ShadowData sharedInstance] layout].count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 0;
    }else{
        return 40;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSMutableArray *settings = [[ShadowData sharedInstance] layout ][[[ShadowData sharedInstance] orderedSections][section]];
    return settings.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShadowSetting *setting = [[ShadowData sharedInstance] layout ] [ [ [ShadowData sharedInstance] orderedSections] [indexPath.section]][indexPath.row];
    long originalIndex = [[ShadowData sharedInstance] indexForKey: setting.key];
    
    UITableViewCell *cell = [self.table dequeueReusableCellWithIdentifier:setting.type];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:setting.type];
        cell.textLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:15];
        cell.detailTextLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:12];
        if([ShadowData enabled:@"darkmode"]){
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.detailTextLabel.textColor = [UIColor whiteColor];
            [cell setBackgroundColor:[UIColor colorWithRed: 30/255.0 green: 30/255.0 blue: 30/255.0 alpha: 1.00]];
        }
    }
    
    
    if([setting.type isEqualToString:@"image"]){
        cell = [UITableViewCell new];
        UIImage * header = [UIImage imageWithContentsOfFile:IotaAssetHeaderImagePath];
        UIImageView *imageView = [[UIImageView new] initWithImage: header];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.layer.cornerRadius = 15;
        imageView.clipsToBounds = true;
        cell.backgroundView = imageView;
        if([ShadowData enabled:@"darkmode"]){
            [cell setBackgroundColor:[UIColor colorWithRed: 30/255.0 green: 30/255.0 blue: 30/255.0 alpha: 1.00]];
        }
        cell.userInteractionEnabled = NO;
        return cell;
    }
    
    if([setting.type isEqualToString:@"switch"]){
        
        ShadowSwitch *switchview = [[ShadowSwitch alloc] initWithFrame:CGRectMake(0,0,0,0)];
        switchview.on = [[ShadowData sharedInstance].settings[setting.key] isEqualToString: @"true"];
        switchview.setting = setting.key;
        
        if([ShadowData enabled:@"darkmode"])
            switchview.onTintColor = [UIColor colorWithRed: 255/255.0 green: 252/255.0 blue: 0/255.0 alpha: 1.00];
        [switchview addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        switchview.tag = originalIndex;
        /*if([[ShadowData sharedInstance].server[setting.key] isEqualToString:@"Disable"]){
            switchview.enabled = NO;
            switchview.on = NO;
            [[ShadowData sharedInstance] disable:setting.key];
        }*/
        cell.accessoryView = switchview;
        
        
    }else if([setting.type isEqualToString:@"button"]){
        UIButton * resetButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [resetButton addTarget:objc_getClass("ShadowHelper") action:NSSelectorFromString(setting.key) forControlEvents:UIControlEventTouchUpInside];
        [resetButton setTitle:[ShadowData sharedInstance].settings[setting.key] forState:UIControlStateNormal];
        if([ShadowData enabled:@"darkmode"])
            resetButton.tintColor = [UIColor colorWithRed: 255/255.0 green: 252/255.0 blue: 0/255.0 alpha: 1.00];
        cell.accessoryView = resetButton;
        [resetButton sizeToFit];
    }else if([setting.type isEqualToString:@"color"]){
      NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"deleted_color"];
      UIColor *color = (colorData) ? [NSKeyedUnarchiver unarchiveObjectWithData:colorData] : [UIColor blackColor];
      NSInteger type = [[NSUserDefaults standardUserDefaults] integerForKey:@"deleted_type"];
      SCColorPickerView *picker = [[objc_getClass("SCColorPickerView") alloc]initWithColorPickerVersion:1 paletteType:type orientation:1];
      picker.delegate = self;
      picker.frame = CGRectMake(0,0,185,10);
      cell.accessoryView = picker;
      [picker moveDropletToColor:color];

    }else if([setting.type isEqualToString:@"text"]){
        
        
        ShadowField *textField = [ShadowField new];
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.font = [UIFont fontWithName:@"AvenirNext-Medium" size:13.5];
        textField.text = [ShadowData sharedInstance].settings[setting.key];
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.keyboardType = UIKeyboardTypeDefault;
        textField.returnKeyType = UIReturnKeyDone;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.returnKeyType = UIReturnKeyDone;
        textField.delegate = self;
        textField.tag = originalIndex;
        textField.setting = setting.key;
        
        /// IMPORTANT STUFF FOR IOS 12 / DARK MODE TODO
        
        if([ShadowData enabled:@"darkmode"]){
            textField.layer.cornerRadius=8.0f;
            textField.layer.masksToBounds = YES;
            textField.layer.borderColor = [[UIColor colorWithRed: 255/255.0 green: 252/255.0 blue: 0/255.0 alpha: 1.00] CGColor];
            textField.layer.borderWidth = 1.0f;
            textField.textColor = [UIColor whiteColor];
            textField.backgroundColor = [UIColor clearColor];
        }
        /*if([[ShadowData sharedInstance].server[setting.key] isEqualToString:@"Disable"]){
            textField.enabled = FALSE;
            textField.text = @"";
            textField.placeholder = @"Disabled";
            [[ShadowData sharedInstance] disable:setting.key];
            
        }*/
        cell.accessoryView = textField;
        [textField sizeToFit];
        [textField setFrame:CGRectMake(textField.frame.origin.x,textField.frame.origin.y,cell.frame.size.width / 2,textField.frame.size.height)];
    }
    cell.textLabel.text = setting.title;
    cell.detailTextLabel.text = setting.text;
    cell.detailTextLabel.numberOfLines = 0;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(BOOL)textFieldShouldEndEditing:(ShadowField *)textField{
    [ShadowData sharedInstance].settings[textField.setting] = textField.text;
    [[ShadowData sharedInstance] save];
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section){
        UILabel *title = [UILabel new];
        title.text = [[[ShadowData sharedInstance] orderedSections][section] uppercaseString];
        title.font = [UIFont fontWithName:@"AvenirNext-Bold" size:13];
        title.textAlignment = NSTextAlignmentCenter;
        if([ShadowData enabled:@"darkmode"]){
            title.backgroundColor = [UIColor colorWithRed: 30/255.0 green: 30/255.0 blue: 30/255.0 alpha: 1.00];
            //title.textColor = [UIColor colorWithRed: 255/255.0 green: 252/255.0 blue: 0/255.0 alpha: 1.00];
            title.textColor = [UIColor whiteColor];
        }else{
            title.backgroundColor = [UIColor whiteColor];
        }
        return title;
    }else{
        return nil;
    }
}

-(void)switchChanged:(ShadowSwitch*)sender {
    [ShadowData sharedInstance].settings[sender.setting] = sender.on ? @"true" : @"false";
    [[ShadowData sharedInstance] save];
    if([ShadowData enabled:@"showbanners"]){
        if([sender.setting isEqualToString:@"iotabrand"]){
            [ShadowHelper banner:@"Reload the settings page! ☺️" color:@"#00FF00"];
        }

        if([sender.setting isEqualToString:@"darkmode"] || [sender.setting isEqualToString:@"upload"] || [sender.setting isEqualToString:@"hidenewchat"] || [sender.setting isEqualToString:@"highlights"] || [sender.setting isEqualToString:@"hideshadow"]){
            [ShadowHelper popup: @"Restart Needed" text: @"A restart is needed to apply these changes.\n\nWould you like to do that now?" yes: @"Restart" no: @"No" action:^(BOOL restart){
                if(restart){
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
                        exit(0);
                    });
                } 
            }];
        }

        if([sender.setting isEqualToString:@"pulltorefresh"]){
            if(sender.on){
                [ShadowHelper dialogWithTitle:@"Notice" text:@"This feature uses the selected them (use the \'iota Theme\' setting to select a theme) to change the ghost images to the selected theme."];
            }
        }

        if([sender.setting isEqualToString:@"loadbanner"]){
            [ShadowHelper banner:@"Changes will take effect after a restart." color:@"#00FF00"];
        }

        if([sender.setting  isEqualToString:@"showstreaktimer"]){
            if(sender.on){
                [ShadowHelper dialogWithTitle:@"Notice" text:@"This will show you the remaining time of each of your current streaks.\n\nWhen you look at the time, it will be the number to the right of the emoji on your streak. The number on the left is your streak count. See the following for an example:\n\n24🔥16\n\nThe 16 represents 16 hours left in the streak."];
            }
        }

        if([sender.setting isEqualToString:@"teleport"]){
            if(sender.on){
                if(![ShadowData enabled:@"location"]){
                    [ShadowHelper banner:@"Please enable \'Spoof Location\' first!" color:@"00FF00"];
                    [ShadowData sharedInstance].settings[sender.setting] = @"false";
                    [[ShadowData sharedInstance] save];
                    sender.on = NO;
                }
            }
        }

        if([sender.setting isEqualToString:@"ransubtitle"]){
            if(sender.on){
                [ShadowHelper dialogWithTitle:@"Notice" text:@"This is just a meme feature that involves a list of company brands you see sponsor a bunch of YouTuber's videos.\n\nI am in no means affiliated or sponsored by any of these companies. I am just having fun."];
            }
        }

        if([sender.setting isEqualToString:@"ransubtitle"]){
            if([ShadowData enabled:@"subtitle"]){
                [ShadowHelper banner:@"Please disable \'Hide Subtitle\' first!" color:@"00FF00"];
                [ShadowData sharedInstance].settings[sender.setting] = @"false";
                [[ShadowData sharedInstance] save];
                sender.on = NO;
            }
        }
    }
}
-(void)colorPickerViewWillShrinkSize:(id)arg1{}
-(void)colorPickerViewWillExpandSize:(id)arg1{}

-(void)colorPickerView:(id)picker didChangeColor:(UIColor *)color{
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:color];
  [defaults setObject:colorData forKey:@"deleted_color"];
}
-(void)colorPickerView:(id)picker didTogglePaletteToType:(NSInteger)type selectedColor:(UIColor *)color{
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setInteger:type forKey:@"deleted_type"];
  NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:color];
  [defaults setObject:colorData forKey:@"deleted_color"];
}
-(void)backPressed:(UIBarButtonItem*)item{
    [self dismissViewControllerAnimated:true completion:nil];
}
@end

