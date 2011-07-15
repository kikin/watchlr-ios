//
//  DeleteVideoResponse.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/25/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "DeleteVideoRequest.h"
#import "UserObject.h"

@implementation DeleteVideoRequest

@synthesize videoObject;

- (void) doDeleteVideoRequest:(VideoObject*)video {
	// get current userId
	NSString* sessionId = [UserObject getUser].sessionId;
	self.videoObject = video;
	
	// build params list
	NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
	[params setObject:sessionId forKey:@"session_id"];
	// [params setObject:[NSNumber numberWithInt: video.videoId] forKey:@"id"];
    
    NSString* requestUrl = [NSString stringWithUTF8String:"http://www.watchlr.com/api/remove/"];
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
	DeleteVideoResponse* response = [[[DeleteVideoResponse alloc] initWithResponse:jsonObject] autorelease];
	response.videoObject = videoObject;
	
	return response;
}

@end
