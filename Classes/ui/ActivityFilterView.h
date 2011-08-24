//
//  ConnectMainView.h
//  KikinVideo
//
//  Created by ludovic cabre on 5/6/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CommonIos/Callback.h>
#import "UserActivityListRequest.h"

@interface ActivityFilterView : UIView {
    UILabel* allActivities;
    UILabel* facebookOnlyActivities;
    UILabel* watchlrOnlyActivities;
}

@property(retain) Callback* optionSelectedCallback;

- (void) showActivityFilterOptions:(ActivityType) activityType;

@end
