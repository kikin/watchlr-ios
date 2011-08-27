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
    self.welcome = [data objectForKey:@"welcome"] != [NSNull null] ? [[data objectForKey:@"welcome"] intValue] : 0;
    self.firstLike = [data objectForKey:@"firstlike"] != [NSNull null] ? [[data objectForKey:@"firstlike"] intValue] : 0;
    self.emptyq = [data objectForKey:@"emptyq"] != [NSNull null] ? [[data objectForKey:@"emptyq"] intValue] : 0;
    
    return self;
}

- (void) updateFromDictionary: (NSDictionary*)data {
    welcome = [data objectForKey:@"welcome"] != [NSNull null] ? [[data objectForKey:@"welcome"] intValue] : 0;
    firstLike = [data objectForKey:@"firstlike"] != [NSNull null] ? [[data objectForKey:@"firstlike"] intValue] : 0;
    emptyq = [data objectForKey:@"emptyq"] != [NSNull null] ? [[data objectForKey:@"emptyq"] intValue] : 0;
}

- (NSDictionary*) toDictionary {
    NSMutableDictionary* userNotification = [[[NSMutableDictionary alloc] init] autorelease];
    
    [userNotification setObject:[[NSNumber numberWithInt:welcome] stringValue] forKey:@"welcome"];
    [userNotification setObject:[[NSNumber numberWithInt:firstLike] stringValue] forKey:@"firstlike"];
    [userNotification setObject:[[NSNumber numberWithInt:emptyq] stringValue] forKey:@"emptyq"];
    
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
    self.syndicate = [data objectForKey:@"syndicate"] != [NSNull null] ? [[data objectForKey:@"syndicate"] intValue] : 2;
    self.follow_email = [data objectForKey:@"follow_email"] != [NSNull null] ? [[data objectForKey:@"follow_email"] intValue] : 2;
    return self;
}

- (void) updateFromDictionary: (NSDictionary*)data {
    syndicate = [data objectForKey:@"syndicate"] != [NSNull null] ? [[data objectForKey:@"syndicate"] intValue] : 2;
    follow_email = [data objectForKey:@"follow_email"] != [NSNull null] ? [[data objectForKey:@"follow_email"] intValue] : 2;
}

- (NSDictionary*) toDictionary {
    NSMutableDictionary* userPreferences = [[[NSMutableDictionary alloc] init] autorelease];
    [userPreferences setObject:[[NSNumber numberWithInt:syndicate] stringValue] forKey:@"syndicate"];
    [userPreferences setObject:[[NSNumber numberWithInt:follow_email] stringValue] forKey:@"follow_email"];
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

@synthesize userId, likes, watches, saves, followersCount, followingCount, follower, following, pictureImageLoaded, name, userName, pictureUrl, squarePictureImage, smallPictureImage, normalPictureImage, largePictureImage, email, notifications, preferences;

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
    self.followersCount = [data objectForKey:@"follower_count"] != [NSNull null] ? [[data objectForKey:@"follower_count"] intValue] : 0;
    self.followingCount = [data objectForKey:@"following_count"] != [NSNull null] ? [[data objectForKey:@"following_count"] intValue] : 0;
    self.follower = [data objectForKey:@"follower"] != [NSNull null] ? [[data objectForKey:@"follower"] boolValue] : 0;
    self.following = [data objectForKey:@"following"] != [NSNull null] ? [[data objectForKey:@"following"] boolValue] : 0;
    
    notifications = [data objectForKey:@"notifications"] != [NSNull null] ? [[UserNotification alloc] initFromDictionary:[data objectForKey:@"notifications"]] : nil;
    preferences = [data objectForKey:@"preferences"] != [NSNull null] ? [[UserPreferences alloc] initFromDictionary:[data objectForKey:@"preferences"]] : nil;
    
    self.squarePictureImage = nil;
    self.smallPictureImage = nil;
    self.normalPictureImage  = nil;
    self.largePictureImage = nil;
    self.pictureImageLoaded = false;
	
    return self;
}

- (void) updateFromDictionary: (NSDictionary*)data {
    self.userName = [data objectForKey:@"username"] != [NSNull null] ? [data objectForKey:@"username"] : nil;
    self.name = [data objectForKey:@"name"] != [NSNull null] ? [data objectForKey:@"name"] : nil;
    self.email = [data objectForKey:@"email"] != [NSNull null] ? [data objectForKey:@"email"] : nil;
    
    self.saves = [data objectForKey:@"saves"] != [NSNull null] ? [[data objectForKey:@"saves"] intValue] : 0;
    self.watches = [data objectForKey:@"watches"] != [NSNull null] ? [[data objectForKey:@"watches"] intValue] : 0;
    self.likes = [data objectForKey:@"likes"] != [NSNull null] ? [[data objectForKey:@"likes"] intValue] : 0;
    self.followersCount = [data objectForKey:@"follower_count"] != [NSNull null] ? [[data objectForKey:@"follower_count"] intValue] : 0;
    self.followingCount = [data objectForKey:@"following_count"] != [NSNull null] ? [[data objectForKey:@"following_count"] intValue] : 0;
    self.follower = [data objectForKey:@"follower"] != [NSNull null] ? [[data objectForKey:@"follower"] boolValue] : 0;
    self.following = [data objectForKey:@"following"] != [NSNull null] ? [[data objectForKey:@"following"] boolValue] : 0;
    
    NSString* profileImageUrl = [data objectForKey:@"picture"] != [NSNull null] ? [data objectForKey:@"picture"] : nil;
    if ([profileImageUrl caseInsensitiveCompare:pictureUrl] != NSOrderedSame) {
        self.squarePictureImage = nil;
        self.smallPictureImage = nil;
        self.normalPictureImage  = nil;
        self.largePictureImage = nil;
        self.pictureImageLoaded = false;
    }
    
    if ([data objectForKey:@"notifications"] != [NSNull null]) {
        [notifications updateFromDictionary:[data objectForKey:@"notifications"]];
    }
    
    if ([data objectForKey:@"preferences"] != [NSNull null]) {
        [preferences updateFromDictionary:[data objectForKey:@"preferences"]];
    }
}

- (NSDictionary*) toDictionary {
    NSMutableDictionary* userProfile = [[[NSMutableDictionary alloc] init] autorelease];
    
    [userProfile setObject:[[NSNumber numberWithInt:likes] stringValue] forKey:@"likes"];
    [userProfile setObject:[[NSNumber numberWithInt:watches] stringValue] forKey:@"watches"];
    [userProfile setObject:[[NSNumber numberWithInt:saves] stringValue] forKey:@"saves"];
    if (userId > -1) { [userProfile setObject:[[NSNumber numberWithInt:userId] stringValue] forKey:@"id"]; }
    if (follower) { [userProfile setObject:@"true" forKey:@"follower"]; } else { [userProfile setObject:@"false" forKey:@"follower"]; }
    if (following) { [userProfile setObject:@"true" forKey:@"following"]; } else { [userProfile setObject:@"false" forKey:@"following"]; }
    [userProfile setObject:[[NSNumber numberWithInt:followersCount] stringValue] forKey:@"follower_count"];
    [userProfile setObject:[[NSNumber numberWithInt:followingCount] stringValue] forKey:@"following_count"];
    
    [userProfile setObject:name forKey:@"name"];
    [userProfile setObject:userName forKey:@"username"];
    [userProfile setObject:pictureUrl forKey:@"picture"];
    [userProfile setObject:email forKey:@"email"];
    
    [userProfile setObject:preferences forKey:@"preferences"];
    [userProfile setObject:notifications forKey:@"notifications"];
    
    return userProfile;
}

- (void) setProfileImageLoadedCallback:(Callback *)callback {
    if (profileImageLoadedCallbackLock == nil) {
        profileImageLoadedCallbackLock = [[NSLock alloc] init];
    }
    
    [profileImageLoadedCallbackLock lock];
    profileImageLoadedCallback = [callback retain];
    [profileImageLoadedCallbackLock unlock];
}

- (void) resetProfileImageLoadedCallback {
    if (profileImageLoadedCallbackLock != nil) {
        [profileImageLoadedCallbackLock lock];
        [profileImageLoadedCallback release];
        profileImageLoadedCallback = nil;
        [profileImageLoadedCallbackLock unlock];
    } else {
        profileImageLoadedCallback = nil;
    }
}

- (void) loadUserImage:(NSString *)sizeType {
    
    //    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    if (profileImageUrlConnection != nil) { 
        [profileImageUrlConnection release];
    }
    
    if (profileImageData != nil) { 
        [profileImageData release];
        profileImageData = nil;
    }
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:[pictureUrl stringByAppendingFormat:@"?type=%@", sizeType]]
                                          cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0];
    
    currentlyLoadingProfileImageSizeType = sizeType;
    profileImageUrlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    //TODO error handling, what if connection is nil?
    
    //    [pool release];
}


- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)incrementalData {
    if (profileImageData == nil) {
        profileImageData = [[NSMutableData alloc] initWithCapacity:(15 * 1024)]; // 15KB
    }
    [profileImageData appendData:incrementalData];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
    
    [profileImageUrlConnection release];
    profileImageUrlConnection = nil;
    
    if (profileImageData != nil) {
        // set profile image
        if ([currentlyLoadingProfileImageSizeType caseInsensitiveCompare:@"square"] == NSOrderedSame) {
            if (squarePictureImage != nil) {
                [squarePictureImage release];
                squarePictureImage = nil;
            }
            squarePictureImage = [[UIImage alloc] initWithData:profileImageData];
        } else if ([currentlyLoadingProfileImageSizeType caseInsensitiveCompare:@"small"] == NSOrderedSame) {
            if (smallPictureImage != nil) {
                [smallPictureImage release];
                smallPictureImage = nil;
            }
            smallPictureImage = [[UIImage alloc] initWithData:profileImageData];
        } else if ([currentlyLoadingProfileImageSizeType caseInsensitiveCompare:@"normal"] == NSOrderedSame) {
            if (normalPictureImage  != nil) {
                [normalPictureImage release];
                normalPictureImage = nil;
            }
            normalPictureImage = [[UIImage alloc] initWithData:profileImageData];
        } else if ([currentlyLoadingProfileImageSizeType caseInsensitiveCompare:@"large"] == NSOrderedSame) {
            if (largePictureImage != nil) {
                [largePictureImage release];
                largePictureImage = nil;
            }
            largePictureImage = [[UIImage alloc] initWithData:profileImageData];
        }
    } 
    
    if (profileImageLoadedCallbackLock != nil) {
        [profileImageLoadedCallbackLock lock];
    }
    
    pictureImageLoaded = true;
    if (profileImageLoadedCallback != nil) {
        
        if ([currentlyLoadingProfileImageSizeType caseInsensitiveCompare:@"square"] == NSOrderedSame) {
            [profileImageLoadedCallback execute:squarePictureImage];
        } else if ([currentlyLoadingProfileImageSizeType caseInsensitiveCompare:@"small"] == NSOrderedSame) {
            [profileImageLoadedCallback execute:smallPictureImage];
        } else if ([currentlyLoadingProfileImageSizeType caseInsensitiveCompare:@"normal"] == NSOrderedSame) {
            [profileImageLoadedCallback execute:normalPictureImage];
        } else if ([currentlyLoadingProfileImageSizeType caseInsensitiveCompare:@"large"] == NSOrderedSame) {
            [profileImageLoadedCallback execute:largePictureImage];
        }
        
        [profileImageLoadedCallback release];
        profileImageLoadedCallback = nil;
    }
    
    if (profileImageLoadedCallbackLock != nil) {
        [profileImageLoadedCallbackLock unlock];
    }
    
    [profileImageData release];
    profileImageData = nil;
}


- (void) dealloc {
    [currentlyLoadingProfileImageSizeType release];
    [name release];
    [userName release];
    [pictureUrl release];
    [email release];
    [notifications release];
    [preferences release];
    [squarePictureImage release];
    [smallPictureImage release];
    [normalPictureImage release];
    [largePictureImage release];
    
    currentlyLoadingProfileImageSizeType = nil;
    name = nil;
	userName = nil;
	pictureUrl = nil;
	email = nil;
	notifications = nil;
    preferences = nil;
    squarePictureImage = nil;
    smallPictureImage = nil;
    normalPictureImage = nil;
    largePictureImage = nil;
    
    [profileImageUrlConnection cancel];
    [profileImageUrlConnection release];
    [profileImageData release];
    
    [profileImageLoadedCallback release];
    profileImageLoadedCallback = nil;
    
    [profileImageLoadedCallbackLock release];
    profileImageLoadedCallbackLock = nil;
    
    [super dealloc];
}


@end
