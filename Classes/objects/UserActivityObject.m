//
//  VideoObject.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "UserActivityObject.h"

// -----------------------------------------------------------
//                    User Activity
// -----------------------------------------------------------
@implementation UserActivityObject

@synthesize timestamp, action, userProfile;

- (id) initFromDictionary: (NSDictionary*)data { 
    self.timestamp = [[data objectForKey:@"timestamp"] longValue];
    self.action = [data objectForKey:@"action"] != [NSNull null] ? [data objectForKey:@"action"] : nil;
    userProfile = [data objectForKey:@"user"] != [NSNull null] ? [[UserProfileObject alloc] initFromDictionary:[data objectForKey:@"user"]] : nil;
    
    return self;
}

- (NSDictionary*) toDictionary {
    NSMutableDictionary* userActivity = [[[NSMutableDictionary alloc] init] autorelease];
    
    [userActivity setObject:[[NSNumber numberWithLong:timestamp] stringValue] forKey:@"timestamp"];
    [userActivity setObject:action forKey:@"action"];
    [userActivity setObject:userProfile forKey:@"user"];
    
    return userActivity;
}

- (void) dealloc {
    [action release];
    [userProfile release];
    
    action = nil;
    userProfile = nil;
    
    [super dealloc];
}

@end