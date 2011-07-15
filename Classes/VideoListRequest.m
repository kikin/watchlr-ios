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

@implementation VideoListRequest

- (void) doGetVideoListRequest:(BOOL)likedVideosOnly startingAt:(int)pageIndex {
	// get current userId
	NSString* sessionId = [UserObject getUser].sessionId;
	// LOG_DEBUG(@"sessionId = %@", sessionId);
	
	// build params list
	NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
	[params setObject:sessionId forKey:@"session_id"];
    [params setObject:@"html5" forKey:@"type"];
    [params setObject:(likedVideosOnly ? @"true" : @"false") forKey:@"likes"];
    
    // send the page index only if you are loading more videos
    if (pageIndex > -1) {
        [params setObject:[NSString stringWithFormat:@"%d", pageIndex] forKey:@"page"];
    }
	
	// do request
	[self doGetRequest:@"http://www.watchlr.com/api/list" params:params];
	
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
