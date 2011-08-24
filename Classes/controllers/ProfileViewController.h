//
//  MostViewedViewController.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "WatchlrViewController.h"
#import "UserProfileView.h"

@interface ProfileViewController: WatchlrViewController {
    UserProfileView* userProfileView;
    UserProfileSettingsView* userProfileSettingsView;
    UserSettingsView* userSettingsView;
    UIImageView* settingsIconView;
    
    UITapGestureRecognizer* tapGesture;
    UITapGestureRecognizer* settingsIconViewTapGesture;
    
    Callback* onLogoutCallback;
}

- (void) setUserObject:(UserProfileObject*)userObject;
- (void) openUserProfileForName:(NSString*)userName;

@end
