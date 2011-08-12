//
//  VideoListRequest.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "GetRequest.h"
#import "GetResponse.h"
#import "UserObject.h"

@implementation GetRequest

- (void) doGetVideoRequest:(NSString*)url {
	// LOG_DEBUG(@"video url = %@", url);
	
	// do request
	[self doGetRequest:url params:nil];
}

- (id) processReceivedString: (NSString*)receivedString {
	// create the response
	GetResponse* response = [[[GetResponse alloc] initWithResponse:receivedString] autorelease];
	
	return response;
}

@end
