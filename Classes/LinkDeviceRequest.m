//
//  LinkDeviceRequest.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/25/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "LinkDeviceRequest.h"


@implementation LinkDeviceRequest

- (void) doLinkDeviceRequest:(NSString*)facebookId {
	// build params list
	NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
	[params setObject:facebookId forKey:@"id"];
	
	// do request	
	[self doGetRequest:@"http://video.kikin.com/api/fb_swap" params:params];
}

- (void) onRequestSuccess: (id)jsonObject {
	LinkDeviceResponse* response = [[LinkDeviceResponse alloc] initWithResponse:jsonObject];
	[successCallback execute:response];
	[response release];
}

- (void) onRequestFailed: (NSString*)errorMessage {
	[errorCallback execute:errorMessage];
}

@end
