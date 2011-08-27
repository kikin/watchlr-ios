//
//  VideoTableCell.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "ActivityTableCell.h"
#import "UserActivityObject.h"
#import "CommonIos/Callback.h"

@implementation ActivityTableCell

@synthesize onUserNameClickedCallback;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		// create user image
        userImageView = [[UIImageView alloc] init];
        userImageView.autoresizingMask = UIViewAutoresizingNone;
        [self addSubview:userImageView];
        
        // create heading activity
        activityHeading = [[UIActicityHeadingLabel alloc] init];
        activityHeading.autoresizingMask = UIViewAutoresizingNone;
        activityHeading.onUsernameClicked = [Callback create:self selector:@selector(onUsernameClicked:)];
        [self addSubview:activityHeading];
        
        // set size/positions
		if (DeviceUtils.isIphone) {
			videoImageView.frame = CGRectMake(10, 10, 106, 80);
			playButtonImage.frame = CGRectMake(((videoImageView.frame.size.width - 30) / 2), ((videoImageView.frame.size.height - 32) / 2), 50, 50);
            
            titleLabel.font = [UIFont boldSystemFontOfSize:12];
            titleLabel.lineBreakMode = UILineBreakModeCharacterWrap | UILineBreakModeTailTruncation;
            titleLabel.numberOfLines = 3;
            
            likesLabel.font = [UIFont boldSystemFontOfSize:20];
		} else {
            userImageView.frame = CGRectMake(5, 5, 50, 50);
			videoImageView.frame = CGRectMake(75, 50, 160, 120);
            playButtonImage.frame = CGRectMake((((videoImageView.frame.size.width - 50) / 2) + videoImageView.frame.origin.x), 
                                               (((videoImageView.frame.size.height - 50) / 2) + videoImageView.frame.origin.y), 50, 50);
            
            titleLabel.font = [UIFont boldSystemFontOfSize:18];
            titleLabel.numberOfLines = 1;
		}
	}
    return self;
}

- (void) onUsernameClicked:(NSString*)userName {
    if (onUserNameClickedCallback != nil) {
        [onUserNameClickedCallback execute:userName];
    }
}

- (void) onUserImageLoaded:(UIImage*)userImage {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    if (userImage != nil) {
        if (![[NSThread currentThread] isCancelled]) {
            [userImageView performSelectorOnMainThread:@selector(setImage:) withObject:userImage waitUntilDone:YES];
            userImageView.hidden = NO;
        }
    } else {
        userImageView.hidden = YES;
    }
    [pool release];
}

- (void) downloadUserImage:(UserProfileObject*)userProfile {
    [userProfile setProfileImageLoadedCallback:[Callback create:self selector:@selector(onUserImageLoaded:)]];
    [userProfile loadUserImage:@"square"];
}

- (void) loadActivityCellImages {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	
    userImageView.hidden = YES;
    if (![[NSThread currentThread] isCancelled]) {
        UserProfileObject* userProfile = ((UserActivityObject*)[activityObject.userActivities objectAtIndex:0]).userProfile;
        if (userProfile.squarePictureImage == nil) {
            if (!userProfile.pictureImageLoaded) {
                [self performSelector:@selector(downloadUserImage:) withObject:userProfile];
            } else {
                userImageView.hidden = YES;
            }
        } else {
            if (![[NSThread currentThread] isCancelled]) {
                [userImageView performSelectorOnMainThread:@selector(setImage:) withObject:userProfile.squarePictureImage waitUntilDone:YES];
                userImageView.hidden = NO;
            }
        }
    }
    
    [pool release];
}

- (void) fixSize {
    if (DeviceUtils.isIphone) {
        
        int thumbnailWidth = 125;
        int	faviconAndSourceHeight = 20;
        int titleHeight = 50;
        
        // set the size for title label
        titleLabel.frame = CGRectMake(thumbnailWidth, 12, (self.frame.size.width - (thumbnailWidth + 10)), titleHeight);
        
        // set the size for likes label
        likesLabel.frame = CGRectMake((self.frame.size.width - 68), self.frame.size.height - (faviconAndSourceHeight + 10), 35, 20);
        
        // set the size for like/unlike button
        likeImageView.frame = CGRectMake((self.frame.size.width - 30), self.frame.size.height - (faviconAndSourceHeight + 10), 20, 20);
        
        // set the size for favicon image
        faviconImageView.frame = CGRectMake(thumbnailWidth, self.frame.size.height - (faviconAndSourceHeight + 5), 15, 15);
        
        // set the size for source label
        sourceLabel.frame = CGRectMake((thumbnailWidth + 20), self.frame.size.height - (faviconAndSourceHeight + 5), (self.frame.size.width - (thumbnailWidth + 20)), 15);
        
    } else {
        int userImageAndOptionsWidth = 210;
        int activityHeadingHeight = 30;
        int thumbnailWidth = 245;
        int	faviconAndSourceHeight = 30;
        int titleHeight = 20;
        
        // set the size for activity heading
        activityHeading.frame = CGRectMake(75, 7, (self.frame.size.width - userImageAndOptionsWidth), activityHeadingHeight);
        
        // set the size for title label
        titleLabel.frame = CGRectMake(thumbnailWidth, videoImageView.frame.origin.y + 2, (self.frame.size.width - (thumbnailWidth + 20)), titleHeight);
        
        descriptionLabel.frame = CGRectMake(thumbnailWidth, videoImageView.frame.origin.y + 10, (self.frame.size.width - (thumbnailWidth + 20)), (self.frame.size.height - (titleHeight + faviconAndSourceHeight + activityHeadingHeight + 15)));
        
        if (!videoObject.saved || videoObject.savedInCurrentTab) {
            // set the size for save/unsaved button
            saveImageView.frame = CGRectMake((self.frame.size.width - 50), 10, 30, 30);
            saveImageView.hidden = NO;
            
            // set the size for like/unlike button
            likeImageView.frame = CGRectMake((self.frame.size.width - 90), 10, 30, 30);
            
            // set the size for likes label
            likesLabel.frame = CGRectMake((self.frame.size.width - 150), 10, 55, 30);
        } else {
            // hide the add button
            saveImageView.hidden = YES;
            
            // set the size for likes label
            likesLabel.frame = CGRectMake((self.frame.size.width - 110), 10, 55, 30);
            
            // set the size for like/unlike button
            likeImageView.frame = CGRectMake((self.frame.size.width - 50), 10, 30, 30);
        }
        
        // set the size for favicon image
        faviconImageView.frame = CGRectMake(thumbnailWidth, self.frame.size.height - (faviconAndSourceHeight + 5), 16, 16);
        
        // set the size for first dot separator
        dotLabel1.frame = CGRectMake(thumbnailWidth + 25, self.frame.size.height - (faviconAndSourceHeight + 10), [dotLabel1.text sizeWithFont:dotLabel1.font].width, 15);
        
        // set the size for source label
        timestampLabel.frame = CGRectMake((30 + thumbnailWidth + dotLabel1.frame.size.width), 
                                          self.frame.size.height - (faviconAndSourceHeight + 5), 
                                          [timestampLabel.text sizeWithFont:timestampLabel.font].width, 
                                          15);
        
        // set the size for second dot separator
        dotLabel2.frame = CGRectMake((35 + thumbnailWidth + dotLabel1.frame.size.width + timestampLabel.frame.size.width), 
                                     self.frame.size.height - (faviconAndSourceHeight + 10), 
                                     [dotLabel2.text sizeWithFont:dotLabel2.font].width, 
                                     15);
        
        // set the size for source label
        sourceLabel.frame = CGRectMake((dotLabel1.frame.size.width + timestampLabel.frame.size.width + dotLabel2.frame.size.width + thumbnailWidth + 40), // x
                                       self.frame.size.height - (faviconAndSourceHeight + 5), // y
                                       [sourceLabel.text sizeWithFont:sourceLabel.font].width, // width
                                       15); // height
        
    }
}

- (void) setActivityObject: (ActivityObject*)activity {
    
    // change acticity object
    if (activityObject) {
        // Release the callback we have set
        UserProfileObject* userProfile = ((UserActivityObject*)[activityObject.userActivities objectAtIndex:0]).userProfile;
        [userProfile resetProfileImageLoadedCallback];
        
        [activityObject release];
    }
    activityObject = [activity retain];
    
    [self setVideoObject:activityObject.video];
    
    // set timestamp
    timestampLabel.text = [self getPrettyDate:activity.timestamp];
    
    if (activity.activityHeadingLabelsList != nil && [activity.activityHeadingLabelsList count] > 0) {
        activityHeading.hidden = NO;
        [activityHeading renderActivityHeading:activity.activityHeadingLabelsList];
    } else {
        activityHeading.hidden = YES;
    }

    // update image
    [self loadActivityCellImages];
}

- (void)dealloc {
    // Release the callback we have set
    activityHeading.onUsernameClicked = nil;
    
    UserProfileObject* userProfile = ((UserActivityObject*)[activityObject.userActivities objectAtIndex:0]).userProfile;
    [userProfile resetProfileImageLoadedCallback];
    
    [onUserNameClickedCallback release];
    
    [userImageView removeFromSuperview];
    [activityHeading removeFromSuperview];
    [activityObject release];
    
    userImageView = nil;
    activityObject = nil;
    activityHeading = nil;
    
	[super dealloc];
}

@end
