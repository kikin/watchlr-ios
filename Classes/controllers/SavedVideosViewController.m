    //
//  MostViewedViewController.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "SavedVideosViewController.h"
#import "VideoResponse.h"
#import "WebViewController.h"

@implementation SavedVideosViewController

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    [super loadView];
    
    videosListView = [[SavedVideosListView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    videosListView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    videosListView.refreshListCallback = [Callback create:self selector:@selector(onClickRefresh)];
    videosListView.loadMoreDataCallback = [Callback create:self selector:@selector(onLoadMoreData)];
    videosListView.onViewSourceClickedCallback = [Callback create:self selector:@selector(onViewSourceClicked:)];
    videosListView.isViewRefreshable = true;
    [self.view addSubview:videosListView];
    [self.view sendSubviewToBack:videosListView];
	
	// request video list
    isRefreshing = true;
//	[self doVideoListRequest:-1 withVideosCount:10];
}

- (void) didReceiveMemoryWarning {
    if (!isActiveTab) {
        [videosListView didReceiveMemoryWarning];
        
        [videoListRequest release];
        videoListRequest = nil;
    } else {
        int level = [DeviceUtils currentMemoryLevel];
        if (level >= OSMemoryNotificationLevelUrgent) {
            [videosListView didReceiveMemoryWarning];
            
            [videoListRequest release];
            videoListRequest = nil;
        }
    }
    
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
	// release memory
    [videosListView removeFromSuperview];
	[videoListRequest release];
    
    videosListView = nil;
    videoListRequest = nil;
    [super dealloc];
}

// --------------------------------------------------------------------------------
//                          Private Functions
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

- (void) onViewSourceClicked:(NSString*)sourceUrl {
    WebViewController* webViewController = [[[WebViewController alloc] init] autorelease];
    [self.navigationController pushViewController:webViewController animated:YES];
    [webViewController loadUrl:sourceUrl];
    
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
                              [NSNumber numberWithInt:[response total]], @"videoCount",
                              [NSNumber numberWithBool:isRefreshing], @"isRefreshing",
                              [NSNumber numberWithInt:lastPageRequested], @"lastPageRequested",
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

- (void) onTabInactivate {
    isActiveTab = false;
    [videosListView closePlayer];
}

- (void) onTabActivate {
    isActiveTab = true;
    [self onClickRefresh];
}

- (void) onApplicationBecomeInactive {
    isActiveTab = false;
    [videosListView closePlayer];
}

@end
