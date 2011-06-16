//
//  ConnectMainView.h
//  KikinVideo
//
//  Created by ludovic cabre on 5/6/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetUserProfileRequest.h"
#import "GetUserProfileResponse.h"
#import "SaveUserProfileRequest.h"
#import "SaveUserProfileResponse.h"
#import "UserProfileObject.h"
#import "LoadingMainView.h"

@interface UserProfileView : UIView {
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
    
    GetUserProfileRequest* getUserProfileRequest;
    GetUserProfileResponse* getUserProfileResponse;
    SaveUserProfileRequest* saveUserProfileRequest;
    SaveUserProfileResponse* saveUserProfileResponse;
    
    UserProfileObject* userProfile;
    bool checked;
}

-(void) showUserProfile;

-(void) doGetUserProfileRequest;
-(void) onGetUserProfileRequestSuccess: (GetUserProfileResponse*)response;
-(void) onGetUserProfileRequestFailed: (NSString*)errorMessage;

-(void) doSaveUserProfileRequest:(NSDictionary*)data;
-(void) onSaveUserProfileRequestSuccess: (SaveUserProfileResponse*)response;
-(void) onSaveUserProfileRequestFailed: (NSString*)errorMessage;

// -(void) textFieldBeginEditing;

@end
