//
//  UrlUtils.m
//  KikinIos
//
//  Created by ludovic cabre on 4/29/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "UrlUtils.h"

@implementation UrlUtils

+ (NSString*) encodeParameters: (NSDictionary*)params {
	NSMutableArray* parts = [NSMutableArray array];
	for (id key in params) {
		id value = [params objectForKey: key];
        if ([value isKindOfClass:[NSDictionary class]]) {
            value = [self encodeParameters:value];
        }
		
		// get the string value of this value
		NSString* stringValue = [NSString stringWithFormat: @"%@", value];
		NSString* stringKey = [NSString stringWithFormat: @"%@", key];
		
		// urlencode the value
		NSString* encodedValue = (NSString*)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)stringValue, NULL, CFSTR(":/?#[]@!$&’()*+,;="), kCFStringEncodingUTF8);
		
		// add to the list
		NSString* part = [NSString stringWithFormat: @"%@=%@", stringKey, encodedValue];
        [encodedValue release];
		[parts addObject: part];
	}
	return [parts componentsJoinedByString: @"&"];
}

+ (NSString*) urlWithoutHash: (NSString*)url {
	NSRange range = [url rangeOfString:@"#"];
	if (range.location != NSNotFound) {
		return [url substringToIndex:range.location];
	}
	return url;
}

+ (BOOL) isSameUrlWithoutHash: (NSString*)url1 url:(NSString*)url2 {
	// LOG_DEBUG(@"url1 = %@", url1);
	// LOG_DEBUG(@"url2 = %@", url2);
	NSString* urlNoHash1 = [[UrlUtils urlWithoutHash:url1] lowercaseString];
	NSString* urlNoHash2 = [[UrlUtils urlWithoutHash:url2] lowercaseString];
	// LOG_DEBUG(@"urlNoHash1 = %@", urlNoHash1);
	// LOG_DEBUG(@"urlNoHash2 = %@", urlNoHash2);
	return [urlNoHash1 isEqualToString:urlNoHash2];
}

+ (BOOL) isOnlyDifferenceHash: (NSString*)url1 url:(NSString*)url2 {
	NSRange range1 = [url1 rangeOfString:@"#"];
	NSRange range2 = [url2 rangeOfString:@"#"];
	
	// make sure that we have a hash at least in one of the urls
	if (range1.location != NSNotFound || range2.location != NSNotFound) {
		
		// remove the hash of the urls
		NSString* urlNoHash1 = [[UrlUtils urlWithoutHash:url1] lowercaseString];
		NSString* urlNoHash2 = [[UrlUtils urlWithoutHash:url2] lowercaseString];
		
		// compare
		return [urlNoHash1 isEqualToString:urlNoHash2];
	}
	
	return NO;
}

@end
