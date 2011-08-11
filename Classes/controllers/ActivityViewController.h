//
//  MostViewedViewController.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "KikinVideoViewController.h"
#import "UserActivityListResponse.h"
#import "UserActivityListRequest.h"

@interface ActivityViewController : KikinVideoViewController {
	UserActivityListRequest* activityListRequest;
    NSMutableArray* activities;
	bool isRefreshing;
}

- (void) doUserActivityListRequest:(BOOL)facebookVideosOnly startingAt:(int)pageStart withCount:(int)videosCount;

@end
