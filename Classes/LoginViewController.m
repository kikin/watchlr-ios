    //
//  LoginViewController.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/25/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "LoginViewController.h"
#import "LinkDeviceRequest.h"
#import "MostViewedViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation LoginViewController

@synthesize window, userObject, loginView;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

- (void) goToMainView:(bool)animated {
	MostViewedViewController* mostViewedViewController = [[MostViewedViewController alloc] initWithNibName:@"MostViewedView" bundle:nil];
	[self presentModalViewController:mostViewedViewController animated:animated];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void) viewDidLoad {
    [super viewDidLoad];
	
	[loginView.layer setCornerRadius:18.0f];
	[loginView.layer setBorderWidth:1.0f];
	[loginView.layer setOpacity:0.8f];
	
	// load our user data
	userObject = [UserObject getUser];
	if (userObject.userId != nil) {
		
		// go the the main view
		[self performSelector:@selector(goToMainView:) withObject: false afterDelay:0.01];
	}
}

- (void) onLinkRequestSuccess: (LinkDeviceResponse*)response {
	if (response.userId != nil) {
		// change our userId (automatically savec)
		userObject.userId = response.userId;
		
		// go the the main view
		[self goToMainView:true];
	}
}

- (void) onLinkRequestFailed: (NSString*)errorMessage {
	NSLog(@"-- onLinkRequestFailed %@", errorMessage);
}

- (IBAction) tryConnecting {
	LinkDeviceRequest* request = [[LinkDeviceRequest alloc] init];
	[request setErrorCallback:self callback:@selector(onLinkRequestFailed:)];
	[request setSuccessCallback:self callback:@selector(onLinkRequestSuccess:)];
	[request doLinkDeviceRequest:textField.text];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
