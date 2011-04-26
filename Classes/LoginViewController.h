//
//  LoginViewController.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/25/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserObject.h"
#import "FBConnect.h"

@interface LoginViewController : UIViewController <FBSessionDelegate, FBRequestDelegate> {
	Facebook* facebook;
	UILabel* titleLabel;
	UILabel* descriptionLabel;
	UIButton* loginButton;
	UIView* loginBgView;
	UIImageView* logoImage;
}

- (void) goToMainView:(bool)animated;
- (void) doLinkDeviceRequest: (NSString*)accessToken;
- (void) onLinkRequestSuccess: (id)jsonObject;
- (void) onLinkRequestFailed: (NSString*)errorMessage;

@end
