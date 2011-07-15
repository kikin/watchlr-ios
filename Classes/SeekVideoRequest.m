//
//  DeleteVideoResponse.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/25/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "SeekVideoRequest.h"
#import "UserObject.h"
#import "SeekVideoResponse.h"

@implementation SeekVideoRequest

- (void) doSeekVideoRequest:(VideoObject*)video andTime:(NSString*)seekTime {
	// get current userId
	NSString* sessionId = [UserObject getUser].sessionId;
	
	// build params list
	NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
	[params setObject:sessionId forKey:@"session_id"];
	// [params setObject:[NSNumber numberWithInt: video.videoId] forKey:@"id"];
    
    NSString* requestUrl = [NSString stringWithFormat:@"http://www.watchlr.com/api/seek/%d/%@", video.videoId, seekTime];
    // requestUrl = [requestUrl stringByAppendingString:[[NSNumber numberWithInt: video.videoId] stringValue]];
	
	// do request	
	[self doGetRequest:requestUrl params:params];
	
	// release memory
	[params release];
}

- (id) processReceivedString: (NSString*)receivedString {
	// let the base parse the json
	id jsonObject = [super processReceivedString:receivedString];
	
	// create the response
    SeekVideoResponse* response = [[[SeekVideoResponse alloc] initWithResponse:jsonObject] autorelease];
	
	return response;
}

@end
