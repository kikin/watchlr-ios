//
//  LoginViewController.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/25/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CommonIos/FBConnect.h>
#import "UserObject.h"
#import "LoadingMainView.h"
#import "ErrorMainView.h"
#import "ConnectMainView.h"
#import "CommonIos/Callback.h"

@interface LoginViewController : UIViewController <FBSessionDelegate, FBRequestDelegate> {
	Facebook* facebook;
	ErrorMainView* errorMainView;
	LoadingMainView* loadingMainView;
	ConnectMainView* connectMainView;
    Callback* onLoginSuccessCallback;
	UIImageView* logoImage;
}

- (Facebook*) facebook;
- (void) showView: (UIView*)view;
- (void) goToMainView:(bool)animated;
- (void) doLinkDeviceRequest: (NSString*)facebookId andAccessToken:(NSString*)facebookAccessToken;
- (void) onLinkRequestSuccess: (id)jsonObject;
- (void) onLinkRequestFailed: (NSString*)errorMessage;

@property(retain) Callback* onLoginSuccessCallback;

@end
