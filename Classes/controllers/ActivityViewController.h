//
//  MostViewedViewController.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "WatchlrViewController.h"
#import "UserActivityListResponse.h"
#import "UserActivityListRequest.h"
#import "ActivityListView.h"
#import "ActivityFilterView.h"
#import "VideoPlayerViewController.h"

@interface ActivityViewController : WatchlrViewController {
	UserActivityListRequest* activityListRequest;
    ActivityListView* allActivitiesListView;
    ActivityListView* facebookOnlyActivitiesListView;
    ActivityListView* watchlrOnlyActivitiesListView;
    ActivityFilterView* activityFilterView;
    VideoPlayerViewController* allActivitiesVideoPlayerViewController;
    VideoPlayerViewController* facebookOnlyActivitiesVideoPlayerViewController;
    VideoPlayerViewController* watchlrOnlyActivitiesVideoPlayerViewController;
    
    UITapGestureRecognizer* tapGesture;
    
    int lastPageRequested;
    bool isRefreshing;
    bool isActiveTab;
    
    ActivityType activityType;
}

@end
