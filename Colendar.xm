#import "substrate.h"
#import "Colendar.h"

/************************ Global Text Loading Functions ***********************/

static CGSize cl_iconSize;

static BOOL cl_isEnabled() {
	NSDictionary *settings =  [NSDictionary dictionaryWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/com.insanj.colendar.plist"]];
	return ![[settings objectForKey:@"disabled"] boolValue];
}

static UIColor * cl_loadColorForCase(int caseNumber) {
	switch (caseNumber) {
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
		case 5:	// clear
			return [UIColor clearColor];
		case 6:	// cream
			return UIColorFromRGB(0xfffdd0);
		case 7:	// gold
			return UIColorFromRGB(0xffd700);
		case 8:	// gray
			return UIColorFromRGB(0x808080);
		case 9:	// green
			return UIColorFromRGB(0x27d827);
		case 10:	// light blue
			return UIColorFromRGB(0xadcae6);
		case 11:	// light green
			return UIColorFromRGB(0x98db70);
		case 12:	// maroon
			return UIColorFromRGB(0x800000);
		case 13:	// navy
			return UIColorFromRGB(0x000080);
		case 14:	// neon blue
			return UIColorFromRGB(0x4d4dff);
		case 15:	// neon green
			return UIColorFromRGB(0x6fff00);
		case 16:	// neon orange
			return UIColorFromRGB(0xff4105);
		case 17:	// neon pink
			return UIColorFromRGB(0xff1cae);
		case 18:	// neon purple
			return UIColorFromRGB(0x993cf3);
		case 19:	// neon red
			return UIColorFromRGB(0xfe0001);
		case 20:	// neon yellow
			return UIColorFromRGB(0xffff00);
		case 21:	// orange
			return UIColorFromRGB(0xffa500);
		case 22:	// pink
			return UIColorFromRGB(0xff748c);
		case 23:	// purple
			return UIColorFromRGB(0x800080);
		case 24:	// red
			return UIColorFromRGB(0xff0000);
		case 25:	// silver
			return UIColorFromRGB(0xc0c0c0);
		case 26:	// turquoise
			return UIColorFromRGB(0x7098DB);
		case 27:	// white
			return UIColorFromRGB(0xffffff);
		case 28:	// yellow
			return UIColorFromRGB(0xffff3b);
	}
}

static UIColor * cl_loadWeekdayColor(NSDictionary *settings) {
	return cl_loadColorForCase([[settings objectForKey:@"weekdayColor"] intValue]);
}

static UIColor * cl_loadWeekOfYearColor(NSDictionary *settings) {
	return cl_loadColorForCase([[settings objectForKey:@"weekofyearColor"] intValue]);
}

static UIColor * cl_loadDateColor(NSDictionary *settings) {
	return cl_loadColorForCase([[settings objectForKey:@"dateColor"] intValue]);
}

/****************** Shared Calendar Appplication Generation *******************/

%group Shared

%hook SBCalendarApplicationIcon

- (id)initWithApplication:(id)application {
	SBCalendarApplicationIcon *icon = %orig();

	NSLog(@"[Colendar] Adding observer for redrawing calendar icon (%@)...", icon);
	[[NSDistributedNotificationCenter defaultCenter] addObserver:icon selector:@selector(reloadIconImage) name:@"CLChange" object:nil];
	return icon;
}

- (UIImage *)generateIconImage:(int)type {
	cl_iconSize = cl_isEnabled() ? [%orig(type) size] : CGSizeZero;
	NSLog(@"[Colendar] In -generateIconImage, assigned size to original's %@.", NSStringFromCGSize(cl_iconSize));
	UIImage *iconImage = %orig(type);
	cl_iconSize = CGSizeZero;

	return iconImage;
}

%end

%end // %group Shared

/******************** iOS >=7 Calendar String Writing Hook ********************/

%group Modern

%hook NSString

- (CGSize)_legacy_drawAtPoint:(CGPoint)arg1 withFont:(id)arg2 {
	if (!CGSizeEqualToSize(cl_iconSize, CGSizeZero)) {
		NSDictionary *settings =  [NSDictionary dictionaryWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/com.insanj.colendar.plist"]];

		if ([self intValue] <= 0) {
			CGPoint centered = CGPointMake(arg1.x + [[settings objectForKey:@"weekdayX"] floatValue], arg1.y + [[settings objectForKey:@"weekdayY"] floatValue]);
			CGFloat roundedFontSize = floorf([[settings objectForKey:@"weekdayFontSize"] floatValue] * 10 + 0.5) / 10;
			NSString *savedFontName = [settings objectForKey:@"weekdayFont"];

			UIFont *font;
			if (savedFontName) {
				font = [UIFont fontWithName:savedFontName size:(((UIFont *)arg2).pointSize + roundedFontSize)];
			}

			else {
				font = [arg2 fontWithSize:(((UIFont *)arg2).pointSize + roundedFontSize)];
			}

			NSDictionary *attributes = @{ @"NSFont" : font, @"NSColor" : cl_loadWeekdayColor(settings)};

			NSLog(@"[Colendar] Drawing day (%@) to point %@ with font %@, due to settings: %@.", self, NSStringFromCGPoint(arg1), font, settings);
			[self drawAtPoint:centered withAttributes:attributes];

			centered = CGPointMake(arg1.x + [[settings objectForKey:@"weekofyearX"] floatValue], arg1.y + [[settings objectForKey:@"weekofyearY"] floatValue]);
			roundedFontSize = floorf([[settings objectForKey:@"weekofyearFontSize"] floatValue] * 10 + 0.5) / 10;
			savedFontName = [settings objectForKey:@"weekofyearFont"];

			if (savedFontName) {
				font = [UIFont fontWithName:savedFontName size:(((UIFont *)arg2).pointSize + roundedFontSize)];
			}

			else {
				font = [arg2 fontWithSize:(((UIFont *)arg2).pointSize + roundedFontSize)];
			}

			attributes = @{ @"NSFont" : font, @"NSColor" : cl_loadWeekOfYearColor(settings)};

			NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSISO8601Calendar];
			NSDateComponents * dateComponent = [calendar components:(NSWeekOfYearCalendarUnit) fromDate:[NSDate date]];
			self = [NSString stringWithFormat:@"%li", (long)[dateComponent weekOfYear]];

			NSLog(@"[Colendar] Drawing WeekOfYear (%@) to point %@ with font %@, due to settings: %@.", self, NSStringFromCGPoint(arg1), font, settings);
			[self drawAtPoint:centered withAttributes:attributes];
		}

		else {
			CGFloat origin = (cl_iconSize.width - [self sizeWithFont:arg2].width) / 2.0;
			CGPoint centered = CGPointMake(origin + [[settings objectForKey:@"dateX"] floatValue], arg1.y + [[settings objectForKey:@"dateY"] floatValue]);
			CGFloat roundedFontSize = floorf([[settings objectForKey:@"dateFontSize"] floatValue] * 10 + 0.5) / 10;
			NSString *savedFontName = [settings objectForKey:@"dateFont"];

			UIFont *font;
			if (savedFontName) {
				font = [UIFont fontWithName:savedFontName size:(((UIFont *)arg2).pointSize + roundedFontSize)];
			}

			else {
				font = [arg2 fontWithSize:(((UIFont *)arg2).pointSize + roundedFontSize)];
			}

			NSDictionary *attributes = @{@"NSFont" : font, @"NSColor" : cl_loadDateColor(settings)};

			NSLog(@"[Colendar] Drawing date (%@) to point %@ with font %@, due to settings: %@.", self, NSStringFromCGPoint(arg1), font, settings);
			[self drawAtPoint:centered withAttributes: attributes];
		}

		if ([[settings objectForKey:@"original"] boolValue]) {
			return %orig(arg1, arg2);
		}

		return CGSizeZero;
	}

	else {
		return %orig(arg1, arg2);
	}
}

%end

%end // %group Modern

/******************** iOS <=6 Calendar String Writing Hook ********************/

%group Ancient

%hook NSString

- (CGSize)drawAtPoint:(CGPoint)arg1 withFont:(id)arg2 {
	if (!CGSizeEqualToSize(cl_iconSize, CGSizeZero)) {
		NSDictionary *settings =  [NSDictionary dictionaryWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/com.insanj.colendar.plist"]];

		if ([self intValue] <= 0) {
			CGPoint centered = CGPointMake(arg1.x + [[settings objectForKey:@"weekdayX"] floatValue], arg1.y + [[settings objectForKey:@"weekdayY"] floatValue]);
			CGFloat roundedFontSize = floorf([[settings objectForKey:@"weekdayFontSize"] floatValue] * 10 + 0.5) / 10;
			NSString *savedFontName = [settings objectForKey:@"weekdayFont"];

			UIFont *font;
			if (savedFontName) {
				font = [UIFont fontWithName:savedFontName size:(((UIFont *)arg2).pointSize + roundedFontSize)];
			}

			else {
				font = [arg2 fontWithSize:(((UIFont *)arg2).pointSize + roundedFontSize)];
			}

			NSLog(@"[Colendar] Drawing day (%@) to point %@ with font %@, due to settings: %@", self, NSStringFromCGPoint(arg1), font, settings);
			[self drawAtPoint:centered forWidth:cl_iconSize.width withFont:font fontColor:cl_loadWeekdayColor(settings) shadowColor:nil];

			centered = CGPointMake(arg1.x + [[settings objectForKey:@"weekofyearX"] floatValue], arg1.y + [[settings objectForKey:@"weekofyearY"] floatValue]);
			roundedFontSize = floorf([[settings objectForKey:@"weekofyearFontSize"] floatValue] * 10 + 0.5) / 10;
			savedFontName = [settings objectForKey:@"weekofyearFont"];

			if (savedFontName) {
				font = [UIFont fontWithName:savedFontName size:(((UIFont *)arg2).pointSize + roundedFontSize)];
			}

			else {
				font = [arg2 fontWithSize:(((UIFont *)arg2).pointSize + roundedFontSize)];
			}

			NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSISO8601Calendar];
			NSDateComponents * dateComponent = [calendar components:(NSWeekOfYearCalendarUnit) fromDate:[NSDate date]];
			self = [NSString stringWithFormat:@"%li", (long)[dateComponent weekOfYear]];

			NSLog(@"[Colendar] Drawing WeekOfYear (%@) to point %@ with font %@, due to settings: %@", self, NSStringFromCGPoint(arg1), font, settings);
			[self drawAtPoint:centered forWidth:cl_iconSize.width withFont:font fontColor:cl_loadWeekOfYearColor(settings) shadowColor:nil];
		}

		else {
			CGFloat origin = (cl_iconSize.width - [self sizeWithFont:arg2].width) / 2.0;
			CGPoint centered = CGPointMake(origin + [[settings objectForKey:@"dateX"] floatValue], arg1.y + [[settings objectForKey:@"dateY"] floatValue]);
			CGFloat roundedFontSize = floorf([[settings objectForKey:@"dateFontSize"] floatValue] * 10 + 0.5) / 10;
			NSString *savedFontName = [settings objectForKey:@"dateFont"];

			UIFont *font;
			if (savedFontName) {
				font = [UIFont fontWithName:savedFontName size:(((UIFont *)arg2).pointSize + roundedFontSize)];
			}

			else {
				font = [arg2 fontWithSize:(((UIFont *)arg2).pointSize + roundedFontSize)];
			}

			NSLog(@"[Colendar] Drawing date (%@) to point %@ with font %@, due to settings: %@", self, NSStringFromCGPoint(centered), font, settings);
			[self drawAtPoint:centered forWidth:cl_iconSize.width withFont:font fontColor:cl_loadDateColor(settings) shadowColor:nil];

		}

		if ([[settings objectForKey:@"original"] boolValue]) {
			return %orig(arg1, arg2);
		}

		return CGSizeZero;
	}

	else {
		return %orig(arg1, arg2);
	}
}

%end

%end // %group Ancient

/************************ Theos Hook Group Constructor ************************/

%ctor {
	%init(Shared);

	if (MODERN_IOS) {
		NSLog(@"[Colendar] Injecting hooks for modern iOS versions...");
		%init(Modern);
	}

	else {
		NSLog(@"[Colendar] Injecting hooks for ancient iOS versions...");
		%init(Ancient);
	}
}
