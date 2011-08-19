//
//  LinkDeviceResponse.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/25/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "LinkDeviceResponse.h"

@implementation LinkDeviceResponse

@synthesize response;

- (id) initWithResponse: (NSDictionary*)jsonObject {
	if ((self = [super initWithResponse:jsonObject])) {
		if (success) {
			// get data
			response = [[jsonObject objectForKey:@"result"] retain];
			
			// LOG_DEBUG(@"sessionId = %@", sessionId);
		}
	}
	return self;
}

- (void) dealloc {
	[response release];
	[super dealloc];
}

@end
