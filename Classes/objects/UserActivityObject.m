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
    self.userProfile = [data objectForKey:@"user"] != [NSNull null] ? [[UserProfileObject alloc] initFromDictionary:[data objectForKey:@"user"]] : nil;
    
    return self;
}

- (NSDictionary*) toDictionary {
    NSMutableDictionary* userActivity = [[[NSMutableDictionary alloc] init] autorelease];
    
    [userActivity setObject:[[NSNumber numberWithLong:self.timestamp] stringValue] forKey:@"timestamp"];
    [userActivity setObject:self.action forKey:@"action"];
    [userActivity setObject:self.userProfile forKey:@"user"];
    
    return userActivity;
}

- (void) dealloc {
    self.action = nil;
    self.userProfile = nil;
    [super dealloc];
}

@end