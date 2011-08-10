//
//  DeleteVideoResponse.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/28/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "SeekVideoResponse.h"

@implementation SeekVideoResponse

@synthesize seekTime;

- (id) initWithResponse: (NSDictionary*)jsonObject {
	if ((self = [super initWithResponse:jsonObject])) {
		if (success) {
			// get the result in the thing
			NSDictionary* response = [jsonObject objectForKey:@"result"];
			
            if ([response objectForKey:@"position"] != [NSNull null]) {
			    seekTime = [[response objectForKey:@"position"] doubleValue];
            } else {
                seekTime = 0.0;
            }
        	
		}
	}
	return self;
}

- (void) dealloc { 
	[super dealloc];
}

@end
