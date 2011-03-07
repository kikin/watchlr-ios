//
//  LinkDeviceRequest.m
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
	NSString* userId = [UserObject getUser].userId;
	self.videoObject = video;
	
	// build params list
	NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
	[params setObject:userId forKey:@"user_id"];
	[params setObject:[NSNumber numberWithInt: video.videoId] forKey:@"id"];
	
	// do request	
	[self doGetRequest:@"http://video.kikin.com/api/delete" params:params];
}

- (void) onRequestSuccess: (id)jsonObject {
	DeleteVideoResponse* response = [[DeleteVideoResponse alloc] initWithResponse:jsonObject];
	response.videoObject = self.videoObject;
	[successHandlerObject performSelector:successHandlerSelector withObject:response];
}

- (void) onRequestFailed: (NSString*)errorMessage {
	[errorHandlerObject performSelector:errorHandlerSelector withObject:errorMessage];
}

@end
