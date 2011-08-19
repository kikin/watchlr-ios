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

@interface SavedVideosViewController : WatchlrViewController {
	VideoListRequest* videoListRequest;
    SavedVideosListView* videosListView;
    
	int lastPageRequested;
    bool isRefreshing;
}

- (void) doVideoListRequest:(int)pageStart withVideosCount:(int)videosCount;

@end
