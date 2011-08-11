//
//  VideoObject.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserActivityObject.h"
#import "VideoObject.h"

// User activity object
@interface ActivityObject : NSObject {
	long                timestamp;
    NSString*           activity_heading;
    NSMutableArray*     userActivities;
    VideoObject*        video;
}

@property()			long timestamp;
@property(retain)	NSString* activity_heading;
@property(retain)	NSMutableArray* userActivities;
@property(retain)   VideoObject* video;

- (id) initFromDictionary: (NSDictionary*)data;
- (void) updateFromDictionary: (NSDictionary*)data;
- (NSDictionary*) toDictionary;

@end