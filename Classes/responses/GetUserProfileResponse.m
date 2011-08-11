//
//  DeleteVideoResponse.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/28/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "GetUserProfileResponse.h"

@implementation GetUserProfileResponse

@synthesize userProfile;

- (id) initWithResponse: (NSDictionary*)jsonObject {
	if ((self = [super initWithResponse:jsonObject])) {
		if (super.success) {
			// get the result in the thing
			NSDictionary* response = [jsonObject objectForKey:@"result"];
			
			// create our video array
			userProfile = [[UserProfileObject alloc] initFromDictionary:response];
		}
	}
	return self;
}

- (void) dealloc {
	[userProfile release];
	[super dealloc];
}

@end
