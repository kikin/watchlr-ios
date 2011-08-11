//
//  VideoListResponse.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DefaultResponse.h"

@interface GetResponse : NSObject {
    NSString* responseBody;
}

@property(retain) NSString* responseBody;

- (id) initWithResponse:(NSString*) aResponseBody;

@end
