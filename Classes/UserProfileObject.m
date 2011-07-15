//
//  VideoObject.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "UserProfileObject.h"

// -----------------------------------------------------------
//                    User Notifications
// -----------------------------------------------------------
@implementation UserNotification

@synthesize welcome, firstLike, emptyq;

- (id) initFromDictionnary: (NSDictionary*)data { 
    self.welcome = [[data objectForKey:@"welcome"] intValue];
    self.firstLike = [[data objectForKey:@"firstlike"] intValue];
    self.emptyq = [[data objectForKey:@"emptyq"] intValue];
    
    return self;
}

- (NSDictionary*) toDictionary {
    NSMutableDictionary* userNotification = [[[NSMutableDictionary alloc] init] autorelease];
    
    [userNotification setObject:[[NSNumber numberWithInt:self.welcome] stringValue] forKey:@"welcome"];
    [userNotification setObject:[[NSNumber numberWithInt:self.firstLike] stringValue] forKey:@"firstlike"];
    [userNotification setObject:[[NSNumber numberWithInt:self.emptyq] stringValue] forKey:@"emptyq"];
    
    return userNotification;
}

- (void) dealloc {
    [super dealloc];
}

@end

// -----------------------------------------------------------
//                    User Preferences
// -----------------------------------------------------------
@implementation UserPreferences

@synthesize syndicate;

- (id) initFromDictionnary: (NSDictionary*)data { 
    self.syndicate = [[data objectForKey:@"syndicate"] intValue];
    return self;
}

- (NSDictionary*) toDictionary {
    NSMutableDictionary* userPreferences = [[[NSMutableDictionary alloc] init] autorelease];
    [userPreferences setObject:[[NSNumber numberWithInt:self.syndicate] stringValue] forKey:@"syndicate"];
    return userPreferences;
}

- (void) dealloc {
    [super dealloc];
}

@end

// -----------------------------------------------------------
//                    User Profile
// -----------------------------------------------------------

@implementation UserProfileObject

@synthesize likes, watched, saved, queued, name, userName, pictureUrl, email, notifications, preferences;

- (id) initFromDictionnary: (NSDictionary*)data {
	// get data from this video
	self.likes = [[data objectForKey:@"likes"] intValue];
    self.watched = [[data objectForKey:@"watched"] intValue];
    self.saved = [[data objectForKey:@"saved"] intValue];
    self.queued = [[data objectForKey:@"queued"] intValue];
	self.name = [data objectForKey:@"name"] != [NSNull null] ? [data objectForKey:@"name"] : nil;
    self.userName = [data objectForKey:@"username"] != [NSNull null] ? [data objectForKey:@"username"] : nil;
    self.pictureUrl = [data objectForKey:@"picture"] != [NSNull null] ? [data objectForKey:@"picture"] : nil;
    self.email = [data objectForKey:@"email"] != [NSNull null] ? [data objectForKey:@"email"] : nil;
    self.notifications = [data objectForKey:@"notifications"] != [NSNull null] ? [[UserNotification alloc] initFromDictionnary:[data objectForKey:@"notifications"]] : nil;
    self.preferences = [data objectForKey:@"preferences"] != [NSNull null] ? [[UserPreferences alloc] initFromDictionnary:[data objectForKey:@"preferences"]] : nil;
	
    return self;
}

- (NSDictionary*) toDictionary {
    NSMutableDictionary* userProfile = [[[NSMutableDictionary alloc] init] autorelease];
    
    [userProfile setObject:[[NSNumber numberWithInt:self.likes] stringValue] forKey:@"likes"];
    [userProfile setObject:[[NSNumber numberWithInt:self.watched] stringValue] forKey:@"watched"];
    [userProfile setObject:[[NSNumber numberWithInt:self.saved] stringValue] forKey:@"saved"];
    [userProfile setObject:[[NSNumber numberWithInt:self.queued] stringValue] forKey:@"queued"];
    
    [userProfile setObject:self.name forKey:@"name"];
    [userProfile setObject:self.userName forKey:@"username"];
    [userProfile setObject:self.pictureUrl forKey:@"picture"];
    [userProfile setObject:self.email forKey:@"email"];
    
    [userProfile setObject:self.preferences forKey:@"preferences"];
    [userProfile setObject:self.notifications forKey:@"notifications"];
    
    return userProfile;
}

- (void) dealloc {
	
    self.name = nil;
	self.userName = nil;
	self.pictureUrl = nil;
	self.email = nil;
	self.notifications = nil;
    self.preferences = nil;
    
    [super dealloc];
}


@end
