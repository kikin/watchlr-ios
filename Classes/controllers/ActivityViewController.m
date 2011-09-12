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
#import "VideoResponse.h"
#import "ProfileViewController.h"
#import "WebViewController.h"
#import "VideoDetailedViewController.h"

@implementation ActivityViewController

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    [super loadView];
    
    allActivitiesListView = [[ActivityListView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    allActivitiesListView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    allActivitiesListView.refreshListCallback = [Callback create:self selector:@selector(onClickRefresh)];
    allActivitiesListView.loadMoreDataCallback = [Callback create:self selector:@selector(onLoadMoreData)];
    allActivitiesListView.onViewSourceClickedCallback = [Callback create:self selector:@selector(onViewSourceClicked:)];
    allActivitiesListView.onUserNameClickedCallback = [Callback create:self selector:@selector(onUsernameClicked:)];
    allActivitiesListView.openVideoDetailPageCallback = [Callback create:self selector:@selector(openVideoDetailPage:)];
    allActivitiesListView.playVideoCallback = [Callback create:self selector:@selector(playVideo:)];
    allActivitiesListView.closeVideoPlayerCallback = [Callback create:self selector:@selector(closeVideoPlayer)];
    allActivitiesListView.sendAllVideoFinishedMessageCallback = [Callback create:self selector:@selector(sendAllVideosFinishedMessage:)];
    allActivitiesListView.isViewRefreshable = true;
    allActivitiesListView.hidden = NO;
    [self.view addSubview:allActivitiesListView];
    [self.view sendSubviewToBack:allActivitiesListView];
    
    facebookOnlyActivitiesListView = [[ActivityListView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    facebookOnlyActivitiesListView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    facebookOnlyActivitiesListView.refreshListCallback = [Callback create:self selector:@selector(onClickRefresh)];
    facebookOnlyActivitiesListView.loadMoreDataCallback = [Callback create:self selector:@selector(onLoadMoreData)];
    facebookOnlyActivitiesListView.onViewSourceClickedCallback = [Callback create:self selector:@selector(onViewSourceClicked:)];
    facebookOnlyActivitiesListView.onUserNameClickedCallback = [Callback create:self selector:@selector(onUsernameClicked:)];
    facebookOnlyActivitiesListView.openVideoDetailPageCallback = [Callback create:self selector:@selector(openVideoDetailPage:)];
    facebookOnlyActivitiesListView.playVideoCallback = [Callback create:self selector:@selector(playVideo:)];
    facebookOnlyActivitiesListView.closeVideoPlayerCallback = [Callback create:self selector:@selector(closeVideoPlayer)];
    facebookOnlyActivitiesListView.sendAllVideoFinishedMessageCallback = [Callback create:self selector:@selector(sendAllVideosFinishedMessage:)];
    facebookOnlyActivitiesListView.isViewRefreshable = true;
    facebookOnlyActivitiesListView.hidden = YES;
    [self.view addSubview:facebookOnlyActivitiesListView];
    [self.view sendSubviewToBack:facebookOnlyActivitiesListView]; 
    
    watchlrOnlyActivitiesListView = [[ActivityListView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    watchlrOnlyActivitiesListView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    watchlrOnlyActivitiesListView.refreshListCallback = [Callback create:self selector:@selector(onClickRefresh)];
    watchlrOnlyActivitiesListView.loadMoreDataCallback = [Callback create:self selector:@selector(onLoadMoreData)];
    watchlrOnlyActivitiesListView.onViewSourceClickedCallback = [Callback create:self selector:@selector(onViewSourceClicked:)];
    watchlrOnlyActivitiesListView.onUserNameClickedCallback = [Callback create:self selector:@selector(onUsernameClicked:)];
    watchlrOnlyActivitiesListView.openVideoDetailPageCallback = [Callback create:self selector:@selector(openVideoDetailPage:)];
    watchlrOnlyActivitiesListView.playVideoCallback = [Callback create:self selector:@selector(playVideo:)];
    watchlrOnlyActivitiesListView.closeVideoPlayerCallback = [Callback create:self selector:@selector(closeVideoPlayer)];
    watchlrOnlyActivitiesListView.sendAllVideoFinishedMessageCallback = [Callback create:self selector:@selector(sendAllVideosFinishedMessage:)];
    watchlrOnlyActivitiesListView.isViewRefreshable = true;
    watchlrOnlyActivitiesListView.hidden = YES;
    [self.view addSubview:watchlrOnlyActivitiesListView];
    [self.view sendSubviewToBack:watchlrOnlyActivitiesListView]; 
    
    activityFilterView = [[ActivityFilterView alloc] init];
    activityFilterView.hidden = YES;
    activityFilterView.optionSelectedCallback = [Callback create:self selector:@selector(onActivityOptionsButtonClicked:)];
    [self.view addSubview:activityFilterView];
    
    // request video lsit
    isRefreshing = true;
    activityType = ALL;
    
    [self performSelector:@selector(onActivityOptionsButtonClicked:) withObject:[NSNumber numberWithInt:activityType]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStyleBordered target:self action:@selector(onFilterButtonClicked)];
    isActiveTab = true;
}

- (void)didReceiveMemoryWarning {
    if (!isActiveTab) {
        // release memory
        [allActivitiesListView didReceiveMemoryWarning];
        [facebookOnlyActivitiesListView didReceiveMemoryWarning];
        [watchlrOnlyActivitiesListView didReceiveMemoryWarning];
        
        [activityListRequest release];
        [tapGesture release];
        
        activityListRequest = nil;
        tapGesture = nil;
    } else {
        int level = [DeviceUtils currentMemoryLevel];
        if (level == OSMemoryNotificationLevelUrgent) {
            switch (activityType) {
                case ALL: {
                    [facebookOnlyActivitiesListView didReceiveMemoryWarning];
                    [watchlrOnlyActivitiesListView didReceiveMemoryWarning];
                    break;
                }
                    
                case FACEBOOK_ONLY: {
                    [allActivitiesListView didReceiveMemoryWarning];
                    [watchlrOnlyActivitiesListView didReceiveMemoryWarning];
                    break;
                }
                    
                case WATCHLR_ONLY: {
                    [facebookOnlyActivitiesListView didReceiveMemoryWarning];
                    [allActivitiesListView didReceiveMemoryWarning];
                    break;
                }
                    
                default:
                    break;
            }
        } else if (level == OSMemoryNotificationLevelCritical) {
            [allActivitiesListView didReceiveMemoryWarning];
            [facebookOnlyActivitiesListView didReceiveMemoryWarning];
            [watchlrOnlyActivitiesListView didReceiveMemoryWarning];
            
            [activityListRequest release];
            [tapGesture release];
            
            activityListRequest = nil;
            tapGesture = nil;
        }
    }
    
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
	// release memory
    [activityListRequest release];
    [tapGesture release];
    
    activityListRequest = nil;
    tapGesture = nil;
    
    [activityFilterView removeFromSuperview];
    [allActivitiesListView removeFromSuperview];
    [facebookOnlyActivitiesListView removeFromSuperview];
    [watchlrOnlyActivitiesListView removeFromSuperview];
    
//    [activityFilterView release];
//    [allActivitiesListView release];
//    [facebookOnlyActivitiesListView release];
//    [watchlrOnlyActivitiesListView release];
    
    if (allActivitiesVideoPlayerViewController != nil) {
        [self.modalViewController dismissModalViewControllerAnimated:NO];
        [allActivitiesVideoPlayerViewController release];
    }
    
    if (facebookOnlyActivitiesVideoPlayerViewController != nil) {
        [self.modalViewController dismissModalViewControllerAnimated:NO];
        [facebookOnlyActivitiesVideoPlayerViewController release];
    }
    
    if (watchlrOnlyActivitiesVideoPlayerViewController != nil) {
        [self.modalViewController dismissModalViewControllerAnimated:NO];
        [watchlrOnlyActivitiesVideoPlayerViewController release];
    }
    
    allActivitiesVideoPlayerViewController = nil;
    facebookOnlyActivitiesVideoPlayerViewController = nil;
    watchlrOnlyActivitiesVideoPlayerViewController = nil;
    
    activityFilterView = nil;
    allActivitiesListView = nil;
    facebookOnlyActivitiesListView = nil;
    watchlrOnlyActivitiesListView = nil;
    
    [super dealloc];
}

// --------------------------------------------------------------------------------
//                          Private Functions
// --------------------------------------------------------------------------------

- (void) doUserActivityListRequest:(ActivityType)type startingAt:(int)pageStart withCount:(int)videosCount {
	// get the list of videos
	if (activityListRequest == nil) {
		activityListRequest = [[UserActivityListRequest alloc] init];
		activityListRequest.errorCallback = [Callback create:self selector:@selector(onListRequestFailed:)];
		activityListRequest.successCallback = [Callback create:self selector:@selector(onListRequestSuccess:)];
	}
	if ([activityListRequest isRequesting]) {
		[activityListRequest cancelRequest];
	}
	[activityListRequest doGetUserActicityListRequest:type startingAt:pageStart withCount:videosCount];	
}

- (ActivityListView*) getActiveView {
    ActivityListView* activeView;
    switch (activityType) {
        case ALL: {
            activeView = allActivitiesListView;
            break;
        }
            
        case FACEBOOK_ONLY: {
            activeView = facebookOnlyActivitiesListView;
            break;
        }
            
        case WATCHLR_ONLY: {
            activeView = watchlrOnlyActivitiesListView;
            break;
        }
            
        default: {
            activeView = allActivitiesListView;
        }
    }
    
    return activeView;
}

- (void) addPageTapGestureRecognizer {
    if (tapGesture == nil) {
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action: @selector(onPageClicked)];
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.numberOfTouchesRequired = 1;
    }
    [self.view addGestureRecognizer:tapGesture];
}

- (void) removePageTapGestureRecognizer {
    [self.view removeGestureRecognizer:tapGesture];
}


// --------------------------------------------------------------------------------
//                                  Callbacks
// --------------------------------------------------------------------------------

- (void) onApplicationBecomeActive: (NSNotification*)notification {
    isRefreshing = true;
    [self doUserActivityListRequest:activityType startingAt:-1 withCount:10];
}

- (void) onClickRefresh {
    isRefreshing = true;
    [self doUserActivityListRequest:activityType startingAt:-1 withCount:(lastPageRequested * 10)];
}

- (void) onLoadMoreData {
    isRefreshing = false;
    [self doUserActivityListRequest:activityType startingAt:(lastPageRequested + 1) withCount:10];
}

- (void) onViewSourceClicked:(NSString*)sourceUrl {
    WebViewController* webViewController = [[[WebViewController alloc] init] autorelease];
    [self.navigationController pushViewController:webViewController animated:YES];
    [webViewController loadUrl:sourceUrl];
    
}

- (void) onUsernameClicked:(NSString*)userName {
    if ([userName rangeOfString:@"/"].location == 0) {
        ProfileViewController* profileViewController = [[[ProfileViewController alloc] init] autorelease];
        [profileViewController openUserProfileForName:[userName substringFromIndex:1]];
        [self.navigationController pushViewController:profileViewController animated:YES];
    } else {
        WebViewController* webViewController = [[[WebViewController alloc] init] autorelease];
        [self.navigationController pushViewController:webViewController animated:YES];
        [webViewController loadUrl:userName];
    }
}

- (void) onFilterButtonClicked {
    if (activityFilterView.hidden) {
        activityFilterView.frame = CGRectMake((self.view.frame.size.width - 150), 0, 150, 105);
        [activityFilterView showActivityFilterOptions:activityType];
        [self addPageTapGestureRecognizer];
    } else {
        activityFilterView.hidden = YES;
        [self removePageTapGestureRecognizer];
    }
}

- (void) onPageClicked {
    LOG_DEBUG(@"On Page clicked");
    if (activityFilterView.hidden == NO) {
        activityFilterView.hidden = YES;
        [self removePageTapGestureRecognizer];
    }
}

- (void) onActivityOptionsButtonClicked:(NSNumber*) type {
    [self removePageTapGestureRecognizer];
    activityFilterView.hidden = YES;
    
    [allActivitiesListView closePlayer];
    [facebookOnlyActivitiesListView closePlayer];
    [watchlrOnlyActivitiesListView closePlayer];
    
    switch([type intValue]) {
        case ALL: {
            activityType = ALL;
            
            allActivitiesListView.hidden = NO;
            facebookOnlyActivitiesListView.hidden = YES;
            watchlrOnlyActivitiesListView.hidden = YES;
            
            
            break;
        }
            
        case FACEBOOK_ONLY: {
            activityType = FACEBOOK_ONLY;
            facebookOnlyActivitiesListView.hidden = NO;
            allActivitiesListView.hidden = YES;
            watchlrOnlyActivitiesListView.hidden = YES;
            break;
        }
            
        case WATCHLR_ONLY: {
            activityType = WATCHLR_ONLY;
            watchlrOnlyActivitiesListView.hidden = NO;
            allActivitiesListView.hidden = YES;
            facebookOnlyActivitiesListView.hidden =YES;
            break;
        }
    }
    
    // update the list
    [self onClickRefresh];
}

- (void) openVideoDetailPage:(VideoObject*)video {
    VideoDetailedViewController* videoDeatiledViewController = [[[VideoDetailedViewController alloc] init] autorelease];
    [self.navigationController pushViewController:videoDeatiledViewController animated:YES];
    [videoDeatiledViewController setVideoObject:video shouldAllowVideoRemoval:NO];
}

-(void) playVideo:(VideoObject*)video inVideoPlayerViewController:(VideoPlayerViewController*)videoPlayerViewController {
    bool isLeanBackMode = true;
    if (self.modalViewController == nil) {
        isLeanBackMode = false;
        [self presentModalViewController:videoPlayerViewController animated:NO];
    }
    
    [videoPlayerViewController playVideo:video];
    
    NSString* trackActionType = @"view";
    if (isLeanBackMode) {
        trackActionType = @"leanback-view";
    }
    
    switch (activityType) {
        case ALL:
            [allActivitiesListView trackAction:trackActionType forVideo:video.videoId];
            break;
            
        case FACEBOOK_ONLY:
            [facebookOnlyActivitiesListView trackAction:trackActionType forVideo:video.videoId];
            break;
            
        case WATCHLR_ONLY:
            [watchlrOnlyActivitiesListView trackAction:trackActionType forVideo:video.videoId];
            break;
            
        default:
            break;
    }
}

- (void) playVideo:(VideoObject*)video {
    switch (activityType) {
        case ALL: {
            if (allActivitiesVideoPlayerViewController == nil) {
                allActivitiesVideoPlayerViewController = [[VideoPlayerViewController alloc] init];
                [allActivitiesListView setVideoPlayerViewControllerCallbacks:allActivitiesVideoPlayerViewController];
            }
            
            [self playVideo:video inVideoPlayerViewController:allActivitiesVideoPlayerViewController];
            break;
        }
            
        case FACEBOOK_ONLY: {
            if (facebookOnlyActivitiesVideoPlayerViewController == nil) {
                facebookOnlyActivitiesVideoPlayerViewController = [[VideoPlayerViewController alloc] init];
                [facebookOnlyActivitiesListView setVideoPlayerViewControllerCallbacks:facebookOnlyActivitiesVideoPlayerViewController];
            }
            
            [self playVideo:video inVideoPlayerViewController:facebookOnlyActivitiesVideoPlayerViewController];
            break;
        }
            
        case WATCHLR_ONLY: {
            if (watchlrOnlyActivitiesVideoPlayerViewController == nil) {
                watchlrOnlyActivitiesVideoPlayerViewController = [[VideoPlayerViewController alloc] init];
                [watchlrOnlyActivitiesListView setVideoPlayerViewControllerCallbacks:watchlrOnlyActivitiesVideoPlayerViewController];
            }
            
            [self playVideo:video inVideoPlayerViewController:watchlrOnlyActivitiesVideoPlayerViewController];
            break;
        }
            
        default:
            break;
    }
}

- (void) closeVideoPlayer {
    switch (activityType) {
        case ALL: {
            if (allActivitiesVideoPlayerViewController != nil) {
                [allActivitiesVideoPlayerViewController closePlayer];
            }
            break;
        }
            
        case FACEBOOK_ONLY: {
            if (facebookOnlyActivitiesVideoPlayerViewController != nil) {
                [facebookOnlyActivitiesVideoPlayerViewController closePlayer];
            }
            break;
        }
            
        case WATCHLR_ONLY: {
            if (watchlrOnlyActivitiesVideoPlayerViewController != nil) {
                [watchlrOnlyActivitiesVideoPlayerViewController closePlayer];
            }
            break;
        }
            
        default:
            break;
    }
    
}

- (void) sendAllVideosFinishedMessage:(NSNumber*)nextButtonClicked {
    switch (activityType) {
        case ALL: {
            if (allActivitiesVideoPlayerViewController != nil) {
                [allActivitiesVideoPlayerViewController sendAllVideosFinishedMessage:[nextButtonClicked boolValue]];
            }
            break;
        }
            
        case FACEBOOK_ONLY: {
            if (facebookOnlyActivitiesVideoPlayerViewController != nil) {
                [facebookOnlyActivitiesVideoPlayerViewController sendAllVideosFinishedMessage:[nextButtonClicked boolValue]];
            }
            break;
        }
            
        case WATCHLR_ONLY: {
            if (watchlrOnlyActivitiesVideoPlayerViewController != nil) {
                [watchlrOnlyActivitiesVideoPlayerViewController sendAllVideosFinishedMessage:[nextButtonClicked boolValue]];
            }
            break;
        }
            
        default:
            break;
    }
}


// --------------------------------------------------------------------------------
//                             Request Callbacks
// --------------------------------------------------------------------------------

- (void) onListRequestSuccess: (UserActivityListResponse*)response {
    ActivityListView* activeView = [self getActiveView];
    if (response.success) {
        // LOG_DEBUG(@"list request success");
        
        
        if ([activeView count] == 0 || !isRefreshing) {
            lastPageRequested = [response page];
        }
        NSDictionary* args = [NSDictionary dictionaryWithObjectsAndKeys:
                              [response activities], @"activitiesList",
                              [NSNumber numberWithInt:[response total]], @"videoCount",
                              [NSNumber numberWithBool:isRefreshing], @"isRefreshing",
                              [NSNumber numberWithInt:lastPageRequested], @"lastPageRequested",
                              nil];
        [activeView performSelectorInBackground:@selector(updateListWrapper:) withObject:args];
	} else {
        [activeView resetLoadingStatus];
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
    ActivityListView* activeView = [self getActiveView];
    
    [activeView resetLoadingStatus];
    isRefreshing = false;
    
    NSString* errorString = [NSString stringWithFormat:@"We failed to retrieve your videos: %@", errorMessage];
	
	// show error message
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Failed to retrieve videos" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
	[alertView release];		
	
	LOG_ERROR(@"list request error: %@", errorMessage);
}

// --------------------------------------------------------------------------------
//                          Public Functions
// --------------------------------------------------------------------------------

- (void) onTabInactivate {
    isActiveTab = false;
    ActivityListView* activeView = [self getActiveView];
    [activeView closePlayer];
}

- (void) onTabActivate {
    isActiveTab = true;
    if (self.navigationController.visibleViewController == self) {
        [self onClickRefresh];
    }
}

- (void) onApplicationBecomeInactive {
    isActiveTab = true;
    [self onTabInactivate];
}

- (BOOL) shouldRotate {
    return NO;
}

@end
