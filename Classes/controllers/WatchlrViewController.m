    //
//  MostViewedViewController.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "WatchlrViewController.h"
#import "LoginViewController.h"
#import "UserObject.h"
#import "VideoPlayerView.h"
#import "VideoTableCell.h"

#import "VideoRequest.h"
#import "VideoResponse.h"
#import "TrackerRequest.h"

@implementation WatchlrViewController

@synthesize onLogoutCallback;

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	// create the view
	UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 500, 500)];
	view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    view.autoresizesSubviews = YES;
    view.backgroundColor = [UIColor whiteColor];
	self.view = view;
	[view release];
    
    self.navigationController.navigationBar.backItem.hidesBackButton = NO;
    self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"watchlr_logo.png"]] autorelease];
    
    // get the event when the app comes back
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // return !DeviceUtils.isIphone;
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
    LOG_DEBUG(@"Dealloc called.");
    
	// stop observing events
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    
	[super dealloc];
}

// --------------------------------------------------------------------------------
// Notification callbacks
// --------------------------------------------------------------------------------


// --------------------------------------------------------------------------------
//                      Public functions
// --------------------------------------------------------------------------------

- (void) logoutUser {
    // erase userId
	UserObject* userObject = [UserObject getUser];
	userObject.sessionId = nil;
    if (onLogoutCallback != nil) {
        [onLogoutCallback execute:nil];
    }
}

- (void) onTabInactivate {
    // subclasses should implement this method 
}

- (void) onTabActivate {
    // subclasses should implement this method 
}

- (void) onApplicationBecomeInactive {
    // subclasses should implement this method
}

@end
