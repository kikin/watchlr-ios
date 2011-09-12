//
//  ConnectMainView.h
//  KikinVideo
//
//  Created by ludovic cabre on 5/6/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CommonIos/Callback.h>
#import "VideoPlayerView.h"
#import "RefreshStatusView.h"
#import "VideoPlayerViewController.h"

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

@interface VideosListView : UIView<UITableViewDelegate, UITableViewDataSource> {
    UITableView*                videosListView;
    NSMutableArray*             videosList;
    VideoPlayerView*            videoPlayerView;
    RefreshStatusView*          refreshStatusView;
    UIActivityIndicatorView*    loadingView;
    
    RefreshState                refreshState;
    LoadMoreState               loadMoreState;
    bool                        loadedAllVideos;
    bool                        isRefreshing;
    bool                        userTappedDetailButton;
}

@property()         bool isViewRefreshable;
@property(retain)   Callback* refreshListCallback;
@property(retain)   Callback* loadMoreDataCallback;
@property(retain)   Callback* addVideoPlayerCallback;
@property(retain)   Callback* onViewSourceClickedCallback;
@property(retain)   Callback* openVideoDetailPageCallback;
@property(retain)   Callback* playVideoCallback;
@property(retain)   Callback* closeVideoPlayerCallback;
@property(retain)   Callback* sendAllVideoFinishedMessageCallback;

- (void)    updateListWrapper: (NSDictionary*)args;
- (int)     count;
- (void)    resetLoadingStatus;
- (void)    closePlayer;
- (void)    didReceiveMemoryWarning;
- (bool)    isVideoPlaying;
- (void)    setVideoPlayerViewControllerCallbacks:(VideoPlayerViewController*)videoPlayerViewController;

- (void) trackAction:(NSString*)action forVideo:(int)vid;
- (void) trackEvent:(NSString*)name withValue:(NSString*)value;
- (void) trackError:(NSString*)error from:(NSString*)where withMessage:(NSString*)message;

@end
