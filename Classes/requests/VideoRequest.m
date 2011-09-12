//
//  DeleteVideoResponse.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/25/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "Request.h"
#import "VideoRequest.h"

#import "UserObject.h"
#import "VideoResponse.h"

@implementation VideoRequest

-(void) doVideoRequest:(NSString*)url withParams:(NSMutableDictionary*)params {
    
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

- (void) addVideo:(int)videoId {
    NSString* requestUrl = [NSString stringWithFormat:@"%@/api/save/%d", WATCHLR_COM_URL, videoId];
    [self doVideoRequest:requestUrl withParams:nil];
}

- (void) deleteVideo:(int)videoId {
    NSString* requestUrl = [NSString stringWithFormat:@"%@/api/remove/%d", WATCHLR_COM_URL, videoId];
    [self doVideoRequest:requestUrl withParams:nil];
}

- (void) likeVideo:(int)videoId {
    NSString* requestUrl = [NSString stringWithFormat:@"%@/api/like/%d", WATCHLR_COM_URL, videoId];
    [self doVideoRequest:requestUrl withParams:nil];
}

- (void) unlikeVideo:(int)videoId {
    NSString* requestUrl = [NSString stringWithFormat:@"%@/api/unlike/%d", WATCHLR_COM_URL, videoId];
    [self doVideoRequest:requestUrl withParams:nil];
}

- (void) getSeekTime:(int)videoId {
    NSString* requestUrl = [NSString stringWithFormat:@"%@/api/seek/%d", WATCHLR_COM_URL, videoId];
    [self doVideoRequest:requestUrl withParams:nil];
}

- (void) updateSeekTime:(NSString*)seekTime forVideo:(int)videoId {
    NSString* requestUrl = [NSString stringWithFormat:@"%@/api/seek/%d/%@", WATCHLR_COM_URL, videoId, seekTime];
    [self doVideoRequest:requestUrl withParams:nil];
}

- (void) getVideoDetail:(int) videoId {
    NSString* requestUrl = [NSString stringWithFormat:@"%@/api/get/%d", WATCHLR_COM_URL, videoId];
    [self doVideoRequest:requestUrl withParams:nil];
}

- (void) getLikedByUsers:(int)videoId forPage:(int)pageNumber withLikedByUsersCount:(int)likedByUsersCount {
    NSString* requestUrl = [NSString stringWithFormat:@"%@/api/liked_by/%d", WATCHLR_COM_URL, videoId];
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:[NSString stringWithFormat:@"%d", (likedByUsersCount > 0 ? likedByUsersCount : 10)] forKey:@"count"];
    
    // send the page index only if you are loading more videos
    if (pageNumber > -1) {
        [params setObject:[NSString stringWithFormat:@"%d", pageNumber] forKey:@"page"];
    }
    [self doVideoRequest:requestUrl withParams:params];
}

- (id) processReceivedString: (NSString*)receivedString {
	// let the base parse the json
	id jsonObject = [super processReceivedString:receivedString];
	
	// create the response
	VideoResponse* response = [[[VideoResponse alloc] initWithResponse:jsonObject] autorelease];
	return response;
}

@end
