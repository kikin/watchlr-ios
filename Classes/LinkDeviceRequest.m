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
    NSString* requestUrl = [NSString stringWithUTF8String:"http://dev-video.kikin.com/api/auth/swap/"];
    requestUrl = [requestUrl stringByAppendingString:facebookId];
    
    
    [self doGetRequest:requestUrl params:nil];
	
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
