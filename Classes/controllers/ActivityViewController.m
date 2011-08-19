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

@implementation ActivityViewController

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    [super loadView];
    
    allActivitiesListView = [[ActivityListView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    allActivitiesListView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    allActivitiesListView.refreshListCallback = [Callback create:self selector:@selector(onClickRefresh)];
    allActivitiesListView.loadMoreDataCallback = [Callback create:self selector:@selector(onLoadMoreData)];
    allActivitiesListView.onUserNameClickedCallback = [Callback create:self selector:@selector(onUsernameClicked:)];
    allActivitiesListView.isViewRefreshable = true;
    allActivitiesListView.hidden = NO;
    [self.view addSubview:allActivitiesListView];
    [self.view sendSubviewToBack:allActivitiesListView];
    
    facebookOnlyActivitiesListView = [[ActivityListView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    facebookOnlyActivitiesListView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    facebookOnlyActivitiesListView.refreshListCallback = [Callback create:self selector:@selector(onClickRefresh)];
    facebookOnlyActivitiesListView.loadMoreDataCallback = [Callback create:self selector:@selector(onLoadMoreData)];
    facebookOnlyActivitiesListView.onUserNameClickedCallback = [Callback create:self selector:@selector(onUsernameClicked:)];
    facebookOnlyActivitiesListView.isViewRefreshable = true;
    facebookOnlyActivitiesListView.hidden = YES;
    [self.view addSubview:facebookOnlyActivitiesListView];
    [self.view sendSubviewToBack:facebookOnlyActivitiesListView]; 
    
    watchlrOnlyActivitiesListView = [[ActivityListView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    watchlrOnlyActivitiesListView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    watchlrOnlyActivitiesListView.refreshListCallback = [Callback create:self selector:@selector(onClickRefresh)];
    watchlrOnlyActivitiesListView.loadMoreDataCallback = [Callback create:self selector:@selector(onLoadMoreData)];
    watchlrOnlyActivitiesListView.onUserNameClickedCallback = [Callback create:self selector:@selector(onUsernameClicked:)];
    watchlrOnlyActivitiesListView.isViewRefreshable = true;
    watchlrOnlyActivitiesListView.hidden = YES;
    [self.view addSubview:watchlrOnlyActivitiesListView];
    [self.view sendSubviewToBack:watchlrOnlyActivitiesListView]; 
    
    activityOptionsButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"All", @"Facebook only", @"Watchlr only", nil]];
    [activityOptionsButton setSegmentedControlStyle:UISegmentedControlStyleBar];
    [activityOptionsButton addTarget:self action:@selector(onActivityOptionsButtonClicked:) forControlEvents:UIControlEventValueChanged];
    activityOptionsButton.tintColor = [UIColor colorWithRed:(12.0/255.0) green:(83.0/255.0) blue:(111.0/255.0) alpha:1.0];
    activityOptionsButton.selectedSegmentIndex = 0;
//    activityOptionsButton.frame = CGRectMake(0, 0, self.view.frame.size.width, 30);
//    [self.view addSubview:activityOptionsButton];
    self.navigationItem.titleView = activityOptionsButton;

    
    // request video lsit
    isRefreshing = true;
    activityType = ALL;
//	[self doUserActivityListRequest:ALL startingAt:-1 withCount:10];
}

- (void)dealloc {
	// release memory
    [activityOptionsButton release];
    [allActivitiesListView release];
    [facebookOnlyActivitiesListView release];
    [watchlrOnlyActivitiesListView release];
	[activityListRequest release];
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
    ActivityListView* activeView = allActivitiesListView;
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
    }
    
    return activeView;
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

- (void) onActivityOptionsButtonClicked:(UIButton*) sender {
    [allActivitiesListView closePlayer];
    [facebookOnlyActivitiesListView closePlayer];
    [watchlrOnlyActivitiesListView closePlayer];
    
    switch(activityOptionsButton.selectedSegmentIndex) {
        case 0: {
            activityType = ALL;
            
            allActivitiesListView.hidden = NO;
            facebookOnlyActivitiesListView.hidden = YES;
            watchlrOnlyActivitiesListView.hidden = YES;
            
            
            break;
        }
            
        case 1: {
            activityType = FACEBOOK_ONLY;
            facebookOnlyActivitiesListView.hidden = NO;
            allActivitiesListView.hidden = YES;
            watchlrOnlyActivitiesListView.hidden = YES;
            break;
        }
            
        case 2: {
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
                              [NSNumber numberWithInt:[response count]], @"videoCount",
                              [NSNumber numberWithBool:isRefreshing], @"isRefreshing",
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
    ActivityListView* activeView = [self getActiveView];
    [activeView closePlayer];
}

- (void) onTabActivate {
    [self onClickRefresh];
}

- (void) onApplicationBecomeInactive {
    [self onTabInactivate];
}

@end
