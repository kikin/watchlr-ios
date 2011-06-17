//
//  Request.m
//  CommonIos
//
//  Created by ludovic cabre on 5/3/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "Request.h"
#import "Logger.h"
#import "UrlUtils.h"

@implementation Request

@synthesize errorCallback, successCallback;

- (id) init {
    if ((self = [super init])) {
		// initialize
		connectionLock = [[NSLock alloc] init];
	}
	return self;
}

- (void) releaseConnection {
	[urlConnection release], urlConnection = nil;
	[responseData release], responseData = nil;
}

- (void) dealloc {
	[self releaseConnection];
	
	[connectionLock release], connectionLock = nil;
	[errorCallback release], errorCallback = nil;
	[successCallback release], successCallback = nil;
	
	[super dealloc];
}

- (bool) isRequesting {
	return urlConnection != nil;
}

- (void) cancelRequest {
	[connectionLock lock];
	if (urlConnection != nil) {
		[urlConnection cancel];
		[self releaseConnection];
	}
	[connectionLock unlock];
}

- (void) doGetRequest: (NSString *)url params:(NSMutableDictionary*)params {
	if (urlConnection != nil) @throw [NSException
									  exceptionWithName:@"Request"
									  reason:@"JsonRequest does not support two request at the same time"
									  userInfo:nil];
	
	[connectionLock lock];
	
	// create final url with parameters
	NSString* finalUrl = [url copy];
	if (params != nil && params.count > 0) {
		finalUrl = [[finalUrl stringByAppendingString:@"?"] stringByAppendingString: [UrlUtils encodeParameters:params]];
	}
	
	// LOG_INFO(@"request url: %@", finalUrl);
	
	// create the data storage
	responseData = [[NSMutableData alloc] init];
	
	// do the request
	NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:finalUrl]];
	urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
	[urlRequest release];
	
	[connectionLock unlock];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[connectionLock lock];
	if (responseData != nil) {
		// add to our current data
		[responseData appendData:data];
	}
	[connectionLock unlock];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[connectionLock lock];
	[self releaseConnection];
	[self onRequestFailed: [error localizedDescription]];
	[connectionLock unlock];
}

- (id) processReceivedString: (NSString*)receivedString {
	return receivedString;
}

- (void) onRequestSuccess: (id)jsonObject {
	[successCallback execute:jsonObject];
}

- (void) onRequestFailed: (NSString*)errorMessage {
	[errorCallback execute:errorMessage];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[connectionLock lock];
	
	@try {
		// get string from received data
		NSString* receivedString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
		if (receivedString == nil) {
			@throw [NSException exceptionWithName:@"RequestInvalidResponse" reason:@"could not convert response to text" userInfo:nil];
		} else {
			//LOG_DEBUG(@"receivedString = %@", receivedString);
			
			// process the received data and then call the callback
			id response = [self processReceivedString:receivedString];
			[response retain];
			[self onRequestSuccess:response];
			[response release];
			[receivedString release];
		}
		
		[self releaseConnection];
	} @catch (NSException* e) {
		[self onRequestFailed: [NSString stringWithFormat:@"%@: %@", e.name, e.description]];
	}

	[connectionLock unlock];
}

@end
