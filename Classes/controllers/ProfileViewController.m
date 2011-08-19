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

@implementation ProfileViewController

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    [super loadView];
    
    userProfileView = [[UserProfileView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    userProfileView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    userProfileView.openUserProfileCallback = [Callback create:self selector:@selector(openUserProfile:)];
    [self.view addSubview:userProfileView];
    [self.view sendSubviewToBack:userProfileView];
}

- (void)dealloc {
    [userProfileView release];
    [super dealloc];
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
