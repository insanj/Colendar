#include "substrate.h"
#import "Colendar.h"

#define CLDictWithHex(a) @{@"CalendarIconDateStyle" : [NSString stringWithFormat:@"padding: 6px 2px; color: #%@; font-size: 36px;", a], @"CalendarIconDayStyle" :  [NSString stringWithFormat:@"padding: 0px 0px 0px 0px; color:#%@; font-size: 10px;", a] }

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

		NSArray *stashFolders = [fileManager contentsOfDirectoryAtPath:@"/private/var/stash" error:&fileError];
		NSMutableArray *themePaths = [[NSMutableArray alloc] init];

		for (NSString *name in stashFolders) {
			if ([name rangeOfString:@"Themes."].location != NSNotFound) {
				[themePaths addObject:[@"/private/var/stash/" stringByAppendingString:name]];
			}
		}

		for (int i = 0; i < themePaths.count; i++) {
			NSString *fullPath = [themePaths[i] stringByAppendingString:@"Colendar.theme"];
			if ([fileManager fileExistsAtPath:fullPath] || i == themePaths.count-1) {
				[fileManager createDirectoryAtPath:fullPath withIntermediateDirectories:YES attributes:nil error:&fileError];
				NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/com.insanj.colendar.plist"]];
				cl_writeToPathWithColorCase([fullPath stringByAppendingString:@"/Info.plist"], [[settings objectForKey:@"globalColor"] intValue]);
			}
		}

		[(SpringBoard *)[UIApplication sharedApplication] _relaunchSpringBoardNow];
	}
}

@end

%ctor{
	[[NSDistributedNotificationCenter defaultCenter] addObserverForName:@"CLWinterboard" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification){
		NSLog(@"[Colendar] Launching Winterboard...");
		SBApplication *winterboard = [[%c(SBApplicationController) sharedInstance] applicationWithDisplayIdentifier:@"com.saurik.WinterBoard"];
        [(SBUIController*)[%c(SBUIController) sharedInstance] activateApplicationAnimated:winterboard];
	}];

	[[NSDistributedNotificationCenter defaultCenter] addObserverForName:@"CLChange" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification){
		NSLog(@"[Colendar] Prompting user to save and respring device (or not)...");
		[[[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Applying color settings will respring your device, are you sure you want to do so now?" delegate:[[CLAlertViewDelegate alloc] init] cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil] autorelease] show];
	}];
}
