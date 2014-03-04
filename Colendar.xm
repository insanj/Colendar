#include "substrate.h"
#import "Colendar.h"

@interface CLAlertViewDelegate : NSObject <UIAlertViewDelegate>
@end

@implementation CLAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (buttonIndex != [alertView cancelButtonIndex]) {
		NSLog(@"[Colendar] Respringing to allow LaunchDaemon to write properly...");
		[(SpringBoard *)[UIApplication sharedApplication] _relaunchSpringBoardNow];
	}
}

@end

%ctor{
	[[NSDistributedNotificationCenter defaultCenter] addObserverForName:@"CLChange" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification){
		NSLog(@"[Colendar] Prompting user to save and respring device (or not)...");
		[[[[UIAlertView alloc] initWithTitle:@"Color Applied" message:@"Although your selected Calendar color has been applied, you'll have to respring to see any changes. Would you like to do so now?" delegate:[[CLAlertViewDelegate alloc] init] cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil] autorelease] show];
	}];
}
