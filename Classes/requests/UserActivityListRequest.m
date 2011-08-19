//
//  VideoListRequest.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "UserActivityListRequest.h"
#import "UserActivityListResponse.h"
#import "UserObject.h"
#import "Request.h"

@implementation UserActivityListRequest

- (void) doGetUserActicityListRequest:(ActivityType)activityType startingAt:(int)pageStart withCount:(int)videosCount {
	// get current userId
	NSString* sessionId = [UserObject getUser].sessionId;
	// LOG_DEBUG(@"sessionId = %@", sessionId);
	
    // /api/activity[?type=[watchlr|facebook]]
	// build params list
	NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
	[params setObject:sessionId forKey:@"session_id"];
    [params setObject:[NSString stringWithFormat:@"%d", (videosCount > 0 ? videosCount : 10)] forKey:@"count"];
    
    switch (activityType) {
        case FACEBOOK_ONLY: {
            [params setObject:@"facebook" forKey:@"type"];
            break;
        }
            
        case WATCHLR_ONLY: {
            [params setObject:@"watchlr" forKey:@"type"];
            break;
        }
            
        default:
            break;
    }

    
    // send the page index only if you are loading more videos
    if (pageStart > -1) {
        [params setObject:[NSString stringWithFormat:@"%d", pageStart] forKey:@"page"];
    }
	
	// do request
    NSString* requestUrl = [NSString stringWithFormat:@"%@/api/activity", WATCHLR_COM_URL];
	[self doGetRequest:requestUrl params:params];
	
	// release memory
	[params release];
}

- (id) processReceivedString: (NSString*)receivedString {
	// let the base parse the json
	id jsonObject = [super processReceivedString:receivedString];
	
	// create the response
	UserActivityListResponse* response = [[[UserActivityListResponse alloc] initWithResponse:jsonObject] autorelease];
	
	return response;
}

@end
