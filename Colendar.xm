#import "substrate.h"
#import "Colendar.h"

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
	cl_textColor = nil;

	return iconImage;
}

%end

/********************* Calendar String Writing Hooks *********************/

%hook NSString

/*  -[<NSString: 0x1708311a0> drawInRect:{{0, 0}, {15.296, 19.088}} withAttributes:{
	    NSColor = "UIDeviceWhiteColorSpace 1 1";
	    NSFont = "<UICTFont: 0x1546928b0> font-family: \".HelveticaNeueInterface-M3\"; font-weight: normal; font-style: normal; font-size: 16.00pt";
	    NSParagraphStyle = "Alignment 4, LineSpacing 0, ParagraphSpacing 0, ParagraphSpacingBefore 0, HeadIndent 0, TailIndent 0, FirstLineHeadIndent 0, LineHeight 0/0, LineHeightMultiple 0, LineBreakMode 5, Tabs (\n    28L,\n    56L,\n    84L,\n    112L,\n    140L,\n    168L,\n    196L,\n    224L,\n    252L,\n    280L,\n    308L,\n    336L\n), DefaultTabInterval 0, Blocks (null), Lists (null), BaseWritingDirection -1, HyphenationFactor 0, TighteningFactor 0, HeaderLevel 0";
	}]
Mar 14 12:42:24 Julian-Weisss-iPhone SpringBoard[7009]: ----- 14

 -[<NSString: 0x170c49b70> drawInRect:{{0, 0}, {130.986, 21.474}} withAttributes:{
	    NSColor = "UIDeviceWhiteColorSpace 1 1";
	    NSFont = "<UICTFont: 0x1546c1be0> font-family: \".HelveticaNeueInterface-M3\"; font-weight: normal; font-style: normal; font-size: 18.00pt";
	}]

*/

- (void)drawInRect:(CGRect)arg1 withAttributes:(id)arg2 {
	%log;

	if (cl_textColor) {
		NSMutableDictionary *attributes = [[NSMutableDictionary alloc] initWithDictionary:arg2];
		[attributes setObject:cl_textColor forKey:[%c(NSColor) class]];
		NSLog(@"[Colendar] In -drawInRect hook, replacing %@ with %@...", arg2, attributes);
		%orig(arg1, attributes);
	}

	else {
		NSLog(@"[Colendar] In -drawAtPoint hook, did not detect stored color...");
		%orig(arg1, arg2);
	}
 }


/*

- (CGSize)_drawInRect:(CGRect)arg1 withFont:(id)arg2 lineBreakMode:(int)arg3 alignment:(int)arg4 lineSpacing:(int)arg5 includeEmoji:(BOOL)arg6 truncationRect:(CGRect*)arg7 {
	%log;
	NSLog(@"----- %@", self);
	return %orig();
}

- (void)drawAtPoint:(CGPoint)arg1 forWidth:(float)arg2 withFont:(id)arg3 fontColor:(id)arg4 shadowColor:(id)arg5 {
	%log;
	NSLog(@"----- %@", self);
	%orig();
}

- (CGSize)drawAtPoint:(CGPoint)arg1 forWidth:(float)arg2 withFont:(id)arg3 fontSize:(float)arg4 lineBreakMode:(int)arg5 baselineAdjustment:(int)arg6 includeEmoji:(BOOL)arg7 {
	%log;
	NSLog(@"----- %@", self);
	return %orig();
}

- (CGSize)drawAtPoint:(CGPoint)arg1 forWidth:(float)arg2 withFont:(id)arg3 fontSize:(float)arg4 lineBreakMode:(int)arg5 baselineAdjustment:(int)arg6 {
	%log;
	NSLog(@"----- %@", self);
	return %orig();
}

- (CGSize)drawAtPoint:(CGPoint)arg1 forWidth:(float)arg2 withFont:(id)arg3 lineBreakMode:(int)arg4 letterSpacing:(float)arg5 includeEmoji:(BOOL)arg6 {
	%log;
	NSLog(@"----- %@", self);
	return %orig();
}

- (CGSize)drawAtPoint:(CGPoint)arg1 forWidth:(float)arg2 withFont:(id)arg3 lineBreakMode:(int)arg4 letterSpacing:(float)arg5 {
	%log;
	NSLog(@"----- %@", self);
	return %orig();
}

- (CGSize)drawAtPoint:(CGPoint)arg1 forWidth:(float)arg2 withFont:(id)arg3 lineBreakMode:(int)arg4 {
	%log;
	NSLog(@"----- %@", self);
	return %orig();
}

- (CGSize)drawAtPoint:(CGPoint)arg1 forWidth:(float)arg2 withFont:(id)arg3 minFontSize:(float)arg4 actualFontSize:(float*)arg5 lineBreakMode:(int)arg6 baselineAdjustment:(int)arg7 includeEmoji:(BOOL)arg8 {
	%log;
	NSLog(@"----- %@", self);
	return %orig();
}

- (CGSize)drawAtPoint:(CGPoint)arg1 forWidth:(float)arg2 withFont:(id)arg3 minFontSize:(float)arg4 actualFontSize:(float*)arg5 lineBreakMode:(int)arg6 baselineAdjustment:(int)arg7 {
	%log;
	NSLog(@"----- %@", self);
	return %orig();
}

- (void)drawAtPoint:(CGPoint)arg1 withAttributes:(id)arg2 {
	%log;
	NSLog(@"----- %@", self);
	return %orig();
}

- (CGSize)drawAtPoint:(CGPoint)arg1 withFont:(id)arg2 {
	%log;
	NSLog(@"----- %@", self);
	return %orig();
}

- (void)drawInRect:(CGRect)arg1 withAttributes:(id)arg2 {
	%log;
	NSLog(@"----- %@", self);
	%orig();
}

- (CGSize)drawInRect:(CGRect)arg1 withFont:(id)arg2 lineBreakMode:(int)arg3 alignment:(int)arg4 lineSpacing:(int)arg5 includeEmoji:(BOOL)arg6 {
	%log;
	NSLog(@"----- %@", self);
	return %orig();
}

- (CGSize)drawInRect:(CGRect)arg1 withFont:(id)arg2 lineBreakMode:(int)arg3 alignment:(int)arg4 lineSpacing:(int)arg5 {
	%log;
	NSLog(@"----- %@", self);
	return %orig();
}

- (CGSize)drawInRect:(CGRect)arg1 withFont:(id)arg2 lineBreakMode:(int)arg3 alignment:(int)arg4 {
	%log;
	NSLog(@"----- %@", self);
	return %orig();
}

- (CGSize)drawInRect:(CGRect)arg1 withFont:(id)arg2 lineBreakMode:(int)arg3 {
	%log;
	NSLog(@"----- %@", self);
	return %orig();
}

- (CGSize)drawInRect:(CGRect)arg1 withFont:(id)arg2 {
	%log;
	NSLog(@"----- %@", self);
	return %orig();
}

- (void)drawWithDegreeAtPoint:(CGPoint)arg1 font:(id)arg2 degreeFont:(id)arg3 degreeOffset:(CGSize)arg4 {
	%log;
	NSLog(@"----- %@", self);
	%orig();
}

- (void)drawWithRect:(CGRect)arg1 options:(int)arg2 attributes:(id)arg3 context:(id)arg4 {
	%log;
	NSLog(@"----- %@", self);
	%orig();
}

/*
//- (void)drawAtPoint:(CGPoint)arg1 forWidth:(float)arg2 withFont:(id)arg3 fontColor:(id)arg4 shadowColor:(id)arg5 {

//- (CGSize)drawAtPoint:(CGPoint)point forWidth:(float)width withFont:(id)font lineBreakMode:(int)mode letterSpacing:(float)spacing includeEmoji:(BOOL)emoji {

- (CGSize)_drawInRect:(CGRect)arg1 withFont:(id)arg2 lineBreakMode:(int)arg3 alignment:(int)arg4 lineSpacing:(int)arg5 includeEmoji:(BOOL)arg6 truncationRect:(CGRect)arg7 {
	if (cl_textColor) {
		NSLog(@"[Colendar] In -drawAtPoint hook, detected %@ stored, using it to draw...", cl_textColor);
		[self drawAtPoint:CGPointMake(arg1.origin.x, arg1.origin.y) forWidth:arg1.size.width withFont:arg2 fontColor:cl_textColor shadowColor:nil];
		return CGSizeZero;
	}

	else {
		NSLog(@"[Colendar] In -drawAtPoint hook, did not detect stored color...");
		return %orig();
	}
}*/

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
