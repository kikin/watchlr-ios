//
//  ConnectMainView.m
//  KikinVideo
//
//  Created by ludovic cabre on 5/6/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "VideosListView.h"
#import <QuartzCore/QuartzCore.h>
#import "VideoTableCell.h"
#import "TrackerRequest.h"
#import "VideoRequest.h"
#import "VideoResponse.h"

@implementation VideosListView

@synthesize isViewRefreshable, refreshListCallback, loadMoreDataCallback, addVideoPlayerCallback;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // create the video table
        videosListView = [[UITableView alloc] init];
        videosListView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        videosListView.rowHeight = DeviceUtils.isIphone ? 100 : 150;
        videosListView.delegate = self;
        videosListView.dataSource = self;
        videosListView.allowsSelection = NO;
        videosListView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        videosListView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self addSubview:videosListView];
        
        // create the refresh status view
        refreshStatusView = [[RefreshStatusView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, 60.0f)];
        refreshStatusView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:refreshStatusView];
        [self bringSubviewToFront:refreshStatusView];
        [refreshStatusView setHidden:YES];
        refreshState = REFRESH_NONE;
        loadMoreState = LOAD_MORE_NONE;
        
        // create the loading indicator
        loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        if (DeviceUtils.isIphone) {
            loadingView.frame = CGRectMake((self.frame.size.width - 50) / 2, (self.frame.size.height - 50) / 2, 50, 50);
        } else {
            loadingView.frame = CGRectMake((self.frame.size.width - 100) / 2, (self.frame.size.height - 100) / 2, 100, 100);
        }
        
        loadingView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [loadingView startAnimating];
        [self addSubview:loadingView];
        [self bringSubviewToFront:loadingView];
    }
    return self;
}

- (void) dealloc {
    [videoPlayerView removeFromSuperview];
    [videoPlayerView release];
    [loadingView release];
    [refreshListCallback release];
    [loadMoreDataCallback release];
    [addVideoPlayerCallback release];
    [refreshStatusView release];
	[videosListView release];
    [videosList release];
    [super dealloc];
}

// --------------------------------------------------------------------------------
//                             Private Functions
// --------------------------------------------------------------------------------

- (void) updateList:(NSArray*)videosArray isRefreshing:(bool)refreshing numberOfVideos:(int)videoCount {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    isRefreshing = refreshing;
    if (videosList == nil) {
        // This is the first time we are loading videos
        // we should create the new videos list element.
        videosList = [[NSMutableArray alloc] init];
        
        for (NSDictionary* videoDic in videosArray) {
            // create video from dictionnary
            VideoObject* videoObject = [[[VideoObject alloc] initFromDictionary:videoDic] autorelease];
            [videosList addObject:videoObject];
        }
        
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
        if ([videosList count] > 0) {
            for (int i = 0; i < [videosList count]; i++) {
                VideoObject* video = [videosList objectAtIndex:i];
                firstMatchedVideoIndex = [videosArray indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                    if ([[(NSDictionary*)(obj) objectForKey:@"id"] intValue] == video.videoId) {
                        *stop = YES;
                        return YES;
                    }
                    return NO;
                }];
                
                if (firstMatchedVideoIndex != NSNotFound) {
                    break;
                }
                
                [videosList removeObject:video];
                i--;
            }
            
        }
        
        // if none of the items matched in the received list and 
        // the existing list, then we have removed all the items from
        // the existing list. So, now we set the first matched index to 0
        // so videos list can fill all the new videos we received.
        if (firstMatchedVideoIndex == NSNotFound) {
            firstMatchedVideoIndex = 0;
        }
        
        // add all the videos to the list that were not present before
        for (int i = 0; i < firstMatchedVideoIndex; i++) {
            // create video from dictionnary
            VideoObject* videoObject = [[[VideoObject alloc] initFromDictionary:[videosArray objectAtIndex:i]] autorelease];
            [videosList insertObject:videoObject atIndex:i];
        }
        
        int lastSavedVideoListItemProcessedIndex = [videosList count];
        for (int i = firstMatchedVideoIndex, j = firstMatchedVideoIndex; 
             (i < [videosList count] && j < [videosList count]);) 
        {
            NSDictionary* newVideoListItem = (NSDictionary*)[videosArray objectAtIndex:i];
            VideoObject* savedVideoListItem = (VideoObject*)[videosList objectAtIndex:j];
            
            if ([[newVideoListItem objectForKey:@"id"] intValue] == savedVideoListItem.videoId) {
                [savedVideoListItem updateFromDictionary:newVideoListItem];
                j++;
                i++;
            } else {
                [videosList removeObject:savedVideoListItem];
            }
            
            lastSavedVideoListItemProcessedIndex = j;
        }
        
        if (lastSavedVideoListItemProcessedIndex < [videosList count]) {
            NSRange range = NSMakeRange(lastSavedVideoListItemProcessedIndex, ([videosList count] - lastSavedVideoListItemProcessedIndex));
            [videosList removeObjectsInRange:range];
            loadedAllVideos = false;
        }
        
        if (lastSavedVideoListItemProcessedIndex < [videosArray count]) {
            for (int i = lastSavedVideoListItemProcessedIndex; i < [videosArray count]; i++) {
                // create video from dictionnary
                VideoObject* videoObject = [[[VideoObject alloc] initFromDictionary:[videosArray objectAtIndex:i]] autorelease];
                [videosList insertObject:videoObject atIndex:i];
            }
            loadedAllVideos = false;
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
        for (NSDictionary* videoDic in videosArray) {
            // create video from dictionnary
            VideoObject* videoObject = [[[VideoObject alloc] initFromDictionary:videoDic] autorelease];
            [videosList addObject:videoObject];
        }
        
        loadMoreState = LOADED;
        if ((videoCount != 0) && ((videoCount % 10) == 0)) {
            loadedAllVideos = false;
        } else {
            loadedAllVideos = true;            
        }
    }
    
    //LOG_DEBUG(@"Sending message to main thread to update videos list");
    [videosListView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    
    loadMoreState = LOAD_MORE_NONE;
    refreshState = REFRESH_NONE;
    [refreshStatusView setRefreshStatus:REFRESH_NONE];
    [refreshStatusView setHidden:YES];
    videosListView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    isRefreshing = false;
    
    if ([loadingView isAnimating]) {
        [loadingView stopAnimating];
    }
    
    [pool release];
}

- (void) loadMoreData {
    if (!loadedAllVideos) {
        if (loadMoreDataCallback != nil) {
            [loadMoreDataCallback execute:nil];
        } else {
            loadMoreState = LOADED;
        }
    } else {
        loadMoreState = LOADED;
    }
}

// --------------------------------------------------------------------------------
//                            Tracking requests
// --------------------------------------------------------------------------------

- (void) trackAction:(NSString*)action forVideo:(int)vid {
    TrackerRequest* trackerRequest = [[[TrackerRequest alloc] init] autorelease];
    [trackerRequest doTrackActionRequest:action forVideoId:vid from:@"SavedTab"];
}

- (void) trackEvent:(NSString*)name withValue:(NSString*)value {
    TrackerRequest* trackerRequest = [[[TrackerRequest alloc] init] autorelease];
    [trackerRequest doTrackEventRequest:name withValue:value from:@"SavedTab"];
}

- (void) trackError:(NSString*)error from:(NSString*)where withMessage:(NSString*)message {
    TrackerRequest* trackerRequest = [[[TrackerRequest alloc] init] autorelease];
    [trackerRequest doTrackErrorRequest:message from:where andError:error];
}


// --------------------------------------------------------------------------------
//                      Video Player functions
// --------------------------------------------------------------------------------

- (void) createVideoPlayer {
    // create the video player
    videoPlayerView = [[VideoPlayerView alloc] init];
    videoPlayerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    videoPlayerView.hidden = YES;
    videoPlayerView.onCloseButtonClickedCallback = [Callback create:self selector:@selector(onVideoPlayerCloseButtonClicked)];
    videoPlayerView.onNextButtonClickedCallback = [Callback create:self selector:@selector(onVideoPlayerNextButtonClicked)];
    videoPlayerView.onPreviousButtonClickedCallback = [Callback create:self selector:@selector(onVideoPlayerPreviousButtonClicked)];
    videoPlayerView.onVideoFinishedCallback = [Callback create:self selector:@selector(onVideoPlaybackFinished)];
    videoPlayerView.onPlaybackErrorCallback = [Callback create:self selector:@selector(onPlaybackError)];
    videoPlayerView.onLikeButtonClickedCallback = [Callback create:self selector:@selector(onVideoLiked:)];
    videoPlayerView.onUnlikeButtonClickedCallback = [Callback create:self selector:@selector(onVideoUnliked:)];
    videoPlayerView.onSaveButtonClickedCallback = [Callback create:self selector:@selector(onVideoSaved:)];
    if (addVideoPlayerCallback != nil) {
        [addVideoPlayerCallback execute:videoPlayerView];
    } else {
        videoPlayerView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [self addSubview:videoPlayerView];
    }
}

- (void) playVideo:(VideoObject *)videoObject {
    if (videoObject != nil) {
        bool isLeanback = true;
        
        if (videoPlayerView == nil) {
            [self performSelector:@selector(createVideoPlayer)];
        }
        
        if (videoPlayerView.hidden == YES) {
            [self bringSubviewToFront:videoPlayerView];
            videoPlayerView.hidden = NO;
            isLeanback = false;
        }
        
        [videoPlayerView playVideo:videoObject];
        
        if (isLeanback) {
            [self trackAction:@"leanback-view" forVideo:videoObject.videoId];
        } else {
            [self trackAction:@"view" forVideo:videoObject.videoId];
        }
    }
}

- (void) onVideoPlayerCloseButtonClicked {
    videoPlayerView.hidden = YES;
}

- (void) onVideoPlayerNextButtonClicked {
    VideoObject* videoObject = videoPlayerView.video;
    NSUInteger idx = [videosList indexOfObject:videoObject] + 1;
    // LOG_DEBUG(@"next idx = %ld %ld", idx, videoObject);
    
    if (idx < videosList.count) {
        [self playVideo:[videosList objectAtIndex:idx]];
        if (idx == (videosList.count - 1)) {
            if (loadMoreState != LOADING) {
                LOG_DEBUG(@"Loading more data");
                loadMoreState = LOADING;
                [self loadMoreData];
            }
        }
    } else {
        [videoPlayerView onAllVideosPlayed:true];
    }
}

- (void) onVideoPlayerPreviousButtonClicked {
    VideoObject* videoObject = videoPlayerView.video;
    NSUInteger idx = [videosList indexOfObject:videoObject];
    if (idx > 0) {
        idx -= 1;
        // LOG_DEBUG(@"previous idx = %ld %ld", idx, videoObject);
        [self playVideo:[videosList objectAtIndex:idx]];
        
    } else {
        [videoPlayerView onAllVideosPlayed: false];
    }
}

- (void) onPlaybackError {
    [self trackEvent:@"VideoPlaybackError" withValue:[[NSNumber numberWithInt:videoPlayerView.video.videoId] stringValue]];
}

- (void) onVideoPlaybackFinished {
    [self onVideoPlayerNextButtonClicked];
}

- (void) closePlayer {
    [videoPlayerView closePlayer];
}

// --------------------------------------------------------------------------------
//                      Video requests
// --------------------------------------------------------------------------------

- (void) onVideoLiked:(VideoObject*)videoObject {
    VideoRequest* likeRequest = [[[VideoRequest alloc] init] autorelease];
    likeRequest.errorCallback = [Callback create:self selector:@selector(onLikeVideoRequestFailed:)];
    likeRequest.successCallback = [Callback create:self selector:@selector(onLikeVideoRequestSuccess:)];
    [likeRequest likeVideo:videoObject];
}

- (void) onVideoUnliked:(VideoObject*)videoObject {
    VideoRequest* unlikeRequest = [[[VideoRequest alloc] init] autorelease];
    unlikeRequest.errorCallback = [Callback create:self selector:@selector(onUnlikeVideoRequestFailed:)];
    unlikeRequest.successCallback = [Callback create:self selector:@selector(onUnlikeVideoRequestSuccess:)];
    [unlikeRequest unlikeVideo:videoObject];
}

- (void) onVideoSaved:(VideoObject*)videoObject {
    VideoRequest* saveRequest = [[[VideoRequest alloc] init] autorelease];
    saveRequest.errorCallback = [Callback create:self selector:@selector(onAddVideoRequestFailed:)];
    saveRequest.successCallback = [Callback create:self selector:@selector(onAddVideoRequestSuccess:)];
    [saveRequest addVideo:videoObject];
}

- (void) onVideoRemoved:(VideoObject*)videoObject {
    VideoRequest* removeRequest = [[[VideoRequest alloc] init] autorelease];
    removeRequest.errorCallback = [Callback create:self selector:@selector(onDeleteRequestFailed:)];
    removeRequest.successCallback = [Callback create:self selector:@selector(onDeleteRequestSuccess:)];
    [removeRequest deleteVideo:videoObject];
}

// --------------------------------------------------------------------------------
//                      Video request callbacks
// --------------------------------------------------------------------------------

- (void) onLikeVideoRequestSuccess: (VideoResponse*)response {
	if (response.success) {
        int videoId = [[response.videoResponse objectForKey:@"id"] intValue];
        NSUInteger idx =[videosList indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            if (((VideoObject*)obj).videoId == videoId) {
                *stop = YES;
                return YES;
            }
            return NO;
        }];
        
        if (idx != NSNotFound) {
            VideoObject* videoObject = [videosList objectAtIndex:idx];
            [videoObject updateFromDictionary:response.videoResponse];
            [videosList replaceObjectAtIndex:idx withObject:videoObject];
            
            
            [videosListView beginUpdates];
            NSIndexPath *index = [NSIndexPath indexPathForRow:idx inSection:0];
            if (index.row < videosList.count) {
                // Update data for the cell
                // LOG_DEBUG(@"Updating video object.");
                VideoTableCell* cell = (VideoTableCell*)[videosListView cellForRowAtIndexPath:index];
                [cell updateLikeButton: videoObject];
            }
            [videosListView endUpdates];
        }
        
        [self trackAction:@"like" forVideo:videoId];
        
	} else {
		LOG_ERROR(@"request success but failed to like video: %@", response.errorMessage);
	}
}

- (void) onLikeVideoRequestFailed: (NSString*)errorMessage {		
	LOG_ERROR(@"failed to like video: %@", errorMessage);
}

- (void) onUnlikeVideoRequestSuccess: (VideoResponse*)response {
	if (response.success) {
        int videoId = [[response.videoResponse objectForKey:@"id"] intValue];
        NSUInteger idx =[videosList indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            if (((VideoObject*)obj).videoId == videoId) {
                *stop = YES;
                return YES;
            }
            return NO;
        }];
        
        if (idx != NSNotFound) {
            VideoObject* videoObject = [videosList objectAtIndex:idx];
            [videoObject updateFromDictionary:response.videoResponse];
            [videosList replaceObjectAtIndex:idx withObject:videoObject];
            
            
            [videosListView beginUpdates];
            NSIndexPath *index = [NSIndexPath indexPathForRow:idx inSection:0];
            if (index.row < videosList.count) {
                // Update data for the cell
                // LOG_DEBUG(@"Updating video object.");
                VideoTableCell* cell = (VideoTableCell*)[videosListView cellForRowAtIndexPath:index];
                [cell updateLikeButton: videoObject];
            }
            [videosListView endUpdates];
        }
        
        [self trackAction:@"unlike" forVideo:videoId];
        
    } else {
        LOG_ERROR(@"request success but failed to unlike video: %@", response.errorMessage);
    }
}

- (void) onUnlikeVideoRequestFailed: (NSString*)errorMessage {		
	LOG_ERROR(@"failed to unlike video: %@", errorMessage);
}

- (void) onAddVideoRequestSuccess: (VideoResponse*)response {
    if (response.success) {
        int videoId = [[response.videoResponse objectForKey:@"id"] intValue];
        NSUInteger idx =[videosList indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            if (((VideoObject*)obj).videoId == videoId) {
                *stop = YES;
                return YES;
            }
            return NO;
        }];
        
        if (idx != NSNotFound) {
            VideoObject* videoObject = [videosList objectAtIndex:idx];
            [videoObject updateFromDictionary:response.videoResponse];
            [videosList replaceObjectAtIndex:idx withObject:videoObject];
            
            
            [videosListView beginUpdates];
            NSIndexPath *index = [NSIndexPath indexPathForRow:idx inSection:0];
            if (index.row < videosList.count) {
                // Update data for the cell
                // LOG_DEBUG(@"Updating video object.");
                VideoTableCell* cell = (VideoTableCell*)[videosListView cellForRowAtIndexPath:index];
                [cell updateSaveButton: videoObject];
            }
            [videosListView endUpdates];
        }
        
        [self trackAction:@"save" forVideo:videoId];
    } else {
        LOG_ERROR(@"request success but failed to save video: %@", response.errorMessage);
    }
}

- (void) onAddVideoRequestFailed: (NSString*)errorMessage {		
	LOG_ERROR(@"failed to save video: %@", errorMessage);
}

- (void) onDeleteRequestSuccess: (VideoResponse*)response {
	if (response.success) {
		int videoId = [[response.videoResponse objectForKey:@"id"] intValue];
        NSUInteger idx =[videosList indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            if (((VideoObject*)obj).videoId == videoId) {
                *stop = YES;
                return YES;
            }
            return NO;
        }];
        
        if (idx != NSNotFound) {
            [videosList removeObjectAtIndex:idx];
            
            [videosListView beginUpdates];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
            [videosListView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                               withRowAnimation:UITableViewRowAnimationFade];
            [videosListView endUpdates];
        }
        [self trackAction:@"remove" forVideo:videoId];
	} else {
		NSString* errorMessage = [NSString stringWithFormat:@"We failed to delete this video: %@", response.errorMessage];
		
		// show error message
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Failed to delete" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		[alertView release];
		
		LOG_ERROR(@"request success but failed to delete video: %@", response.errorMessage);
	}
}

- (void) onDeleteRequestFailed: (NSString*)errorMessage {		
	NSString* errorString = [NSString stringWithFormat:@"We failed to delete this video: %@", errorMessage];
	
	// show error message
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Failed to delete" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
	
	LOG_ERROR(@"failed to delete video: %@", errorMessage);
}

// --------------------------------------------------------------------------------
//                      Table view delegate
// --------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (videosList != nil) {
		return [videosList count];
	} else {
		return 0;
	}
}

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
        cell.addVideoCallback = [Callback create:self selector:@selector(onVideoSaved:)];
    }
	
    if (indexPath.row < videosList.count) {
        // Update data for the cell
        VideoObject* videoObject = [videosList objectAtIndex:indexPath.row];
        [cell setVideoObject: videoObject];

        if (indexPath.row == (videosList.count - 1)) {
            if (loadMoreState != LOADING) {
                LOG_DEBUG(@"Loading more data");
                loadMoreState = LOADING;
                [self loadMoreData];
            }
        }
    }
	
    return cell;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// unselect row
	[tableView deselectRowAtIndexPath:indexPath animated:TRUE];
}

// --------------------------------------------------------------------------------
//                      Scrollview delegates/datasource
// --------------------------------------------------------------------------------

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    if (isViewRefreshable) {
        if (scrollView.contentOffset.y < 0 && scrollView.contentOffset.y > -60) {
            if (refreshStatusView.hidden)
                refreshStatusView.hidden = NO;
            
            if (refreshState != PULLING_DOWN) {
                refreshState = PULLING_DOWN;
                [refreshStatusView setRefreshStatus:PULLING_DOWN];
            }
            
//            refreshStatusView.frame = CGRectMake(refreshStatusView.frame.origin.x, topToolbar.frame.size.height, self.view.frame.size.width, -scrollView.contentOffset.y);
            refreshStatusView.frame = CGRectMake(refreshStatusView.frame.origin.x, 0, self.frame.size.width, -scrollView.contentOffset.y);
            
        } else if (scrollView.contentOffset.y >= 0) {
            
            if (!refreshStatusView.hidden) {
                refreshStatusView.hidden = YES;
                [refreshStatusView setRefreshStatus:REFRESH_NONE];
            }
            
            refreshState = REFRESH_NONE;
            
        } else if (scrollView.contentOffset.y <= -60) {
            if (refreshState < RELEASING) {
                refreshState = RELEASING;
                [refreshStatusView setRefreshStatus:RELEASING];
            }
            
//            refreshStatusView.frame = CGRectMake(refreshStatusView.frame.origin.x, topToolbar.frame.size.height - 60 - scrollView.contentOffset.y, self.view.frame.size.width, 60);
            refreshStatusView.frame = CGRectMake(refreshStatusView.frame.origin.x, -(60 + scrollView.contentOffset.y), self.frame.size.width, 60);
        }
    }
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (isViewRefreshable) {
        if (scrollView.contentOffset.y <= -65) {
            refreshState = REFRESHING;
            [refreshStatusView setRefreshStatus:REFRESHING];
            scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
            if (refreshListCallback != nil) {
                [refreshListCallback execute:nil];
            }
        }
    }
}

// --------------------------------------------------------------------------------
//                             Public Functions
// --------------------------------------------------------------------------------

- (void) updateListWrapper: (NSDictionary*)args {
    [self updateList:[args objectForKey:@"videosList"] isRefreshing:[[args objectForKey:@"isRefreshing"] boolValue] numberOfVideos:[[args objectForKey:@"videoCount"] integerValue]];
}

- (int) count {
    return (videosList != nil) ? [videosList count] : 0;
}

- (void) resetLoadingStatus {
    if ([loadingView isAnimating]) {
        [loadingView stopAnimating];
    }
    
    loadMoreState = LOAD_MORE_NONE;
    refreshState = REFRESH_NONE;
    [refreshStatusView setRefreshStatus:REFRESH_NONE];
    [refreshStatusView setHidden:YES];
    videosListView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    isRefreshing = false;
}

@end
