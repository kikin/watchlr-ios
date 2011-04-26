//
//  JsonRequest.m
//  KikinIos
//
//  Created by ludovic cabre on 4/1/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "JsonRequest.h"
#import "Logger.h"

@implementation JsonRequest

@synthesize errorCallback, successCallback;

- (id) init {
	if (self = [super init]) {
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

- (NSString*) encodeParameters: (NSDictionary*)params {
	NSMutableArray* parts = [NSMutableArray array];
	for (id key in params) {
		id value = [params objectForKey: key];
		
		// get the string value of this value
		NSString* stringValue = [NSString stringWithFormat: @"%@", value];
		NSString* stringKey = [NSString stringWithFormat: @"%@", key];
		
		// urlencode the value
		NSString* encodedValue = (NSString*)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)stringValue, NULL, CFSTR(":/?#[]@!$&’()*+,;="), kCFStringEncodingUTF8);
		
		// add to the list
		NSString* part = [NSString stringWithFormat: @"%@=%@", stringKey, encodedValue];
		[parts addObject: part];
	}
	return [parts componentsJoinedByString: @"&"];
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
									  exceptionWithName:@"JsonRequest"
									  reason:@"JsonRequest does not support two request at the same time"
									  userInfo:nil];
	
	[connectionLock lock];
	
	// create final url with parameters
	NSString* finalUrl = [url copy];
	if (params != nil && params.count > 0) {
		finalUrl = [[finalUrl stringByAppendingString:@"?"] stringByAppendingString: [self encodeParameters:params]];
	}
	
	LOG_INFO(@"request url: %@", finalUrl);
	
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
	[self onRequestFailed: [error description]];
	[connectionLock unlock];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[connectionLock lock];
	
	// get string from received data
	NSString* receivedString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	if (receivedString == nil) {
		[self onRequestFailed: @"could not convert response to text"];
		
	} else {
		// parse received data
		SBJsonParser* parser = [SBJsonParser new];
		id response = [parser objectWithString:receivedString];
		if (response == nil) {
			[self onRequestFailed: @"could not parse the server response"];
		} else {
			LOG_DEBUG(@"%@", receivedString);
			[self onRequestSuccess:response];
		}
		[parser release];
	}
	[receivedString release];
	
	[self releaseConnection];
	[connectionLock unlock];
}


@end
