//
//  DeleteVideoResponse.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/28/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "UserProfileResponse.h"

@implementation UserProfileResponse

@synthesize userProfile;

- (id) initWithResponse: (NSDictionary*)jsonObject {
	if ((self = [super initWithResponse:jsonObject])) {
		if (super.success) {
			// get the result in the thing
			userProfile = [jsonObject objectForKey:@"result"];
            [userProfile retain];
		}
	}
	return self;
}

- (void) dealloc {
	[userProfile release];
	[super dealloc];
}

@end
