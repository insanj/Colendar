#include "substrate.h"
#import "../Colendar.h"

#define URL_ENCODE(string) [(NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)(string), NULL, CFSTR(":/=,!$& '()*+;[]@#?"), kCFStringEncodingUTF8) autorelease]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

static UIColor *clTintColor;
static void cl_setTintColor() {
	NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/com.insanj.colendar.plist"]];
	NSArray *colors =  @[ UIColorFromRGB(0x0000cc), UIColorFromRGB(0xa5492a), UIColorFromRGB(0x36454f),
					  	UIColorFromRGB(0xffd700), UIColorFromRGB(0x808080), UIColorFromRGB(0x27d827),
					  	UIColorFromRGB(0xffa500), UIColorFromRGB(0xff748c), UIColorFromRGB(0x800080),
					  	UIColorFromRGB(0xff0000), UIColorFromRGB(0xffffff), UIColorFromRGB(0xffff3b) ];

	clTintColor = [colors objectAtIndex:[[settings objectForKey:@"globalColor"] intValue]];
}

static UIColor *cl_getTintColor() {
	if (!clTintColor) {
		cl_setTintColor();
	}

	return clTintColor;
}

@interface CLPrefsListController : PSListController
@end

@implementation CLPrefsListController

- (NSArray *)specifiers{
	if(!_specifiers)
		_specifiers = [[self loadSpecifiersFromPlistName:@"CLPrefs" target:self] retain];

	return _specifiers;
}

- (void)loadView{
	[super loadView];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareTapped:)];
}

- (void)viewDidLoad{
	[super viewDidLoad];

	[UISwitch appearanceWhenContainedIn:self.class, nil].onTintColor = cl_getTintColor();
	[UISegmentedControl appearanceWhenContainedIn:self.class, nil].tintColor = cl_getTintColor();
}

- (void)viewWillAppear:(BOOL)animated{
    [(UITableView *)self.view deselectRowAtIndexPath:((UITableView *)self.view).indexPathForSelectedRow animated:YES];

	self.view.tintColor = cl_getTintColor();
    self.navigationController.navigationBar.tintColor = cl_getTintColor();

	NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/com.insanj.colendar.plist"]];

	if (![settings objectForKey:@"globalColor"]) {
		PSSpecifier *colorSpecifier = [self specifierForID:@"GlobalColor"];
		[self setPreferenceValue:@(0.0) specifier:colorSpecifier];
		[self reloadSpecifier:colorSpecifier];
	}
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];

	self.view.tintColor = nil;
	self.navigationController.navigationBar.tintColor = nil;
}

- (void)shareTapped:(UIBarButtonItem *)sender {
	NSString *text = @"Making a beautiful, colorful Calendar has never been easier than with Colendar by @insanj and @k3levs!";
	NSURL *url = [NSURL URLWithString:@"http://github.com/insanj/colendar"];

	if (%c(UIActivityViewController)) {
		UIActivityViewController *viewController = [[[%c(UIActivityViewController) alloc] initWithActivityItems:[NSArray arrayWithObjects:text, url, nil] applicationActivities:nil] autorelease];
		[self.navigationController presentViewController:viewController animated:YES completion:NULL];
	}

	else if (%c(TWTweetComposeViewController) && [TWTweetComposeViewController canSendTweet]) {
		TWTweetComposeViewController *viewController = [[[TWTweetComposeViewController alloc] init] autorelease];
		viewController.initialText = text;
		[viewController addURL:url];
		[self.navigationController presentViewController:viewController animated:YES completion:NULL];
	}

	else {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://twitter.com/intent/tweet?text=%@%%20%@", URL_ENCODE(text), URL_ENCODE(url.absoluteString)]]];
	}
}

- (void)respring {
	[[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"CLChange" object:nil];
}

- (void)winterboard {
	[[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"CLWinterboard" object:nil];
}

- (void)k3levs {
	[self twitter:@"k3levs"];
}

- (void)insanj {
	[self twitter:@"insanj"];
}

- (void)twitterWithSpecifier:(PSSpecifier *)specifier {
	NSString *label = [specifier.properties objectForKey:@"label"];
	NSString *user = [label substringFromIndex:1];

	[self twitter:user];
}

- (void)twitter:(NSString *)user {
	if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot:"]])
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tweetbot:///user_profile/" stringByAppendingString:user]]];

	else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitterrific:"]])
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitterrific:///profile?screen_name="  stringByAppendingString:user]]];

	else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetings:"]])
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tweetings:///user?screen_name=" stringByAppendingString:user]]];

	else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter:"]])
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitter://user?screen_name=" stringByAppendingString:user]]];

	else
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"https://mobile.twitter.com/" stringByAppendingString:user]]];
}

@end

@interface CLWinterBoardButtonCell : PSTableCell
@end

@implementation CLWinterBoardButtonCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier {

	UIImageView *winterboardView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30.0, 30.0)];
	[winterboardView setImage:[UIImage imageWithContentsOfFile:@"/Applications/WinterBoard.app/icon.png"]];
	winterboardView.layer.masksToBounds = YES;
	winterboardView.layer.cornerRadius = 7.0;

	UIGraphicsBeginImageContextWithOptions(winterboardView.bounds.size, NO, 0.0);
	[winterboardView.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	[winterboardView release];
	[specifier setProperty:image forKey:@"iconImage"];
	CLWinterBoardButtonCell *cell = [[super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier] autorelease];

	return cell;
}

@end

@interface CLButtonShiftTopCell : PSTableCell
@end

@implementation CLButtonShiftTopCell

- (void)layoutSubviews {
	[super layoutSubviews];

	CGRect doubleFrame = self.contentView.frame;
	doubleFrame.size.height *= 2;
	[self.imageView setCenter:CGPointMake(self.imageView.center.x, CGRectGetMidY(doubleFrame))];
}

@end

@interface CLButtonShiftBottomCell : PSTableCell
@end

@implementation CLButtonShiftBottomCell

- (void)layoutSubviews {
	[super layoutSubviews];

	CGRect doubleFrame = self.contentView.frame;
	doubleFrame.origin.y -= doubleFrame.size.height;
	doubleFrame.size.height *= 2;
	[self.imageView setCenter:CGPointMake(self.imageView.center.x, CGRectGetMidY(doubleFrame))];
}

@end

@interface CLListItemsController : PSListItemsController
@end

@implementation CLListItemsController

- (void)viewWillAppear:(BOOL)animated{
	self.navigationController.navigationBar.tintColor = cl_getTintColor();
}

- (void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	self.navigationController.navigationBar.tintColor = nil;
}

- (id)tableView:(id)arg1 cellForRowAtIndexPath:(id)arg2{
	PSTableCell *cell = [super tableView:arg1 cellForRowAtIndexPath:arg2];

	NSDictionary *labelToColor =  @{ @"Blue"  	: UIColorFromRGB(0x0000cc),
									@"Brown" 	: UIColorFromRGB(0xa5492a),
									@"Charcoal"  : UIColorFromRGB(0x36454f),
									@"Gold"	  : UIColorFromRGB(0xffd700),
									@"Gray"	  : UIColorFromRGB(0x808080),
									@"Green"	 : UIColorFromRGB(0x27d827),
									@"Orange"	: UIColorFromRGB(0xffa500),
									@"Pink"	  : UIColorFromRGB(0xff748c),
									@"Purple"	: UIColorFromRGB(0x800080),
									@"Red" 	  : UIColorFromRGB(0xff0000),
									@"White" 	: UIColorFromRGB(0xffffff),
									@"Yellow"	: UIColorFromRGB(0xffff3b) };

	UIView *colorThumb = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20.0, 20.0)];
	colorThumb.backgroundColor = [labelToColor objectForKey:[[cell titleLabel] text]];
	colorThumb.layer.masksToBounds = YES;
	colorThumb.layer.cornerRadius = 5.0;
	colorThumb.layer.borderColor = [UIColor lightGrayColor].CGColor;
	colorThumb.layer.borderWidth = 0.5;

	UIGraphicsBeginImageContextWithOptions(colorThumb.bounds.size, NO, 0.0);
	[colorThumb.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	[colorThumb release];
	[cell.imageView setImage:image];

	return cell;
}

- (void)tableView:(id)arg1 didSelectRowAtIndexPath:(id)arg2 {
	[super tableView:arg1 didSelectRowAtIndexPath:arg2];

	cl_setTintColor();
	self.navigationController.navigationBar.tintColor = cl_getTintColor();
}


@end
