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

@interface LoginViewController : UIViewController <FBSessionDelegate, FBRequestDelegate> {
	Facebook* facebook;
	ErrorMainView* errorMainView;
	LoadingMainView* loadingMainView;
	ConnectMainView* connectMainView;
	UIImageView* logoImage;
}

- (Facebook*) facebook;
- (void) showView: (UIView*)view;
- (void) goToMainView:(bool)animated;
- (void) doLinkDeviceRequest: (NSString*)accessToken;
- (void) onLinkRequestSuccess: (id)jsonObject;
- (void) onLinkRequestFailed: (NSString*)errorMessage;

@end
