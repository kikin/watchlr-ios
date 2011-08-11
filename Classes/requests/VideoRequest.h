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

- (void) addVideo:(VideoObject*)video;
- (void) deleteVideo:(VideoObject*)video;
- (void) likeVideo:(VideoObject*)video;
- (void) unlikeVideo:(VideoObject*)video;
- (void) getSeekTime:(VideoObject*)video;
- (void) updateSeekTime:(NSString*)seekTime forVideo:(VideoObject*)video;

- (id) processReceivedString: (NSString*)receivedString;

@end
