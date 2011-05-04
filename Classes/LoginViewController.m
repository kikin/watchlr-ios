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

- (void)loadView {
	// create the view
	UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 500, 500)];
	view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	self.view = view;
	[view release];
	
	// add the kikin logo in the middle
	logoImage = [[UIImageView alloc] init];
	logoImage.frame = CGRectMake((view.frame.size.width-350)/2, (view.frame.size.height-350)/2, 350, 350);
	logoImage.image = [UIImage imageNamed:@"kikin_logo.png"];
	logoImage.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
	[view addSubview:logoImage];
	
	// add the rounded rect view over the logo
	loginBgView = [[UIView alloc] init];
	loginBgView.frame = CGRectMake((view.frame.size.width-500)/2, (view.frame.size.height-200)/2, 500, 200);
	loginBgView.backgroundColor = [UIColor colorWithRed:215.0/255.0 green:235.0/255.0 blue:255.0/255.0 alpha:1.0];
	loginBgView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
	loginBgView.layer.cornerRadius = 18.0f;
	loginBgView.layer.borderWidth = 1.0f;
	loginBgView.layer.opacity = 0.8f;
	[view addSubview:loginBgView];
	
	// create the title lable inside
	titleLabel = [[UILabel alloc] init];
	titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	//titleLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;	
	titleLabel.frame = CGRectMake(0, 10, loginBgView.frame.size.width, 35);
	titleLabel.text = @"kikin video";
	titleLabel.textAlignment = UITextAlignmentCenter;
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.font = [UIFont boldSystemFontOfSize:28.0];
	[loginBgView addSubview:titleLabel];
	
	// create the description
	descriptionLabel = [[UILabel alloc] init];
	descriptionLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;	
	descriptionLabel.frame = CGRectMake(30, 50, loginBgView.frame.size.width-60, 70);
	descriptionLabel.text = @"Access kikin video from your iPad by login on facebook. Go to http://video.kikin.com for more information.";
	descriptionLabel.textAlignment = UITextAlignmentCenter;
	descriptionLabel.backgroundColor = [UIColor clearColor];
	descriptionLabel.numberOfLines = 3;
	descriptionLabel.font = [UIFont systemFontOfSize:18.0];
	[loginBgView addSubview:descriptionLabel];
	
	// create the facebook login button inside
	loginButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
	loginButton.frame = CGRectMake((loginBgView.frame.size.width-200)/2, loginBgView.frame.size.height-50, 200, 35);
	loginButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
	[loginButton addTarget:self action:@selector(onClickConnectButton:) forControlEvents:UIControlEventTouchUpInside];
	[loginButton setTitle:@"Connect with Facebook" forState:UIControlStateNormal];
	[loginBgView addSubview:loginButton];
	
	// some changes for iPhone/iPod version
	if (DeviceUtils.isIphone) {
		loginBgView.frame = CGRectMake((view.frame.size.width-300)/2, (view.frame.size.height-250)/2, 300, 250);
		descriptionLabel.numberOfLines = 4;
	}
	
	// create the facebook object for connection
	facebook = [[Facebook alloc] initWithAppId:@"142118469191927"];
	
	// look if the user is already loggedIn
	UserObject* user = [UserObject getUser];
	if (user.sessionId != nil) {
		// go the the main view
		[self performSelector:@selector(goToMainView:) withObject:nil afterDelay:0.5];
	}
}

- (void) onClickConnectButton: (UIButton*)sender {
	facebook.sessionDelegate = self;
	[facebook removeAllCookies];
	[facebook authorizeWithFBAppAuth:YES safariAuth:NO];
}

- (Facebook*) facebook {
	return facebook;
}

- (void) goToMainView:(bool)animated {
	MostViewedViewController* mostViewedViewController = [[MostViewedViewController alloc] initWithNibName:@"MostViewedView" bundle:nil];
	[self presentModalViewController:mostViewedViewController animated:animated];
	
}

- (void) fbDidLogin {
	// we need the user id in order to connect him with the server
	[facebook requestWithGraphPath:@"me" andDelegate:self];
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
	LOG_ERROR(@"failed to executed /me request to get the user id: %@", error);
}

- (void)request:(FBRequest *)request didLoad:(id)result {
	// get the user id
	NSDictionary* data = result;
	NSString* facebookId = [data objectForKey:@"id"];
	if (facebookId != nil) {
		// link this device with the server using this id
		[self doLinkDeviceRequest:facebookId];
	}
}

- (void) onLinkRequestSuccess: (LinkDeviceResponse*)response {
	if (response.sessionId != nil) {
		// change our userId (automatically savec)
		UserObject* userObject = [UserObject getUser];
		userObject.sessionId = response.sessionId;
		
		// go the the main view
		[self goToMainView:true];
	}
}

- (void) onLinkRequestFailed: (NSString*)errorMessage {
	LOG_ERROR(@"failed to link the device: %@", errorMessage);
}

- (void) doLinkDeviceRequest: (NSString*)accessToken {
	LinkDeviceRequest* request = [[LinkDeviceRequest alloc] init];
	request.successCallback = [Callback create:self selector:@selector(onLinkRequestSuccess:)];
	request.errorCallback = [Callback create:self selector:@selector(onLinkRequestFailed:)];
	[request doLinkDeviceRequest:accessToken];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	//if (DeviceUtils.isIphone) {
	//	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
	//} else {
		return YES;
	//}
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
    [super dealloc];
}

@end
