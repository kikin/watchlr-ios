//
//  MostViewedViewController.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "WatchlrViewController.h"
#import "VideoListRequest.h"
#import "SavedVideosListView.h"
#import "VideoPlayerViewController.h"

@interface SavedVideosViewController : WatchlrViewController {
	VideoListRequest* videoListRequest;
    SavedVideosListView* videosListView;
    VideoPlayerViewController* videoPlayerViewController;
    
	int lastPageRequested;
    bool isRefreshing;
    bool isActiveTab;
}

@end
