//
//  DeleteVideoResponse.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/25/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "SaveUserProfileRequest.h"
#import "UserObject.h"

@implementation SaveUserProfileRequest

- (void) doSaveUserProfileRequest:(NSDictionary*)userProfile {
	// get current userId
	NSString* sessionId = [UserObject getUser].sessionId;
	
	// build params list
	NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary:userProfile];
    [params setObject:sessionId forKey:@"session_id"];
    // [params setObject:videoObject.videoUrl forKey:@"url"];
    
    NSString* requestUrl = [NSString stringWithUTF8String:"http://video.kikin.com/api/auth/profile"];
    
    // do request	
    [self doGetRequest:requestUrl params:params];
    
	
	// release memory
	[params release];
}

- (id) processReceivedString: (NSString*)receivedString {
	// let the base parse the json
	id jsonObject = [super processReceivedString:receivedString];
	
	// create the response
	SaveUserProfileResponse* response = [[[SaveUserProfileResponse alloc] initWithResponse:jsonObject] autorelease];
	
	return response;
}

@end
