//
//  DeleteVideoResponse.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/25/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "UserProfileRequest.h"
#import "UserProfileResponse.h"
#import "UserObject.h"
#import "Request.h"

@implementation UserProfileRequest

- (void) getUserProfile {
	// get current userId
	NSString* sessionId = [UserObject getUser].sessionId;
	
    // build params list
	NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
	[params setObject:sessionId forKey:@"session_id"];
	
    NSString* requestUrl = [NSString stringWithFormat:@"%@/api/auth/profile", WATCHLR_COM_URL];
    
	// do request	
	[self doGetRequest:requestUrl params:params];
	
	// release memory
	[params release];
}

- (void) updateUserProfile:(NSDictionary*)userProfile {
	// get current userId
	NSString* sessionId = [UserObject getUser].sessionId;
	
	// build params list
	NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary:userProfile];
    [params setObject:sessionId forKey:@"session_id"];
    
    NSString* requestUrl = [NSString stringWithFormat:@"%@/api/auth/profile", WATCHLR_COM_URL];
    
    // do request	
    [self doGetRequest:requestUrl params:params];
    
	
	// release memory
	[params release];
}

- (id) processReceivedString: (NSString*)receivedString {
	// let the base parse the json
	id jsonObject = [super processReceivedString:receivedString];
	
	// create the response
	UserProfileResponse* response = [[[UserProfileResponse alloc] initWithResponse:jsonObject] autorelease];
	
	return response;
}

@end
