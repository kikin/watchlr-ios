    //
//  MostViewedViewController.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "LikedVideosViewController.h"
#import "VideoResponse.h"
#import "WebViewController.h"
#import "VideoDetailedViewController.h"

@implementation LikedVideosViewController

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    [super loadView];
    
    videosListView = [[VideosListView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    videosListView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    videosListView.refreshListCallback = [Callback create:self selector:@selector(onClickRefresh)];
    videosListView.loadMoreDataCallback = [Callback create:self selector:@selector(onLoadMoreData)];
    videosListView.onViewSourceClickedCallback = [Callback create:self selector:@selector(onViewSourceClicked:)];
    videosListView.openVideoDetailPageCallback = [Callback create:self selector:@selector(openVideoDetailPage:)];
    videosListView.playVideoCallback = [Callback create:self selector:@selector(playVideo:)];
    videosListView.closeVideoPlayerCallback = [Callback create:self selector:@selector(closeVideoPlayer)];
    videosListView.sendAllVideoFinishedMessageCallback = [Callback create:self selector:@selector(sendAllVideosFinishedMessage:)];
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
    
    if (videoPlayerViewController != nil) {
        [self.navigationController popToViewController:self animated:NO];
        [videoPlayerViewController release];
    }
    
    videoPlayerViewController = nil;
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
	[videoListRequest doGetVideoListRequest:YES startingAt:pageStart withCount:videosCount];	
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

- (void) openVideoDetailPage:(VideoObject*)video {
    VideoDetailedViewController* videoDeatiledViewController = [[[VideoDetailedViewController alloc] init] autorelease];
    [self.navigationController pushViewController:videoDeatiledViewController animated:YES];
    [videoDeatiledViewController setVideoObject:video shouldAllowVideoRemoval:NO];
}

- (void) playVideo:(VideoObject*)video {
    if (videoPlayerViewController == nil) {
        videoPlayerViewController = [[VideoPlayerViewController alloc] init];
        [videosListView setVideoPlayerViewControllerCallbacks:videoPlayerViewController];
    }
    
    bool isLeanBackMode = true;
    if (self.modalViewController == nil) {
        isLeanBackMode = false;
        [self presentModalViewController:videoPlayerViewController animated:NO];
    }
    
    [videoPlayerViewController playVideo:video];
    
    if (isLeanBackMode) {
        [videosListView trackAction:@"leanback-view" forVideo:video.videoId];
    } else {
        [videosListView trackAction:@"view" forVideo:video.videoId];
    }
}

- (void) closeVideoPlayer {
    if (videoPlayerViewController != nil) {
        [videoPlayerViewController closePlayer];
    }
}

- (void) sendAllVideosFinishedMessage:(NSNumber*)nextButtonClicked {
    if (videoPlayerViewController != nil) {
        [videoPlayerViewController sendAllVideosFinishedMessage:[nextButtonClicked boolValue]];
    }
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
        
		// show error message
        NSString* errorMessage = [NSString stringWithFormat:@"We failed to retrieve your videos: %@", response.errorMessage];
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Failed to retrieve videos" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		[alertView release];		
		
		LOG_ERROR(@"request success but failed to list videos: %@", response.errorMessage);
	}
}

- (void) onListRequestFailed: (NSString*)errorMessage {
    [videosListView resetLoadingStatus];
    isRefreshing = false;
    
	// show error message
    NSString* errorString = [NSString stringWithFormat:@"We failed to retrieve your videos: %@", errorMessage];
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
    if (self.navigationController.visibleViewController == self) {
        [self onClickRefresh];
    }
}

- (void) onApplicationBecomeInactive {
    isActiveTab = false;
    [videosListView closePlayer];
}

- (BOOL) shouldRotate {
    return [videosListView isVideoPlaying];
}

@end
