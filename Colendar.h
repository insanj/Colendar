#include <Preferences/PSListItemsController.h>
#include <Preferences/PSListController.h>
#include <Preferences/PSTableCell.h>
#import <UIKit/UIActivityViewController.h>
#import <Twitter/Twitter.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface NSDistributedNotificationCenter : NSNotificationCenter
@end

@interface UIImage (Private)
+ (UIImage *)imageNamed:(NSString *)named inBundle:(NSBundle *)bundle;
@end

@interface UIApplication (Private)
- (BOOL)launchApplicationWithIdentifier:(id)arg1 suspended:(BOOL)arg2;
@end

@interface SBApplication
- (void)activate;
- (id)pathForSmallIcon;
- (id)pathForIcon;
@end

@interface SBApplicationController
+ (id)sharedInstance;
- (id)applicationWithDisplayIdentifier:(id)id;
@end

@interface SpringBoard : UIApplication
- (void)applicationOpenURL:(NSURL *)url publicURLsOnly:(BOOL)only;
- (BOOL)launchApplicationWithIdentifier:(id)identifier suspended:(BOOL)suspended;
- (void)_applicationOpenURL:(id)url withApplication:(id)application sender:(id)sender publicURLsOnly:(BOOL)only animating:(BOOL)animating additionalActivationFlags:(id)flags activationHandler:(id)handler;
- (void)_relaunchSpringBoardNow;
@end

@interface PreferencesAppController : UIApplication
- (void)applicationOpenURL:(id)url;
@end

@interface SBUIController
- (void)activateApplicationAnimated:(id)app;
@end

@interface SBApplicationIcon
- (id)initWithApplication:(id)application;
- (id)generateIconImage:(int)image;
@end

@interface SBIcon
- (id)smallIcon;
- (id)getIconImage:(int)arg1;
- (id)icon;
@end

@interface SBIconViewMap
+ (id)homescreenMap;
- (id)iconModel;
@end

@interface SBIconModel
- (id)iconForDisplayIdentifier:(NSString *)id;
@end

@interface NSWorkspace
+ (id)sharedWorkspace;
- (id)iconForFile:(id)arg1;
- (id)absolutePathForAppBundleWithIdentifier:(NSString *)arg1;
@end

/*typedef enum PSCellType {
	PSGroupCell,
	PSLinkCell,
	PSLinkListCell,
	PSListItemCell,
	PSTitleValueCell,
	PSSliderCell,
	PSSwitchCell,
	PSStaticTextCell,
	PSEditTextCell,
	PSSegmentCell,
	PSGiantIconCell,
	PSGiantCell,
	PSSecureEditTextCell,
	PSButtonCell,
	PSEditTextViewCell,
} PSCellType;*/

@interface SBCalendarApplicationIcon //: SBApplicationIcon
+ (id)countriesRequiringBlackDayOfWeek;
- (id)initWithApplication:(id)application;
- (void)_drawIconIntoCurrentContextWithImageSize:(CGSize)imageSize iconBase:(id)base;
- (BOOL)canGenerateImageInBackgroundForFormat:(int)format;
- (id)colorForDayOfWeek;
- (void)dealloc;
- (id)generateIconImage:(int)image;
- (id)getUnmaskedIconImage:(int)image;
- (BOOL)isBlackDayOfWeekRequiredForLocale:(id)locale;
- (void)localeChanged;
- (id)numberFont;
@end 
