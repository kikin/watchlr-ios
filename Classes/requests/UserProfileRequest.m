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

- (void) doUserProfileRequest:(NSString*)url withParams:(NSMutableDictionary*)params {
    
    // get current userId
	NSString* sessionId = [UserObject getUser].sessionId;
    
    if (params == nil) {
        params = [[NSMutableDictionary alloc] init];
    } 
    [params setObject:sessionId forKey:@"session_id"];
    
    
    // do request	
	[self doGetRequest:url params:params];
    
    // release params
    [params release];
}

- (void) getUserProfile {
	NSString* requestUrl = [NSString stringWithFormat:@"%@/api/auth/profile", WATCHLR_COM_URL];
    [self doUserProfileRequest:requestUrl withParams:nil];
}

- (void) updateUserProfile:(NSDictionary*)userProfile {
	// build params list
	NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary:userProfile];
    NSString* requestUrl = [NSString stringWithFormat:@"%@/api/auth/profile", WATCHLR_COM_URL];
    [self doUserProfileRequest:requestUrl withParams:params];
}

- (void) getUserProfile:(NSString*)username {
    NSString* requestUrl = [NSString stringWithFormat:@"%@/api/user", WATCHLR_COM_URL];
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setValue:username forKey:@"username"];
    [self doUserProfileRequest:requestUrl withParams:params];
}

- (void) getPeopleUserFollows:(NSString*)username {
    NSString* requestUrl = [NSString stringWithFormat:@"%@/api/followers", WATCHLR_COM_URL];
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setValue:username forKey:@"username"];
    [self doUserProfileRequest:requestUrl withParams:params];
}

- (void) getPeopleFollowingUser:(NSString*)username {
    NSString* requestUrl = [NSString stringWithFormat:@"%@/api/following", WATCHLR_COM_URL];
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setValue:username forKey:@"username"];
    [self doUserProfileRequest:requestUrl withParams:params];
}

- (void) getLikedVideosByUser:(NSString*)username {
    NSString* requestUrl = [NSString stringWithFormat:@"%@/api/liked_videos", WATCHLR_COM_URL];
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setValue:username forKey:@"username"];
    [self doUserProfileRequest:requestUrl withParams:params];
}

- (void) followUser:(int) userId {
    NSString* requestUrl = [NSString stringWithFormat:@"%@/api/follow/%d", WATCHLR_COM_URL, userId];
    [self doUserProfileRequest:requestUrl withParams:nil];
}

- (void) unfollowUser:(int) userId {
    NSString* requestUrl = [NSString stringWithFormat:@"%@/api/unfollow/%d", WATCHLR_COM_URL, userId];
    [self doUserProfileRequest:requestUrl withParams:nil];
}

- (id) processReceivedString: (NSString*)receivedString {
	// let the base parse the json
	id jsonObject = [super processReceivedString:receivedString];
	
	// create the response
	UserProfileResponse* response = [[[UserProfileResponse alloc] initWithResponse:jsonObject] autorelease];
	
	return response;
}

@end
