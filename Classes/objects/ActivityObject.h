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

// -----------------------------------------------------------
//                    Pair
// -----------------------------------------------------------
@interface ActivityStringPair: NSObject {
    
}

@property(retain)   NSString*key;
@property(retain)   NSString*value;

@end


// -----------------------------------------------------------
//                    User activity object
// -----------------------------------------------------------
@interface ActivityObject : NSObject {
	double                timestamp;
    NSString*           activity_heading;
    NSArray*            activityHeadingLabelsList;
    NSMutableArray*     userActivities;
    VideoObject*        video;
}

@property()			double timestamp;
@property(retain)	NSString* activity_heading;
@property(retain)	NSArray* activityHeadingLabelsList;
@property(retain)	NSMutableArray* userActivities;
@property(retain)   VideoObject* video;

- (id) initFromDictionary: (NSDictionary*)data;
- (void) updateFromDictionary: (NSDictionary*)data;
- (NSDictionary*) toDictionary;

@end