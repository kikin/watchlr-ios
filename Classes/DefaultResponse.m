//
//  DefaultResponse.m
//  KikinVideo
//
//  Created by ludovic cabre on 4/25/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "DefaultResponse.h"

@implementation DefaultResponse

@synthesize errorCode, errorMessage, success;

- (id) initWithResponse: (NSDictionary*)jsonObject {
	errorCode = 400;
    if ((self = [super init])) {
		success = [[jsonObject objectForKey:@"success"] boolValue];
		if (!success) {
			errorMessage = [[jsonObject objectForKey:@"error"] retain];
			if (errorMessage == nil || errorMessage.length == 0) {
				errorMessage = @"No error message found";
			}
		}
        
        errorCode = [[jsonObject objectForKey:@"code"] intValue];
        LOG_DEBUG(@"Error code:%d", errorCode);
	} 
	return self;
}

- (void) dealloc {
	[errorMessage release];
	[super dealloc];
}


@end
