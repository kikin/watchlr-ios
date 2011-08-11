//
//  VideoListResponse.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "GetResponse.h"

@implementation GetResponse

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
