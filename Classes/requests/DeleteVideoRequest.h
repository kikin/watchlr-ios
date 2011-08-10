//
//  DeleteVideoResponse.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/25/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonIos/JsonRequest.h>
#import "DeleteVideoResponse.h"
#import "VideoObject.h"

@interface DeleteVideoRequest : JsonRequest {

}

- (void) doDeleteVideoRequest:(VideoObject*)video;
- (id) processReceivedString: (NSString*)receivedString;

@property(retain) VideoObject* videoObject;

@end
