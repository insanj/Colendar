#import "substrate.h"
#import "Colendar.h"

/********************* Global Text Loading Functions *********************/

static UIColor *cl_textColor;

static UIColor * cl_loadTextColor(BOOL overwrite) {
	if (cl_textColor && !overwrite)
		return cl_textColor;

	NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/com.insanj.colendar.plist"]];
	switch ([[settings objectForKey:@"globalColor"] intValue]) {
		default:
		case 0:	// baby blue
			cl_textColor = UIColorFromRGB(0x89cff0);
			break;
		case 1:	// beige
			cl_textColor = UIColorFromRGB(0xe4e4a1);
			break;
		case 2:	// blue
			cl_textColor = UIColorFromRGB(0x0000cc);
			break;
		case 3:	// brown
			cl_textColor = UIColorFromRGB(0xa5492a);
			break;
		case 4:	// charcoal
			cl_textColor = UIColorFromRGB(0x36454f);
			break;
		case 5:	// cream
			cl_textColor = UIColorFromRGB(0xfffdd0);
			break;
		case 6:	// gold
			cl_textColor = UIColorFromRGB(0xffd700);
			break;
		case 7:	// gray
			cl_textColor = UIColorFromRGB(0x808080);
			break;
		case 8:	// green
			cl_textColor = UIColorFromRGB(0x27d827);
			break;
		case 9:	// light blue
			cl_textColor = UIColorFromRGB(0xadcae6);
			break;
		case 10:	// light green
			cl_textColor = UIColorFromRGB(0x98db70);
			break;
		case 11:	// maroon
			cl_textColor = UIColorFromRGB(0x800000);
			break;
		case 12:	// navy
			cl_textColor = UIColorFromRGB(0x000080);
			break;
		case 13:	// neon blue
			cl_textColor = UIColorFromRGB(0x4d4dff);
			break;
		case 14:	// neon green
			cl_textColor = UIColorFromRGB(0x6fff00);
			break;
		case 15:	// neon orange
			cl_textColor = UIColorFromRGB(0xff4105);
			break;
		case 16:	// neon pink
			cl_textColor = UIColorFromRGB(0xff1cae);
			break;
		case 17:	// neon purple
			cl_textColor = UIColorFromRGB(0x993cf3);
			break;
		case 18:	// neon red
			cl_textColor = UIColorFromRGB(0xfe0001);
			break;
		case 19:	// neon yellow
			cl_textColor = UIColorFromRGB(0xffff00);
			break;
		case 20:	// orange
			cl_textColor = UIColorFromRGB(0xffa500);
			break;
		case 21:	// pink
			cl_textColor = UIColorFromRGB(0xff748c);
			break;
		case 22:	// purple
			cl_textColor = UIColorFromRGB(0x800080);
			break;
		case 23:	// red
			cl_textColor = UIColorFromRGB(0xff0000);
			break;
		case 24:	// silver
			cl_textColor = UIColorFromRGB(0xc0c0c0);
			break;
		case 25:	// turquoise
			cl_textColor = UIColorFromRGB(0x7098DB);
			break;
		case 26:	// white
			cl_textColor = UIColorFromRGB(0xffffff);
			break;
		case 27:	// yellow
			cl_textColor = UIColorFromRGB(0xffff3b);
			break;
	}

	return cl_textColor;
}

/******************** Calendar Appplication Generation ********************/

%hook SBCalendarApplicationIcon

- (UIImage *)generateIconImage:(int)type {
	cl_loadTextColor(YES);
	UIImage *iconImage = %orig(type);
	cl_textColor = nil;
	return iconImage;
}

%end

/********************* Calendar String Writing Hooks *********************/

%hook NSString

//- (CGSize)drawAtPoint:(CGPoint)point forWidth:(CGFloat)width withFont:(UIFont *)font lineBreakMode:(UILinkBreakMode)mode letterSpacing:(CGFloat)spacing includeEmoji:(BOOL)emoji {
- (void)drawAtPoint:(CGPoint)arg1 forWidth:(float)arg2 withFont:(id)arg3 fontColor:(id)arg4 shadowColor:(id)arg5 {
	UIColor *color = cl_textColor ? cl_textColor : arg4;
	NSLog(@"[Colendar] In -drawAtPoint hook, using color %@ to write...", color);
	%orig(arg1, arg2, arg3, color, arg5);
}

%end

/********************** AlertView Respring Handlers **********************/

@interface CLAlertViewDelegate : NSObject <UIAlertViewDelegate>
@end

@implementation CLAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (buttonIndex != [alertView cancelButtonIndex]) {
NSLog(@"[Colendar] Received notification to respring, doing so now...");
[(SpringBoard *)[UIApplication sharedApplication] _relaunchSpringBoardNow];
	}
}

@end

/********************** Global Const, Notif Listener **********************/

%ctor{
	[[NSDistributedNotificationCenter defaultCenter] addObserverForName:@"CLChange" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification){
		NSLog(@"[Colendar] Prompting user to save and respring device (or not)...");
		[[[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Applying color settings will respring your device, are you sure you want to do so now?" delegate:[[CLAlertViewDelegate alloc] init] cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil] autorelease] show];
	}];
}
