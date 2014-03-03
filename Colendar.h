#include <Preferences/PSListItemsController.h>
#include <Preferences/PSListController.h>
#include <Preferences/PSTableCell.h>
#include <UIKit/UIActivityViewController.h>
#include <Twitter/Twitter.h>
#include <QuartzCore/QuartzCore.h>

@interface NSDistributedNotificationCenter : NSNotificationCenter
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
- (BOOL)launchApplicationWithIdentifier:(id)identifier suspended:(BOOL)suspended;
- (void)_applicationOpenURL:(id)url withApplication:(id)application sender:(id)sender publicURLsOnly:(BOOL)only animating:(BOOL)animating additionalActivationFlags:(id)flags activationHandler:(id)handler;
- (void)_relaunchSpringBoardNow;
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

typedef enum PSCellType {
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
} PSCellType;
