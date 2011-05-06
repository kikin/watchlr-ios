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
	[self doGetRequest:@"https://video.kikin.com/api/fb_swap" params:params];
	
	// release memory
	[params release];
}

- (id) processReceivedString: (NSString*)receivedString {
	// let the base parse the json
	id jsonObject = [super processReceivedString:receivedString];
	
	// create the response
	LinkDeviceResponse* response = [[[LinkDeviceResponse alloc] initWithResponse:jsonObject] autorelease];
	
	return response;
}

@end
