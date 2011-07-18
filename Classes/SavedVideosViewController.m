    //
//  MostViewedViewController.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "SavedVideosViewController.h"
#import "VideoTableCell.h"
#import "VideoObject.h"

@implementation SavedVideosViewController

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    [super loadView];
	
    // request video lsit
    isRefreshing = true;
	[self doVideoListRequest:-1];
}

- (void) doVideoListRequest:(int)startIndex {
	// get the list of videos
	if (videoListRequest == nil) {
		videoListRequest = [[VideoListRequest alloc] init];
		videoListRequest.errorCallback = [Callback create:self selector:@selector(onListRequestFailed:)];
		videoListRequest.successCallback = [Callback create:self selector:@selector(onListRequestSuccess:)];
	}
	if ([videoListRequest isRequesting]) {
		[videoListRequest cancelRequest];
	}
	[videoListRequest doGetVideoListRequest:NO startingAt:startIndex];
}

- (void) onClickRefresh {
    isRefreshing = true;
	[self doVideoListRequest: -1];
}

- (void) onLoadMoreData {
    if (!loadedAllVideos) {
        isRefreshing = false;
        [self doVideoListRequest: (lastPageRequested + 1)];
    } else {
        loadMoreState = LOADED;
    }
}

- (void) onApplicationBecomeActive: (NSNotification*)notification {
    // LOG_DEBUG(@"Changing orientation");
    isRefreshing = true;
	[self doVideoListRequest: -1];
}

- (void) updateList:(NSArray*)videosList withLastPageRequested:(int)pageNumber andNumberOfVideos:(int)videoCount {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    if (videos == nil) {
        // This is the first time we are loading videos
        // we should create the new videos list element.
        videos = [[NSMutableArray alloc] init];
        
        for (NSDictionary* videoDic in videosList) {
            // create video from dictionnary
            VideoObject* videoObject = [[[VideoObject alloc] initFromDictionnary:videoDic] autorelease];
            [videos addObject:videoObject];
        }
        
        lastPageRequested = pageNumber;
        loadedAllVideos = false;
        
        [loadingView stopAnimating];
        
    } else if (isRefreshing) {
        // user wants to refresh the list
        // insert only those videos which are never inserted
        int firstVideoId = ((VideoObject*)[videos objectAtIndex:0]).videoId;
        int i = 0;
        for (NSDictionary* videoDic in videosList) {
            int videoId = [[videoDic objectForKey:@"id"] intValue];
            if (firstVideoId == videoId) {
                break;
            } else {
                // create video from dictionnary
                VideoObject* videoObject = [[[VideoObject alloc] initFromDictionnary:videoDic] autorelease];
                [videos insertObject:videoObject atIndex:i];
                ++i;
            }
        }
        
        // indicates refresh action is completed
        refreshState = REFRESHED;
        [refreshStatusView setRefreshStatus:REFRESHED];
        
    } else { 
        // Appending the videos retreived to the list
        for (NSDictionary* videoDic in videosList) {
            // create video from dictionnary
            VideoObject* videoObject = [[[VideoObject alloc] initFromDictionnary:videoDic] autorelease];
            [videos addObject:videoObject];
        }
        
        loadMoreState = LOADED;
        lastPageRequested = pageNumber;
        if (videoCount < 10) {
            loadedAllVideos = true;
        }
    }
    
    //LOG_DEBUG(@"Sending message to main thread to update videos list");
    [videosTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    
    loadMoreState = LOAD_MORE_NONE;
    refreshState = REFRESH_NONE;
    [refreshStatusView setRefreshStatus:REFRESH_NONE];
    [refreshStatusView setHidden:YES];
    videosTable.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    isRefreshing = false;
    
    [pool release];
}

- (void) updateListWrapper: (NSDictionary*)args {
    [self updateList:[args objectForKey:@"videosList"] withLastPageRequested:[[args objectForKey:@"pageNumber"] integerValue] andNumberOfVideos:[[args objectForKey:@"videoCount"] integerValue]];
}

- (void) onListRequestSuccess: (VideoListResponse*)response {
    if (response.success) {
		// LOG_DEBUG(@"list request success");
        NSDictionary* args = [NSDictionary dictionaryWithObjectsAndKeys:
                              [response videos], @"videosList",
                              [NSNumber numberWithInt:[response page]], @"pageNumber",
                              [NSNumber numberWithInt:[response count]], @"videoCount",
                              nil];
        [self performSelectorInBackground:@selector(updateListWrapper:) withObject:args];
	} else {
        loadMoreState = LOAD_MORE_NONE;
        refreshState = REFRESH_NONE;
        [refreshStatusView setRefreshStatus:REFRESH_NONE];
        [refreshStatusView setHidden:YES];
        videosTable.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
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
    loadMoreState = LOAD_MORE_NONE;
	refreshState = REFRESH_NONE;
    [refreshStatusView setRefreshStatus:REFRESH_NONE];
    [refreshStatusView setHidden:YES];
    videosTable.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    
    NSString* errorString = [NSString stringWithFormat:@"We failed to retrieve your videos: %@", errorMessage];
	
	// show error message
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Failed to retrieve videos" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
	[alertView release];		
	
	LOG_ERROR(@"list request error: %@", errorMessage);
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
	return @"Remove";
}

- (void)dealloc {
	// release memory
	[videoListRequest release];
    [super dealloc];
}

@end
