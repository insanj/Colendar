#include "substrate.h"

@interface NSDistributedNotificationCenter : NSNotificationCenter
@end

@interface SpringBoard : UIApplication
- (BOOL)launchApplicationWithIdentifier:(id)identifier suspended:(BOOL)suspended;
- (void)_applicationOpenURL:(id)url withApplication:(id)application sender:(id)sender publicURLsOnly:(BOOL)only animating:(BOOL)animating additionalActivationFlags:(id)flags activationHandler:(id)handler;
- (void)_relaunchSpringBoardNow;
@end

@interface SBApplicationIcon
- (id)initWithApplication:(id)application;
- (id)generateIconImage:(int)image;
@end

@interface CLAlertViewDelegate : NSObject <UIAlertViewDelegate>
@end

@implementation CLAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if(buttonIndex != [alertView cancelButtonIndex])
		[(SpringBoard *)[UIApplication sharedApplication] _relaunchSpringBoardNow];
}

@end

%ctor{
	[[NSDistributedNotificationCenter defaultCenter] addObserverForName:@"CLRespring" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification){
		[[[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Applying color settings will respring your device, are you sure you want to do so now?" delegate:[[CLAlertViewDelegate alloc] init] cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil] autorelease] show];
	}];

	[[NSDistributedNotificationCenter defaultCenter] addObserverForName:@"CLWinterboard" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification){
		[(SpringBoard *)[UIApplication sharedApplication] launchApplicationWithIdentifier:@"com.saurik.Winterboard" suspended:YES];
	}];
}
