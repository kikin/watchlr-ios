//
//  UserObject.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/25/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UserDataFile.h"

@interface UserObject : NSObject {
	UserDataFile * userDataFile;
	NSString* sessionId;
    UIImage* userImage;
    NSString* userName;
    NSString* userEmail;
    bool pushVideosToFacebook;
    int userId;
}

- (id) init;
- (void) saveUserProfile;
- (void) resetUser;

+ (UserObject*) instance;
+ (UserObject*) getUser;

@property(retain) NSString* sessionId;
@property(retain) UIImage* userImage;
@property(retain) NSString* userName;
@property(retain) NSString* userEmail;
@property         bool pushVideosToFacebook;
@property         int userId;

@end
