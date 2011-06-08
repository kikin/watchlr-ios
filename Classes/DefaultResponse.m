//
//  DefaultResponse.m
//  KikinVideo
//
//  Created by ludovic cabre on 4/25/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "DefaultResponse.h"

@implementation DefaultResponse

- (id) initWithResponse: (NSDictionary*)jsonObject {
	if ((self = [super init])) {
		success = [[jsonObject objectForKey:@"success"] boolValue];
		if (!success) {
			errorMessage = [[jsonObject objectForKey:@"error"] retain];
			if (errorMessage == nil || errorMessage.length == 0) {
				errorMessage = @"No error message found";
			}
		}
	}
	return self;
}

- (NSString*) errorMessage {
	return errorMessage;
}

- (BOOL) success {
	return success;
}

- (void) dealloc {
	[errorMessage release];
	[super dealloc];
}


@end
