//
//  VideoListRequest.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "JsonRequest.h"

@implementation JsonRequest

@synthesize successHandlerSelector, successHandlerObject, errorHandlerSelector, errorHandlerObject;

- (id) init {
	self = [super init];
	if (self) {
		responseData = [[NSMutableData data] retain];
	}
	return self;
}

- (void) dealloc {
	[responseData release];
	[super dealloc];
}

- (NSString*) encodeParameters: (NSDictionary*)params {
	NSMutableArray* parts = [NSMutableArray array];
	for (id key in params) {
		id value = [params objectForKey: key];
		
		// get the string value of this value
		NSString* stringValue = [NSString stringWithFormat: @"%@", value];
		NSString* stringKey = [NSString stringWithFormat: @"%@", key];
		
		// urlencode the value
		NSString* encodedValue = [stringValue stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
		
		// add to the list
		NSString* part = [NSString stringWithFormat: @"%@=%@", stringKey, encodedValue];
		[parts addObject: part];
	}
	return [parts componentsJoinedByString: @"&"];
}

- (void) doGetRequest: (NSString *)url params:(NSDictionary*)params {
	if (urlRequest != nil) @throw [NSException
								   exceptionWithName:@"JsonRequest"
								   reason:@"JsonRequest does not support two request at the same time"
								   userInfo:nil];
	
	NSString* finalUrl = [url copy]; 
	if (params != nil && params.count > 0) {
		finalUrl = [[finalUrl stringByAppendingString:@"?"] stringByAppendingString: [self encodeParameters:params]];
	}
	
	NSLog(@"JsonRequest GET request URL: %@", finalUrl);
	
	urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:finalUrl]];
	[[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	// erase any previous data
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	// add to our current data
	[responseData appendData:data];
}

- (void) setErrorCallback: (id)object callback:(SEL)callback {
	// save callback
	errorHandlerObject = object;
	errorHandlerSelector = callback;
}

- (void) setSuccessCallback: (id)object callback:(SEL)callback {
	// save callback
	successHandlerObject = object;
	successHandlerSelector = callback;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	// put to nil so a request can be done again
	urlRequest = nil;
	
	[self onRequestFailed: [error description]];
	//[self onRequestFailed:[error description]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	// get string from received data
	NSString *receivedString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	if (receivedString == nil) {
		[self onRequestFailed: @"could not convert response to text"];
	} else {
		// parse received data
		SBJsonParser* parser = [SBJsonParser new];
		NSDictionary* response = [parser objectWithString:receivedString];
		if (response == nil) {
			[self onRequestFailed: @"could not parse the server response"];
		} else {
			// parsing successful check request status
			bool success = [[response objectForKey:@"success"] boolValue];
			if (success) {
				// everything is perfect
				id result = [response objectForKey:@"result"];
				[self onRequestSuccess:result];
			} else {
				// server saying there was an error
				id errorMessage = [response objectForKey:@"error"];
				[self onRequestFailed: [NSString stringWithFormat: @"server returned an error %@", errorMessage]];
			}
		}
		[parser release];
	}
	[connection release];
	
	// put to nil so a request can be done again
	urlRequest = nil;
}

@end
