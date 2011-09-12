//
//  MostViewedViewController.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "WatchlrViewController.h"
#import "UserListView.h"

typedef enum {
    FOLLOWER_USERS_LIST,
    FOLLOWING_USERS_LIST,
    LIKED_BY_USERS_LIST
} UserType;

@interface UsersViewController : WatchlrViewController {
	UserListView*   usersListView;
    
    int             lastPageRequested;
    bool            isRefreshing;
    bool            isActiveTab;
    
    UserType        userType;
    int             videoId;
    int             userId;
    
}

- (void) showFollowersList:(int)user_id;
- (void) showFollowingUsersList:(int)user_id;
- (void) showLikedByUsersList:(int)video_id;

@end
