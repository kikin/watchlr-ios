    //
//  MostViewedViewController.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "SavedVideosViewController.h"
#import "VideoResponse.h"

@implementation SavedVideosViewController

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    [super loadView];
    
    videosListView = [[SavedVideosListView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    videosListView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    videosListView.refreshListCallback = [Callback create:self selector:@selector(onClickRefresh)];
    videosListView.loadMoreDataCallback = [Callback create:self selector:@selector(onLoadMoreData)];
    videosListView.isViewRefreshable = true;
    [self.view addSubview:videosListView];
    [self.view sendSubviewToBack:videosListView];
	
	// request video list
    isRefreshing = true;
	[self doVideoListRequest:-1 withVideosCount:10];
}

- (void)dealloc {
	// release memory
    [videosListView release];
	[videoListRequest release];
    [super dealloc];
}

// --------------------------------------------------------------------------------
//                                  Callbacks
// --------------------------------------------------------------------------------
- (void) onApplicationBecomeActive: (NSNotification*)notification {
    isRefreshing = true;
    [self doVideoListRequest: -1 withVideosCount:10];
}

- (void) onClickRefresh {
    isRefreshing = true;
	[self doVideoListRequest:-1 withVideosCount:(lastPageRequested * 10)];
}

- (void) onLoadMoreData {
    isRefreshing = false;
    [self doVideoListRequest: (lastPageRequested + 1) withVideosCount:10];
}

// --------------------------------------------------------------------------------
//                             Request Callbacks
// --------------------------------------------------------------------------------

- (void) onListRequestSuccess: (VideoListResponse*)response {
    if (response.success) {
		// LOG_DEBUG(@"list request success");
        if ([videosListView count] == 0 || !isRefreshing) {
            lastPageRequested = [response page];
        }
        NSDictionary* args = [NSDictionary dictionaryWithObjectsAndKeys:
                              [response videos], @"videosList",
                              [NSNumber numberWithInt:[response count]], @"videoCount",
                              [NSNumber numberWithBool:isRefreshing], @"isRefreshing",
                              nil];
        [videosListView performSelectorInBackground:@selector(updateListWrapper:) withObject:args];
	} else {
        [videosListView resetLoadingStatus];
        isRefreshing = false;
        
		NSString* errorMessage = [NSString stringWithFormat:@"We failed to retrieve your videos: %@", response.errorMessage];
		
		// show error message
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Failed to retrieve videos" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		[alertView release];		
		
		LOG_ERROR(@"request success but failed to list videos: %@", response.errorMessage);
	}
}

- (void) onListRequestFailed: (NSString*)errorMessage {
    [videosListView resetLoadingStatus];
    isRefreshing = false;
    
    NSString* errorString = [NSString stringWithFormat:@"We failed to retrieve your videos: %@", errorMessage];
	
	// show error message
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Failed to retrieve videos" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
	[alertView release];		
	
	LOG_ERROR(@"list request error: %@", errorMessage);
}



// --------------------------------------------------------------------------------
//                          Public Functions
// --------------------------------------------------------------------------------

- (void) doVideoListRequest:(int)pageStart withVideosCount:(int)videosCount {
	// get the list of videos
	if (videoListRequest == nil) {
		videoListRequest = [[VideoListRequest alloc] init];
		videoListRequest.errorCallback = [Callback create:self selector:@selector(onListRequestFailed:)];
		videoListRequest.successCallback = [Callback create:self selector:@selector(onListRequestSuccess:)];
	}
	if ([videoListRequest isRequesting]) {
		[videoListRequest cancelRequest];
	}
	[videoListRequest doGetVideoListRequest:NO startingAt:pageStart withCount:videosCount];	
}

- (void) onTabInactivate {
    [videosListView closePlayer];
}

- (void) onTabActivate {
    [self onClickRefresh];
}

- (void) onApplicationBecomeInactive {
    [videosListView closePlayer];
}

@end
