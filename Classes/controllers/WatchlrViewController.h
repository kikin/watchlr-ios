//
//  MostViewedViewController.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserProfileSettingsView.h"
#import "UserSettingsView.h"
#import "CommonIos/Callback.h"


/** Video List View Controller. */
@interface WatchlrViewController : UIViewController {
	UserProfileSettingsView* userProfileSettingsView;
    UserSettingsView* userSettingsView;
    
    Callback* onLogoutCallback;
}

- (void) onClickAccount;
- (void) showUserProfile;
- (void) showFeedbackForm;
- (void) logoutUser;
- (void) onApplicationBecomeInactive;

- (void) onTabInactivate;
- (void) onTabActivate;

@property(retain) Callback* onLogoutCallback;

@end
