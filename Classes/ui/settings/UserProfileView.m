//
//  ConnectMainView.m
//  KikinVideo
//
//  Created by ludovic cabre on 5/6/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "UserProfileView.h"
#import <QuartzCore/QuartzCore.h>

#import "UserProfileRequest.h"
#import "UserProfileResponse.h"

@implementation UserProfileView

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		// add the rounded rect view over the logo
		self.backgroundColor = [UIColor colorWithRed:(12.0/255.0) green:(83.0/255.0) blue:(111.0/255.0) alpha:1.0];
		self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
		self.layer.cornerRadius = 10.0f;
		self.layer.borderWidth = 1.0f;
        // self.layer.shadowColor = [[UIColor colorWithRed:(12.0/255.0) green:(83.0/255.0) blue:(111.0/255.0) alpha:0.85] CGColor];
        self.layer.shadowRadius = 10.0f;
        self.layer.shadowOpacity = 0.5;
        self.layer.shadowOffset = CGSizeMake(-15, 20);
		// self.layer.opacity = 0.95f;
        
        // create the name label
        nameLabel = [[UILabel alloc] init];
        nameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        nameLabel.text = @"";
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = [UIFont boldSystemFontOfSize:20.0];
        nameLabel.textAlignment = UITextAlignmentLeft;
        [self addSubview:nameLabel];
        
        // create the user profile image
        userProfileImageView = [[UIImageView alloc] init];
        userProfileImageView.image = [UIImage imageNamed:@"watchlr_favicon.png"];
        [self addSubview:userProfileImageView];
        
        // create the username label
        userNameLabel = [[UILabel alloc] init];
        userNameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        userNameLabel.text = @"Username:";
        userNameLabel.textColor = [UIColor whiteColor];
        userNameLabel.backgroundColor = [UIColor clearColor];
        userNameLabel.textAlignment = UITextAlignmentLeft;
        [self addSubview:userNameLabel];
        
        // create the username text view
        userNameTextView = [[UITextField alloc] init];
        userNameTextView.backgroundColor = [UIColor whiteColor];
        userNameTextView.textAlignment = UITextAlignmentLeft;
        userNameTextView.text = @"";
        userNameTextView.borderStyle = UITextBorderStyleLine;
        userNameTextView.clearButtonMode = UITextFieldViewModeWhileEditing;
        userNameTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
        userNameTextView.returnKeyType = UIReturnKeyDone;
        [userNameTextView addTarget:self action:@selector(textFieldStartEditing:) forControlEvents:UIControlEventEditingChanged];
        //[userNameTextView addTarget:self action:@selector(textFieldDidEditing) forControlEvents];
        [self addSubview:userNameTextView];
        
        // create the username label
        userEmailLabel = [[UILabel alloc] init];
        userEmailLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        userEmailLabel.text = @"Email:";
        userEmailLabel.textColor = [UIColor whiteColor];
        userEmailLabel.backgroundColor = [UIColor clearColor];
        userEmailLabel.textAlignment = UITextAlignmentLeft;
        [self addSubview:userEmailLabel];
        
        // create the username text view
        userEmailTextView = [[UITextField alloc] init];
        userEmailTextView.backgroundColor = [UIColor whiteColor];
        userEmailTextView.textAlignment = UITextAlignmentLeft;
        userEmailTextView.text = @"";
        userEmailTextView.borderStyle = UITextBorderStyleLine;
        userEmailTextView.clearButtonMode = UITextFieldViewModeWhileEditing;
        userEmailTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
        userEmailTextView.keyboardType = UIKeyboardTypeEmailAddress;
        userEmailTextView.returnKeyType = UIReturnKeyDone;
        [self addSubview:userEmailTextView];
        
        // create the checkbox button
        checkboxImageView = [[UIImageView alloc] init];
        checkboxImageView.image = [UIImage imageNamed:@"checkbox-checked.png"];
        [self addSubview:checkboxImageView];
        
        // create the label for checkbox
        pushToFacebookLabel = [[UILabel alloc] init];
        pushToFacebookLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        pushToFacebookLabel.text = @"Automatically update Facebook when I like videos";
        pushToFacebookLabel.backgroundColor = [UIColor clearColor];
        pushToFacebookLabel.textAlignment = UITextAlignmentLeft;
        pushToFacebookLabel.textColor = [UIColor whiteColor];
        [self addSubview:pushToFacebookLabel];
        
        // create the save button
        saveButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
        [saveButton addTarget:self action:@selector(onClickSaveButton:) forControlEvents:UIControlEventTouchUpInside];
		[saveButton setTitle:@"Save" forState:UIControlStateNormal];
        saveButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
		[self addSubview:saveButton];
        
        // create the save button
        cancelButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
        [cancelButton addTarget:self action:@selector(onClickCancelButton:) forControlEvents:UIControlEventTouchUpInside];
		[cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        cancelButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
		[self addSubview:cancelButton];
        
        if (DeviceUtils.isIphone) {
            nameLabel.frame = CGRectMake(10, 10, 300, 30);
            userProfileImageView.frame = CGRectMake(10, 55, 50, 50);
            
            userNameLabel.frame = CGRectMake(70, 50, 80, 20);
            userNameLabel.font = [UIFont boldSystemFontOfSize:12.0];
            
            userNameTextView.font = [UIFont systemFontOfSize:12.0];
            userNameTextView.frame = CGRectMake(140, 50, 160, 20);
            
            userEmailLabel.frame = CGRectMake(70, 80, 50, 20);
            userEmailLabel.font = [UIFont boldSystemFontOfSize:12.0];
            
            userEmailTextView.font = [UIFont systemFontOfSize:12.0];
            userEmailTextView.frame = CGRectMake(140, 80, 160, 20);
            
            checkboxImageView.frame = CGRectMake(10, 120, 16, 16);
            
            pushToFacebookLabel.frame = CGRectMake(35, 117, 300, 20);
            pushToFacebookLabel.font = [UIFont boldSystemFontOfSize:10.0];
            
        } else {
            nameLabel.frame = CGRectMake(20, 15, 500, 30);
            userProfileImageView.frame = CGRectMake(20, 55, 100, 100);
            
            userNameLabel.frame = CGRectMake(150, 55, 90, 20);
            userNameLabel.font = [UIFont boldSystemFontOfSize:14.0];
            
            userNameTextView.font = [UIFont systemFontOfSize:14.0];
            userNameTextView.frame = CGRectMake(230, 55, 250, 20);
            
            userEmailLabel.frame = CGRectMake(150, 85, 80, 20);
            userEmailLabel.font = [UIFont boldSystemFontOfSize:14.0];
            
            userEmailTextView.font = [UIFont systemFontOfSize:14.0];
            userEmailTextView.frame = CGRectMake(230, 85, 250, 20);
            
            checkboxImageView.frame = CGRectMake(150, 125, 16, 16);
            
            pushToFacebookLabel.frame = CGRectMake(175, 122, 400, 20);
            pushToFacebookLabel.font = [UIFont boldSystemFontOfSize:12.0];
        }
        
        // listen for keyboard hide and show
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldWillBeginEditing:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidEditing:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void) onClickSaveButton: (UIButton*)sender {
    
    // check if username is not empty
    if ([userNameTextView.text length] == 0) {
        // show error message
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Username cannot be empty" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        
        LOG_ERROR(@"failed to save user settings: %@", @"Username cannot be empty");
    }
    
    // check if email address is not empty
    if ([userEmailTextView.text length] == 0) {
        // show error message
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Email address cannot be empty" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        
        LOG_ERROR(@"failed save user settings: %@", @"Email address cannot be empty");
    }
    
    NSMutableDictionary* userProfileObject = [[NSMutableDictionary alloc] init];
    bool modified = false;
    // check if anything has changed
    if (NSOrderedSame != [userNameTextView.text localizedCompare:userProfile.userName]) {
        [userProfileObject setObject:userNameTextView.text forKey:@"username"];
        modified = true;
    }
    
    if (NSOrderedSame != [userEmailTextView.text localizedCompare:userProfile.email]) {
        [userProfileObject setObject:userEmailTextView.text forKey:@"email"];
        modified = true;
    }
        
    if (checked != (userProfile.preferences.syndicate == 1)) {
        NSString* preferences = [NSString stringWithFormat:@"{\"syndicate\":%d}", (checked ? 1: 0)];
        [userProfileObject setObject:preferences forKey:@"preferences"];
        // [preferences release];
        modified = true;
    }
    
    if (modified) {
        [self doSaveUserProfileRequest:userProfileObject];
    }
    
    [userProfileObject release];
}

- (void) onClickCancelButton: (UIButton*)sender {
    [self setHidden:YES];
}

-(void) showUserProfile {
    if (loadingView == nil) {
        loadingView = [[LoadingMainView alloc] initWithFrame:CGRectMake((self.superview.frame.size.width-300)/2, (self.superview.frame.size.height-55)/2, 300, 55)];
        [self.superview addSubview:loadingView];
        [self.superview bringSubviewToFront:loadingView];
    }
    
    [loadingView setHidden:NO];
    [self doGetUserProfileRequest];
}

- (void) loadUserProfileImage:(NSString*)userProfileImageUrl {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	
    if (userProfileImageUrl != nil) {
        if (DeviceUtils.isIphone) {
            userProfileImageUrl = [userProfileImageUrl stringByAppendingString:@"?type=small"];
        } else {
            userProfileImageUrl = [userProfileImageUrl stringByAppendingString:@"?type=normal"];
        }
        
        
        NSURL* url = [NSURL URLWithString:userProfileImageUrl];
        NSData* data = [NSData dataWithContentsOfURL:url];
        if (data != nil) {
            // set thumbnail image
            UIImage* img = [[UIImage alloc] initWithData:data];
            if (img != nil) {
                // make sure the thread was not killed
                if (![[NSThread currentThread] isCancelled]) {
                    [userProfileImageView performSelectorOnMainThread:@selector(setImage:) withObject:img waitUntilDone:YES];
                    userProfileImageView.frame = CGRectMake(userProfileImageView.frame.origin.x, userProfileImageView.frame.origin.y, img.size.width, img.size.height);
                }
                [img release];
            }
        }
    }
    
    [pool release];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [nameLabel release];
    [userProfileImageView release];
    [userNameLabel release];
    [userNameTextView release];
    [userEmailLabel release];
    [userEmailTextView release];
    [checkboxImageView release];
    [pushToFacebookLabel release];
    [saveButton release];
    [cancelButton release];
    
    if (loadingView != nil) {
        [loadingView release];
    }
    
    [userProfile release];
    [super dealloc];
}

// ------------------------------------------
//                  Touch Events
// ------------------------------------------
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *myTouch in touches)
    {
        CGPoint touchLocation = [myTouch locationInView:self];
        
        CGRect checkBoxRect = [checkboxImageView bounds];
        checkBoxRect = [checkboxImageView convertRect:checkBoxRect toView:self];
        if (CGRectContainsPoint(checkBoxRect, touchLocation)) {
            if (checked) {
                checked = false;
                checkboxImageView.image = [UIImage imageNamed:@"checkbox.png"];
            } else {
                checked = true;
                checkboxImageView.image = [UIImage imageNamed:@"checkbox-checked.png"];
            }
        }
    }
}

// -------------------------------------------------
//                      Requests
// -------------------------------------------------
-(void) doGetUserProfileRequest {
    UserProfileRequest* userProfileRequest = [[[UserProfileRequest alloc] init] autorelease];
    userProfileRequest.errorCallback = [Callback create:self selector:@selector(onGetUserProfileRequestFailed:)];
    userProfileRequest.successCallback = [Callback create:self selector:@selector(onGetUserProfileRequestSuccess:)];
	[userProfileRequest getUserProfile];	
}

- (void) onGetUserProfileRequestSuccess: (UserProfileResponse*)response {
	if (response.success) {
        if (userProfile != nil) [userProfile release];
		// save response and get videos
		userProfile = response.userProfile;
        if (userProfile != nil) {
            [userProfile retain];
            nameLabel.text = userProfile.name;
            [self loadUserProfileImage:userProfile.pictureUrl];
            userNameTextView.text = userProfile.userName;
            userEmailTextView.text = userProfile.email;
            checked = (userProfile.preferences.syndicate == 1);
            checkboxImageView.image = [UIImage imageNamed:(checked ? @"checkbox-checked.png" : @"checkbox.png")];
            
            if (DeviceUtils.isIphone) {
                saveButton.frame = CGRectMake(self.frame.size.width - 170, self.frame.size.height- 40, 75, 30);
                cancelButton.frame = CGRectMake(self.frame.size.width - 85, self.frame.size.height- 40, 75, 30);
                
            } else {
                saveButton.frame = CGRectMake(self.frame.size.width - 225, self.frame.size.height-50, 100, 35);
                cancelButton.frame = CGRectMake(self.frame.size.width - 115, self.frame.size.height-50, 100, 35);
            }
        }
        
        [UIView transitionFromView:loadingView toView:self duration:1.0 options:UIViewAnimationOptionLayoutSubviews completion:^(BOOL finished) {
            [loadingView setHidden:YES];
            [self setHidden:NO];
        }];
        // [self setHidden:NO];
		
		// LOG_DEBUG(@"get user profile request success");
	} else {
		NSString* errorMessage = [NSString stringWithFormat:@"We failed to retrieve your profile: %@", response.errorMessage];
		
        [loadingView setHidden:NO];
		// show error message
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Failed to retrieve user profile" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		[alertView release];		
		
		LOG_ERROR(@"request success but failed to show user profile: %@", response.errorMessage);
	}
}

- (void) onGetUserProfileRequestFailed: (NSString*)errorMessage {
	NSString* errorString = [NSString stringWithFormat:@"We failed to retrieve your profile: %@", errorMessage];
	
    [loadingView setHidden:NO];
	// show error message
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Failed to retrieve user profile" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
	[alertView release];		
	
	LOG_ERROR(@"get user profile request error: %@", errorMessage);
}

-(void) doSaveUserProfileRequest:(NSDictionary*)data {
    UserProfileRequest* userProfileRequest = [[[UserProfileRequest alloc] init] autorelease];
    userProfileRequest.errorCallback = [Callback create:self selector:@selector(onSaveUserProfileRequestFailed:)];
    userProfileRequest.successCallback = [Callback create:self selector:@selector(onSaveUserProfileRequestSuccess:)];
	[userProfileRequest updateUserProfile:data];
}

-(void) onSaveUserProfileRequestSuccess: (UserProfileResponse*)response {
    if (response.success) {
		// save response and get videos
        [self setHidden:YES];
		
		// LOG_DEBUG(@"save user profile request success");
	} else {
        
        UIAlertView* alertView; 
        NSString* errorMessage;
        switch (response.errorCode) {
            case 400: {
                errorMessage = [NSString stringWithFormat:@"Unable to access server. Please try again some time later."];
                alertView = [[UIAlertView alloc] initWithTitle:@"Failed to save user profile" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                break;
            }
                
            case 401: {
                errorMessage = [NSString stringWithFormat:@"Your session has expired. Please login again."];
                alertView = [[UIAlertView alloc] initWithTitle:@"Failed to save user profile" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                break;
            }
                
            case 406: {
                errorMessage = [NSString stringWithFormat:@"Username you entered is invalid. Try '%@'", response.errorMessage];
                alertView = [[UIAlertView alloc] initWithTitle:@"Failed to save user profile" message:errorMessage delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
                userProfile.userName = response.errorMessage;
                break;
            }
                
            default: {
                errorMessage = [NSString stringWithFormat:@"Unable to access server. Please try again some time later."];
                alertView = [[UIAlertView alloc] initWithTitle:@"Failed to save user profile" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                break;
            }
        }
		
		
		// show error message
		[alertView show];
		[alertView release];		
		
		LOG_ERROR(@"request success but failed to save user profile: %@", response.errorMessage);
	}
}

-(void) onSaveUserProfileRequestFailed: (NSString*)errorMessage {
    NSString* errorString = [NSString stringWithFormat:@"Unable to access server. Please try again some time later."];
	
	// show error message
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Failed to save user profile" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
	[alertView release];		
	
	LOG_ERROR(@"save user profile request error: %@", errorMessage);
}

// ---------------------------------------------------------
//             Alert View delegate implementation
// ---------------------------------------------------------
- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        userNameTextView.textColor = [UIColor redColor];
    } else {
        [UIView animateWithDuration:0.2 animations:^(void) {
            userNameTextView.textColor = [UIColor blackColor];
            userNameTextView.text = userProfile.userName;
        }];
    }
}

// ---------------------------------------------------------
//                  Keyboard Notifications
// ---------------------------------------------------------
- (void) textFieldWillBeginEditing:(NSNotification*)aNotification {
    [UIView animateWithDuration:0.3 animations:^(void) {
        userNameTextView.textColor = [UIColor blackColor];
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y - 60, self.frame.size.width, self.frame.size.height);
    }];
}

- (void) textFieldDidEditing:(NSNotification*)aNotification {
    [UIView animateWithDuration:0.3 animations:^(void) {
        userNameTextView.textColor = [UIColor blackColor];
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y + 60, self.frame.size.width, self.frame.size.height);
    }];
}

- (void) textFieldStartEditing:(id)sender {
    [UIView animateWithDuration:0.3 animations:^(void) {
        userNameTextView.textColor = [UIColor blackColor];
    }];
}

@end
