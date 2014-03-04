#include "substrate.h"
#import "Colendar.h"

#define CLDictWithHex(a) @{@"CalendarIconDateStyle" : [NSString stringWithFormat:@"padding: 6px 2px; color: #%@; font-size: 36px;", a], @"CalendarIconDayStyle" :  [NSString stringWithFormat:@"padding: 0px 0px 0px 0px; color:#%@; font-size: 10px;", a] }

void cl_writeToPathWithColorCase(NSString *path, int colorCase){
	NSDictionary *infoPlist;
	switch(colorCase){
		default:
		case 0:	// baby blue
			infoPlist = CLDictWithHex(@"89cff0");
			break;
		case 1:	// beige
			infoPlist = CLDictWithHex(@"e4e4a1");
			break;
		case 2:	// blue
			infoPlist = CLDictWithHex(@"0000cc");
			break;
		case 3:	// brown
			infoPlist = CLDictWithHex(@"a5492a");
			break;
		case 4:	// charcoal
			infoPlist = CLDictWithHex(@"36454f");
			break;
		case 5:	// cream
			infoPlist = CLDictWithHex(@"fffdd0");
			break;
		case 6:	// gold
			infoPlist = CLDictWithHex(@"ffd700");
			break;
		case 7:	// gray
			infoPlist = CLDictWithHex(@"808080");
			break;
		case 8:	// green
			infoPlist = CLDictWithHex(@"27d827");
			break;
		case 9:	// light blue
			infoPlist = CLDictWithHex(@"adcae6");
			break;
		case 10:	// light green
			infoPlist = CLDictWithHex(@"98db70");
			break;
		case 11:	// maroon
			infoPlist = CLDictWithHex(@"800000");
			break;
		case 12:	// navy
			infoPlist = CLDictWithHex(@"000080");
			break;
		case 13:	// neon blue
			infoPlist = CLDictWithHex(@"4d4dff");
			break;
		case 14:	// neon green
			infoPlist = CLDictWithHex(@"6fff00");
			break;
		case 15:	// neon orange
			infoPlist = CLDictWithHex(@"ff4105");
			break;
		case 16:	// neon pink
			infoPlist = CLDictWithHex(@"ff1cae");
			break;
		case 17:	// neon purple
			infoPlist = CLDictWithHex(@"993cf3");
			break;
		case 18:	// neon red
			infoPlist = CLDictWithHex(@"fe0001");
			break;
		case 19:	// neon yellow
			infoPlist = CLDictWithHex(@"ffff00");
			break;
		case 20:	// orange
			infoPlist = CLDictWithHex(@"ffa500");
			break;
		case 21:	// pink
			infoPlist = CLDictWithHex(@"ff748c");
			break;
		case 22:	// purple
			infoPlist = CLDictWithHex(@"800080");
			break;
		case 23:	// red
			infoPlist = CLDictWithHex(@"ff0000");
			break;
		case 24:	// silver
			infoPlist = CLDictWithHex(@"c0c0c0");
			break;
		case 25:	// turquoise
			infoPlist = CLDictWithHex(@"7098DB");
			break;
		case 26:	// white
			infoPlist = CLDictWithHex(@"ffffff");
			break;
		case 27:	// yellow
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

		[themePaths release];
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
