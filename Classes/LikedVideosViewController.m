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
	
    UIImage* anImage = [UIImage imageNamed:@"29-heart.png"];
    UITabBarItem* theItem = [[UITabBarItem alloc] initWithTitle:@"Liked" image:anImage tag:0];
    self.tabBarItem = theItem;
    [theItem release];
    [anImage release];
	
	// request video lsit
	[self doVideoListRequest];
}

- (void) doVideoListRequest {
	// get the list of videos
	if (videoListRequest == nil) {
		videoListRequest = [[VideoListRequest alloc] init];
		videoListRequest.errorCallback = [Callback create:self selector:@selector(onListRequestFailed:)];
		videoListRequest.successCallback = [Callback create:self selector:@selector(onListRequestSuccess:)];
	}
	if ([videoListRequest isRequesting]) {
		[videoListRequest cancelRequest];
	}
	[videoListRequest doGetVideoListRequest:YES];	
}

- (void) onClickRefresh {
	[self doVideoListRequest];
}

- (void) onApplicationBecomeActive: (NSNotification*)notification {
	[self doVideoListRequest];
}

- (void) onListRequestSuccess: (VideoListResponse*)response {
	if (response.success) {
		// save response and get videos
		videoListResponse = [response retain];
		videos = [[NSMutableArray arrayWithArray:[response videos]] retain];
		
		// refresh the table
		[videosTable reloadData];
        
        state = REFRESHED;
        [refreshStatusView setRefreshStatus:REFRESHED];
		
		LOG_DEBUG(@"list request success");
	} else {
		NSString* errorMessage = [NSString stringWithFormat:@"We failed to retrieve your videos: %@", response.errorMessage];
		
		// show error message
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Failed to retrieve videos" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		[alertView release];		
		
		LOG_ERROR(@"request success but failed to list videos: %@", response.errorMessage);
	}
    
    state = REFRESH_NONE;
    [refreshStatusView setRefreshStatus:REFRESH_NONE];
    [refreshStatusView setHidden:YES];
    videosTable.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    
}

- (void) onListRequestFailed: (NSString*)errorMessage {
	state = REFRESH_NONE;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"VideoTableCell";
	
	// try to reuse an id
    VideoTableCell* cell = (VideoTableCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        // Create the cell
        cell = [[[VideoTableCell alloc] initWithStyle:UITableViewCellEditingStyleDelete reuseIdentifier:CellIdentifier] autorelease];
		cell.playVideoCallback = [Callback create:self selector:@selector(playVideo:)];
    }
	
	if (indexPath.row < videos.count) {
		// Update data for the cell
		VideoObject* videoObject = [videos objectAtIndex:indexPath.row];
		[cell setVideoObject: videoObject];
	}
	
    return cell;
}

- (void)dealloc {
	// release memory
	[videoListRequest release];
	[videoListResponse release];
	
    [super dealloc];
}

@end
