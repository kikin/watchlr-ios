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

- (id) initFromDictionary: (NSDictionary*)data { 
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

@synthesize syndicate, follow_email;

- (id) initFromDictionary: (NSDictionary*)data { 
    self.syndicate = [[data objectForKey:@"syndicate"] intValue];
    self.follow_email = [[data objectForKey:@"follow_email"] intValue];
    return self;
}

- (NSDictionary*) toDictionary {
    NSMutableDictionary* userPreferences = [[[NSMutableDictionary alloc] init] autorelease];
    [userPreferences setObject:[[NSNumber numberWithInt:self.syndicate] stringValue] forKey:@"syndicate"];
    [userPreferences setObject:[[NSNumber numberWithInt:self.follow_email] stringValue] forKey:@"follow_email"];
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

@synthesize likes, watches, saves, pictureImageLoaded, name, userName, pictureUrl, pictureImage, email, notifications, preferences;

- (id) initFromDictionary: (NSDictionary*)data {
	// get data
    self.likes = [[data objectForKey:@"likes"] intValue];
    self.watches = [[data objectForKey:@"watches"] intValue];
    self.saves = [[data objectForKey:@"saves"] intValue];
	self.name = [data objectForKey:@"name"] != [NSNull null] ? [data objectForKey:@"name"] : nil;
    self.userName = [data objectForKey:@"username"] != [NSNull null] ? [data objectForKey:@"username"] : nil;
    self.pictureUrl = [data objectForKey:@"picture"] != [NSNull null] ? [data objectForKey:@"picture"] : nil;
    self.email = [data objectForKey:@"email"] != [NSNull null] ? [data objectForKey:@"email"] : nil;
    self.notifications = [data objectForKey:@"notifications"] != [NSNull null] ? [[UserNotification alloc] initFromDictionary:[data objectForKey:@"notifications"]] : nil;
    self.preferences = [data objectForKey:@"preferences"] != [NSNull null] ? [[UserPreferences alloc] initFromDictionary:[data objectForKey:@"preferences"]] : nil;
    
    self.pictureImage = nil;
    self.pictureImageLoaded = false;
	
    return self;
}

- (NSDictionary*) toDictionary {
    NSMutableDictionary* userProfile = [[[NSMutableDictionary alloc] init] autorelease];
    
    [userProfile setObject:[[NSNumber numberWithInt:self.likes] stringValue] forKey:@"likes"];
    [userProfile setObject:[[NSNumber numberWithInt:self.watches] stringValue] forKey:@"watches"];
    [userProfile setObject:[[NSNumber numberWithInt:self.saves] stringValue] forKey:@"saves"];
    
    [userProfile setObject:self.name forKey:@"name"];
    [userProfile setObject:self.userName forKey:@"username"];
    [userProfile setObject:self.pictureUrl forKey:@"picture"];
    [userProfile setObject:self.email forKey:@"email"];
    
    [userProfile setObject:self.preferences forKey:@"preferences"];
    [userProfile setObject:self.notifications forKey:@"notifications"];
    
    return userProfile;
}

- (void) loadUserImage:(Callback*)onUserImageLoaded {
    
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    NSURL* url = [NSURL URLWithString:self.pictureUrl];
    NSData* data = [NSData dataWithContentsOfURL:url];
    if (data != nil) {
        // set thumbnail image
        pictureImage = [[UIImage alloc] initWithData:data];
    }
    
    pictureImageLoaded = true;
    
    if (onUserImageLoaded != nil) {
        [onUserImageLoaded execute:pictureImage];
        onUserImageLoaded = nil;
    }
    
    [pool release];
}

- (void) dealloc {
	
    self.name = nil;
	self.userName = nil;
	self.pictureUrl = nil;
	self.email = nil;
	self.notifications = nil;
    self.preferences = nil;
    self.pictureImageLoaded = nil;
    
    [super dealloc];
}


@end
