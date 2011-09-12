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

- (void) getUserProfile:(int)userId {
    NSString* requestUrl = [NSString stringWithFormat:@"%@/api/user", WATCHLR_COM_URL];
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSNumber numberWithInt:userId] forKey:@"user_id"];
    [self doUserProfileRequest:requestUrl withParams:params];
}

- (void) getUserProfileForName:(NSString*)username {
    NSString* requestUrl = [NSString stringWithFormat:@"%@/api/user", WATCHLR_COM_URL];
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setValue:username forKey:@"username"];
    [self doUserProfileRequest:requestUrl withParams:params];
}

- (void) getPeopleUserFollows:(int)userId forPage:(int)page withFollowersCount:(int)followersCount {
    NSString* requestUrl = [NSString stringWithFormat:@"%@/api/followers", WATCHLR_COM_URL];
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSNumber numberWithInt:userId] forKey:@"user_id"];
    [params setObject:[NSString stringWithFormat:@"%d", (followersCount > 0 ? followersCount : 10)] forKey:@"count"];
    
    // send the page index only if you are loading more videos
    if (page > -1) {
        [params setObject:[NSString stringWithFormat:@"%d", page] forKey:@"page"];
    }
    [self doUserProfileRequest:requestUrl withParams:params];
}

- (void) getPeopleFollowingUser:(int)userId forPage:(int)page withFollowingCount:(int)followingCount {
    NSString* requestUrl = [NSString stringWithFormat:@"%@/api/following", WATCHLR_COM_URL];
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSNumber numberWithInt:userId] forKey:@"user_id"];
    [params setObject:[NSString stringWithFormat:@"%d", (followingCount > 0 ? followingCount : 10)] forKey:@"count"];
    
    // send the page index only if you are loading more videos
    if (page > -1) {
        [params setObject:[NSString stringWithFormat:@"%d", page] forKey:@"page"];
    }
    [self doUserProfileRequest:requestUrl withParams:params];
}

- (void) getLikedVideosByUser:(int)userId forPage:(int)page withVideosCount:(int)videosCount {
    NSString* requestUrl = [NSString stringWithFormat:@"%@/api/liked_videos", WATCHLR_COM_URL];
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSNumber numberWithInt:userId] forKey:@"user_id"];
    [params setObject:[NSString stringWithFormat:@"%d", (videosCount > 0 ? videosCount : 10)] forKey:@"count"];
    
    // send the page index only if you are loading more videos
    if (page > -1) {
        [params setObject:[NSString stringWithFormat:@"%d", page] forKey:@"page"];
    }
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
