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
#import "FeedbackViewController.h"
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
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Account" style:UIBarButtonItemStyleBordered target:self action:@selector(onClickAccount)] autorelease];
    self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"watchlr_logo.png"]] autorelease];
    
    userProfileSettingsView = [[UserProfileSettingsView alloc] init];
	userProfileSettingsView.hidden = YES;
    [self.view addSubview:userProfileSettingsView];
    
    userSettingsView = [[UserSettingsView alloc] init];
	userSettingsView.hidden = YES;
    userSettingsView.showUserProfileCallback = [Callback create:self selector:@selector(showUserProfile)];
    userSettingsView.showFeedbackFormCallback = [Callback create:self selector:@selector(showFeedbackForm)];
    userSettingsView.logoutCallback = [Callback create:self selector:@selector(logoutUser)];
    
	[self.view addSubview:userSettingsView];
    
    // get the event when the app comes back
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    if (!userSettingsView.hidden) {
        userSettingsView.frame = CGRectMake(self.view.frame.size.width - 210, 0, userSettingsView.frame.size.width, userSettingsView.frame.size.height);
        // [userSettingsView showUserSettings];
    }
    
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
    
	// release memory
	[userProfileSettingsView release];
    [userSettingsView release];
    
    [super dealloc];
}

// --------------------------------------------------------------------------------
// Notification callbacks
// --------------------------------------------------------------------------------


// --------------------------------------------------------------------------------
//                      Navigation bar functions
// --------------------------------------------------------------------------------

- (void) onClickAccount {
    if (userSettingsView.hidden) {
        /*userSettingsView.frame = CGRectMake(self.view.frame.size.width - 210, topToolbar.frame.size.height, userSettingsView.frame.size.width, userSettingsView.frame.size.height);*/
        if (DeviceUtils.isIphone) {
            userSettingsView.frame = CGRectMake(0, self.view.frame.size.height - 190, self.view.frame.size.width, 190);
        } else {
            userSettingsView.frame = CGRectMake((self.view.frame.size.width - 210), 0, 210, 190);
        }
        
        [userSettingsView showUserSettings];
        
    } else {
        userSettingsView.hidden = YES;
    }
    //[settingsMenu setMenuVisible:YES animated:YES];
}

// --------------------------------------------------------------------------------
//                      Public functions
// --------------------------------------------------------------------------------

- (void) showUserProfile {
    if (DeviceUtils.isIphone) {
        userProfileSettingsView.frame = CGRectMake(5, (self.view.frame.size.height-190)/2, self.view.frame.size.width - 10, 190);
    } else {
        userProfileSettingsView.frame = CGRectMake((self.view.frame.size.width-500)/2, (self.view.frame.size.height-210)/2, 500, 210);
    }
    [userProfileSettingsView showUserProfile];
}

- (void) showFeedbackForm {
    FeedbackViewController* feedbackViewController = [[FeedbackViewController alloc] init];
    feedbackViewController.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    [self presentModalViewController:feedbackViewController animated:YES];
    
    [feedbackViewController loadFeedbackForm];
    [feedbackViewController release];
}

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
