//
//  DeleteVideoResponse.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/25/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonIos/JsonRequest.h>
#import "VideoObject.h"

@interface VideoRequest : JsonRequest {

}

- (void) addVideo:(int)videoId;
- (void) deleteVideo:(int)videoId;
- (void) likeVideo:(int)videoId;
- (void) unlikeVideo:(int)videoId;
- (void) getSeekTime:(int)videoId;
- (void) updateSeekTime:(NSString*)seekTime forVideo:(int)videoId;
- (void) getVideoDetail:(int)videoId;
- (void) getLikedByUsers:(int)videoId forPage:(int)pageNumber withLikedByUsersCount:(int)likedByUsersCount;

- (id) processReceivedString: (NSString*)receivedString;

@end
