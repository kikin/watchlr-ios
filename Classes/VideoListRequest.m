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

- (void) doGetVideoListRequest {
	// get current userId
	NSString* sessionId = [UserObject getUser].sessionId;
	
	// build params list
	NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
	[params setObject:sessionId forKey:@"user_id"];
	
	// do request
	[self doGetRequest:@"http://video.kikin.com/api/list" params:params];
}

- (void) onRequestSuccess: (id)jsonObject {
	VideoListResponse* response = [[VideoListResponse alloc] initWithResponse:jsonObject];
	[successCallback execute:response];
	[response release];
}

- (void) onRequestFailed: (NSString*)errorMessage {
	[errorCallback execute:errorMessage];
}

@end
