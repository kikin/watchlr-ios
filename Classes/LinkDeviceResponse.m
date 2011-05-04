//
//  LinkDeviceResponse.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/25/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "LinkDeviceResponse.h"

@implementation LinkDeviceResponse

- (id) initWithResponse: (NSDictionary*)jsonObject {
	if (self = [super initWithResponse:jsonObject]) {
		if (success) {
			// get data
			sessionId = [[[jsonObject objectForKey:@"result"] objectForKey:@"user_id"] retain];
			
			LOG_DEBUG(@"sessionId = %@", sessionId);
		}
	}
	return self;
}

- (NSString*) sessionId {
	return sessionId;
}

- (void) dealloc {
	[sessionId release];
	[super dealloc];
}

@end
