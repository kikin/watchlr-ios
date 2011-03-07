//
//  LoginViewController.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/25/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserObject.h"

@interface LoginViewController : UIViewController {
	IBOutlet UIWindow *window;
	IBOutlet UIButton* connectButton;
	IBOutlet UITextField* textField;
	IBOutlet UIView* loginView;
	UserObject* userObject;
}

- (IBAction) tryConnecting;

- (void) onLinkRequestSuccess: (id)jsonObject;
- (void) onLinkRequestFailed: (NSString*)errorMessage;

@property (nonatomic, assign) UserObject* userObject;
@property (nonatomic, retain) IBOutlet UIView* loginView;
@property (nonatomic, retain) IBOutlet UIWindow *window;

@end
