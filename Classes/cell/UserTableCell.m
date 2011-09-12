//
//  VideoTableCell.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "UserTableCell.h"
#import "UserObject.h"

@implementation UserTableCell

@synthesize openUserProfileCallback;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		// Auto resize the views
        self.contentView.autoresizesSubviews = YES;
        
        // create the image
		profilePicView = [[UIImageView alloc] init];
        profilePicView.frame = CGRectMake(10, 10, 50, 50);
		[self addSubview:profilePicView];
        
        // create the username
		userNameLabel = [[UILabel alloc] init];
		userNameLabel.backgroundColor = [UIColor clearColor];
		userNameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		userNameLabel.text = @"";
        userNameLabel.numberOfLines = 1;
		[self addSubview:userNameLabel];
        
        nameLabel = [[UILabel alloc] init];
		nameLabel.backgroundColor = [UIColor clearColor];
		nameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		nameLabel.text = @"";
        nameLabel.numberOfLines = 1;
		[self addSubview:nameLabel];
        
        if (DeviceUtils.isIphone) {
            userNameLabel.font = [UIFont boldSystemFontOfSize:15];
            nameLabel.font = [UIFont systemFontOfSize:15];
        } else {
            userNameLabel.font = [UIFont boldSystemFontOfSize:18];
            nameLabel.font = [UIFont systemFontOfSize:18];
        }
	}
    return self;
}

- (void) onUserImageLoaded:(UIImage*)userImage {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    if (userImage != nil) {
        if (![[NSThread currentThread] isCancelled]) {
            [profilePicView performSelectorOnMainThread:@selector(setImage:) withObject:userImage waitUntilDone:YES];
            profilePicView.hidden = NO;
        }
    } else {
        profilePicView.hidden = YES;
    }
    [pool release];
}

- (void) downloadUserImage {
    [userProfile setProfileImageLoadedCallback:[Callback create:self selector:@selector(onUserImageLoaded:)]];
    [userProfile loadUserImage:@"square"];
}

- (void) loadImage {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	
    profilePicView.hidden = YES;
    if (![[NSThread currentThread] isCancelled]) {
        if (userProfile.squarePictureImage == nil) {
            if (!userProfile.pictureImageLoaded) {
                [self performSelector:@selector(downloadUserImage) withObject:nil];
            } else {
                profilePicView.hidden = YES;
            }
        } else {
            if (![[NSThread currentThread] isCancelled]) {
                [profilePicView performSelectorOnMainThread:@selector(setImage:) withObject:userProfile.squarePictureImage waitUntilDone:YES];
                profilePicView.hidden = NO;
            }
        }
    }
    
    [pool release];
}

- (void) fixSize {
    userNameLabel.frame = CGRectMake(70, 10, self.frame.size.width - (profilePicView.frame.size.width + 80), ((self.frame.size.height - 20) / 2));
    nameLabel.frame = CGRectMake(70, userNameLabel.frame.origin.y + userNameLabel.frame.size.height, self.frame.size.width - (profilePicView.frame.size.width + 80), ((self.frame.size.height - 20) / 2));
}

- (void)setUserObject: (UserProfileObject*)userProfileObject {
	// change user profile object
    // LOG_DEBUG(@"Drawing the cell");
	if (userProfile) {
        [userProfile resetProfileImageLoadedCallback];
        [userProfile release];
        
        userProfile = nil;
    }
    
    userProfile = [userProfileObject retain];
    
    // set the username
    if (userProfile.userId == [UserObject getUser].userId) {
        userNameLabel.text = @"You";
    } else {
        userNameLabel.text = userProfile.userName;
        nameLabel.text = [NSString stringWithFormat:@"(%@)", userProfile.name];
    }
    
    [self loadImage];
}

- (void) layoutSubviews {
    [super layoutSubviews];
    [self performSelectorOnMainThread:@selector(fixSize) withObject:nil waitUntilDone:NO];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *myTouch in touches)
    {
        if (CGRectContainsPoint([self bounds], [myTouch locationInView:self])) {
            if (openUserProfileCallback != nil) {
                [openUserProfileCallback execute:userProfile];
            }
        }
    }
}

- (void)dealloc {
    [userProfile resetProfileImageLoadedCallback];
    
    [profilePicView removeFromSuperview];
    [userNameLabel removeFromSuperview];
    [nameLabel removeFromSuperview];
    
    [openUserProfileCallback release];
    [userProfile release];
    
    profilePicView = nil;
    userNameLabel = nil;
    nameLabel = nil;
    openUserProfileCallback = nil;
    userProfile = nil;
    
    [super dealloc];
}

@end
