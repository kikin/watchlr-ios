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
	[params setObject:sessionId forKey:@"user_id"];
	[params setObject:[NSNumber numberWithInt: video.videoId] forKey:@"id"];
	
	// do request	
	[self doGetRequest:@"https://video.kikin.com/api/delete" params:params];
}

- (id) processReceivedString: (NSString*)receivedString {
	// let the base parse the json
	id jsonObject = [super processReceivedString:receivedString];
	
	// create the response
	DeleteVideoResponse* response = [[DeleteVideoResponse alloc] initWithResponse:jsonObject];
	
	return response;
}

@end
