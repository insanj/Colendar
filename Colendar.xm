#include "substrate.h"

@interface NSDistributedNotificationCenter : NSNotificationCenter
@end

@interface SpringBoard : UIApplication
-(void)_relaunchSpringBoardNow;
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
}
