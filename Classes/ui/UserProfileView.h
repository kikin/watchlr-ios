//
//  ErrorMainView.h
//  KikinVideo
//
//  Created by ludovic cabre on 5/6/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CommonIos/Callback.h>
#import "VideosListView.h"
#import "UserListView.h"
#import "UserProfileObject.h"

/** Refresh States. */
typedef enum {
    LIKED_VIDEOS_VIEW = 1,
    FOLLWERS_VIEW = 2,
    FOLLOWING_VIEW = 3
} ActiveView;

@interface UserProfileView : UIView {
    VideosListView*     likedVideosView;
    UserListView*       followersView;
    UserListView*       followingView;
    
    UIImageView*        profilePicView;
    UILabel*            usernameView;
    UIButton*           followButton;
    UISegmentedControl* optionsButton;
    
    UserProfileObject*  userProfile;
    
    ActiveView activeView;
    
    bool isLikedVideosListRefreshing;
    bool isFollowersListRefreshing;
    bool isFollowingListRefreshing;
    
    int lastlikedVideosPageRequested;
    int lastFollowersPageRequested;
    int lastFollowingPageRequested;
}

@property(retain) Callback* openUserProfileCallback;
@property(retain) Callback* onViewSourceClickedCallback;

- (void) setUserProfile: (UserProfileObject*)user;
- (UserProfileObject*) getUserProfile;
- (void) closePlayer;
- (void) didReceiveMemoryWarning:(bool)forced;

@end