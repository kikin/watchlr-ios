//
//  ErrorMainView.h
//  KikinVideo
//
//  Created by ludovic cabre on 5/6/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CommonIos/Callback.h>
#import "UserProfileObject.h"

/** Refresh States. */
//typedef enum {
//    LIKED_VIDEOS_VIEW = 1,
//    FOLLWERS_VIEW = 2,
//    FOLLOWING_VIEW = 3
//} ActiveView;

@interface UserProfileIphoneView : UIView<UITableViewDataSource, UITableViewDelegate> {
    UITableView*        optionsButtonList;
    UIImageView*        profilePicView;
    UILabel*            usernameView;
    UILabel*            nameView;
    UIButton*           followButton;
    
    UserProfileObject*  userProfile;
}

@property(retain) Callback* showLikedVideosListCallback;
@property(retain) Callback* showFollowersListCallback;
@property(retain) Callback* showFollowingListCallback;

- (void) setUserProfile: (UserProfileObject*)user;
- (UserProfileObject*) getUserProfile;
- (void) didReceiveMemoryWarning:(bool)forced;

@end