//
//  VideoListResponse.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "VideoResponse.h"
#import "VideoObject.h"

@implementation VideoResponse

@synthesize responseBody;

- (id) initWithResponse:(NSString*) aResponseBody {
    if ((self = [super init])) {
        self.responseBody = aResponseBody;
    }
    
    return self;
    
}

- (void) dealloc {
    [responseBody release];
    [super dealloc];
}

@end
