    //
//  LoginViewController.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/25/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "LoginViewController.h"
#import "LinkDeviceRequest.h"
#import "UserProfileRequest.h"
#import "UserProfileResponse.h"
#import <QuartzCore/QuartzCore.h>

@implementation LoginViewController

@synthesize onLoginSuccessCallback;

const char* FB_APP_ID = "220283271338035";

- (void)loadView {
	// create the view
	UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 500, 500)];
	view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	self.view = view;
	[view release];
	
	// add the kikin logo in the middle
	UIImageView* logoImage = [[[UIImageView alloc] init] autorelease];
	logoImage.frame = CGRectMake((view.frame.size.width-350)/2, (view.frame.size.height-350)/2, 350, 350);
	logoImage.image = [UIImage imageNamed:@"watchlr_favicon_big.png"];
	logoImage.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
	[view addSubview:logoImage];
	
	// create the connect view
	connectMainView = [[ConnectMainView alloc] initWithFrame:CGRectMake((view.frame.size.width-500)/2, (view.frame.size.height-200)/2, 500, 200)];
	connectMainView.hidden = YES;
	connectMainView.clickConnectCallback = [Callback create:self selector:@selector(onClickConnectButton:)];
	[view addSubview:connectMainView];
	
	// create the loading view
	loadingMainView = [[LoadingMainView alloc] initWithFrame:CGRectMake((view.frame.size.width-300)/2, (view.frame.size.height-55)/2, 300, 55)];
	loadingMainView.hidden = NO;
	[view addSubview:loadingMainView];
	
	// create the error view
	errorMainView = [[ErrorMainView alloc] initWithFrame:CGRectMake((view.frame.size.width-500)/2, (view.frame.size.height-200)/2, 500, 200)];
	errorMainView.hidden = YES;
	errorMainView.clickOkCallback = [Callback create:self selector:@selector(onClickOkErrorButton:)];
	[view addSubview:errorMainView];
	
	// some changes for iPhone/iPod version
	if (DeviceUtils.isIphone) {
		connectMainView.frame = CGRectMake((view.frame.size.width-300)/2, (view.frame.size.height-250)/2, 300, 250);
		errorMainView.frame = CGRectMake((view.frame.size.width-300)/2, (view.frame.size.height-200)/2, 300, 200);
	}
	
	// create the facebook object for connection
	facebook = [[Facebook alloc] initWithAppId:[NSString stringWithCString:FB_APP_ID encoding:NSUTF8StringEncoding]];
	
	// look if the user is already loggedIn
	UserObject* user = [UserObject getUser];
	if (user.sessionId != nil) {
        // save the user id for the legacy users
        if (user.userId < 1) {
            [self performSelector:@selector(doUserProfileRequest)];
            [self showView:loadingMainView];
        } else {
            // go the the main view
            [self performSelector:@selector(goToMainView:) withObject:nil afterDelay:0.0];
        }
	} else {
		[self showView:connectMainView];
	}
}

- (void) showView: (UIView*)view {
	loadingMainView.hidden = YES;
	connectMainView.hidden = YES;
	errorMainView.hidden = YES;
	view.hidden = NO;
}

- (void) onClickOkErrorButton: (id)sender {
	// show connect view
	[self showView:connectMainView];
}

- (void) onClickConnectButton: (id)sender {
	// show loading
	[self showView:loadingMainView];
	
	// start facebook connect
	facebook.sessionDelegate = self;
	[facebook removeAllCookies];
    NSArray* permissions = [NSArray arrayWithObjects:@"offline_access", @"publish_stream", @"read_stream", @"email", nil];
    [facebook authorize:permissions WithFBAppAuth:NO safariAuth:NO];
}

- (Facebook*) facebook {
	return facebook;
}

- (void) goToMainView:(bool)animated {
    if (onLoginSuccessCallback != nil) {
        [onLoginSuccessCallback execute:nil];
    }
	// [self showView:connectMainView];
}

- (void) fbDidNotLogin:(BOOL)cancelled {
	// show connect view
	[self showView:connectMainView];
}

- (void) fbDidLogin {
	// we need the user id in order to connect him with the server
    [facebook requestWithGraphPath:@"me" andDelegate:self];
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
	[errorMainView setErrorMessage: @"Facebook failed to give us the credentials to connect you."];
	[self showView:errorMainView];
	
	LOG_ERROR(@"failed to executed /me request to get the user id: %@", error);
}

- (void)request:(FBRequest *)request didLoad:(id)result {
	// get the user id
	NSDictionary* data = result;
	NSString* facebookId = [data objectForKey:@"id"];
    LOG_DEBUG(@"Facebook access tooken: %@", [facebook accessToken]);
    NSString* facebookAccessToken = [facebook accessToken];
	if (facebookId != nil && facebookAccessToken != nil) {
		// link this device with the server using this id
		[self doLinkDeviceRequest:facebookId andAccessToken:facebookAccessToken];
	}
}

- (void) onLinkRequestSuccess: (LinkDeviceResponse*)response {
	if (response.success) {
		if (response.response != nil) {
            // change our userId (automatically savec)
			UserObject* userObject = [UserObject getUser];
			userObject.sessionId = [response.response objectForKey:@"session_id"];
            if (userObject.sessionId == nil) {
                NSString* errorMessage = @"We failed to connect with the watchlr servers: Missing sessionId";
                [errorMainView setErrorMessage:errorMessage];
                [self showView:errorMainView];
                
                LOG_ERROR(@"failed to connect: missing sessionId");
            } else {
                userObject.userName = [[response.response objectForKey:@"user"] objectForKey:@"username"];
                userObject.userId = [[[response.response objectForKey:@"user"] objectForKey:@"id"] intValue];
                
                [userObject saveUserProfile];
                
                // go the the main view
                [self goToMainView:YES];
            }
		} else {
			NSString* errorMessage = @"We failed to connect with the watchlr servers: Missing sessionId";
			[errorMainView setErrorMessage:errorMessage];
			[self showView:errorMainView];
			
			LOG_ERROR(@"failed to connect: missing sessionId");
		}
	} else {
		NSString* errorMessage = [NSString stringWithFormat:@"We failed to connect with the watchlr servers: %@.", response.errorMessage];
		[errorMainView setErrorMessage:errorMessage];
		[self showView:errorMainView];
		
		LOG_ERROR(@"failed to connect: %@", response.errorMessage);
	}
}

- (void) onLinkRequestFailed: (NSString*)errorMessage {
	[errorMainView setErrorMessage:@"We failed to connect with the watchlr servers: Bad response."];
	[self showView:errorMainView];
	
	LOG_ERROR(@"failed to link the device: %@", errorMessage);
}

- (void) onUserProfileRequestSuccess: (UserProfileResponse*)response {
	if (response.success) {
        UserObject* userObject = [UserObject getUser];
        userObject.userName = [[response userProfile] objectForKey:@"username"];
        userObject.userId = [[[response userProfile] objectForKey:@"id"] intValue];
        
        [userObject saveUserProfile];
        
        // go the the main view
        [self goToMainView:YES];
        
	} else {
		NSString* errorMessage = [NSString stringWithFormat:@"We failed to connect with the watchlr servers: %@.", response.errorMessage];
		[errorMainView setErrorMessage:errorMessage];
		[self showView:errorMainView];
		
		LOG_ERROR(@"failed to connect: %@", response.errorMessage);
	}
}

- (void) onUserProfileRequestFailed: (NSString*)errorMessage {
	[errorMainView setErrorMessage:@"We failed to connect with the watchlr servers: Bad response."];
	[self showView:errorMainView];
	
	LOG_ERROR(@"failed to link the device: %@", errorMessage);
}

- (void) doUserProfileRequest {
    UserProfileRequest* request = [[UserProfileRequest alloc] init];
    request.successCallback = [Callback create:self selector:@selector(onUserProfileRequestSuccess:)];
    request.errorCallback = [Callback create:self selector:@selector(onUserProfileRequestFailed:)];
    [request getUserProfile];
    [request release];
}

- (void) doLinkDeviceRequest: (NSString*)facebookId andAccessToken:(NSString*)facebookAccessToken {
	LinkDeviceRequest* request = [[LinkDeviceRequest alloc] init];
	request.successCallback = [Callback create:self selector:@selector(onLinkRequestSuccess:)];
	request.errorCallback = [Callback create:self selector:@selector(onLinkRequestFailed:)];
	[request doLinkDeviceRequest:facebookId andAccessToken:facebookAccessToken];
    [request release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
    connectMainView.clickConnectCallback = nil;
    errorMainView.clickOkCallback = nil;
    facebook.sessionDelegate = nil;
    
    [onLoginSuccessCallback release];
	[connectMainView removeFromSuperview];
	[errorMainView removeFromSuperview];
	[loadingMainView removeFromSuperview];
    [facebook release];
    
    onLoginSuccessCallback = nil;
    connectMainView = nil;
    errorMainView = nil;
    loadingMainView = nil;
    facebook = nil;
    
    [super dealloc];
}

@end
