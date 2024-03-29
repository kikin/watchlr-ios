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
#import "WebViewController.h"
#import "FeedbackViewController.h"
#import "VideosViewController.h"
#import "UsersViewController.h"
#import "UserObject.h"

@implementation ProfileViewController

@synthesize onLogoutCallback;

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
    
    if (DeviceUtils.isIphone) {
        userProfileIphoneView = [[UserProfileIphoneView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        userProfileIphoneView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        userProfileIphoneView.showLikedVideosListCallback = [Callback create:self selector:@selector(showLikedVideosList:)];
        userProfileIphoneView.showFollowersListCallback = [Callback create:self selector:@selector(showFollowersList:)];
        userProfileIphoneView.showFollowingListCallback = [Callback create:self selector:@selector(showFollowingList:)];
        [self.view addSubview:userProfileIphoneView];
        [self.view sendSubviewToBack:userProfileIphoneView];
    } else {
        userProfileView = [[UserProfileView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        userProfileView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        userProfileView.onViewSourceClickedCallback = [Callback create:self selector:@selector(onViewSourceClicked:)];
        userProfileView.openUserProfileCallback = [Callback create:self selector:@selector(openUserProfile:)];
        [self.view addSubview:userProfileView];
        [self.view sendSubviewToBack:userProfileView];
    }
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

- (void)didReceiveMemoryWarning {
    if (!isActiveTab) {
        // release memory
        if (DeviceUtils.isIphone) {
            [userProfileIphoneView didReceiveMemoryWarning:true];
        } else {
            [userProfileView didReceiveMemoryWarning:true];
        }
        
        [tapGesture release];
        [settingsIconViewTapGesture release];
        
        settingsIconViewTapGesture = nil;
        tapGesture = nil;
        
        // we will not release callbacks 
        // as there is no way to recover them.
    } else {
        int level = [DeviceUtils currentMemoryLevel];
        if (level >= OSMemoryNotificationLevelUrgent) {
            if (DeviceUtils.isIphone) {
                [userProfileIphoneView didReceiveMemoryWarning:false];
            } else {
                [userProfileView didReceiveMemoryWarning:false];
            }
            
            [tapGesture release];
            [settingsIconViewTapGesture release];
            
            settingsIconViewTapGesture = nil;
            tapGesture = nil;
            
            // we will not release callbacks 
            // as there is no way to recover them.
        }
    }
    
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    // release memory
    [onLogoutCallback release];
    onLogoutCallback = nil;
    
    [tapGesture release];
    [settingsIconViewTapGesture release];
    
    settingsIconViewTapGesture = nil;
    tapGesture = nil;
    
    if (userProfileIphoneView != nil) {
        [userProfileIphoneView removeFromSuperview];
    }
    
    if (userProfileView != nil) {
        [userProfileView removeFromSuperview];
    }
    
	[userProfileSettingsView removeFromSuperview];
    [userSettingsView removeFromSuperview];
    [settingsIconView removeFromSuperview];
    
    userProfileIphoneView = nil;
    userProfileView = nil;
    userProfileSettingsView = nil;
    userSettingsView = nil;
    settingsIconView = nil;
    
    [super dealloc];
}


// --------------------------------------------------------------------------------
//                                  Private functions
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

- (void) logoutUser {
    // erase userId
	UserObject* userObject = [UserObject getUser];
	[userObject resetUser];
    
    if (onLogoutCallback != nil) {
        [onLogoutCallback execute:nil];
    }
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

- (void) getUserProfile:(NSNumber*)userId {
	UserProfileRequest* userProfileRequest = [[[UserProfileRequest alloc] init] autorelease];
    userProfileRequest.errorCallback = [Callback create:self selector:@selector(onUserProfileRequestFailed:)];
    userProfileRequest.successCallback = [Callback create:self selector:@selector(onUserProfileRequestSuccess:)];
	[userProfileRequest getUserProfile:[userId intValue]];	
}

- (void) getUserProfileForName:(NSString*)username {
	UserProfileRequest* userProfileRequest = [[[UserProfileRequest alloc] init] autorelease];
    userProfileRequest.errorCallback = [Callback create:self selector:@selector(onUserProfileRequestFailed:)];
    userProfileRequest.successCallback = [Callback create:self selector:@selector(onUserProfileRequestSuccess:)];
	[userProfileRequest getUserProfileForName:username];	
}

// --------------------------------------------------------------------------------
//                                  Callbacks
// --------------------------------------------------------------------------------

- (void) onApplicationBecomeActive: (NSNotification*)notification {
    if (DeviceUtils.isIphone) {
        [self setUserObject:[userProfileIphoneView getUserProfile]];
    } else {
        [self setUserObject:[userProfileView getUserProfile]];
    }
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
            userSettingsView.frame = CGRectMake(0, self.view.frame.size.height - 200, self.view.frame.size.width, 200);
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

- (void) showLikedVideosList:(NSNumber*) user_id {
    VideosViewController* videosViewController = [[[VideosViewController alloc] init] autorelease];
    [self.navigationController pushViewController:videosViewController animated:YES];
    [videosViewController setUserProfile:[user_id intValue]];
}

- (void) showFollowersList:(NSNumber*) user_id {
    UsersViewController* usersViewController = [[[UsersViewController alloc] init] autorelease];
    [self.navigationController pushViewController:usersViewController animated:YES];
    [usersViewController showFollowersList:[user_id intValue]];
}

- (void) showFollowingList:(NSNumber*) user_id {
    UsersViewController* usersViewController = [[[UsersViewController alloc] init] autorelease];
    [self.navigationController pushViewController:usersViewController animated:YES];
    [usersViewController showFollowingUsersList:[user_id intValue]];
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
            NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
            NSDictionary* result = [response userProfile];
            UserProfileObject* userProfile = [[UserProfileObject alloc] initFromDictionary:result];
            if (DeviceUtils.isIphone) {
                [userProfileIphoneView setUserProfile:userProfile];
            } else {
                [userProfileView setUserProfile:userProfile];
            }
            [userProfile release];
            [pool release];
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
    isActiveTab = true;
    if (user != nil) {
        [self performSelector:@selector(getUserProfile:) withObject:[NSNumber numberWithInt:user.userId]];
    } else {
        [self performSelector:@selector(getLoggedInUserProfile) withObject:nil];
    }
}

- (void) openUserProfileForName:(NSString*)userName {
    isActiveTab = true;
    [self performSelector:@selector(getUserProfileForName:) withObject:userName];
}

- (void) onTabInactivate {
    isActiveTab = false;
    if (!DeviceUtils.isIphone) {
        [userProfileView closePlayer];
    }
}

- (void) onTabActivate {
    isActiveTab = true;
    if (self == self.navigationController.visibleViewController) {
        if (DeviceUtils.isIphone) {
            [self setUserObject:[userProfileIphoneView getUserProfile]];
        } else {
            [self setUserObject:[userProfileView getUserProfile]];
        }
        
    }
}

- (void) onApplicationBecomeInactive {
    isActiveTab = false;
    [self onTabInactivate];
}

- (BOOL) shouldRotate {
    return NO;
}

@end
