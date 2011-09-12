//
//  MostViewedViewController.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "WatchlrViewController.h"
#import "VideosListView.h"
#import "VideoPlayerViewController.h"

@interface VideosViewController : WatchlrViewController {
	VideosListView*     videosListView;
    VideoPlayerViewController* videoPlayerViewController;
    
    int                 lastPageRequested;
    bool                isRefreshing;
    bool                isActiveTab;
    
    int                 userId;
}

- (void) setUserProfile:(int)user_id;

@end
