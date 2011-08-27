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

@interface LikedVideosViewController : WatchlrViewController {
	VideoListRequest* videoListRequest;
    VideosListView* videosListView;
    
    int lastPageRequested;
    bool isRefreshing;
    bool isActiveTab;
}

@end
