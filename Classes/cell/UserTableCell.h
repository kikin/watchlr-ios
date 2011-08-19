//
//  VideoTableCell.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CommonIos/Callback.h>

#import "UserProfileObject.h"

@interface UserTableCell : UITableViewCell {
	UserProfileObject* userProfile;
	
    UIImageView* profilePicView;
    UILabel* userNameLabel;

	Callback* openUserProfileCallback;
}

@property(retain) Callback* openUserProfileCallback;

- (void) setUserObject: (UserProfileObject*)userProfileObject;

@end
