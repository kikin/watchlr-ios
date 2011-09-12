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
#import "DeviceUtils.h"

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
	[urlConnection release];
    urlConnection = nil;
	[responseData release];
    responseData = nil;
}

- (void) dealloc {
	[self releaseConnection];
	
	[connectionLock release];
    connectionLock = nil;
	[errorCallback release];
    errorCallback = nil;
	[successCallback release];
    successCallback = nil;
	
	[super dealloc];
}

- (bool) isRequesting {
	return urlConnection != nil;
}

- (void) cancelRequest {
	if (urlConnection != nil) {
        [connectionLock lock];
        // LOG_DEBUG(@"Locked connection for cancelling the request.");
		[urlConnection cancel];
		[self releaseConnection];
        [connectionLock unlock];
        // LOG_DEBUG(@"Unlocked connection after cancelling the request.");
	}
}

- (void) doGetRequest: (NSString *)url params:(NSMutableDictionary*)params {
	if (urlConnection != nil) @throw [NSException
									  exceptionWithName:@"Request"
									  reason:@"JsonRequest does not support two request at the same time"
									  userInfo:nil];
	
	[connectionLock lock];
    // LOG_DEBUG(@"Locked connection for making the request.");
	
	// create final url with parameters
	// NSString* finalUrl = [url copy];
	if (params != nil && params.count > 0) {
		url = [[url stringByAppendingString:@"?"] stringByAppendingString: [UrlUtils encodeParameters:params]];
	}
	
	// LOG_INFO(@"request url: %@", finalUrl);
	
	// create the data storage
	responseData = [[NSMutableData alloc] init];
	
	// do the request
	NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    NSString* version = [[DeviceUtils version] stringByReplacingOccurrencesOfString:@"." withString:@"_"];
    NSString* userAgentString = [NSString stringWithFormat:@"AppleCoreMedia/1.0.0.8H7 (%@; U; CPU OS %@ like Mac OS X; en_us)", ([DeviceUtils isIphone] ? @"iPhone" : @"iPad"), version];
    [urlRequest setValue: userAgentString forHTTPHeaderField:@"User-Agent"];
    
	urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
	[urlRequest release];
	// [finalUrl release];
	[connectionLock unlock];
    // LOG_DEBUG(@"Unlocked connection after making the request.");
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[connectionLock lock];
    // LOG_DEBUG(@"Locked connection for appending the response data.");
	if (responseData != nil) {
		// add to our current data
		[responseData appendData:data];
	}
	[connectionLock unlock];
    // LOG_DEBUG(@"Unocked connection after appending the response data.");
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[connectionLock lock];
    // LOG_DEBUG(@"Locked connection because request failed and we want to do cleanup.");
	[self releaseConnection];
	[self onRequestFailed: [error localizedDescription]];
	[connectionLock unlock];
    // LOG_DEBUG(@"Unlocked connection because request failed and we have done cleanup.");
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
	// LOG_DEBUG(@"Locked connection data finished loading and we are calling callbacks.");
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
    // LOG_DEBUG(@"Unlocked connection data finished loading and we have called callbacks.");
}

@end
