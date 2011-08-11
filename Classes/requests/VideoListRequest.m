//
//  VideoListRequest.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "VideoListRequest.h"
#import "VideoListResponse.h"
#import "UserObject.h"
#import "Request.h"

@implementation VideoListRequest

- (void) doGetVideoListRequest:(BOOL)likedVideosOnly startingAt:(int)pageStart withCount:(int)videosCount {
	// get current userId
	NSString* sessionId = [UserObject getUser].sessionId;
	// LOG_DEBUG(@"sessionId = %@", sessionId);
	
	// build params list
	NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
	[params setObject:sessionId forKey:@"session_id"];
    [params setObject:@"html5" forKey:@"type"];
    [params setObject:(likedVideosOnly ? @"true" : @"false") forKey:@"likes"];
    [params setObject:[NSString stringWithFormat:@"%d", (videosCount > 0 ? videosCount : 10)] forKey:@"count"];
    
    // send the page index only if you are loading more videos
    if (pageStart > -1) {
        [params setObject:[NSString stringWithFormat:@"%d", pageStart] forKey:@"page"];
    }
	
	// do request
    NSString* requestUrl = [NSString stringWithFormat:@"%@/api/list", WATCHLR_COM_URL];
	[self doGetRequest:requestUrl params:params];
	
	// release memory
	[params release];
}

- (id) processReceivedString: (NSString*)receivedString {
	// let the base parse the json
	id jsonObject = [super processReceivedString:receivedString];
	
	// create the response
	VideoListResponse* response = [[[VideoListResponse alloc] initWithResponse:jsonObject] autorelease];
	
	return response;
}

@end
