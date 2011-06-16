//
//  MostViewedViewController.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerViewController.h"
#import "DeleteVideoRequest.h"
#import "UserProfileView.h"
#import "UserSettingsView.h"
#import "RefreshStatusView.h"

/** Cutomized tool bar. */
@interface KikinVideoToolBar : UIToolbar {
    UIImageView* kikinLogo;
}
@end

/** Refresh States. */
typedef enum {
    REFRESH_NONE,
    PULLING_DOWN,
    RELEASING,
    REFRESHING,
    REFRESHED
} RefreshState;

/** Video List View Controller. */
@interface KikinVideoViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	DeleteVideoRequest* deleteVideoRequest;
	UITableView* videosTable;
    UIBarButtonItem* accountButton;
	KikinVideoToolBar* topToolbar;
	UserProfileView* userProfileView;
    UserSettingsView* userSettingsView;
    RefreshStatusView* refreshStatusView;
    
    NSMutableArray* videos;
    RefreshState state;
    // UIViewController* settingsMenu;
    
}

- (void) onClickAccount;
- (void) onClickRefresh;
- (void) playVideo:(VideoObject*)videoObject;
- (void) showUserProfile;
- (void) showFeedbackForm;
- (void) logoutUser;

@end
