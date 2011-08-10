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
	[self doVideoListRequest:-1 withVideosCount:10];
}

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

- (void) onClickRefresh {
    isRefreshing = true;
	[self doVideoListRequest: -1 withVideosCount:(lastPageRequested * 10)];
}

- (void) onLoadMoreData {
    if (!loadedAllVideos) {
        isRefreshing = false;
        [self doVideoListRequest: (lastPageRequested + 1) withVideosCount:10];
    } else {
        loadMoreState = LOADED;
    }
}

- (void) onApplicationBecomeActive: (NSNotification*)notification {
    // LOG_DEBUG(@"Changing orientation");
    isRefreshing = true;
	[self doVideoListRequest: -1 withVideosCount:10];
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
        if ((videoCount % 10) == 0) {
            loadedAllVideos = false;
        } else {
            loadedAllVideos = true;            
        }
        
    } else if (isRefreshing) {
        // We are doing this odd logic intead of replacing all the video elements 
        // because we don't want to make extra calls to fetch thumbnail and favicon, 
        // everytime user refreshes their list or switch between tabs
        
        // user wants to refresh the list
        // insert only those videos which are never inserted
        NSUInteger firstMatchedVideoIndex = NSNotFound;
        if ([videos count] > 0) {
            for (int i = 0; i < [videos count]; i++) {
                VideoObject* video = [videos objectAtIndex:i];
                firstMatchedVideoIndex = [videosList indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                    if ([[(NSDictionary*)(obj) objectForKey:@"id"] intValue] == video.videoId) {
                        *stop = YES;
                        return YES;
                    }
                    return NO;
                }];
                
                if (firstMatchedVideoIndex != NSNotFound) {
                    break;
                }
                
                [videos removeObject:video];
                i--;
            }
            
        }
        
        if (firstMatchedVideoIndex != NSNotFound) {
            // add all the videos to the list that were not present before
            for (int i = 0; i < firstMatchedVideoIndex; i++) {
                // create video from dictionnary
                VideoObject* videoObject = [[[VideoObject alloc] initFromDictionnary:[videosList objectAtIndex:i]] autorelease];
                [videos insertObject:videoObject atIndex:i];
            }
            
            int lastSavedVideoListItemProcessedIndex = [videos count];
            for (int i = firstMatchedVideoIndex, j = firstMatchedVideoIndex; i < [videosList count];) {
                NSDictionary* newVideoListItem = (NSDictionary*)[videosList objectAtIndex:i];
                VideoObject* savedVideoListItem = (VideoObject*)[videos objectAtIndex:j];
                
                if ([[newVideoListItem objectForKey:@"id"] intValue] == savedVideoListItem.videoId) {
                    savedVideoListItem.likes = [[newVideoListItem objectForKey:@"likes"] intValue];
                    savedVideoListItem.liked = [[newVideoListItem objectForKey:@"liked"] boolValue];
                    j++;
                    i++;
                } else {
                    [videos removeObject:savedVideoListItem];
                }
                
                lastSavedVideoListItemProcessedIndex = j;
            }
            
            if (lastSavedVideoListItemProcessedIndex < [videos count]) {
                NSRange range = NSMakeRange(lastSavedVideoListItemProcessedIndex, ([videos count] - lastSavedVideoListItemProcessedIndex));
                [videos removeObjectsInRange:range];
                loadedAllVideos = false;
            }
        }
        
        // NOTE: please don't update lastPageRequested over here
        //       otherwise it will screw the logic for loading more videos.
        //       Refresh can request for more than 10 videos in the
        //       single page. So updating it here will screw the last page 
        //       requested number. If you really want to update the last page 
        //       requested over here. Then my suggestion would be to divide
        //       the videos count with 10 and then update the page number accordingly.
        
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
        if ((videoCount % 10) == 0) {
            loadedAllVideos = false;
        } else {
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
    
    if ([loadingView isAnimating]) {
        [loadingView stopAnimating];
    }
    
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
        if ([loadingView isAnimating]) {
            [loadingView stopAnimating];
        }
        
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
    if ([loadingView isAnimating]) {
        [loadingView stopAnimating];
    }
    
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

- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath {
	return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (deleteVideoRequest == nil) {
		// create a delete request if not already done
		deleteVideoRequest = [[DeleteVideoRequest alloc] init];
		deleteVideoRequest.errorCallback = [Callback create:self selector:@selector(onDeleteRequestFailed:)];
		deleteVideoRequest.successCallback = [Callback create:self selector:@selector(onDeleteRequestSuccess:)];
	}
	
	// get the video item
	if (indexPath.row < videos.count) {
		VideoObject* video = [videos objectAtIndex:indexPath.row];
		
		// cancel any current request
		if ([deleteVideoRequest isRequesting]) {
			[deleteVideoRequest cancelRequest];
		}
		
		// LOG_DEBUG(@"delete idx = %ld %ld", indexPath.row, video);
		
		// do the request
		[deleteVideoRequest doDeleteVideoRequest:video];
	}
}


- (void)dealloc {
	// release memory
	[videoListRequest release];
    [super dealloc];
}

@end