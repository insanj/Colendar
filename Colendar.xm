#import "substrate.h"
#import "Colendar.h"

/********************* Global Text Loading Functions *********************/

static CGSize cl_iconSize;

static UIColor * cl_loadTextColor() {
	NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/com.insanj.colendar.plist"]];
	switch ([[settings objectForKey:@"globalColor"] intValue]) {
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

/******************** Calendar Appplication Generation ********************/

%hook SBCalendarApplicationIcon

- (UIImage *)generateIconImage:(int)type {
	cl_iconSize = [%orig(type) size];
	NSLog(@"[Colendar] In -generateIconImage, assigned size to original's %@.", NSStringFromCGSize(cl_iconSize));
	UIImage *iconImage = %orig(type);
	cl_iconSize = CGSizeZero;

	return iconImage;
}

%end

/********************* Calendar String Writing Hooks *********************/

%hook NSString

- (CGSize)_legacy_drawAtPoint:(CGPoint)arg1 withFont:(id)arg2 {
	if (!CGSizeEqualToSize(cl_iconSize, CGSizeZero)) {
		if ([self intValue] <= 0) {
			NSLog(@"[Colendar] Drawing day (%@) to point %@.", self, NSStringFromCGPoint(arg1));
			[self drawAtPoint:arg1 withAttributes:@{ @"NSFont" : arg2, @"NSColor" : cl_loadTextColor()}];
		}

		else {
			CGFloat width = cl_iconSize.width;
			CGFloat leeway = 10.0;
			CGSize dateSize = [self sizeWithFont:arg2 forWidth:(width+leeway) lineBreakMode:0];

			CGFloat base = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 89 : 70);
			[self drawAtPoint:CGPointMake((width + 1 - dateSize.width) / 2, (base - dateSize.height) / 2) withAttributes:@{ @"NSFont" : arg2, @"NSColor" : cl_loadTextColor()}];

			/*
			CGFloat origin = (cl_iconSize.width - [self sizeWithFont:arg2].width) / 2.0;
			CGPoint centered = CGPointMake(origin, arg1.y);

			NSLog(@"[Colendar] Drawing date (%@) to point %@.", self, NSStringFromCGPoint(centered));
			*/
		}

		return CGSizeZero;
	}

	else {
		return %orig(arg1, arg2);
	}
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
