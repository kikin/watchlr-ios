//
//  ConnectMainView.m
//  KikinVideo
//
//  Created by ludovic cabre on 5/6/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "ActivityListView.h"
#import <QuartzCore/QuartzCore.h>
#import "ActivityObject.h"
#import "ActivityTableCell.h"

@implementation ActivityListView

@synthesize onUserNameClickedCallback;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		videosListView.rowHeight = DeviceUtils.isIphone ? 100 : 180;
    }
    return self;
}

- (void) dealloc {
    [onUserNameClickedCallback release];
    [activitiesList release];
    [super dealloc];
}

// --------------------------------------------------------------------------------
//                             Private Functions
// --------------------------------------------------------------------------------

- (void) updateList:(NSArray*)activitiesArray isRefreshing:(bool)refreshing numberOfVideos:(int)activityCount {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    isRefreshing = refreshing;
    
    if (activitiesList == nil) {
        // This is the first time we are loading videos
        // we should create the new videos list element.
        videosList = [[NSMutableArray alloc] init];
        activitiesList = [[NSMutableArray alloc] init];
        
        for (NSDictionary* activityDic in activitiesArray) {
            // create video from dictionnary
            ActivityObject* activity = [[[ActivityObject alloc] initFromDictionary:activityDic] autorelease];
            [activitiesList addObject:activity];
            activity.video.savedInCurrentTab = false;
            [videosList addObject:activity.video];
        }
        
        if ((activityCount != 0) && ((activityCount % 10) == 0)) {
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
        if ([activitiesList count] > 0) {
            for (int i = 0; i < [activitiesList count]; i++) {
                ActivityObject* activity = [activitiesList objectAtIndex:i];
                firstMatchedActicityIndex = [activitiesArray indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
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
                
                [activitiesList removeObject:activity];
                [videosList removeObjectAtIndex:i];
                i--;
            }
            
        }
        
        // if none of the items matched in the received list and 
        // the existing list, then we have removed all the items from
        // the existing list. So, now we set the first matched index to 0
        // so activity can fill all the new videos we received.
        if (firstMatchedActicityIndex == NSNotFound) {
            firstMatchedActicityIndex = 0;
        }
        
        
        // add all the videos to the list that were not present before
        for (int i = 0; i < firstMatchedActicityIndex; i++) {
            // create video from dictionnary
            ActivityObject* activity = [[[ActivityObject alloc] initFromDictionary:[activitiesArray objectAtIndex:i]] autorelease];
            [activitiesList insertObject:activity atIndex:i];
            activity.video.savedInCurrentTab = false;
            [videosList insertObject:activity.video atIndex:i];
        }
        
        int lastActicvityItemProcessedIndex = [activitiesList count];
        for (int i = firstMatchedActicityIndex, j = firstMatchedActicityIndex; 
             ((i < [activitiesArray count]) && (j < [activitiesList count]));) {
            
            NSDictionary* newActivityItem = (NSDictionary*)[activitiesArray objectAtIndex:i];
            ActivityObject* activityListItem = (ActivityObject*)[activitiesList objectAtIndex:j];
            
            NSDictionary* newActivityVideo = [newActivityItem objectForKey:@"video"];
            if ([[newActivityVideo objectForKey:@"id"] intValue] == activityListItem.video.videoId) {
                [activityListItem updateFromDictionary:newActivityItem];
                activityListItem.video.savedInCurrentTab = false;
                [videosList replaceObjectAtIndex:j withObject:activityListItem.video];
                j++;
                i++;
            } else {
                [activitiesList removeObject:activityListItem];
                [videosList removeObjectAtIndex:j];
            }
            
            lastActicvityItemProcessedIndex = j;
        }
        
        if (lastActicvityItemProcessedIndex < [activitiesList count]) {
            NSRange range = NSMakeRange(lastActicvityItemProcessedIndex, ([activitiesList count] - lastActicvityItemProcessedIndex));
            [activitiesList removeObjectsInRange:range];
            [videosList removeObjectsInRange:range];
            loadedAllVideos = false;
        }
        
        if (lastActicvityItemProcessedIndex < [activitiesArray count]) {
            for (int i = lastActicvityItemProcessedIndex; i < [activitiesArray count]; i++) {
                // create video from dictionnary
                ActivityObject* activity = [[[ActivityObject alloc] initFromDictionary:[activitiesArray objectAtIndex:i]] autorelease];
                [activitiesList insertObject:activity atIndex:i];
                activity.video.savedInCurrentTab = false;
                [videosList insertObject:activity.video atIndex:i];
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
        for (NSDictionary* activityDic in activitiesArray) {
            // create video from dictionnary
            ActivityObject* activityObject = [[[ActivityObject alloc] initFromDictionary:activityDic] autorelease];
            [activitiesList addObject:activityObject];
            activityObject.video.savedInCurrentTab = false;
            [videosList addObject:activityObject.video];
        }
        
        loadMoreState = LOADED;
        if ((activityCount != 0) && ((activityCount % 10) == 0)) {
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

// --------------------------------------------------------------------------------
//                              User Callbacks
// --------------------------------------------------------------------------------

- (void) onUserNameClicked:(NSString*)userName {
    if (onUserNameClickedCallback != nil) {
        [onUserNameClickedCallback execute:userName];
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
        cell.onUserNameClickedCallback = [Callback create:self selector:@selector(onUserNameClicked:)];
    }
	
	if (indexPath.row < activitiesList.count) {
		// Update data for the cell
		ActivityObject* activity = [activitiesList objectAtIndex:indexPath.row];
		[cell setActivityObject: activity];
        
        if (indexPath.row == (activitiesList.count - 2)) {
            if (loadMoreState != LOADING) {
                LOG_DEBUG(@"Loading more data");
                loadMoreState = LOADING;
                [self performSelector:@selector(loadMoreData)];
            }
        }
	}
	
    return cell;
}


// --------------------------------------------------------------------------------
//                             Private Functions
// --------------------------------------------------------------------------------

- (void) updateListWrapper: (NSDictionary*)args {
    [self updateList:[args objectForKey:@"activitiesList"] isRefreshing:[[args objectForKey:@"isRefreshing"] boolValue] numberOfVideos:[[args objectForKey:@"videoCount"] integerValue]];
}


@end
