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
	NSString* userId = [UserObject getUser].userId;
	
	// build params list
	NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
	[params setObject:userId forKey:@"user_id"];
	
	// do request
	[self doGetRequest:@"http://video.kikin.com/api/list" params:params];
}

- (void) onRequestSuccess: (id)jsonObject {
	VideoListResponse* response = [[VideoListResponse alloc] initWithResponse:jsonObject];
	[successHandlerObject performSelector:successHandlerSelector withObject:response];
}

- (void) onRequestFailed: (NSString*)errorMessage {
	[errorHandlerObject performSelector:errorHandlerSelector withObject:errorMessage];
}

@end
