//
//  ErrorMainView.m
//  KikinVideo
//
//  Created by ludovic cabre on 5/6/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "UserProfileIphoneView.h"
#import <QuartzCore/QuartzCore.h>
#import "UserProfileRequest.h"
#import "UserProfileResponse.h"
#import "UserObject.h"

@implementation UserProfileIphoneView

@synthesize showLikedVideosListCallback, showFollowersListCallback, showFollowingListCallback;

- (id) initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        UIColor* color = [UIColor colorWithRed:(12.0/255.0) green:(83.0/255.0) blue:(111.0/255.0) alpha:1.0];
        
        profilePicView = [[UIImageView alloc] init];
        profilePicView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
//        profilePicView.layer.borderWidth = 1.0f;
        profilePicView.layer.borderColor = color.CGColor;
        [self addSubview:profilePicView];
        
        usernameView = [[UILabel alloc] init];
        usernameView.backgroundColor = [UIColor clearColor];
        usernameView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        usernameView.text = @"";
        usernameView.font = [UIFont boldSystemFontOfSize:15];
        usernameView.textColor = color;
        usernameView.numberOfLines = 1;
        [self addSubview:usernameView];
        
        nameView = [[UILabel alloc] init];
        nameView.backgroundColor = [UIColor clearColor];
        nameView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        nameView.text = @"";
        nameView.font = [UIFont italicSystemFontOfSize:15];
        nameView.textColor = color;
        nameView.numberOfLines = 1;
        [self addSubview:nameView];
        
        followButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
        [followButton addTarget:self action:@selector(onFollowButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        followButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        [followButton setTitleColor:color forState:UIControlStateNormal];
        [self addSubview:followButton];
        
        optionsButtonList = [[UITableView alloc] init];
        optionsButtonList.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//        optionsButtonList.layer.borderColor = color.CGColor;
        optionsButtonList.layer.borderWidth = 0.3f;
        optionsButtonList.layer.cornerRadius = 5.0f;
        optionsButtonList.rowHeight = 40;
        optionsButtonList.delegate = self;
        optionsButtonList.dataSource = self;
        optionsButtonList.allowsSelection = YES;
        [self addSubview:optionsButtonList];
    }
    
    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    profilePicView.frame = CGRectMake(5, 5, 100, profilePicView.frame.size.height);
    CGSize usernameViewSize = [usernameView.text sizeWithFont:usernameView.font];
    usernameView.frame = CGRectMake((profilePicView.frame.origin.x + profilePicView.frame.size.width + 15), 10, 
                                    usernameViewSize.width, usernameViewSize.height);
    
    CGSize nameViewSize = [nameView.text sizeWithFont:nameView.font];
    nameView.frame = CGRectMake((profilePicView.frame.origin.x + profilePicView.frame.size.width + 15), 
                                (usernameView.frame.origin.y + usernameView.frame.size.height + 5), 
                                 nameViewSize.width, nameViewSize.height);
    
    if ((nameView.frame.origin.y + nameView.frame.size.height + 40) > (profilePicView.frame.origin.y + profilePicView.frame.size.height)) {
        followButton.frame = CGRectMake(5, (profilePicView.frame.origin.y + profilePicView.frame.size.height + 10), 
                                        (self.frame.size.width - 10), 40);
    } else {
        followButton.frame = CGRectMake((profilePicView.frame.origin.x + profilePicView.frame.size.width + 15), 
                                        (nameView.frame.origin.y + nameView.frame.size.height + 15), 
                                        (self.frame.size.width - (profilePicView.frame.origin.x + profilePicView.frame.size.width + 25)), 40);
    }
    
    
    CGFloat optionsButtonListYPos = MAX(profilePicView.frame.origin.y + profilePicView.frame.size.height, 
                                            followButton.frame.origin.y + followButton.frame.size.height);
    
    optionsButtonList.frame = CGRectMake(5, optionsButtonListYPos + 15, self.frame.size.width - 10, 120);
}

- (void) didReceiveMemoryWarning:(bool)forced {
//    if  (forced) {
//        [likedVideosView didReceiveMemoryWarning];
//        [followersView didReceiveMemoryWarning];
//        [followingView didReceiveMemoryWarning];
//    } else {
//        int level = [DeviceUtils currentMemoryLevel];
//        if (level == OSMemoryNotificationLevelUrgent) {
//            switch (activeView) {
//                case LIKED_VIDEOS_VIEW: {
//                    [followersView didReceiveMemoryWarning];
//                    [followingView didReceiveMemoryWarning];
//                    break;
//                }
//                    
//                case FOLLWERS_VIEW: {
//                    [likedVideosView didReceiveMemoryWarning];
//                    [followingView didReceiveMemoryWarning];
//                    break;
//                }
//                    
//                case FOLLOWING_VIEW: {
//                    [likedVideosView didReceiveMemoryWarning];
//                    [followersView didReceiveMemoryWarning];
//                    break;
//                }
//                    
//                default:
//                    break;
//            }
//        } else if (level == OSMemoryNotificationLevelCritical) {
//            [likedVideosView didReceiveMemoryWarning];
//            [followersView didReceiveMemoryWarning];
//            [followingView didReceiveMemoryWarning];
//        }
//    }
}

- (void) dealloc {
    [userProfile resetProfileImageLoadedCallback];
    [userProfile release];
    userProfile = nil;
    
    if (showLikedVideosListCallback != nil) {
        [showLikedVideosListCallback release];
    }
    
    if (showFollowersListCallback != nil) {
        [showFollowersListCallback release];
    }
    
    if (showFollowingListCallback != nil) {
        [showFollowingListCallback release];
    }
    
    optionsButtonList.delegate = nil;
    optionsButtonList.dataSource = nil;
	
    [profilePicView removeFromSuperview];
    [followButton removeFromSuperview];
    [usernameView removeFromSuperview];
    [nameView removeFromSuperview];
    [optionsButtonList removeFromSuperview];
    
    profilePicView = nil;
    followButton = nil;
    usernameView = nil;
    nameView = nil;
    optionsButtonList = nil;
    
    showLikedVideosListCallback = nil;
    showFollowersListCallback = nil;
    showFollowingListCallback = nil;
    
    [super dealloc];
}

// --------------------------------------------------------------------------------
//                                  Private functions
// --------------------------------------------------------------------------------

- (void) onUserImageLoaded:(UIImage*)userImage {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    if (userImage != nil) {
        if (![[NSThread currentThread] isCancelled]) {
            CGFloat profilePicViewHeight = MIN(userProfile.normalPictureImage.size.height, (self.frame.size.height - 125));
            profilePicView.frame = CGRectMake(5, 5, 100, profilePicViewHeight);
            [profilePicView performSelectorOnMainThread:@selector(setImage:) withObject:userImage waitUntilDone:YES];
            profilePicView.hidden = NO;
            [self layoutSubviews];
        }
    } else {
        profilePicView.hidden = YES;
    }
    [pool release];
}

- (void) downloadUserImage {
    [userProfile setProfileImageLoadedCallback:[Callback create:self selector:@selector(onUserImageLoaded:)]];
    [userProfile loadUserImage:@"normal"];
    
}

// --------------------------------------------------------------------------------
//                                  Requests
// --------------------------------------------------------------------------------

- (void) followUser:(UserProfileObject*)user {
    UserProfileRequest* userProfileRequest = [[[UserProfileRequest alloc] init] autorelease];
    userProfileRequest.errorCallback = [Callback create:self selector:@selector(onFollowRequestFailed:)];
    userProfileRequest.successCallback = [Callback create:self selector:@selector(onFollowRequestSuccess:)];
	[userProfileRequest followUser:user.userId];
}

- (void) unfollowUser:(UserProfileObject*)user {
    UserProfileRequest* userProfileRequest = [[[UserProfileRequest alloc] init] autorelease];
    userProfileRequest.errorCallback = [Callback create:self selector:@selector(onFollowRequestFailed:)];
    userProfileRequest.successCallback = [Callback create:self selector:@selector(onFollowRequestSuccess:)];
	[userProfileRequest unfollowUser:user.userId];
}

// --------------------------------------------------------------------------------
//                                  Callbacks
// --------------------------------------------------------------------------------

- (void) onFollowButtonClicked:(UIButton*)sender {
    if (userProfile.following) {
        [self performSelector:@selector(unfollowUser:) withObject:userProfile];
    } else {
        [self performSelector:@selector(followUser:) withObject:userProfile];
    }
}

// --------------------------------------------------------------------------------
//                             Request Callbacks
// --------------------------------------------------------------------------------

- (void) onFollowRequestSuccess: (UserProfileResponse*)response {
    if (response.success) {
        NSDictionary* result = [response userProfile];
        UserProfileObject* newUserProfile = [[[UserProfileObject alloc] initFromDictionary:result] autorelease];
        if (userProfile != nil) {
            [userProfile release];
        }
        
        userProfile = [newUserProfile retain];
        NSString* followButtonTitle = (userProfile.following ? @"unfollow" :  @"follow");
        [followButton setTitle:followButtonTitle forState:UIControlStateNormal];
        
	} else {
        NSString* errorMessage = [NSString stringWithFormat:@"We failed to make follow request: %@", response.errorMessage];
		
		// show error message
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Failed to make follow request" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		[alertView release];		
		
		LOG_ERROR(@"request success but failed to make follow request: %@", response.errorMessage);
	}
}

- (void) onFollowRequestFailed: (NSString*)errorMessage {
    NSString* errorString = [NSString stringWithFormat:@"We failed to make follow request: %@", errorMessage];
	
	// show error message
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Failed to follow request" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
	[alertView release];		
	
	LOG_ERROR(@"list request error: %@", errorMessage);
}

// --------------------------------------------------------------------------------
//                      Table view delegate
// --------------------------------------------------------------------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"UserDetailOprionsButtonCell";
	
	// try to reuse an id
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        // Create the cell
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
	
	cell.textLabel.textAlignment = UITextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
	cell.textLabel.textColor = [UIColor colorWithRed:(12.0/255.0) green:(83.0/255.0) blue:(111.0/255.0) alpha:1.0];
    
    switch (indexPath.row) {
        case 0: {
            cell.textLabel.text = [NSString stringWithFormat:@"%d  liked videos", userProfile.likes];
            break;
        }
            
        case 1: {
            cell.textLabel.text = [NSString stringWithFormat:@"%d  followers", userProfile.followersCount];
            break;
        }
            
        case 2: {
            cell.textLabel.text = [NSString stringWithFormat:@"%d  following", userProfile.followingCount];
            break;
        }
            
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            if (showLikedVideosListCallback != nil) {
                [showLikedVideosListCallback execute:[NSNumber numberWithInt:userProfile.userId]];
            }
            break;
        }
            
        case 1: {
            if (showFollowersListCallback != nil) {
                [showFollowersListCallback execute:[NSNumber numberWithInt:userProfile.userId]];
            }
            break;
        }
            
        case 2: {
            if (showFollowingListCallback != nil) {
                [showFollowingListCallback execute:[NSNumber numberWithInt:userProfile.userId]];
            }
            break;
        }
            
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


// --------------------------------------------------------------------------------
//                          Public Functions
// --------------------------------------------------------------------------------

- (void) setUserProfile: (UserProfileObject*)user {
    if (userProfile != nil) {
        [userProfile resetProfileImageLoadedCallback];
        [userProfile release];
    }
    
    userProfile = [user retain];
    
    usernameView.text = userProfile.userName;
    nameView.text = [NSString stringWithFormat:@"(%@)", userProfile.name];
    
    NSString* followButtonTitle = (userProfile.following ? @"unfollow" :  @"follow");
    [followButton setTitle:followButtonTitle forState:UIControlStateNormal];

    if ([UserObject getUser].userId == user.userId) {
        [followButton setHidden:YES];
    } else {
        [followButton setHidden:NO];
    }
    
    [optionsButtonList reloadData];
    
    if (![[NSThread currentThread] isCancelled]) {
        if (userProfile.normalPictureImage == nil) {
            if (!userProfile.pictureImageLoaded) {
                [self performSelector:@selector(downloadUserImage) withObject:nil];
            } else {
                profilePicView.hidden = YES;
            }
        } else {
            if (![[NSThread currentThread] isCancelled]) {
                [self performSelectorOnMainThread:@selector(onUserImageLoaded:) withObject:userProfile.normalPictureImage waitUntilDone:YES];
            }
        }
    }
}

- (UserProfileObject*) getUserProfile {
    return userProfile;
}

@end
