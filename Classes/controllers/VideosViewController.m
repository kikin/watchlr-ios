    //
//  MostViewedViewController.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "VideosViewController.h"
#import "WebViewController.h"
#import "VideoDetailedViewController.h"
#import "UserProfileRequest.h"
#import "UserProfileResponse.h"

@implementation VideosViewController

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    [super loadView];
    
    videosListView = [[VideosListView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    videosListView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    videosListView.loadMoreDataCallback = [Callback create:self selector:@selector(onLoadMoreData)];
    videosListView.onViewSourceClickedCallback = [Callback create:self selector:@selector(onViewSourceClicked:)];
    videosListView.openVideoDetailPageCallback = [Callback create:self selector:@selector(openVideoDetailPage:)];
    videosListView.playVideoCallback = [Callback create:self selector:@selector(playVideo:)];
    videosListView.closeVideoPlayerCallback = [Callback create:self selector:@selector(closeVideoPlayer)];
    videosListView.sendAllVideoFinishedMessageCallback = [Callback create:self selector:@selector(sendAllVideosFinishedMessage:)];
    videosListView.isViewRefreshable = false;
    [self.view addSubview:videosListView];
    [self.view sendSubviewToBack:videosListView]; 
	
	// request video list
//    isRefreshing = true;
//	[self doVideoListRequest:-1 withVideosCount:10];
}

- (void) didReceiveMemoryWarning {
    if (!isActiveTab) {
        [videosListView didReceiveMemoryWarning];
    } else {
        int level = [DeviceUtils currentMemoryLevel];
        if (level >= OSMemoryNotificationLevelUrgent) {
            [videosListView didReceiveMemoryWarning];
        }
    }
    
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
	// release memory
    [videosListView removeFromSuperview];
    
    if (videoPlayerViewController != nil) {
        [self.navigationController popToViewController:self animated:NO];
        [videoPlayerViewController release];
    }
    
    videoPlayerViewController = nil;
    videosListView = nil;
    [super dealloc];
}

// --------------------------------------------------------------------------------
//                                  Requests
// --------------------------------------------------------------------------------

- (void) getLikedVideos:(int)user_id forPage:(int)pageNumber withVideosCount:(int)videosCount {
    UserProfileRequest* userProfileRequest = [[[UserProfileRequest alloc] init] autorelease];
    userProfileRequest.errorCallback = [Callback create:self selector:@selector(onLikedVideosRequestFailed:)];
    userProfileRequest.successCallback = [Callback create:self selector:@selector(onLikedVideosRequestSuccess:)];
	[userProfileRequest getLikedVideosByUser:user_id forPage:pageNumber withVideosCount:videosCount];
}

// --------------------------------------------------------------------------------
//                                  Callbacks
// --------------------------------------------------------------------------------
- (void) onApplicationBecomeActive: (NSNotification*)notification {
    isRefreshing = true;
    [self getLikedVideos:userId forPage:-1 withVideosCount:10];
}

- (void) onLoadMoreData {
    isRefreshing = false;
    [self getLikedVideos:userId forPage:(lastPageRequested + 1) withVideosCount:10];
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

- (void) onLikedVideosRequestSuccess: (UserProfileResponse*)response {
    if (response.success) {
        NSDictionary* result = [response userProfile];
        
        if ([videosListView count] == 0 || !isRefreshing) {
            lastPageRequested = [result objectForKey:@"page"] != [NSNull null] ? [[result objectForKey:@"page"] intValue] : 1;
        }
        
        int total = [result objectForKey:@"total"] != [NSNull null] ? [[result objectForKey:@"total"] intValue] : 0;
        NSDictionary* args = [NSDictionary dictionaryWithObjectsAndKeys:
                              [result objectForKey:@"videos"], @"videosList",
                              [NSNumber numberWithInt:total], @"videoCount",
                              [NSNumber numberWithBool:isRefreshing], @"isRefreshing",
                              [NSNumber numberWithInt:lastPageRequested], @"lastPageRequested",
                              nil];
        [videosListView performSelectorInBackground:@selector(updateListWrapper:) withObject:args];
	} else {
        [videosListView resetLoadingStatus];
        
		NSString* errorMessage = [NSString stringWithFormat:@"We failed to retrieve user videos: %@", response.errorMessage];
		
		// show error message
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Failed to retrieve videos" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		[alertView release];		
		
		LOG_ERROR(@"request success but failed to list videos: %@", response.errorMessage);
	}
}

- (void) onLikedVideosRequestFailed: (NSString*)errorMessage {
    [videosListView resetLoadingStatus];
    
    NSString* errorString = [NSString stringWithFormat:@"We failed to retrieve user videos: %@", errorMessage];
	
	// show error message
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Failed to retrieve videos" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
	[alertView release];		
	
	LOG_ERROR(@"list request error: %@", errorMessage);
}

// --------------------------------------------------------------------------------
//                          Public Functions
// --------------------------------------------------------------------------------

- (void) setUserProfile:(int)user_id {
    userId = user_id;
    [self getLikedVideos:userId forPage:-1 withVideosCount:10];
}

- (void) onTabInactivate {
    isActiveTab = false;
    [videosListView closePlayer];
}

- (void) onTabActivate {
    isActiveTab = true;
    if (self.navigationController.visibleViewController == self) {
        if ([videosListView count] == 0) {
            [self getLikedVideos:userId forPage:-1 withVideosCount:10];
        }
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
