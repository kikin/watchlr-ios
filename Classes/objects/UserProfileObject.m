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

@synthesize userId, likes, watches, saves, followers, following, pictureImageLoaded, name, userName, pictureUrl, pictureImage, email, notifications, preferences;

- (id) initFromDictionary: (NSDictionary*)data {
	// get data
    self.userId = [data objectForKey:@"id"] != [NSNull null] ? [[data objectForKey:@"id"] intValue] : -1;
    self.userName = [data objectForKey:@"username"] != [NSNull null] ? [data objectForKey:@"username"] : nil;
    self.name = [data objectForKey:@"name"] != [NSNull null] ? [data objectForKey:@"name"] : nil;
    self.pictureUrl = [data objectForKey:@"picture"] != [NSNull null] ? [data objectForKey:@"picture"] : nil;
    self.email = [data objectForKey:@"email"] != [NSNull null] ? [data objectForKey:@"email"] : nil;
    
    self.saves = [data objectForKey:@"saves"] != [NSNull null] ? [[data objectForKey:@"saves"] intValue] : 0;
    self.watches = [data objectForKey:@"watches"] != [NSNull null] ? [[data objectForKey:@"watches"] intValue] : 0;
    self.likes = [data objectForKey:@"likes"] != [NSNull null] ? [[data objectForKey:@"likes"] intValue] : 0;
    self.followers = [data objectForKey:@"followers"] != [NSNull null] ? [[data objectForKey:@"followers"] intValue] : 0;
    self.following = [data objectForKey:@"following"] != [NSNull null] ? [[data objectForKey:@"following"] intValue] : 0;
    
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
    if (self.userId > -1) { [userProfile setObject:[[NSNumber numberWithInt:self.userId] stringValue] forKey:@"id"]; }
    [userProfile setObject:[[NSNumber numberWithInt:self.followers] stringValue] forKey:@"followers"];
    [userProfile setObject:[[NSNumber numberWithInt:self.following] stringValue] forKey:@"following"];
    
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
