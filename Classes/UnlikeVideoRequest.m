//
//  DeleteVideoResponse.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/25/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "UnlikeVideoRequest.h"
#import "UserObject.h"

@implementation UnlikeVideoRequest

@synthesize videoObject;

- (void) doUnlikeVideoRequest:(VideoObject*)video {
	// get current userId
	NSString* sessionId = [UserObject getUser].sessionId;
	self.videoObject = video;
	
	// build params list
	NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
	[params setObject:sessionId forKey:@"session_id"];
	// [params setObject:videoObject.videoUrl forKey:@"url"];
	
    NSString* requestUrl = [NSString stringWithUTF8String:"http://dev-video.kikin.com/api/unlike/"];
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
	UnlikeVideoResponse* response = [[[UnlikeVideoResponse alloc] initWithResponse:jsonObject] autorelease];
	response.videoObject = videoObject;
	
	return response;
}

@end
