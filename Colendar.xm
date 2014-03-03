#include "substrate.h"

#define CLDictWithHex(a) @{@"CalendarIconDateStyle" : [NSString stringWithFormat:@"padding: 6px 2px; color: #%@; font-size: 36px;", a], @"CalendarIconDayStyle" :  [NSString stringWithFormat:@"padding: 0px 0px 0px 0px; color:#%@; font-size: 10px;", a] }

@interface NSDistributedNotificationCenter : NSNotificationCenter
@end

@interface UIApplication (Private)
- (BOOL)launchApplicationWithIdentifier:(id)arg1 suspended:(BOOL)arg2;
@end

@interface SBApplication
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
+ (id)sharedInstace;
- (void)activateApplicationAnimated:(id)app;
@end

@interface SBApplicationIcon
- (id)initWithApplication:(id)application;
- (id)generateIconImage:(int)image;
@end

void cl_writeToPathWithColorCase(NSString *path, int colorCase){
	NSDictionary *infoPlist;
	switch(colorCase){
		default:
		case 0:	// blue
			infoPlist = CLDictWithHex(@"0000cc");
			break;
		case 1:	// brown
			infoPlist = CLDictWithHex(@"a5492a");
			break;
		case 2:	// charcoal
			infoPlist = CLDictWithHex(@"36454f");
			break;
		case 3:	// gold
			infoPlist = CLDictWithHex(@"ffd700");
			break;
		case 4:	// gray
			infoPlist = CLDictWithHex(@"808080");
			break;
		case 5:	// green
			infoPlist = CLDictWithHex(@"27d827");
			break;
		case 6:	// orange
			infoPlist = CLDictWithHex(@"ffa500");
			break;
		case 7:	// pink
			infoPlist = CLDictWithHex(@"ff748c");
			break;
		case 8:	// purple
			infoPlist = CLDictWithHex(@"800080");
			break;
		case 9:	// red
			infoPlist = CLDictWithHex(@"ff0000");
			break;
		case 10:	// white
			infoPlist = CLDictWithHex(@"ffffff");
			break;
		case 11:	// yellow
			infoPlist = CLDictWithHex(@"ffff3b");
			break;
	}

	[infoPlist writeToFile:path atomically:YES];
	NSLog(@"[Colendar] Found and wrote to Colendar theme file successfully!");
}

@interface CLAlertViewDelegate : NSObject <UIAlertViewDelegate>
@end

@implementation CLAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (buttonIndex != [alertView cancelButtonIndex]) {
		NSError *fileError;
		NSFileManager *fileManager = [NSFileManager defaultManager];

		NSArray *stashFolders = [fileManager contentsOfDirectoryAtPath:@"/private/var/stash/" error:&fileError];
		int indexOfLastFolder; BOOL foundFolder;

		for (NSString *name in stashFolders) {
			if([name rangeOfString:@"Themes."].location != NSNotFound){
				indexOfLastFolder = [stashFolders indexOfObject:name];
				NSString *fullPath = [NSString stringWithFormat:@"/private/var/stash/%@/%@", name, @"Colendar.theme"];
				if ([fileManager fileExistsAtPath:fullPath]) {
					NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/com.insanj.colendar.plist"]];
					cl_writeToPathWithColorCase([fullPath stringByAppendingString:@"/Info.plist"], [[settings objectForKey:@"globalColor"] intValue]);
					foundFolder = YES;
				}
			}
		}

		if (!foundFolder) {
			NSString *fullPath = [NSString stringWithFormat:@"/private/var/stash/%@/%@", stashFolders[indexOfLastFolder], @"Colendar.theme"];
			[fileManager createDirectoryAtPath:fullPath withIntermediateDirectories:YES attributes:nil error:&fileError];
			NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/com.insanj.colendar.plist"]];
			cl_writeToPathWithColorCase([fullPath stringByAppendingString:@"/Info.plist"], [[settings objectForKey:@"globalColor"] intValue]);
		}

		[(SpringBoard *)[UIApplication sharedApplication] _relaunchSpringBoardNow];
	}
}

@end

%ctor{
	[[NSDistributedNotificationCenter defaultCenter] addObserverForName:@"CLWinterboard" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification){
		NSLog(@"[Colendar] Launching Winterboard...");
		SBApplication *winterboard = [[%c(SBApplicationController) sharedInstance] applicationWithDisplayIdentifier:@"com.saurik.winterboard"];
        [(SBUIController*)[%c(SBUIController) sharedInstance] activateApplicationAnimated:winterboard];
	//	[[UIApplication sharedApplication] launchApplicationWithIdentifier:@"com.saurik.Winterboard" suspended:NO];
	}];

	[[NSDistributedNotificationCenter defaultCenter] addObserverForName:@"CLChange" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification){
		NSLog(@"[Colendar] Prompting user to save and respring device (or not)...");
		[[[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Applying color settings will respring your device, are you sure you want to do so now?" delegate:[[CLAlertViewDelegate alloc] init] cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil] autorelease] show];
	}];
}
