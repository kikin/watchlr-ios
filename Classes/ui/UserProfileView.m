//
//  ErrorMainView.m
//  KikinVideo
//
//  Created by ludovic cabre on 5/6/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "UserProfileView.h"
#import <QuartzCore/QuartzCore.h>
#import "UserTableCell.h"
#import "UserProfileObject.h"
#import "UserProfileRequest.h"
#import "UserProfileResponse.h"
#import "ProfileViewController.h"
#import "UserObject.h"

@implementation UserProfileView

@synthesize openUserProfileCallback, onViewSourceClickedCallback;

- (id) initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        UIColor* color = [UIColor colorWithRed:(12.0/255.0) green:(83.0/255.0) blue:(111.0/255.0) alpha:1.0];
        
        profilePicView = [[UIImageView alloc] init];
        profilePicView.frame = CGRectMake(8, 10, 100, 100);
        profilePicView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        profilePicView.layer.borderWidth = 1.0f;
        profilePicView.layer.borderColor = color.CGColor;
        [self addSubview:profilePicView];
        
        usernameView = [[UILabel alloc] init];
        usernameView.backgroundColor = [UIColor clearColor];
        usernameView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        usernameView.text = @"";
        usernameView.font = [UIFont boldSystemFontOfSize:18];
        usernameView.textColor = color;
        usernameView.numberOfLines = 1;
        usernameView.frame = CGRectMake(120, 10, self.frame.size.width - 100, 30);
        [self addSubview:usernameView];
        
        followButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
        [followButton addTarget:self action:@selector(onFollowButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        followButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        followButton.frame = CGRectMake(self.frame.size.width - 90, 10, 80, 60);
        [followButton setTitleColor:color forState:UIControlStateNormal];
        [self addSubview:followButton];
        
        optionsButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"0 liked videos", @"0 followers", @"0 following", nil]];
        [optionsButton setSegmentedControlStyle:UISegmentedControlStyleBezeled];
        [optionsButton addTarget:self action:@selector(onOptionsButtonClicked:) forControlEvents:UIControlEventValueChanged];
        optionsButton.tintColor = color;
        [self addSubview:optionsButton];
        
        likedVideosView = [[VideosListView alloc] initWithFrame:CGRectMake(0, 120, self.frame.size.width, self.frame.size.height - 120)];
        likedVideosView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        likedVideosView.isViewRefreshable = false;
		likedVideosView.layer.borderWidth = 1.0f;
        likedVideosView.layer.borderColor = color.CGColor;
        likedVideosView.addVideoPlayerCallback = [Callback create:self selector:@selector(addVideoPlayer:)];
        likedVideosView.onViewSourceClickedCallback = [Callback create:self selector:@selector(onViewSourceClicked:)];
        likedVideosView.loadMoreDataCallback = [Callback create:self selector:@selector(onLoadMoreLikedVideos)];
        [self addSubview:likedVideosView];
        [self sendSubviewToBack:likedVideosView];
        
        followersView = [[UserListView alloc] initWithFrame:CGRectMake(0, 120, self.frame.size.width, self.frame.size.height - 120)];
        followersView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        followersView.openUserProfileCallback = [Callback create:self selector:@selector(openUserProfile:)];
        followersView.loadMoreDataCallback = [Callback create:self selector:@selector(onLoadMoreFollowers)];
        followersView.hidden = NO;
		followersView.layer.borderWidth = 1.0f;
        followersView.layer.borderColor = color.CGColor;
        
        [self addSubview:followersView];
        [self sendSubviewToBack:followersView];
        
        followingView = [[UserListView alloc] initWithFrame:CGRectMake(0, 120, self.frame.size.width, self.frame.size.height - 120)];
        followingView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        followingView.openUserProfileCallback = [Callback create:self selector:@selector(openUserProfile:)];
        followingView.loadMoreDataCallback = [Callback create:self selector:@selector(onLoadMoreFollowing)];
        followingView.hidden = NO;
		followingView.layer.borderWidth = 1.0f;
        followingView.layer.borderColor = color.CGColor;
        [self addSubview:followingView];
        [self sendSubviewToBack:followingView];
        
        activeView = LIKED_VIDEOS_VIEW;
        isLikedVideosListRefreshing = true;
        isFollowersListRefreshing = true;
        isFollowingListRefreshing = true;
        
        lastlikedVideosPageRequested = 1;
        lastFollowersPageRequested = 1;
        lastFollowingPageRequested = 1;
    }
    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    profilePicView.frame = CGRectMake(8, 10, 100, profilePicView.frame.size.height);
    usernameView.frame = CGRectMake(125, 10, [usernameView.text sizeWithFont:usernameView.font].width, 30);
    followButton.frame = CGRectMake(usernameView.frame.size.width + 150, 10, 200, 30);
    
    optionsButton.frame = CGRectMake(120, 50, self.frame.size.width - 121, 30);
    likedVideosView.frame = CGRectMake(120, 78, self.frame.size.width - 121, self.frame.size.height - 79);
    followersView.frame = CGRectMake(120, 78, self.frame.size.width - 121, self.frame.size.height - 79);
    followingView.frame = CGRectMake(120, 78, self.frame.size.width - 121, self.frame.size.height - 79);
}

- (void) didReceiveMemoryWarning:(bool)forced {
    if  (forced) {
        [likedVideosView didReceiveMemoryWarning];
        [followersView didReceiveMemoryWarning];
        [followingView didReceiveMemoryWarning];
    } else {
        int level = [DeviceUtils currentMemoryLevel];
        if (level == OSMemoryNotificationLevelUrgent) {
            switch (activeView) {
                case LIKED_VIDEOS_VIEW: {
                    [followersView didReceiveMemoryWarning];
                    [followingView didReceiveMemoryWarning];
                    break;
                }
                    
                case FOLLWERS_VIEW: {
                    [likedVideosView didReceiveMemoryWarning];
                    [followingView didReceiveMemoryWarning];
                    break;
                }
                    
                case FOLLOWING_VIEW: {
                    [likedVideosView didReceiveMemoryWarning];
                    [followersView didReceiveMemoryWarning];
                    break;
                }
                    
                default:
                    break;
            }
        } else if (level == OSMemoryNotificationLevelCritical) {
            [likedVideosView didReceiveMemoryWarning];
            [followersView didReceiveMemoryWarning];
            [followingView didReceiveMemoryWarning];
        }
    }
    
}

- (void) dealloc {
    [userProfile resetProfileImageLoadedCallback];
    
    likedVideosView.loadMoreDataCallback = nil;
    likedVideosView.addVideoPlayerCallback = nil;
    likedVideosView.onViewSourceClickedCallback = nil;
    
    followersView.openUserProfileCallback = nil;
    followersView.loadMoreDataCallback = nil;
    
    followingView.openUserProfileCallback = nil;
    followingView.loadMoreDataCallback = nil;
    
    [openUserProfileCallback release];
    [onViewSourceClickedCallback release];
    [userProfile release];
    
	[profilePicView removeFromSuperview];
    [usernameView removeFromSuperview];
    [followButton removeFromSuperview];
    [optionsButton removeFromSuperview];
    [likedVideosView removeFromSuperview];
    [followersView removeFromSuperview];
    [followingView removeFromSuperview];
    
    openUserProfileCallback = nil;
    onViewSourceClickedCallback = nil;
    userProfile = nil;
    
    profilePicView = nil;
    usernameView = nil;
    followButton = nil;
    optionsButton = nil;
    likedVideosView = nil;
    followersView = nil;
    followingView = nil;
    
    [super dealloc];
}

// --------------------------------------------------------------------------------
//                                  Private functions
// --------------------------------------------------------------------------------

- (void) onUserImageLoaded:(UIImage*)userImage {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    if (userImage != nil) {
        if (![[NSThread currentThread] isCancelled]) {
            profilePicView.frame = CGRectMake(8, 10, 100, userImage.size.height);
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

- (void) getFollowers:(UserProfileObject*)user forPage:(int)pageNumber withFollowersCount:(int)followersCount {
    UserProfileRequest* userProfileRequest = [[[UserProfileRequest alloc] init] autorelease];
    userProfileRequest.errorCallback = [Callback create:self selector:@selector(onFollowersRequestFailed:)];
    userProfileRequest.successCallback = [Callback create:self selector:@selector(onFollowersRequestSuccess:)];
	[userProfileRequest getPeopleUserFollows:user.userId forPage:pageNumber withFollowersCount:followersCount];	
}

- (void) getFollowing:(UserProfileObject*)user forPage:(int)pageNumber withFollowingCount:(int)followingCount {
    UserProfileRequest* userProfileRequest = [[[UserProfileRequest alloc] init] autorelease];
    userProfileRequest.errorCallback = [Callback create:self selector:@selector(onFollowingRequestFailed:)];
    userProfileRequest.successCallback = [Callback create:self selector:@selector(onFollowingRequestSuccess:)];
	[userProfileRequest getPeopleFollowingUser:user.userId forPage:pageNumber withFollowingCount:followingCount];
}

- (void) getLikedVideos:(UserProfileObject*)user forPage:(int)pageNumber withVideosCount:(int)videosCount {
    UserProfileRequest* userProfileRequest = [[[UserProfileRequest alloc] init] autorelease];
    userProfileRequest.errorCallback = [Callback create:self selector:@selector(onLikedVideosRequestFailed:)];
    userProfileRequest.successCallback = [Callback create:self selector:@selector(onLikedVideosRequestSuccess:)];
	[userProfileRequest getLikedVideosByUser:user.userId forPage:pageNumber withVideosCount:videosCount];
}

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

- (void) onLoadMoreLikedVideos {
    isLikedVideosListRefreshing = false;
    [self getLikedVideos:userProfile forPage:(lastlikedVideosPageRequested + 1) withVideosCount:10];
}

- (void) onLoadMoreFollowers {
    isFollowersListRefreshing = false;
    [self getFollowers:userProfile forPage:(lastFollowersPageRequested + 1) withFollowersCount:20];
}

- (void) onLoadMoreFollowing {
    isFollowingListRefreshing = false;
    [self getFollowing:userProfile forPage:(lastFollowingPageRequested + 1) withFollowingCount:20];
}

- (void) onOptionsButtonClicked:(UIButton*)sender {
    switch(optionsButton.selectedSegmentIndex) {
        case 0: {
            [self performSelector:@selector(onLikedVideosButtonClicked:) withObject:nil];
            
            break;
        }
            
        case 1: {
            [self performSelector:@selector(onFollowersButtonClicked:) withObject:nil];
            break;
        }
            
        case 2: {
            [self performSelector:@selector(onFollowingButtonClicked:) withObject:nil];
            break;
        }
    }
}

- (void) onFollowButtonClicked:(UIButton*)sender {
    if (userProfile.following) {
        [self performSelector:@selector(unfollowUser:) withObject:userProfile];
    } else {
        [self performSelector:@selector(followUser:) withObject:userProfile];
    }
}

- (void) onLikedVideosButtonClicked:(UIButton*)sender {
    likedVideosView.hidden = NO;
    followersView.hidden = YES;
    followingView.hidden = YES;
    
    activeView = LIKED_VIDEOS_VIEW;
    
    isLikedVideosListRefreshing = true;
    [self getLikedVideos:userProfile forPage:-1 withVideosCount:(lastlikedVideosPageRequested * 10)];
    
}

- (void) onFollowersButtonClicked:(UIButton*)sender {
    [likedVideosView closePlayer];
    followersView.hidden = NO;
    likedVideosView.hidden = YES;
    followingView.hidden = YES;
    
    activeView = FOLLWERS_VIEW;
    
    isFollowersListRefreshing = true;
    [self getFollowers:userProfile forPage:-1 withFollowersCount:(lastFollowersPageRequested * 20)];
}

- (void) onFollowingButtonClicked:(UIButton*)sender {
    [likedVideosView closePlayer];
    followingView.hidden = NO;
    likedVideosView.hidden = YES;
    followersView.hidden = YES;
    
    activeView = FOLLOWING_VIEW;
    
    isFollowingListRefreshing = true;
    [self getFollowing:userProfile forPage:-1 withFollowingCount:(lastFollowingPageRequested * 20)];
}

- (void) openUserProfile:(UserProfileObject*)user {
    [likedVideosView closePlayer];
    
    if (openUserProfileCallback != nil) {
        [openUserProfileCallback execute:user];
    }
}

- (void) onViewSourceClicked:(NSString*)sourceUrl {
    if (onViewSourceClickedCallback != nil) {
        [onViewSourceClickedCallback execute:sourceUrl];
    }
}

- (void) addVideoPlayer: (VideoPlayerView*) videoPlayer {
    videoPlayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:videoPlayer];
    [self bringSubviewToFront:videoPlayer];
}

// --------------------------------------------------------------------------------
//                             Request Callbacks
// --------------------------------------------------------------------------------

- (void) onLikedVideosRequestSuccess: (UserProfileResponse*)response {
    if (response.success) {
        NSDictionary* result = [response userProfile];
        
        if ([likedVideosView count] == 0 || !isLikedVideosListRefreshing) {
            lastlikedVideosPageRequested = [result objectForKey:@"page"] != [NSNull null] ? [[result objectForKey:@"page"] intValue] : 1;
        }
        
        int total = [result objectForKey:@"total"] != [NSNull null] ? [[result objectForKey:@"total"] intValue] : 0;
        NSDictionary* args = [NSDictionary dictionaryWithObjectsAndKeys:
                              [result objectForKey:@"videos"], @"videosList",
                              [NSNumber numberWithInt:total], @"videoCount",
                              [NSNumber numberWithBool:isLikedVideosListRefreshing], @"isRefreshing",
                              [NSNumber numberWithInt:lastlikedVideosPageRequested], @"lastPageRequested",
                              nil];
        [likedVideosView performSelectorInBackground:@selector(updateListWrapper:) withObject:args];
	} else {
        [likedVideosView resetLoadingStatus];
        
		NSString* errorMessage = [NSString stringWithFormat:@"We failed to retrieve user videos: %@", response.errorMessage];
		
		// show error message
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Failed to retrieve videos" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		[alertView release];		
		
		LOG_ERROR(@"request success but failed to list videos: %@", response.errorMessage);
	}
}

- (void) onLikedVideosRequestFailed: (NSString*)errorMessage {
    [likedVideosView resetLoadingStatus];
    
    NSString* errorString = [NSString stringWithFormat:@"We failed to retrieve user videos: %@", errorMessage];
	
	// show error message
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Failed to retrieve videos" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
	[alertView release];		
	
	LOG_ERROR(@"list request error: %@", errorMessage);
}

- (void) onFollowersRequestSuccess: (UserProfileResponse*)response {
    if (response.success) {
        NSDictionary* result = [response userProfile];
        if ([followersView count] == 0 || !isFollowersListRefreshing) {
            lastFollowersPageRequested = [result objectForKey:@"page"] != [NSNull null] ? [[result objectForKey:@"page"] intValue] : 1;
        }
        
        int total = [result objectForKey:@"total"] != [NSNull null] ? [[result objectForKey:@"total"] intValue] : 0;
        NSDictionary* args = [NSDictionary dictionaryWithObjectsAndKeys:
                              [result objectForKey:@"followers"], @"usersList",
                              [NSNumber numberWithInt:total], @"userCount",
                              [NSNumber numberWithBool:isFollowersListRefreshing], @"isRefreshing",
                              [NSNumber numberWithInt:lastFollowersPageRequested], @"lastPageRequested",
                              nil];
        [followersView performSelectorInBackground:@selector(updateListWrapper:) withObject:args];
	} else {
        [followersView resetLoadingStatus];
        
		NSString* errorMessage = [NSString stringWithFormat:@"We failed to retrieve user followers: %@", response.errorMessage];
		
		// show error message
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Failed to retrieve followers" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		[alertView release];		
		
		LOG_ERROR(@"request success but failed to list followers: %@", response.errorMessage);
	}
}

- (void) onFollowersRequestFailed: (NSString*)errorMessage {
    [followersView resetLoadingStatus];
    
    NSString* errorString = [NSString stringWithFormat:@"We failed to retrieve user followers: %@", errorMessage];
	
	// show error message
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Failed to retrieve followers" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
	[alertView release];		
	
	LOG_ERROR(@"followers request error: %@", errorMessage);
}

- (void) onFollowingRequestSuccess: (UserProfileResponse*)response {
    if (response.success) {
        NSDictionary* result = [response userProfile];
        if ([followingView count] == 0 || !isFollowingListRefreshing) {
            lastFollowingPageRequested = [result objectForKey:@"page"] != [NSNull null] ? [[result objectForKey:@"page"] intValue] : 1;
        }
        
        int total = [result objectForKey:@"total"] != [NSNull null] ? [[result objectForKey:@"total"] intValue] : 0;
        NSDictionary* args = [NSDictionary dictionaryWithObjectsAndKeys:
                              [result objectForKey:@"following"], @"usersList",
                              [NSNumber numberWithInt:total], @"userCount",
                              [NSNumber numberWithBool:isFollowingListRefreshing], @"isRefreshing",
                              [NSNumber numberWithInt:lastFollowingPageRequested], @"lastPageRequested",
                              nil];
        [followingView performSelectorInBackground:@selector(updateListWrapper:) withObject:args];
	} else {
        [followingView resetLoadingStatus];
        
		NSString* errorMessage = [NSString stringWithFormat:@"We failed to retrieve people following users: %@", response.errorMessage];
		
		// show error message
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Failed to retrieve following" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		[alertView release];		
		
		LOG_ERROR(@"request success but failed to list followers: %@", response.errorMessage);
	}
}

- (void) onFollowingRequestFailed: (NSString*)errorMessage {
    [followingView resetLoadingStatus];
    
    NSString* errorString = [NSString stringWithFormat:@"We failed to retrieve user following: %@", errorMessage];
	
	// show error message
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Failed to retrieve following" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
	[alertView release];		
	
	LOG_ERROR(@"followers request error: %@", errorMessage);
}

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
//                          Public Functions
// --------------------------------------------------------------------------------

- (void) setUserProfile: (UserProfileObject*)user {
    if (userProfile != nil) {
        [userProfile resetProfileImageLoadedCallback];
        [userProfile release];
    }
    
    userProfile = [user retain];
    
    switch(activeView) {
        case LIKED_VIDEOS_VIEW: {
            optionsButton.selectedSegmentIndex = 0;
            break;
        }
            
        case FOLLWERS_VIEW: {
            optionsButton.selectedSegmentIndex = 1;
            break;
        }
            
        case FOLLOWING_VIEW: {
            optionsButton.selectedSegmentIndex = 2;
            break;
        }
    }
    
    usernameView.text = [userProfile.userName stringByAppendingFormat:@" (%@)", userProfile.name];
    [self layoutSubviews];
    NSString* followButtonTitle = (userProfile.following ? @"unfollow" :  @"follow");
    [followButton setTitle:followButtonTitle forState:UIControlStateNormal];
    LOG_DEBUG(@"Logged in user:%d", [UserObject getUser].userId);
    if ([UserObject getUser].userId == user.userId) {
        [followButton setHidden:YES];
    } else {
        [followButton setHidden:NO];
    }
    
    [optionsButton setTitle:[NSString stringWithFormat:@"%d  liked videos", userProfile.likes] forSegmentAtIndex:0];
    [optionsButton setTitle:[NSString stringWithFormat:@"%d  followers", userProfile.followersCount] forSegmentAtIndex:1];
    [optionsButton setTitle:[NSString stringWithFormat:@"%d  following", userProfile.followingCount] forSegmentAtIndex:2];
    
    if (![[NSThread currentThread] isCancelled]) {
        if (userProfile.normalPictureImage == nil) {
            if (!userProfile.pictureImageLoaded) {
                [self performSelector:@selector(downloadUserImage) withObject:nil];
            } else {
                profilePicView.hidden = YES;
            }
        } else {
            if (![[NSThread currentThread] isCancelled]) {
                profilePicView.frame = CGRectMake(8, 10, 100, userProfile.normalPictureImage.size.height);
                [profilePicView performSelectorOnMainThread:@selector(setImage:) withObject:userProfile.normalPictureImage waitUntilDone:YES];
                profilePicView.hidden = NO;
                [self layoutSubviews];
            }
        }
    }
}

- (UserProfileObject*) getUserProfile {
    return userProfile;
}

- (void) closePlayer {
    if (activeView == LIKED_VIDEOS_VIEW) {
        [likedVideosView closePlayer];
    }
}

@end
