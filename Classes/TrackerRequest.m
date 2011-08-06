//
//  DeleteVideoResponse.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/25/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "TrackerRequest.h"
#import "TrackerResponse.h"
#import "UserObject.h"

@implementation TrackerRequest

-(void) doTrackingRequest:(NSString*)url withParams:(NSMutableDictionary*)params {
    
    // get current userId
	NSString* sessionId = [UserObject getUser].sessionId;
    
    [params setObject:sessionId forKey:@"session_id"];
    [params setObject:@"iPad" forKey:@"agent"];
    [params setObject:@"1.0" forKey:@"version"];
    
    // do request	
	[self doGetRequest:url params:params];
}

- (void) doTrackActionRequest:(NSString*)action forVideoId:(int)vid from:(NSString*)tab {
    // build params list
	NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
	[params setObject:action forKey:@"action"];
	[params setObject:[NSNumber numberWithInt:vid] forKey:@"id"];
    
	// do Request
    [self doTrackingRequest:[NSString stringWithUTF8String:"http://www.watchlr.com/track/action"] withParams:params];
    
	// release memory
	[params release];
}

- (void) doTrackEventRequest:(NSString*)name withValue:(NSString*)value from:(NSString*)tab {
    // build params list
	NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:name forKey:@"name"];
	[params setObject:value forKey:@"value"];
	
	// do request	
	[self doTrackingRequest:[NSString stringWithUTF8String:"http://www.watchlr.com/track/event"] withParams:params];
	
	// release memory
	[params release];
}

- (void) doTrackErrorRequest:(NSString*)message from:(NSString*)where andError:error {
	// build params list
	NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:where forKey:@"from"];
	[params setObject:message forKey:@"msg"];
    [params setObject:error forKey:@"exception"];
	
	// do request	
	[self doTrackingRequest:[NSString stringWithUTF8String:"http://www.watchlr.com/track/event"] withParams:params];
	
	// release memory
	[params release];
}

- (id) processReceivedString: (NSString*)receivedString {
//	// let the base parse the json
//	id jsonObject = [super processReceivedString:receivedString];
//	
//	// create the response
//	UnlikeVideoResponse* response = [[[UnlikeVideoResponse alloc] initWithResponse:jsonObject] autorelease];
//	response.videoObject = videoObject;
//	
//	return response;
    return NULL;
}

@end
