#include "substrate.h"
#import "Colendar.h"

#define CLDictWithHex(a) @{@"CalendarIconDateStyle" : [NSString stringWithFormat:@"padding: 6px 2px; color: #%@; font-size: 36px;", a], @"CalendarIconDayStyle" :  [NSString stringWithFormat:@"padding: 0px 0px 0px 0px; color:#%@; font-size: 10px;", a] }

UIColor *cl_colorWithColorCase(int colorCase) {
	switch(colorCase){
		default:
		case 0:	// baby blue
			return UIColorFromRGB(0x89cff0);
		case 1:	// beige
			return UIColorFromRGB(0xe4e4a1);
		case 2:	// blue
			return UIColorFromRGB(0x0000cc);
		case 3:	// brown
			return UIColorFromRGB(0xa5492a);
		case 4:	// charcoal
			return UIColorFromRGB(0x36454f);
		case 5:	// cream
			return UIColorFromRGB(0xfffdd0);
		case 6:	// gold
			return UIColorFromRGB(0xffd700);
		case 7:	// gray
			return UIColorFromRGB(0x808080);
		case 8:	// green
			return UIColorFromRGB(0x27d827);
		case 9:	// light blue
			return UIColorFromRGB(0xadcae6);
		case 10:	// light green
			return UIColorFromRGB(0x98db70);
		case 11:	// maroon
			return UIColorFromRGB(0x800000);
		case 12:	// navy
			return UIColorFromRGB(0x000080);
		case 13:	// neon blue
			return UIColorFromRGB(0x4d4dff);
		case 14:	// neon green
			return UIColorFromRGB(0x6fff00);
		case 15:	// neon orange
			return UIColorFromRGB(0xff4105);
		case 16:	// neon pink
			return UIColorFromRGB(0xff1cae);
		case 17:	// neon purple
			return UIColorFromRGB(0x993cf3);
		case 18:	// neon red
			return UIColorFromRGB(0xfe0001);
		case 19:	// neon yellow
			return UIColorFromRGB(0xffff00);
		case 20:	// orange
			return UIColorFromRGB(0xffa500);
		case 21:	// pink
			return UIColorFromRGB(0xff748c);
		case 22:	// purple
			return UIColorFromRGB(0x800080);
		case 23:	// red
			return UIColorFromRGB(0xff0000);
		case 24:	// silver
			return UIColorFromRGB(0xc0c0c0);
		case 25:	// turquoise
			return UIColorFromRGB(0x7098DB);
		case 26:	// white
			return UIColorFromRGB(0xffffff);
		case 27:	// yellow
			return UIColorFromRGB(0xffff3b);
	}
}

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

UIColor *cl_colorFromPrefs() {
	NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/com.insanj.colendar.plist"]];
	return cl_colorWithColorCase([[settings objectForKey:@"globalColor"] intValue]);
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
				// must be root
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

%hook SBCalendarApplicationIcon

- (void)_drawIconIntoCurrentContextWithImageSize:(CGSize)imageSize iconBase:(UIImage *)base {
	%log;
	%orig();
}

// [UIColor colorWithRed:255/255.0f green:59.000115/255.0f blue:47.999925/255.0f alpha:1.0f];
- (UIColor *)colorForDayOfWeek {
	NSLog(@"[colorfordayofweek-----] %@", %orig);
	return %orig();
//	return cl_colorFromPrefs();
}

- (UIImage *)generateIconImage:(int)image{
	%log;
	return %orig();
}

- (UIFont *)numberFont{
	return %orig();
}

%end

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
