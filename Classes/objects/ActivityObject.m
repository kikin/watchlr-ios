//
//  VideoObject.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "ActivityObject.h"

// -----------------------------------------------------------
//                    User Activity
// -----------------------------------------------------------
@implementation ActivityObject

@synthesize timestamp, activity_heading, userActivities, video;

- (id) initFromDictionnary: (NSDictionary*)data { 
    self.timestamp = [[data objectForKey:@"timestamp"] longValue];
    self.activity_heading = [data objectForKey:@"activity_heading"] != [NSNull null] ? [data objectForKey:@"activity_heading"] : nil;
    self.video = [data objectForKey:@"video"] != [NSNull null] ? [[VideoObject alloc] initFromDictionnary:[data objectForKey:@"video"]] : nil;
    
    NSArray* userActivitiesList = [data objectForKey:@"user_activities"];
    if (userActivitiesList != nil) {
        self.userActivities = [[NSMutableArray alloc] init];
        for (NSDictionary* userActivity in userActivitiesList) {
            UserActivityObject* userActivityObject = [[[UserActivityObject alloc] initFromDictionnary:userActivity] autorelease];
            [self.userActivities addObject:userActivityObject];
        }
    } else {
        self.userActivities = nil;
    }
    
    return self;
}

- (NSDictionary*) toDictionary {
    NSMutableDictionary* userActivity = [[[NSMutableDictionary alloc] init] autorelease];
    
    [userActivity setObject:[[NSNumber numberWithLong:self.timestamp] stringValue] forKey:@"timestamp"];
    [userActivity setObject:self.activity_heading forKey:@"activity_heading"];
    [userActivity setObject:self.userActivities forKey:@"user_activities"];
    [userActivity setObject:self.video forKey:@"video"];
    
    return userActivity;
}

- (void) dealloc {
    self.activity_heading = nil;
    self.userActivities = nil;
    self.video = nil;
    
    [super dealloc];
}

@end