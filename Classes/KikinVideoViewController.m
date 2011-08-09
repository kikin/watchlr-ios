    //
//  MostViewedViewController.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "KikinVideoViewController.h"
#import "LoginViewController.h"
#import "UserObject.h"
#import "FeedbackViewController.h"
#import "VideoPlayerView.h"
#import "VideoTableCell.h"

@implementation KikinVideoToolBar

- (void) layoutSubviews {
    [super layoutSubviews];
    if (!kikinLogo) {
        for (UIView* imageView in self.subviews) {
            if ([imageView isKindOfClass:[UIImageView class]]) {
                kikinLogo = [imageView retain];
            }
        }
    }
    
    kikinLogo.frame = CGRectMake(((self.frame.size.width - 110) / 2), ((self.frame.size.height - 24) / 2), 110, 24);
}

-(void) dealloc {
    [kikinLogo release];
    [super dealloc];
}

@end

@implementation KikinVideoViewController

@synthesize onLogoutCallback;

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	// create the view
	UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 500, 500)];
	view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    view.autoresizesSubviews = YES;
	self.view = view;
	[view release];
    
    // create the video player
    videoPlayerView = [[VideoPlayerView alloc] init];
    videoPlayerView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
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
    [self.view addSubview:videoPlayerView];
    
    // create the toolbar
	topToolbar = [[KikinVideoToolBar alloc] init];
    topToolbar.frame = CGRectMake(0, 0, self.view.frame.size.width, 42);
    topToolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    topToolbar.tintColor = [UIColor colorWithRed:(12.0/255.0) green:(83.0/255.0) blue:(111.0/255.0) alpha:1.0];
    
    UIImageView* kikinLogo = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"watchlr_logo.png"]] autorelease];
    [topToolbar insertSubview:kikinLogo atIndex:0];
    [topToolbar setAutoresizesSubviews:YES];
    
	NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:3];
    
    // create a spacer
    UIBarButtonItem* spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [buttons addObject:spacer];
    [spacer release];
	
	// create the disconnect button
	accountButton = [[UIBarButtonItem alloc] init];
	accountButton.title = @"Account";
	accountButton.style = UIBarButtonItemStyleBordered;
	accountButton.action = @selector(onClickAccount);
	[buttons addObject:accountButton];
	
    // add the buttons to the bar
    [topToolbar setItems:buttons];
    [buttons release];

    // create the video table
    videosTable = [[UITableView alloc] init];
    videosTable.frame = CGRectMake(0, 42, view.frame.size.width, view.frame.size.height-42);
    videosTable.rowHeight = DeviceUtils.isIphone ? 100 : 150;
    videosTable.delegate = self;
    videosTable.dataSource = self;
    videosTable.allowsSelection = NO;
    videosTable.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    videosTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:videosTable];

    userProfileView = [[UserProfileView alloc] init];
	userProfileView.hidden = YES;
    [self.view addSubview:userProfileView];
    
    userSettingsView = [[UserSettingsView alloc] init];
	userSettingsView.hidden = YES;
    userSettingsView.showUserProfileCallback = [Callback create:self selector:@selector(showUserProfile)];
    userSettingsView.showFeedbackFormCallback = [Callback create:self selector:@selector(showFeedbackForm)];
    userSettingsView.logoutCallback = [Callback create:self selector:@selector(logoutUser)];
    
	[self.view addSubview:userSettingsView];
    
    
    refreshStatusView = [[RefreshStatusView alloc] initWithFrame:CGRectMake(0.0f, topToolbar.frame.size.height, self.view.frame.size.width, 60.0f)];
    refreshStatusView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:refreshStatusView];
    [self.view bringSubviewToFront:refreshStatusView];
    [refreshStatusView setHidden:YES];
    refreshState = REFRESH_NONE;
    loadMoreState = LOAD_MORE_NONE;
    
    [self.view addSubview:topToolbar];
    [self.view bringSubviewToFront:topToolbar];
    
    loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    if (DeviceUtils.isIphone) {
        loadingView.frame = CGRectMake((self.view.frame.size.width - 50) / 2, (self.view.frame.size.height - 50) / 2, 50, 50);
    } else {
        loadingView.frame = CGRectMake((self.view.frame.size.width - 100) / 2, (self.view.frame.size.height - 100) / 2, 100, 100);
    }
    
    loadingView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [loadingView startAnimating];
    [self.view addSubview:loadingView];
    [self.view bringSubviewToFront:loadingView];
    
    // settingsMenu = [[UIViewController alloc] init];
    
    // get the event when the app comes back
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void) playVideo:(VideoObject *)videoObject {
    if (videoObject != nil) {
        /*PlayerViewController* playerViewController = [[PlayerViewController alloc] init];
        playerViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentModalViewController:playerViewController animated:YES];
        [playerViewController setVideo:videoObject];
        [playerViewController release];*/
        /*if (videoPlayerView.hidden == YES) {
            [self.view bringSubviewToFront:videoPlayerView];
            videoPlayerView.hidden = NO;
            [UIView animateWithDuration:0.2 animations:^(void) {
                videoPlayerView.frame = CGRectMake((self.view.frame.size.width - 580)/2, (self.view.frame.size.height - 365)/ 2, 580, 365);
            } completion:^(BOOL finished) {
                [videoPlayerView playVideo:videoObject];
            }];
        } else {
            [videoPlayerView playVideo:videoObject];
        }*/
        
        bool isLeanback = true;
        
        if (videoPlayerView.hidden == YES) {
            [self.view bringSubviewToFront:videoPlayerView];
            videoPlayerView.hidden = NO;
            // LOG_DEBUG(@"list view Frame coordinates: %f, %f, %f, %f", self.view.frame.size.width, self.view.frame.size.height, self.view.frame.origin.x, self.view.frame.origin.y);
            // videoPlayerView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
            self.hidesBottomBarWhenPushed = YES;
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
    /*[UIView animateWithDuration:0.2 animations:^(void) {
        videoPlayerView.frame = CGRectMake((self.view.frame.size.width)/2, (self.view.frame.size.height)/ 2, 0, 0);
    } completion:^(BOOL finished) {
        videoPlayerView.hidden = YES;
    }];*/
    videoPlayerView.hidden = YES;
    self.hidesBottomBarWhenPushed = NO;
}

- (void) onVideoPlayerNextButtonClicked {
    VideoObject* videoObject = videoPlayerView.video;
    NSUInteger idx = [videos indexOfObject:videoObject] + 1;
    // LOG_DEBUG(@"next idx = %ld %ld", idx, videoObject);
    
    if (idx < videos.count) {
        [self playVideo:[videos objectAtIndex:idx]];
        if (idx == (videos.count - 1)) {
            if (loadMoreState != LOADING) {
                LOG_DEBUG(@"Loading more data");
                loadMoreState = LOADING;
                [self onLoadMoreData];
            }
        }
    } else {
        [videoPlayerView onAllVideosPlayed:true];
    }
}

- (void) onVideoPlayerPreviousButtonClicked {
    VideoObject* videoObject = videoPlayerView.video;
    NSUInteger idx = [videos indexOfObject:videoObject];
    if (idx > 0) {
        idx -= 1;
        // LOG_DEBUG(@"previous idx = %ld %ld", idx, videoObject);
        [self playVideo:[videos objectAtIndex:idx]];
        
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

- (void) showUserProfile {
    if (DeviceUtils.isIphone) {
        userProfileView.frame = CGRectMake(5, (self.view.frame.size.height-190)/2, self.view.frame.size.width - 10, 190);
    } else {
        userProfileView.frame = CGRectMake((self.view.frame.size.width-500)/2, (self.view.frame.size.height-210)/2, 500, 210);
    }
    [userProfileView showUserProfile];
}

- (void) showFeedbackForm {
    FeedbackViewController* feedbackViewController = [[FeedbackViewController alloc] init];
    feedbackViewController.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    [self presentModalViewController:feedbackViewController animated:YES];
    
    [feedbackViewController loadFeedbackForm];
    [feedbackViewController release];
}

- (void) logoutUser {
    // erase userId
	UserObject* userObject = [UserObject getUser];
	userObject.sessionId = nil;
    if (onLogoutCallback != nil) {
        [onLogoutCallback execute:nil];
    }
}

- (void) onClickRefresh {
    // Sub class will implement this method
}

- (void) onLoadMoreData {
    // Sub class will implement this method
}


- (void) onClickAccount {
    if (userSettingsView.hidden) {
        /*userSettingsView.frame = CGRectMake(self.view.frame.size.width - 210, topToolbar.frame.size.height, userSettingsView.frame.size.width, userSettingsView.frame.size.height);*/
        if (DeviceUtils.isIphone) {
            userSettingsView.frame = CGRectMake(0, self.view.frame.size.height - 190, self.view.frame.size.width, 190);
        } else {
            userSettingsView.frame = CGRectMake((self.view.frame.size.width - 210), topToolbar.frame.size.height, 210, 190);
        }
        
        [userSettingsView showUserSettings];
        
    } else {
        userSettingsView.hidden = YES;
    }
    //[settingsMenu setMenuVisible:YES animated:YES];
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    if (!videoPlayerView.isFullScreenMode) {
        [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
        if (!userSettingsView.hidden) {
            userSettingsView.frame = CGRectMake(self.view.frame.size.width - 210, topToolbar.frame.size.height, userSettingsView.frame.size.width, userSettingsView.frame.size.height);
            // [userSettingsView showUserSettings];
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // return !DeviceUtils.isIphone;
    return YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	[super viewDidUnload];
}

- (void)dealloc {
    LOG_DEBUG(@"Dealloc called.");
    
	// stop observing events
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];

	// release memory
	[videos release];
	[accountButton release];
	[videosTable release];
	[topToolbar release];
    [userProfileView release];
    [userSettingsView release];
    [refreshStatusView release];
    [videoPlayerView release];
    [loadingView release];
    
    [super dealloc];
}

// --------------------------------------------------------------------------------
// Notification callbacks
// --------------------------------------------------------------------------------
- (void) onApplicationBecomeInactive {
    LOG_DEBUG(@"Application become inactive.");
    [videoPlayerView closePlayer];
}

// --------------------------------------------------------------------------------
// Requests
// --------------------------------------------------------------------------------

- (void) trackAction:(NSString*)action forVideo:(int)vid {
    TrackerRequest* trackerRequest = [[[TrackerRequest alloc] init] autorelease];
        //            addVideoRequest.errorCallback = [Callback create:self selector:@selector(onAddVideoRequestFailed:)];
        //            addVideoRequest.successCallback = [Callback create:self selector:@selector(onAddVideoRequestSuccess:)];
    
    // do the request
    [trackerRequest doTrackActionRequest:action forVideoId:vid from:@"SavedTab"];
}

- (void) trackEvent:(NSString*)name withValue:(NSString*)value {
    TrackerRequest* trackerRequest = [[[TrackerRequest alloc] init] autorelease];
    //            addVideoRequest.errorCallback = [Callback create:self selector:@selector(onAddVideoRequestFailed:)];
    //            addVideoRequest.successCallback = [Callback create:self selector:@selector(onAddVideoRequestSuccess:)];
    
    // do the request
    [trackerRequest doTrackEventRequest:name withValue:value from:@"SavedTab"];
}

- (void) trackError:(NSString*)error from:(NSString*)where withMessage:(NSString*)message {
    TrackerRequest* trackerRequest = [[[TrackerRequest alloc] init] autorelease];
    //            addVideoRequest.errorCallback = [Callback create:self selector:@selector(onAddVideoRequestFailed:)];
    //            addVideoRequest.successCallback = [Callback create:self selector:@selector(onAddVideoRequestSuccess:)];
    
    // do the request
    [trackerRequest doTrackErrorRequest:message from:where andError:error];
}

- (void) onVideoLiked:(VideoObject*)videoObject {
    if (likeVideoRequest == nil) {
        // create a delete request if not already done
        likeVideoRequest = [[LikeVideoRequest alloc] init];
        likeVideoRequest.errorCallback = [Callback create:self selector:@selector(onLikeVideoRequestFailed:)];
        likeVideoRequest.successCallback = [Callback create:self selector:@selector(onLikeVideoRequestSuccess:)];
    }
    
    
    // cancel any current request
    if ([likeVideoRequest isRequesting]) {
        [likeVideoRequest cancelRequest];
    }
    
    // do the request
    [likeVideoRequest doLikeVideoRequest:videoObject];
}

- (void) onVideoUnliked:(VideoObject*)videoObject {
    if (unlikeVideoRequest == nil) {
        // create a delete request if not already done
        unlikeVideoRequest = [[UnlikeVideoRequest alloc] init];
        unlikeVideoRequest.errorCallback = [Callback create:self selector:@selector(onUnlikeVideoRequestFailed:)];
        unlikeVideoRequest.successCallback = [Callback create:self selector:@selector(onUnlikeVideoRequestSuccess:)];
    }
    
    
    // cancel any current request
    if ([unlikeVideoRequest isRequesting]) {
        [unlikeVideoRequest cancelRequest];
    }
    
    // do the request
    [unlikeVideoRequest doUnlikeVideoRequest:videoObject];
}

- (void) onVideoSaved:(VideoObject*)videoObject {
    if (addVideoRequest == nil) {
        // create a delete request if not already done
        addVideoRequest = [[AddVideoRequest alloc] init];
        addVideoRequest.errorCallback = [Callback create:self selector:@selector(onAddVideoRequestFailed:)];
        addVideoRequest.successCallback = [Callback create:self selector:@selector(onAddVideoRequestSuccess:)];
    }
    
    
    // cancel any current request
    if ([addVideoRequest isRequesting]) {
        [addVideoRequest cancelRequest];
    }
    
    // do the request
    [addVideoRequest doAddVideoRequest:videoObject];
}

- (void) onVideoRemoved:(VideoObject*)videoObject {
    if (deleteVideoRequest == nil) {
        // create a delete request if not already done
        deleteVideoRequest = [[DeleteVideoRequest alloc] init];
        deleteVideoRequest.errorCallback = [Callback create:self selector:@selector(onDeleteRequestFailed:)];
        deleteVideoRequest.successCallback = [Callback create:self selector:@selector(onDeleteRequestSuccess:)];
    }
    
    
    // cancel any current request
    if ([deleteVideoRequest isRequesting]) {
        [deleteVideoRequest cancelRequest];
    }
    
    // do the request
    [deleteVideoRequest doDeleteVideoRequest:videoObject];
}

- (void) onLikeVideoRequestSuccess: (LikeVideoResponse*)response {
	if (response.success) {
        VideoObject* videoObject = response.videoObject;
        NSUInteger idx = [videos indexOfObject:videoObject];
		// LOG_DEBUG(@"like idx = %ld %ld", idx, videoObject);
        videoObject.likes += 1;
        videoObject.liked = true;
        [videos replaceObjectAtIndex:idx withObject:videoObject];
        
		
		[videosTable beginUpdates];
		NSIndexPath *index = [NSIndexPath indexPathForRow:idx inSection:0];
        if (index.row < videos.count) {
            // Update data for the cell
            // LOG_DEBUG(@"Updating video object.");
            VideoTableCell* cell = (VideoTableCell*)[videosTable cellForRowAtIndexPath:index];
            [cell setVideoObject: videoObject];
        }
        [videosTable endUpdates];
        
        [self trackAction:@"like" forVideo:videoObject.videoId];
        
	} else {
		LOG_ERROR(@"request success but failed to like video: %@", response.errorMessage);
	}
}

- (void) onLikeVideoRequestFailed: (NSString*)errorMessage {		
	LOG_ERROR(@"failed to like video: %@", errorMessage);
}

- (void) onUnlikeVideoRequestSuccess: (UnlikeVideoResponse*)response {
	if (response.success) {
        VideoObject* videoObject = response.videoObject;
        NSUInteger idx = [videos indexOfObject:videoObject];
		// LOG_DEBUG(@"unlike idx = %ld %ld", idx, videoObject);
        videoObject.likes -= 1;
        videoObject.liked = false;
        [videos replaceObjectAtIndex:idx withObject:videoObject];
        
		
		[videosTable beginUpdates];
		NSIndexPath *index = [NSIndexPath indexPathForRow:idx inSection:0];
        if (index.row < videos.count) {
            // Update data for the cell
            // LOG_DEBUG(@"Updating video object.");
            VideoTableCell* cell = (VideoTableCell*)[videosTable cellForRowAtIndexPath:index];
            [cell setVideoObject: videoObject];
        }
        [videosTable endUpdates];
        
        [self trackAction:@"unlike" forVideo:videoObject.videoId];
        
    } else {
        LOG_ERROR(@"request success but failed to like video: %@", response.errorMessage);
    }
}

- (void) onUnlikeVideoRequestFailed: (NSString*)errorMessage {		
	LOG_ERROR(@"failed to unlike video: %@", errorMessage);
}

- (void) onAddVideoRequestSuccess: (UnlikeVideoResponse*)response {
	if (response.success) {
        [self trackAction:@"save" forVideo:response.videoObject.videoId];
	} else {
		LOG_ERROR(@"request success but failed to unlike video: %@", response.errorMessage);
	}
}

- (void) onAddVideoRequestFailed: (NSString*)errorMessage {		
	LOG_ERROR(@"failed to unlike video: %@", errorMessage);
}

- (void) onDeleteRequestSuccess: (DeleteVideoResponse*)response {
	if (response.success) {
		VideoObject* videoObject = response.videoObject;
		
		NSUInteger idx = [videos indexOfObject:videoObject];
		// LOG_DEBUG(@"delete idx = %ld %ld", idx, videoObject);
		[videos removeObjectAtIndex:idx];
		
		[videosTable beginUpdates];
		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
		[videosTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
						   withRowAnimation:UITableViewRowAnimationFade];
		[videosTable endUpdates];
        [self trackAction:@"remove" forVideo:videoObject.videoId];
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
// TableView delegates/datasource
// --------------------------------------------------------------------------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (videos != nil) {
		return [videos count];
	} else {
		return 0;
	}
}

/*- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// unselect row
	[tableView deselectRowAtIndexPath:indexPath animated:TRUE];
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


- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y < 0 && scrollView.contentOffset.y > -60) {
        if (refreshStatusView.hidden)
            refreshStatusView.hidden = NO;
        
        if (refreshState != PULLING_DOWN) {
            refreshState = PULLING_DOWN;
            [refreshStatusView setRefreshStatus:PULLING_DOWN];
        }
        
        refreshStatusView.frame = CGRectMake(refreshStatusView.frame.origin.x, topToolbar.frame.size.height, self.view.frame.size.width, -scrollView.contentOffset.y);
        
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
        
        refreshStatusView.frame = CGRectMake(refreshStatusView.frame.origin.x, topToolbar.frame.size.height - 60 - scrollView.contentOffset.y, self.view.frame.size.width, 60);
    }
    
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.y <= -65) {
        refreshState = REFRESHING;
        [refreshStatusView setRefreshStatus:REFRESHING];
        scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        [self onClickRefresh];
    }
}

@end
