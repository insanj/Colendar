#include <Preferences/PSListItemsController.h>
#include <Preferences/PSListController.h>
#include <Preferences/PSTableCell.h>
#include <UIKit/UIActivityViewController.h>
#include <Twitter/Twitter.h>
#include <MessageUI/MessageUI.h>
#include <notify.h>

#define URL_ENCODE(string) [(NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)(string), NULL, CFSTR(":/=,!$& '()*+;[]@#?"), kCFStringEncodingUTF8) autorelease]
#define CLTintColor [UIColor colorWithRed:40/255.0f green:160/255.0f blue:244/255.0f alpha:1.0f]

@interface SpringBoard : UIApplication
- (void)_relaunchSpringBoardNow;
@end

@interface CLListItemsController : PSListItemsController
@end

@implementation CLListItemsController

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.tintColor = CLTintColor;
}

- (void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	self.navigationController.navigationBar.tintColor = nil;
}

@end

@interface CLPrefsListController : PSListController
@end

@implementation CLPrefsListController

- (void)viewDidLoad{
	[super viewDidLoad];
	[UISwitch appearanceWhenContainedIn:self.class, nil].onTintColor = CLTintColor;
	[UISegmentedControl appearanceWhenContainedIn:self.class, nil].tintColor = CLTintColor;
}

- (void)loadView{
	[super loadView];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareTapped:)];
}

- (NSArray *)specifiers{
	if(!_specifiers)
		_specifiers = [[self loadSpecifiersFromPlistName:@"CLPrefs" target:self] retain];

	return _specifiers;
}

- (void)viewWillAppear:(BOOL)animated{
    [(UITableView *)self.view deselectRowAtIndexPath:((UITableView *)self.view).indexPathForSelectedRow animated:YES];

	self.view.tintColor = CLTintColor;
    self.navigationController.navigationBar.tintColor = CLTintColor;

	NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/com.insanj.colendar.plist"]];

	if(![settings objectForKey:@"globalColor"]){
		PSSpecifier *colorSpecifier = [self specifierForID:@"GlobalColor"];
		[self setPreferenceValue:@(1.0) specifier:colorSpecifier];
		[self reloadSpecifier:colorSpecifier];
	}
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];

	self.view.tintColor = nil;
	self.navigationController.navigationBar.tintColor = nil;
}

- (void)shareTapped:(UIBarButtonItem *)sender{
	NSString *text = @"Making a beautiful, colorful Calendar has never been easier than with Colendar by @insanj and @k3levs!";
	NSURL *url = [NSURL URLWithString:@"http://github.com/insanj/colendar"];

	if(%c(UIActivityViewController)){
		UIActivityViewController *viewController = [[[%c(UIActivityViewController) alloc] initWithActivityItems:[NSArray arrayWithObjects:text, url, nil] applicationActivities:nil] autorelease];
		[self.navigationController presentViewController:viewController animated:YES completion:NULL];
	} else if (%c(TWTweetComposeViewController) && [TWTweetComposeViewController canSendTweet]) {
		TWTweetComposeViewController *viewController = [[[TWTweetComposeViewController alloc] init] autorelease];
		viewController.initialText = text;
		[viewController addURL:url];
		[self.navigationController presentViewController:viewController animated:YES completion:NULL];
	} else {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://twitter.com/intent/tweet?text=%@%%20%@", URL_ENCODE(text), URL_ENCODE(url.absoluteString)]]];
	}
}

- (void)respring{
//	needs a tweak loaded into springboard to do this
}

- (void)k3levs{
	[self twitter:@"k3levs"];
}

- (void)insanj{
	[self twitter:@"insanj"];
}

- (void)twitterWithSpecifier:(PSSpecifier *)specifier{
	NSString *label = [specifier.properties objectForKey:@"label"];
	NSString *user = [label substringFromIndex:1];

	[self twitter:user];
}

- (void)twitter:(NSString *)user{

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
