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

- (void) onListRequestSuccess: (VideoListResponse*)response {
	if (response.success) {
		// save response and get videos
		videoListResponse = [response retain];
        if (isRefreshing) {
            if (videos == nil) {
                videos = [[response videos] retain]; 
                lastPageRequested = [response page];
                loadedAllVideos = false;
            } else {
                VideoObject* firstVideo = [videos objectAtIndex:0];
                NSUInteger i, count = [[response videos] count];
                for (i = 0; i < count; i++)
                {
                    VideoObject* newVideo = (VideoObject*)[[response videos] objectAtIndex:i];
                    if (newVideo.videoId == firstVideo.videoId) {
                        break;
                    }
                    
                    [videos insertObject:newVideo atIndex:i];
                }
                
            }
            
            refreshState = REFRESHED;
            [refreshStatusView setRefreshStatus:REFRESHED];
            
        } else {
            [videos addObjectsFromArray:[response videos]];
            loadMoreState = LOADED;
            lastPageRequested = [response page];
            if ([response total] == [videos count]) {
                loadedAllVideos = true;
            }
        }
        
		// refresh the table
		[videosTable reloadData];
		
		// LOG_DEBUG(@"list request success");
	} else {
		NSString* errorMessage = [NSString stringWithFormat:@"We failed to retrieve your videos: %@", response.errorMessage];
		
		// show error message
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Failed to retrieve videos" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		[alertView release];		
		
		LOG_ERROR(@"request success but failed to list videos: %@", response.errorMessage);
	}
    
    loadMoreState = LOAD_MORE_NONE;
    refreshState = REFRESH_NONE;
    [refreshStatusView setRefreshStatus:REFRESH_NONE];
    [refreshStatusView setHidden:YES];
    videosTable.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    isRefreshing = false;
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
	[videoListResponse release];
	
    [super dealloc];
}

@end
