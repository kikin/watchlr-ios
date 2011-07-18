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
#import "LikeVideoRequest.h"
#import "UnlikeVideoRequest.h"
#import "AddVideoRequest.h"
#import "UserProfileView.h"
#import "UserSettingsView.h"
#import "RefreshStatusView.h"
#import "VideoPlayerView.h"
#import "CommonIos/Callback.h"

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

/** Loading more videos. */
typedef enum {
    LOAD_MORE_NONE,
    LOADING,
    LOADED
} LoadMoreState;
 

/** Video List View Controller. */
@interface KikinVideoViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	LikeVideoRequest* likeVideoRequest;
    UnlikeVideoRequest* unlikeVideoRequest;
    AddVideoRequest* addVideoRequest;
    DeleteVideoRequest* deleteVideoRequest;
    
	UITableView* videosTable;
    UIBarButtonItem* accountButton;
	KikinVideoToolBar* topToolbar;
	UserProfileView* userProfileView;
    UserSettingsView* userSettingsView;
    RefreshStatusView* refreshStatusView;
    VideoPlayerView* videoPlayerView;
    UIActivityIndicatorView* loadingView;
    
    Callback* onLogoutCallback;
    
    NSMutableArray* videos;
    RefreshState refreshState;
    LoadMoreState loadMoreState;
    
    bool loadedAllVideos;
    int lastPageRequested;
}

- (void) onClickAccount;
- (void) onClickRefresh;
- (void) onLoadMoreData;
- (void) onVideoLiked:(VideoObject*)videoObject;
- (void) onVideoUnliked:(VideoObject*)videoObject;
- (void) onVideoSaved:(VideoObject*)videoObject;
- (void) onVideoRemoved:(VideoObject*)videoObject;
- (void) playVideo:(VideoObject*)videoObject;
- (void) showUserProfile;
- (void) showFeedbackForm;
- (void) logoutUser;
- (void) onApplicationBecomeInactive;


@property(retain) Callback* onLogoutCallback;

@end
