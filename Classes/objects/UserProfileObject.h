//
//  VideoObject.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <Foundation/Foundation.h>

// UserNotification object
@interface UserNotification : NSObject {
	int welcome;
    int firstLike;
    int emptyq;
}

@property()			int welcome;
@property()			int firstLike;
@property()			int emptyq;

- (id) initFromDictionnary: (NSDictionary*)data;
- (NSDictionary*) toDictionary;

@end

// User preferences object
@interface UserPreferences : NSObject {
	int syndicate;
    int follow_email;
}

@property()			int syndicate;
@property()         int follow_email;

- (id) initFromDictionnary: (NSDictionary*)data;
- (NSDictionary*) toDictionary;

@end

// User Profile object
@interface UserProfileObject : NSObject {
	int likes;
    int watches;
    int saves;
    NSString* name;
    NSString* userName;
    NSString* pictureUrl;
    NSString* email;
    UserNotification* notifications; //{"welcome": 1, "firstlike": 1, "emptyq": 1}, 
    UserPreferences* preferences; //{"syndicate": 1}}
}

@property()			int likes;
@property()			int watches;
@property()			int saves;
@property(retain)	NSString* name;
@property(retain)	NSString* userName;
@property(retain)	NSString* pictureUrl;
@property(retain)	NSString* email;
@property(retain)	UserNotification* notifications;
@property(retain)	UserPreferences* preferences;

- (id) initFromDictionnary: (NSDictionary*)data;
- (NSDictionary*) toDictionary;

@end