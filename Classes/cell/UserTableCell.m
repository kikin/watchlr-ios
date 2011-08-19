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
        userNameLabel.font = [UIFont boldSystemFontOfSize:18];
        userNameLabel.numberOfLines = 1;
		[self addSubview:userNameLabel];
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
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    [userProfile loadUserImage:[Callback create:self selector:@selector(onUserImageLoaded:)] withSize:@"square"];
    [pool release];
}

- (void) loadImage {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	
    if (![[NSThread currentThread] isCancelled]) {
        if (userProfile.squarePictureImage == nil) {
            if (!userProfile.pictureImageLoaded) {
                [self performSelectorInBackground:@selector(downloadUserImage) withObject:nil];
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
    userNameLabel.frame = CGRectMake(70, 10, self.frame.size.width - (profilePicView.frame.size.width + 80), self.frame.size.height - 20);
}

- (void)setUserObject: (UserProfileObject*)userProfileObject {
	// change user profile object
    // LOG_DEBUG(@"Drawing the cell");
	if (userProfile) 
        [userProfile release];
    
    userProfile = [userProfileObject retain];
    
    // set the username
    if (userProfile.userId == [UserObject getUser].userId) {
        userNameLabel.text = @"You";
    } else {
        userNameLabel.text = [userProfile.userName stringByAppendingFormat:@" (%@)", userProfile.name];
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
        
    }
}

- (void)dealloc {
    [profilePicView release];
    [userNameLabel release];
    [openUserProfileCallback release];
    [super dealloc];
}

@end
