//
//  DeleteVideoResponse.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/25/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonIos/JsonRequest.h>
#import "TrackerResponse.h"

@interface TrackerRequest : JsonRequest {

}

- (void) doTrackActionRequest:(NSString*)action forVideoId:(int)vid from:(NSString*)tab;
- (void) doTrackEventRequest:(NSString*)name withValue:(NSString*)value from:(NSString*)tab;
- (void) doTrackErrorRequest:(NSString*)message from:(NSString*)where andError:error;
- (id) processReceivedString: (NSString*)receivedString;

@end
