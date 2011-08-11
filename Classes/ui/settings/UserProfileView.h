//
//  ConnectMainView.h
//  KikinVideo
//
//  Created by ludovic cabre on 5/6/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserProfileObject.h"
#import "LoadingMainView.h"

@interface UserProfileView : UIView<UIAlertViewDelegate> {
    UILabel* nameLabel;
    UIImageView* userProfileImageView;
	UILabel* userNameLabel;
    UITextField* userNameTextView;
	UILabel* userEmailLabel;
    UITextField* userEmailTextView;
    UIImageView* checkboxImageView;
    UILabel* pushToFacebookLabel;
	UIButton* saveButton;
    UIButton* cancelButton;
    
    LoadingMainView* loadingView;
    UserProfileObject* userProfile;
    bool checked;
}

-(void) showUserProfile;

-(void) doGetUserProfileRequest;
-(void) doSaveUserProfileRequest:(NSDictionary*)data;

-(void) textFieldWillBeginEditing:(NSNotification*)aNotification;
-(void) textFieldDidEditing:(NSNotification*)aNotification;
-(void) textFieldStartEditing:(id)sender;

@end
