#import "substrate.h"
#import "Colendar.h"

#define BUILDID @"been"

/********************* Global Text Loading Functions *********************/

static UIColor *cl_textColor;

static UIColor * cl_loadTextColor() {
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
	NSLog(@"[Colendar] In -generateIconImage, grabbed color %@ from settings...", cl_loadTextColor());
	UIImage *iconImage = %orig(type);
	NSLog(@"[Colendar] Should've altered %@ to include %@ making it %@, now relinquishing...", %orig, cl_textColor, iconImage);
	cl_textColor = nil;

	return iconImage;
}

%end

/********************* Calendar String Writing Hooks *********************/

/*%hook NSString

- (CGSize)drawAtPoint:(CGPoint)point forWidth:(CGFloat)width withFont:(UIFont *)font lineBreakMode:(UILineBreakMode)mode letterSpacing:(CGFloat)spacing includeEmoji:(BOOL)emoji {
	NSLog(@"[Colendar-%@] First method log for %@:", BUILDID, self);
	%log;
	return %orig();
}

- (CGSize)_drawInRect:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(UILineBreakMode)mode alignment:(UITextAlignment)alignment lineSpacing:(float)spacing includeEmoji:(BOOL)emoji truncationRect:(CGRect)truncation {
	NSLog(@"[Colendar-%@] Second method log for %@:", BUILDID, self);
	%log;
	return %orig();
}

- (void)drawInRect:(CGRect)rect withAttributes:(NSDictionary *)attributes {
	NSLog(@"[Colendar-%@] Third method log for %@:", BUILDID, self);
	%log;
	%orig();
}

-(CGRect)boundingRectWithSize:(CGSize)size options:(int /*NSInteger)options attributes:(NSDictionary *)attributes context:(id)context {
	NSLog(@"[Colendar-%@] Fourth method log for %@:", BUILDID, self);
	%log;
	return %orig();
}

- (CGSize)sizeWithFont:(UIFont *)font forWidth:(CGFloat)with lineBreakMode:(UILineBreakMode)mode letterSpacing:(CGFloat)spacing {
	NSLog(@"[Colendar-%@] Fifth method log for %@:", BUILDID, self);
	%log;
	return %orig();
}

- (CGSize)sizeWithFont:(UIFont *)font {
	NSLog(@"[Colendar-%@] Sixth method log for %@:", BUILDID, self);
	%log;
	return %orig();
}


- (void)drawInRect:(CGRect)arg1 withAttributes:(id)arg2 {
	if (cl_textColor) {
		NSMutableDictionary *attributes = [[NSMutableDictionary alloc] initWithDictionary:arg2];
		[attributes setObject:cl_loadTextColor() forKey:@"NSColor"];
		NSLog(@"[Colendar] In -drawInRect hook, replacing %@ with %@ for %@...", arg2, attributes, self);
		%orig(arg1, attributes);
	}

	else {
		NSLog(@"[Colendar] In -drawInRect hook, did not detect stored color for %@...", self);
		%orig(arg1, arg2);
	}
}


%end*/

%hook SBCalendarIconContentsView

-(id)initWithFrame:(CGRect)frame {
	%log;
	NSLog(@"asdfkjahsdlfkjahsdlkfjh");
	return %orig();
}

-(void)drawRect:(CGRect)rect {
	%log;
	NSLog(@"asdfkjahsdlfkjahsdlkfjh");
	%orig();
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
