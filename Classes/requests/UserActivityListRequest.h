//
//  VideoListRequest.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonIos/JsonRequest.h>

typedef enum {
    ALL,
    FACEBOOK_ONLY,
    WATCHLR_ONLY
} ActivityType;

@interface UserActivityListRequest : JsonRequest

- (void) doGetUserActicityListRequest:(ActivityType)activityType startingAt:(int)pageStart withCount:(int)videosCount;
- (id) processReceivedString: (NSString*)receivedString;

@end
