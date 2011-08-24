    //
//  MostViewedViewController.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "ProfileViewController.h"
#import "UserProfileRequest.h"
#import "UserProfileResponse.h"
#import "VideoPlayerView.h"
#import "WebViewController.h"
#import "FeedbackViewController.h"

@implementation ProfileViewController

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    [super loadView];
    
    userProfileSettingsView = [[UserProfileSettingsView alloc] init];
	userProfileSettingsView.hidden = YES;
    [self.view addSubview:userProfileSettingsView];
    
    userSettingsView = [[UserSettingsView alloc] init];
	userSettingsView.hidden = YES;
    userSettingsView.showUserProfileCallback = [Callback create:self selector:@selector(showUserProfile)];
    userSettingsView.showFeedbackFormCallback = [Callback create:self selector:@selector(showFeedbackForm)];
    userSettingsView.logoutCallback = [Callback create:self selector:@selector(logoutUser)];
	[self.view addSubview:userSettingsView];
    
    userProfileView = [[UserProfileView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    userProfileView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    userProfileView.onViewSourceClickedCallback = [Callback create:self selector:@selector(onViewSourceClicked:)];
    userProfileView.openUserProfileCallback = [Callback create:self selector:@selector(openUserProfile:)];
    
    [self.view addSubview:userProfileView];
    [self.view sendSubviewToBack:userProfileView];
    
}

- (void) viewDidLoad {
    if ([self.navigationController.viewControllers count] == 1) {
        if (settingsIconView == nil) {
            settingsIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"white-gear.png"]];
        }
        
        if (settingsIconViewTapGesture == nil) {
            settingsIconViewTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action: @selector(onClickAccount)];
            settingsIconViewTapGesture.numberOfTapsRequired = 1;
            settingsIconViewTapGesture.numberOfTouchesRequired = 1;
        }
        
        [settingsIconView addGestureRecognizer:settingsIconViewTapGesture];
        
        if (self.navigationItem.rightBarButtonItem == nil) {
            self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:settingsIconView] autorelease];
        }
    }
}

- (void) viewDidUnload {
    [settingsIconView removeGestureRecognizer:settingsIconViewTapGesture];
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    if (!userSettingsView.hidden) {
        userSettingsView.frame = CGRectMake(self.view.frame.size.width - 210, 0, userSettingsView.frame.size.width, userSettingsView.frame.size.height);
    }
    
}

- (void)dealloc {
    // release memory
    [userProfileView release];
	[userProfileSettingsView release];
    [userSettingsView release];
    [settingsIconView release];
    
    [tapGesture release];
    [settingsIconViewTapGesture release];
    [onLogoutCallback release];
    
    [super dealloc];
}


// --------------------------------------------------------------------------------
//                                  Provate functions
// --------------------------------------------------------------------------------

- (void) addPageTapGestureRecognizer {
    if (tapGesture == nil) {
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action: @selector(onPageClicked)];
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.numberOfTouchesRequired = 1;
    }
    [self.view addGestureRecognizer:tapGesture];
}

- (void) removePageTapGestureRecognizer {
    [self.view removeGestureRecognizer:tapGesture];
}


// --------------------------------------------------------------------------------
//                                  Requests
// --------------------------------------------------------------------------------

- (void) getLoggedInUserProfile {
    UserProfileRequest* userProfileRequest = [[[UserProfileRequest alloc] init] autorelease];
    userProfileRequest.errorCallback = [Callback create:self selector:@selector(onUserProfileRequestFailed:)];
    userProfileRequest.successCallback = [Callback create:self selector:@selector(onUserProfileRequestSuccess:)];
	[userProfileRequest getUserProfile];
}

- (void) getUserProfile:(NSString*)userName {
	UserProfileRequest* userProfileRequest = [[[UserProfileRequest alloc] init] autorelease];
    userProfileRequest.errorCallback = [Callback create:self selector:@selector(onUserProfileRequestFailed:)];
    userProfileRequest.successCallback = [Callback create:self selector:@selector(onUserProfileRequestSuccess:)];
	[userProfileRequest getUserProfile:userName];	
}

// --------------------------------------------------------------------------------
//                                  Callbacks
// --------------------------------------------------------------------------------

- (void) onApplicationBecomeActive: (NSNotification*)notification {
    [self setUserObject:[userProfileView getUserProfile]];
}

- (void) openUserProfile:(UserProfileObject*)user {
    ProfileViewController* profileViewController = [[[ProfileViewController alloc] init] autorelease];
    [profileViewController setUserObject:user];
    [self.navigationController pushViewController:profileViewController animated:YES];
    
}

- (void) onViewSourceClicked:(NSString*)sourceUrl {
    WebViewController* webViewController = [[[WebViewController alloc] init] autorelease];
    [self.navigationController pushViewController:webViewController animated:YES];
    [webViewController loadUrl:sourceUrl];
    
}

- (void) onClickAccount {
    if (userSettingsView.hidden) {
        /*userSettingsView.frame = CGRectMake(self.view.frame.size.width - 210, topToolbar.frame.size.height, userSettingsView.frame.size.width, userSettingsView.frame.size.height);*/
        if (DeviceUtils.isIphone) {
            userSettingsView.frame = CGRectMake(0, self.view.frame.size.height - 190, self.view.frame.size.width, 190);
        } else {
            userSettingsView.frame = CGRectMake((self.view.frame.size.width - 210), 0, 210, 145);
        }
        
        [userSettingsView showUserSettings];
        [self addPageTapGestureRecognizer];
    } else {
        userSettingsView.hidden = YES;
        [self removePageTapGestureRecognizer];
    }
    //[settingsMenu setMenuVisible:YES animated:YES];
}

- (void) onPageClicked {
    LOG_DEBUG(@"On Page clicked");
    if (userSettingsView.hidden == NO) {
        userSettingsView.hidden = YES;
        [self removePageTapGestureRecognizer];
    }
}

- (void) showUserProfile {
    [self removePageTapGestureRecognizer];
    if (DeviceUtils.isIphone) {
        userProfileSettingsView.frame = CGRectMake(5, (self.view.frame.size.height-190)/2, self.view.frame.size.width - 10, 190);
    } else {
        userProfileSettingsView.frame = CGRectMake((self.view.frame.size.width-500)/2, (self.view.frame.size.height-210)/2, 500, 210);
    }
    [userProfileSettingsView showUserProfile];
}

- (void) showFeedbackForm {
    [self removePageTapGestureRecognizer];
    FeedbackViewController* feedbackViewController = [[FeedbackViewController alloc] init];
    feedbackViewController.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    [self presentModalViewController:feedbackViewController animated:YES];
    
    [feedbackViewController loadFeedbackForm];
    [feedbackViewController release];
}

// --------------------------------------------------------------------------------
//                             Request Callbacks
// --------------------------------------------------------------------------------

- (void) onUserProfileRequestSuccess: (UserProfileResponse*)response {
    @try {
        if (response.success) {
            
            NSDictionary* result = [response userProfile];
            UserProfileObject* userProfile = [[[UserProfileObject alloc] initFromDictionary:result] autorelease];
            [userProfileView setUserProfile:userProfile];
            
        } else {
            NSString* errorMessage = [NSString stringWithFormat:@"We failed to retrieve user profile: %@", response.errorMessage];
            
            // show error message
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Failed to retrieve profile" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            [alertView release];		
            
            LOG_ERROR(@"request success but failed to show profile: %@", response.errorMessage);
        }
    }
    @catch (NSException *exception) {
        LOG_ERROR(@"We failed in parsinf user profile response.");
    }
    @finally {
        
    }
    
}

- (void) onUserProfileRequestFailed: (NSString*)errorMessage {
    NSString* errorString = [NSString stringWithFormat:@"We failed to retrieve user profile: %@", errorMessage];
	
	// show error message
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Failed to retrieve profile" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
	[alertView release];		
	
	LOG_ERROR(@"profile request error: %@", errorMessage);
}

// --------------------------------------------------------------------------------
//                          Public Functions
// --------------------------------------------------------------------------------

- (void) setUserObject:(UserProfileObject*)user {
    if (user != nil) {
        [self performSelector:@selector(getUserProfile:) withObject:user.userName];
    } else {
        [self performSelector:@selector(getLoggedInUserProfile) withObject:nil];
    }
}

- (void) openUserProfileForName:(NSString*)userName {
    [self performSelector:@selector(getUserProfile:) withObject:userName];
}

- (void) onTabInactivate {
    [userProfileView closePlayer];
}

- (void) onTabActivate {
    [self setUserObject:[userProfileView getUserProfile]];
}

- (void) onApplicationBecomeInactive {
    [self onTabInactivate];
}


@end
