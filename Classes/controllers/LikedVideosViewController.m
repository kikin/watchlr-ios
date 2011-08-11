    //
//  MostViewedViewController.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "LikedVideosViewController.h"
#import "VideoTableCell.h"

@implementation LikedVideosViewController

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    [super loadView];
	
	// request video list
    isRefreshing = true;
	[self doVideoListRequest:-1 withVideosCount:10];
}

- (void)dealloc {
	// release memory
	[videoListRequest release];
    [super dealloc];
}

// --------------------------------------------------------------------------------
//                             Private Functions
// --------------------------------------------------------------------------------

- (void) updateList:(NSArray*)videosList withLastPageRequested:(int)pageNumber andNumberOfVideos:(int)videoCount {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    if (videos == nil) {
        // This is the first time we are loading videos
        // we should create the new videos list element.
        videos = [[NSMutableArray alloc] init];
        
        for (NSDictionary* videoDic in videosList) {
            // create video from dictionnary
            VideoObject* videoObject = [[[VideoObject alloc] initFromDictionary:videoDic] autorelease];
            [videos addObject:videoObject];
        }
        
        lastPageRequested = pageNumber;
        if ((videoCount != 0) && ((videoCount % 10) == 0)) {
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
                VideoObject* videoObject = [[[VideoObject alloc] initFromDictionary:[videosList objectAtIndex:i]] autorelease];
                [videos insertObject:videoObject atIndex:i];
            }
            
            int lastSavedVideoListItemProcessedIndex = [videos count];
            for (int i = firstMatchedVideoIndex, j = firstMatchedVideoIndex; 
                 (i < [videosList count] && j < [videos count]);) 
            {
                NSDictionary* newVideoListItem = (NSDictionary*)[videosList objectAtIndex:i];
                VideoObject* savedVideoListItem = (VideoObject*)[videos objectAtIndex:j];
                
                if ([[newVideoListItem objectForKey:@"id"] intValue] == savedVideoListItem.videoId) {
                    [savedVideoListItem updateFromDictionary:newVideoListItem];
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
            
            if (lastSavedVideoListItemProcessedIndex < [videosList count]) {
                for (int i = lastSavedVideoListItemProcessedIndex; i < [videosList count]; i++) {
                    // create video from dictionnary
                    VideoObject* videoObject = [[[VideoObject alloc] initFromDictionary:[videosList objectAtIndex:i]] autorelease];
                    [videos insertObject:videoObject atIndex:i];
                }
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
            VideoObject* videoObject = [[[VideoObject alloc] initFromDictionary:videoDic] autorelease];
            [videos addObject:videoObject];
        }
        
        loadMoreState = LOADED;
        lastPageRequested = pageNumber;
        if ((videoCount != 0) && ((videoCount % 10) == 0)) {
            loadedAllVideos = false;
        } else {
            loadedAllVideos = true;            
        }
    }
    
    // LOG_DEBUG(@"Sending message to main thread to update videos list");
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
    if (!loadedAllVideos) {
        isRefreshing = false;
        [self doVideoListRequest: (lastPageRequested + 1) withVideosCount:10];
    } else {
        loadMoreState = LOADED;
    }
}

// --------------------------------------------------------------------------------
//                             Request Callbacks
// --------------------------------------------------------------------------------

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

// --------------------------------------------------------------------------------
// TableView delegates/datasource
// --------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"VideoTableCell";
	
	// try to reuse an id
    VideoTableCell* cell = (VideoTableCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        // Create the cell
        cell = [[[VideoTableCell alloc] initWithStyle:UITableViewCellEditingStyleDelete reuseIdentifier:CellIdentifier] autorelease];
		cell.playVideoCallback = [Callback create:self selector:@selector(playVideo:)];
        cell.likeVideoCallback = [Callback create:self selector:@selector(onVideoLiked:)];
        cell.unlikeVideoCallback = [Callback create:self selector:@selector(onVideoUnliked:)];
    }
	
	if (indexPath.row < videos.count) {
		// Update data for the cell
		VideoObject* videoObject = [videos objectAtIndex:indexPath.row];
		[cell setVideoObject: videoObject];
        
        if (indexPath.row == (videos.count - 1)) {
            if (loadMoreState != LOADING) {
                LOG_DEBUG(@"Loading more data");
                loadMoreState = LOADING;
                [self onLoadMoreData];
            }
        }
	}
	
    return cell;
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
	[videoListRequest doGetVideoListRequest:YES startingAt:pageStart withCount:videosCount];	
}

@end
