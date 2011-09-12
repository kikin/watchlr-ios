//
//  MostViewedViewController.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "WatchlrViewController.h"
#import "UserProfileView.h"
#import "UserProfileIphoneView.h"

@interface ProfileViewController: WatchlrViewController {
    UserProfileView* userProfileView;
    UserProfileIphoneView* userProfileIphoneView;
    UserProfileSettingsView* userProfileSettingsView;
    UserSettingsView* userSettingsView;
    UIImageView* settingsIconView;
    
    UITapGestureRecognizer* tapGesture;
    UITapGestureRecognizer* settingsIconViewTapGesture;
    
    Callback* onLogoutCallback;
    
    bool isActiveTab;
}

@property(retain) Callback* onLogoutCallback;

- (void) setUserObject:(UserProfileObject*)userObject;
- (void) openUserProfileForName:(NSString*)userName;

@end
