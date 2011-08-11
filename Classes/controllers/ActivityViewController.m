    //
//  MostViewedViewController.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "ActivityViewController.h"
#import "ActivityTableCell.h"
#import "ActivityObject.h"

@implementation ActivityViewController

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    [super loadView];
    
    videosTable.rowHeight = DeviceUtils.isIphone ? 100 : 180;
	
    // request video lsit
    isRefreshing = true;
	[self doUserActivityListRequest:NO startingAt:-1 withCount:10];
}

- (void)dealloc {
	// release memory
	[activities release];
    [activityListRequest release];
    [super dealloc];
}

// --------------------------------------------------------------------------------
//                             Private Functions
// --------------------------------------------------------------------------------

- (void) updateList:(NSArray*)activitiesList withLastPageRequested:(int)pageNumber andNumberOfVideos:(int)activityCount {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    if (activities == nil) {
        // This is the first time we are loading videos
        // we should create the new videos list element.
        videos = [[NSMutableArray alloc] init];
        activities = [[NSMutableArray alloc] init];
        
        for (NSDictionary* activityDic in activitiesList) {
            // create video from dictionnary
            ActivityObject* activity = [[[ActivityObject alloc] initFromDictionary:activityDic] autorelease];
            [activities addObject:activity];
            activity.video.savedInCurrentTab = false;
            [videos addObject:activity.video];
        }
        
        lastPageRequested = pageNumber;
        if ((activityCount % 10) == 0) {
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
        NSUInteger firstMatchedActicityIndex = NSNotFound;
        if ([activities count] > 0) {
            for (int i = 0; i < [activities count]; i++) {
                ActivityObject* activity = [activities objectAtIndex:i];
                firstMatchedActicityIndex = [activitiesList indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                    NSDictionary* video = [obj objectForKey:@"video"];
                    if ([[video objectForKey:@"id"] intValue] == activity.video.videoId) {
                        *stop = YES;
                        return YES;
                    }
                    return NO;
                }];
                
                if (firstMatchedActicityIndex != NSNotFound) {
                    break;
                }
                
                [activities removeObject:activity];
                [videos removeObjectAtIndex:i];
                i--;
            }
            
        }
        
        if (firstMatchedActicityIndex != NSNotFound) {
            // add all the videos to the list that were not present before
            for (int i = 0; i < firstMatchedActicityIndex; i++) {
                // create video from dictionnary
                ActivityObject* activity = [[[ActivityObject alloc] initFromDictionary:[activitiesList objectAtIndex:i]] autorelease];
                [activities insertObject:activity atIndex:i];
                activity.video.savedInCurrentTab = false;
                [videos insertObject:activity.video atIndex:i];
            }
            
            int lastActicvityItemProcessedIndex = [activities count];
            for (int i = firstMatchedActicityIndex, j = firstMatchedActicityIndex; i < [activitiesList count];) {
                NSDictionary* newActivityItem = (NSDictionary*)[activitiesList objectAtIndex:i];
                ActivityObject* activityListItem = (ActivityObject*)[activities objectAtIndex:j];
                
                NSDictionary* newActivityVideo = [newActivityItem objectForKey:@"video"];
                if ([[newActivityVideo objectForKey:@"id"] intValue] == activityListItem.video.videoId) {
                    [activityListItem updateFromDictionary:newActivityItem];
                    activityListItem.video.savedInCurrentTab = false;
                    [videos replaceObjectAtIndex:j withObject:activityListItem.video];
                    j++;
                    i++;
                } else {
                    [activities removeObject:activityListItem];
                    [videos removeObjectAtIndex:j];
                }
                
                lastActicvityItemProcessedIndex = j;
            }
            
            if (lastActicvityItemProcessedIndex < [activities count]) {
                NSRange range = NSMakeRange(lastActicvityItemProcessedIndex, ([activities count] - lastActicvityItemProcessedIndex));
                [activities removeObjectsInRange:range];
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
        for (NSDictionary* activityDic in activitiesList) {
            // create video from dictionnary
            ActivityObject* activityObject = [[[ActivityObject alloc] initFromDictionary:activityDic] autorelease];
            [activities addObject:activityObject];
            activityObject.video.savedInCurrentTab = false;
            [videos addObject:activityObject.video];
        }
        
        loadMoreState = LOADED;
        lastPageRequested = pageNumber;
        if ((activityCount % 10) == 0) {
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
    [self updateList:[args objectForKey:@"activitiesList"] withLastPageRequested:[[args objectForKey:@"pageNumber"] integerValue] andNumberOfVideos:[[args objectForKey:@"videoCount"] integerValue]];
}

// --------------------------------------------------------------------------------
//                                  Callbacks
// --------------------------------------------------------------------------------

- (void) onClickRefresh {
    isRefreshing = true;
	[self doUserActivityListRequest:NO startingAt:-1 withCount:(lastPageRequested * 10)];
}

- (void) onLoadMoreData {
    if (!loadedAllVideos) {
        isRefreshing = false;
        [self doUserActivityListRequest:NO startingAt:(lastPageRequested + 1) withCount:10];
    } else {
        loadMoreState = LOADED;
    }
}

- (void) onApplicationBecomeActive: (NSNotification*)notification {
    // LOG_DEBUG(@"Changing orientation");
    isRefreshing = true;
	[self doUserActivityListRequest:NO startingAt:-1 withCount:10];
}

// --------------------------------------------------------------------------------
//                             Request Callbacks
// --------------------------------------------------------------------------------

- (void) onListRequestSuccess: (UserActivityListResponse*)response {
    if (response.success) {
		// LOG_DEBUG(@"list request success");
        NSDictionary* args = [NSDictionary dictionaryWithObjectsAndKeys:
                              [response activities], @"activitiesList",
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

// Overriding base class method
- (void) onAddVideoRequestSuccess: (AddVideoResponse*)response {
//     [super onAddVideoRequestSuccess:response]; 
	if (response.success) {
        VideoObject* videoObject = response.videoObject;
        NSUInteger idx = [videos indexOfObject:videoObject];
		videoObject.saved = true;
        ActivityObject* activity = (ActivityObject*)[activities objectAtIndex:idx];
        activity.video = videoObject;
        [activities replaceObjectAtIndex:idx withObject:activity];
        [videos replaceObjectAtIndex:idx withObject:videoObject];
        
		
		[videosTable beginUpdates];
		NSIndexPath *index = [NSIndexPath indexPathForRow:idx inSection:0];
        if (index.row < activities.count) {
            // Update data for the cell
            // LOG_DEBUG(@"Updating video object.");
            ActivityTableCell* cell = (ActivityTableCell*)[videosTable cellForRowAtIndexPath:index];
            [cell updateSaveButton:activity];
        }
        [videosTable endUpdates];
        
        [self trackAction:@"save" forVideo:response.videoObject.videoId];
    } else {
        LOG_ERROR(@"request success but failed to save video: %@", response.errorMessage);
    }
}

// --------------------------------------------------------------------------------
//                      TableView delegates/datasource
// --------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"VideoTableCell";
	
	// try to reuse an id
    ActivityTableCell* cell = (ActivityTableCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        // Create the cell
        cell = [[[ActivityTableCell alloc] initWithStyle:UITableViewCellEditingStyleDelete reuseIdentifier:CellIdentifier] autorelease];
		cell.playVideoCallback = [Callback create:self selector:@selector(playVideo:)];
        cell.likeVideoCallback = [Callback create:self selector:@selector(onVideoLiked:)];
        cell.unlikeVideoCallback = [Callback create:self selector:@selector(onVideoUnliked:)];
        cell.addVideoCallback = [Callback create:self selector:@selector(onVideoSaved:)];
    }
	
	if (indexPath.row < activities.count) {
		// Update data for the cell
		ActivityObject* activity = [activities objectAtIndex:indexPath.row];
		[cell setActivityObject: activity];
        
        if (indexPath.row == (activities.count - 2)) {
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

- (void) doUserActivityListRequest:(BOOL)facebookVideosOnly startingAt:(int)pageStart withCount:(int)videosCount {
	// get the list of videos
	if (activityListRequest == nil) {
		activityListRequest = [[UserActivityListRequest alloc] init];
		activityListRequest.errorCallback = [Callback create:self selector:@selector(onListRequestFailed:)];
		activityListRequest.successCallback = [Callback create:self selector:@selector(onListRequestSuccess:)];
	}
	if ([activityListRequest isRequesting]) {
		[activityListRequest cancelRequest];
	}
	[activityListRequest doGetUserActicityListRequest:NO startingAt:pageStart withCount:videosCount];	
}



@end
