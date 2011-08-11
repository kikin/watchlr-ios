//
//  DeleteVideoResponse.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/28/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "VideoResponse.h"

@implementation VideoResponse

@synthesize videoResponse;

- (id) initWithResponse: (NSDictionary*)jsonObject {
	if ((self = [super initWithResponse:jsonObject])) {
		if (success) {
			// get the result in the thing
			videoResponse = [jsonObject objectForKey:@"result"];
            [videoResponse retain];
		}
	}
	return self;
}

- (void) dealloc {
	[videoResponse release];
	[super dealloc];
}


@end
