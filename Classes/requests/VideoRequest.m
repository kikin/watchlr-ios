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

- (void) addVideo:(VideoObject*)video {
    NSString* requestUrl = [NSString stringWithFormat:@"%@/api/save/%d", WATCHLR_COM_URL, video.videoId];
    [self doVideoRequest:requestUrl withParams:nil];
}

- (void) deleteVideo:(VideoObject*)video {
    NSString* requestUrl = [NSString stringWithFormat:@"%@/api/remove/%d", WATCHLR_COM_URL, video.videoId];
    [self doVideoRequest:requestUrl withParams:nil];
}

- (void) likeVideo:(VideoObject*)video {
    NSString* requestUrl = [NSString stringWithFormat:@"%@/api/like/%d", WATCHLR_COM_URL, video.videoId];
    [self doVideoRequest:requestUrl withParams:nil];
}

- (void) unlikeVideo:(VideoObject*)video {
    NSString* requestUrl = [NSString stringWithFormat:@"%@/api/unlike/%d", WATCHLR_COM_URL, video.videoId];
    [self doVideoRequest:requestUrl withParams:nil];
}

- (void) getSeekTime:(VideoObject*)video {
    NSString* requestUrl = [NSString stringWithFormat:@"%@/api/seek/%d", WATCHLR_COM_URL, video.videoId];
    [self doVideoRequest:requestUrl withParams:nil];
}

- (void) updateSeekTime:(NSString*)seekTime forVideo:(VideoObject*)video {
    NSString* requestUrl = [NSString stringWithFormat:@"%@/api/seek/%d/%@", WATCHLR_COM_URL, video.videoId, seekTime];
    [self doVideoRequest:requestUrl withParams:nil];
}

- (id) processReceivedString: (NSString*)receivedString {
	// let the base parse the json
	id jsonObject = [super processReceivedString:receivedString];
	
	// create the response
	VideoResponse* response = [[[VideoResponse alloc] initWithResponse:jsonObject] autorelease];
	return response;
}

@end
