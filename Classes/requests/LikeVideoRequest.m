//
//  DeleteVideoResponse.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/25/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "LikeVideoRequest.h"
#import "UserObject.h"
#import "Request.h"

@implementation LikeVideoRequest

@synthesize videoObject;

- (void) doLikeVideoRequest:(VideoObject*)video {
	// get current userId
	NSString* sessionId = [UserObject getUser].sessionId;
	self.videoObject = video;
	
	// build params list
	NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
	[params setObject:sessionId forKey:@"session_id"];
	// [params setObject:videoObject.videoUrl forKey:@"url"];
    
    NSString* requestUrl = [NSString stringWithFormat:@"%@/api/like/", WATCHLR_COM_URL];
    requestUrl = [requestUrl stringByAppendingString:[[NSNumber numberWithInt: video.videoId] stringValue]];
	
	// do request	
	[self doGetRequest:requestUrl params:params];
	
	// release memory
	[params release];
}

- (id) processReceivedString: (NSString*)receivedString {
	// let the base parse the json
	id jsonObject = [super processReceivedString:receivedString];
	
	// create the response
	LikeVideoResponse* response = [[[LikeVideoResponse alloc] initWithResponse:jsonObject] autorelease];
	response.videoObject = videoObject;
	
	return response;
}

@end
