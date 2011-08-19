//
//  ConnectMainView.h
//  KikinVideo
//
//  Created by ludovic cabre on 5/6/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CommonIos/Callback.h>

@interface UserSettingsView : UIView {
    UISegmentedControl* userProfileButton;
    UISegmentedControl* feedbackButton;
    UISegmentedControl* logoutButton;
    UISegmentedControl* cancelButton;
    
    Callback* showUserProfileCallback;
    Callback* showFeedbackFormCallback;
    Callback* logoutCallback;
}

@property(retain) Callback* showUserProfileCallback;
@property(retain) Callback* showFeedbackFormCallback;
@property(retain) Callback* logoutCallback;

-(void) showUserSettings;

@end
