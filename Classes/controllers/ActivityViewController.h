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

@interface ActivityViewController : WatchlrViewController {
	UserActivityListRequest* activityListRequest;
    ActivityListView* allActivitiesListView;
    ActivityListView* facebookOnlyActivitiesListView;
    ActivityListView* watchlrOnlyActivitiesListView;
    ActivityFilterView* activityFilterView;
//    UISegmentedControl* activityOptionsButton;
    
    UITapGestureRecognizer* tapGesture;
    
    int lastPageRequested;
    bool isRefreshing;
    
    ActivityType activityType;
}

@end
