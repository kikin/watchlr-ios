//
//  VideoListRequest.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonIos/Request.h>

@interface GetRequest : Request

- (void) doGetVideoRequest:(NSString*)url;
- (id) processReceivedString: (NSString*)receivedString;

@end
