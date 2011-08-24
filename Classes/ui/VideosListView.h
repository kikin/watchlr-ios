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
}

@property()         bool isViewRefreshable;
@property(retain)   Callback* refreshListCallback;
@property(retain)   Callback* loadMoreDataCallback;
@property(retain)   Callback* addVideoPlayerCallback;
@property(retain)   Callback* onViewSourceClickedCallback;

- (void)    updateListWrapper: (NSDictionary*)args;
- (int)     count;
- (void)    resetLoadingStatus;
- (void)    closePlayer;

@end
