//
//  VideoListRequest.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "JsonpRequest.h"
#import "UrlUtils.h"

@implementation JsonpRequest

- (void) doGetRequest: (NSString *)url params:(NSMutableDictionary*)params {
	// add some extra parameters
	//[params setObject:@"callback" forKey:@"callback"];
	[params setObject:@"JSON" forKey:@"resultDataType"];
	[params setObject:@"javascript" forKey:@"returnType"];
	[params setObject:@"default" forKey:@"layout"];
	[params setObject:@"en-US" forKey:@"ul"];
	
	[super doGetRequest:url params:params];
}

- (id) processReceivedString: (NSString*)receivedString {
	// remove the function name
	NSString* callbackName = @"callback";
	NSRange start = [receivedString rangeOfString:[callbackName stringByAppendingString:@"({"]];
	NSRange end = [receivedString rangeOfString:@"})" options:NSBackwardsSearch];
	
	if (start.location != NSNotFound && end.location != NSNotFound) {
		NSString* jsonString = [receivedString substringWithRange: NSMakeRange(start.location+9, end.location-start.location-8)]; 
		
		// parse received data
		SBJsonParser* parser = [SBJsonParser new];
		NSDictionary* response = [parser objectWithString:jsonString];
		[parser release];
		
		if (response == nil) {
			@throw [NSException exceptionWithName:@"RequestInvalidJson" reason:receivedString userInfo:nil];
		} else {
			return response;
		}
	} else {
		@throw [NSException exceptionWithName:@"RequestNoJsonpCallback" reason:receivedString userInfo:nil];
	}
}

@end
