//
//  MostViewedViewController.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "WatchlrViewController.h"
#import "VideoListRequest.h"
#import "VideosListView.h"
#import "VideoPlayerViewController.h"

@interface LikedVideosViewController : WatchlrViewController {
	VideoListRequest* videoListRequest;
    VideosListView* videosListView;
    VideoPlayerViewController* videoPlayerViewController;
    
    int lastPageRequested;
    bool isRefreshing;
    bool isActiveTab;
}

@end
