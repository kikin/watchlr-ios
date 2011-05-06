//
//  DeleteVideoResponse.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/28/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "DeleteVideoResponse.h"

@implementation DeleteVideoResponse

@synthesize videoObject;

- (id) initWithResponse: (NSDictionary*)jsonObject {
	if (self = [super initWithResponse:jsonObject]) {
		// nothing else to do
	}
	return self;
}

- (void) dealloc {
	[videoObject release];
	[super dealloc];
}


@end
