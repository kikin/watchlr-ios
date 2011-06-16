//
//  JsonRequest.m
//  KikinIos
//
//  Created by ludovic cabre on 4/1/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "JsonRequest.h"
#import "UrlUtils.h"

@implementation JsonRequest

- (id) processReceivedString: (NSString*)receivedString {
	// parse received data
	SBJsonParser* parser = [SBJsonParser new];
	id response = [parser objectWithString:receivedString];
	[parser release];
	
	// did we get a response?
	if (response == nil) {
		@throw [NSException exceptionWithName:@"RequestInvalidJson" reason:receivedString userInfo:nil];
	}
	
	return response;
}

@end
