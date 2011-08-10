//
//  VideoListResponse.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "UserActivityListResponse.h"
#import "ActivityObject.h"

@implementation UserActivityListResponse

- (id) initWithResponse: (NSDictionary*)jsonObject {
	if ((self = [super initWithResponse:jsonObject])) {
		if (success) {
			// get the result in the thing
			NSDictionary* response = [jsonObject objectForKey:@"result"];
			
			// get count/start
			count = [[response objectForKey:@"count"] intValue];
			page = [[response objectForKey:@"page"] intValue];
            total = [[response objectForKey:@"total"] intValue];
			
			// get all the videos
			if (count > 0) {
				activities = [[response objectForKey:@"user_activities"] retain];
			}
		}
	}
	return self;
}

- (int) count {
	return count;
}

- (int) page {
	return page;
}

- (int) total {
    return total;
}

- (NSArray*) activities {
	return activities;
}

- (void) dealloc {
	[activities release];
	[super dealloc];
}

@end
