    //
//  MostViewedViewController.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "UsersViewController.h"
#import "ProfileViewController.h"
#import "UserProfileRequest.h"
#import "UserProfileResponse.h"
#import "VideoRequest.h"
#import "VideoResponse.h"

@implementation UsersViewController

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    [super loadView];
    
    usersListView = [[UserListView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    usersListView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    usersListView.loadMoreDataCallback = [Callback create:self selector:@selector(onLoadMoreData)];
    usersListView.openUserProfileCallback = [Callback create:self selector:@selector(openUserProfile:)];
    [self.view addSubview:usersListView];
    [self.view sendSubviewToBack:usersListView]; 
	
	// request video list
//    isRefreshing = true;
//	[self doVideoListRequest:-1 withVideosCount:10];
}

- (void) didReceiveMemoryWarning {
    if (!isActiveTab) {
        [usersListView didReceiveMemoryWarning];
    } else {
        int level = [DeviceUtils currentMemoryLevel];
        if (level >= OSMemoryNotificationLevelUrgent) {
            [usersListView didReceiveMemoryWarning];
        }
    }
    
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
	// release memory
    [usersListView removeFromSuperview];
	
    usersListView = nil;
    [super dealloc];
}

// --------------------------------------------------------------------------------
//                          Private Functions
// --------------------------------------------------------------------------------

// --------------------------------------------------------------------------------
//                                  Requests
// --------------------------------------------------------------------------------

- (void) getFollowers:(int)user_id forPage:(int)pageNumber withFollowersCount:(int)followersCount {
    UserProfileRequest* userProfileRequest = [[[UserProfileRequest alloc] init] autorelease];
    userProfileRequest.errorCallback = [Callback create:self selector:@selector(onFollowersRequestFailed:)];
    userProfileRequest.successCallback = [Callback create:self selector:@selector(onFollowersRequestSuccess:)];
	[userProfileRequest getPeopleUserFollows:user_id forPage:pageNumber withFollowersCount:followersCount];	
}

- (void) getFollowing:(int)user_id forPage:(int)pageNumber withFollowingCount:(int)followingCount {
    UserProfileRequest* userProfileRequest = [[[UserProfileRequest alloc] init] autorelease];
    userProfileRequest.errorCallback = [Callback create:self selector:@selector(onFollowingRequestFailed:)];
    userProfileRequest.successCallback = [Callback create:self selector:@selector(onFollowingRequestSuccess:)];
	[userProfileRequest getPeopleFollowingUser:user_id forPage:pageNumber withFollowingCount:followingCount];
}

- (void) getLikedByUsers:(int)video_id forPage:(int)pageNumber withLikedByUsersCount:(int)likedByUsersCount {
    VideoRequest* videoRequest = [[[VideoRequest alloc] init] autorelease];
    videoRequest.errorCallback = [Callback create:self selector:@selector(onLikedByUsersRequestFailed:)];
    videoRequest.successCallback = [Callback create:self selector:@selector(onLikedByUsersRequestSuccess:)];
	[videoRequest getLikedByUsers:video_id forPage:pageNumber withLikedByUsersCount:likedByUsersCount];
}

// --------------------------------------------------------------------------------
//                                  Callbacks
// --------------------------------------------------------------------------------
- (void) onClickRefresh {
    isRefreshing = true;
    switch (userType) {
        case FOLLOWER_USERS_LIST:
            [self getFollowers:userId forPage:-1 withFollowersCount:(lastPageRequested * 20)];
            break;
            
        case FOLLOWING_USERS_LIST:
            [self getFollowing:userId forPage:-1 withFollowingCount:(lastPageRequested * 20)];
            break;
            
        case LIKED_BY_USERS_LIST:
            [self getLikedByUsers:videoId forPage:-1 withLikedByUsersCount:(lastPageRequested * 20)];
            break;
            
        default:
            break;
    }
}

- (void) onApplicationBecomeActive: (NSNotification*)notification {
    [self onClickRefresh];
}

- (void) onLoadMoreData {
    isRefreshing = false;
    switch (userType) {
        case FOLLOWER_USERS_LIST:
            [self getFollowers:userId forPage:(lastPageRequested + 1) withFollowersCount:20];
            break;
            
        case FOLLOWING_USERS_LIST:
            [self getFollowing:userId forPage:(lastPageRequested + 1) withFollowingCount:20];
            break;
            
        case LIKED_BY_USERS_LIST:
            [self getLikedByUsers:videoId forPage:(lastPageRequested + 1) withLikedByUsersCount:20];
            break;
            
        default:
            break;
    }
//    [self doVideoListRequest: (lastPageRequested + 1) withVideosCount:10];
}

- (void) openUserProfile:(UserProfileObject*)userProfile {
    ProfileViewController* profileViewController = [[[ProfileViewController alloc] init] autorelease];
    [self.navigationController pushViewController:profileViewController animated:YES];
    [profileViewController setUserObject:userProfile];
}

// --------------------------------------------------------------------------------
//                             Request Callbacks
// --------------------------------------------------------------------------------

- (void) onFollowersRequestSuccess: (UserProfileResponse*)response {
    if (response.success) {
        NSDictionary* result = [response userProfile];
        if ([usersListView count] == 0 || !isRefreshing) {
            lastPageRequested = [result objectForKey:@"page"] != [NSNull null] ? [[result objectForKey:@"page"] intValue] : 1;
        }
        
        int total = [result objectForKey:@"total"] != [NSNull null] ? [[result objectForKey:@"total"] intValue] : 0;
        NSDictionary* args = [NSDictionary dictionaryWithObjectsAndKeys:
                              [result objectForKey:@"followers"], @"usersList",
                              [NSNumber numberWithInt:total], @"userCount",
                              [NSNumber numberWithBool:isRefreshing], @"isRefreshing",
                              [NSNumber numberWithInt:lastPageRequested], @"lastPageRequested",
                              nil];
        [usersListView performSelectorInBackground:@selector(updateListWrapper:) withObject:args];
	} else {
        [usersListView resetLoadingStatus];
        
		NSString* errorMessage = [NSString stringWithFormat:@"We failed to retrieve user followers: %@", response.errorMessage];
		
		// show error message
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Failed to retrieve followers" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		[alertView release];		
		
		LOG_ERROR(@"request success but failed to list followers: %@", response.errorMessage);
	}
}

- (void) onFollowersRequestFailed: (NSString*)errorMessage {
    [usersListView resetLoadingStatus];
    
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
        if ([usersListView count] == 0 || !isRefreshing) {
            lastPageRequested = [result objectForKey:@"page"] != [NSNull null] ? [[result objectForKey:@"page"] intValue] : 1;
        }
        
        int total = [result objectForKey:@"total"] != [NSNull null] ? [[result objectForKey:@"total"] intValue] : 0;
        NSDictionary* args = [NSDictionary dictionaryWithObjectsAndKeys:
                              [result objectForKey:@"following"], @"usersList",
                              [NSNumber numberWithInt:total], @"userCount",
                              [NSNumber numberWithBool:isRefreshing], @"isRefreshing",
                              [NSNumber numberWithInt:lastPageRequested], @"lastPageRequested",
                              nil];
        [usersListView performSelectorInBackground:@selector(updateListWrapper:) withObject:args];
	} else {
        [usersListView resetLoadingStatus];
        
		NSString* errorMessage = [NSString stringWithFormat:@"We failed to retrieve people following users: %@", response.errorMessage];
		
		// show error message
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Failed to retrieve following" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		[alertView release];		
		
		LOG_ERROR(@"request success but failed to list followers: %@", response.errorMessage);
	}
}

- (void) onFollowingRequestFailed: (NSString*)errorMessage {
    [usersListView resetLoadingStatus];
    
    NSString* errorString = [NSString stringWithFormat:@"We failed to retrieve user following: %@", errorMessage];
	
	// show error message
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Failed to retrieve following" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
	[alertView release];		
	
	LOG_ERROR(@"following request error: %@", errorMessage);
}

- (void) onLikedByUsersRequestSuccess: (VideoResponse*)response {
    if (response.success) {
        NSDictionary* result = [response videoResponse];
        if ([usersListView count] == 0 || !isRefreshing) {
            lastPageRequested = [result objectForKey:@"page"] != [NSNull null] ? [[result objectForKey:@"page"] intValue] : 1;
        }
        
        int total = [result objectForKey:@"total"] != [NSNull null] ? [[result objectForKey:@"total"] intValue] : 0;
        NSDictionary* args = [NSDictionary dictionaryWithObjectsAndKeys:
                              [result objectForKey:@"liked_by"], @"usersList",
                              [NSNumber numberWithInt:total], @"userCount",
                              [NSNumber numberWithBool:isRefreshing], @"isRefreshing",
                              [NSNumber numberWithInt:lastPageRequested], @"lastPageRequested",
                              nil];
        [usersListView performSelectorInBackground:@selector(updateListWrapper:) withObject:args];
	} else {
        [usersListView resetLoadingStatus];
        
		NSString* errorMessage = [NSString stringWithFormat:@"We failed to retrieve people who have liked the video: %@", response.errorMessage];
		
		// show error message
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Failed to retrieve people who liked the video" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		[alertView release];		
		
		LOG_ERROR(@"request success but failed to list the users who liked the video: %@", response.errorMessage);
	}
}

- (void) onLikedByUsersRequestFailed: (NSString*)errorMessage {
    [usersListView resetLoadingStatus];
    
    NSString* errorString = [NSString stringWithFormat:@"We failed to retrieve people who liked the video: %@", errorMessage];
	
	// show error message
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Failed to retrieve people who liked the video" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
	[alertView release];		
	
	LOG_ERROR(@"liked by users request error: %@", errorMessage);
}

// --------------------------------------------------------------------------------
//                          Public Functions
// --------------------------------------------------------------------------------
- (void) onTabInactivate {
    isActiveTab = false;
}

- (void) onTabActivate {
    isActiveTab = true;
    if (self.navigationController.visibleViewController == self) {
        [self onClickRefresh];
    }
}

- (void) onApplicationBecomeInactive {
    [self onTabActivate];
}

- (BOOL) shouldRotate {
    return NO;
}

- (void) showFollowersList:(int)user_id {
    userId = user_id;
    userType = FOLLOWER_USERS_LIST;
    [self getFollowers:userId forPage:-1 withFollowersCount:20];
}

- (void) showFollowingUsersList:(int)user_id {
    userId = user_id;
    userType = FOLLOWING_USERS_LIST;
    [self getFollowing:userId forPage:-1 withFollowingCount:20];
}

- (void) showLikedByUsersList:(int)video_id {
    videoId = video_id;
    userType = LIKED_BY_USERS_LIST;
    [self getLikedByUsers:videoId forPage:-1 withLikedByUsersCount:20];
}

@end
