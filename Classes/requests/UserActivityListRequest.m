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

@implementation UserActivityListRequest

- (void) doGetUserActicityListRequest:(BOOL)facebookVideosOnly startingAt:(int)pageStart withCount:(int)videosCount {
	// get current userId
	NSString* sessionId = [UserObject getUser].sessionId;
	// LOG_DEBUG(@"sessionId = %@", sessionId);
	
    // /api/activity[?type=[watchlr|facebook]][&since=<epoch>]
	// build params list
	NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
	[params setObject:sessionId forKey:@"session_id"];
    [params setObject:@"html5" forKey:@"type"];
    [params setObject:(facebookVideosOnly ? @"facebook" : @"watchlr") forKey:@"type"];
    [params setObject:[NSString stringWithFormat:@"%d", (videosCount > 0 ? videosCount : 10)] forKey:@"count"];
    
    // send the page index only if you are loading more videos
    if (pageStart > -1) {
        [params setObject:[NSString stringWithFormat:@"%d", pageStart] forKey:@"page"];
    }
	
	// do request
	[self doGetRequest:@"http://dev.watchlr.com/api/activity" params:params];
	
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
