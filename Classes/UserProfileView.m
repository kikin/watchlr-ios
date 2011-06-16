//
//  ConnectMainView.m
//  KikinVideo
//
//  Created by ludovic cabre on 5/6/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "UserProfileView.h"
#import <QuartzCore/QuartzCore.h>

@implementation UserProfileView

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		// add the rounded rect view over the logo
		self.backgroundColor = [UIColor colorWithRed:(12.0/255.0) green:(83.0/255.0) blue:(111.0/255.0) alpha:0.8];
		self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
		self.layer.cornerRadius = 10.0f;
		self.layer.borderWidth = 1.0f;
		// self.layer.opacity = 0.95f;
        
        // create the name label
        nameLabel = [[UILabel alloc] init];
        nameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        nameLabel.frame = CGRectMake(20, 15, 500, 30);
        nameLabel.text = @"";
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = [UIFont boldSystemFontOfSize:20.0];
        nameLabel.textAlignment = UITextAlignmentLeft;
        [self addSubview:nameLabel];
        
        // create the user profile image
        userProfileImageView = [[UIImageView alloc] init];
        userProfileImageView.frame = CGRectMake(20, 55, 100, 100);
        userProfileImageView.image = [UIImage imageNamed:@"kikin_logo.png"];
        [self addSubview:userProfileImageView];
        
        // create the username label
        userNameLabel = [[UILabel alloc] init];
        userNameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        userNameLabel.frame = CGRectMake(150, 55, 80, 20);
        userNameLabel.text = @"Username:";
        userNameLabel.textColor = [UIColor whiteColor];
        userNameLabel.backgroundColor = [UIColor clearColor];
        userNameLabel.font = [UIFont boldSystemFontOfSize:14.0];
        userNameLabel.textAlignment = UITextAlignmentLeft;
        [self addSubview:userNameLabel];
        
        // create the username text view
        userNameTextView = [[UITextField alloc] init];
        userNameTextView.backgroundColor = [UIColor whiteColor];
        userNameTextView.font = [UIFont systemFontOfSize:14.0];
        userNameTextView.textAlignment = UITextAlignmentLeft;
        userNameTextView.text = @"";
        userNameTextView.frame = CGRectMake(230, 55, 250, 20);
        [self addSubview:userNameTextView];
        
        // create the username label
        userEmailLabel = [[UILabel alloc] init];
        userEmailLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        userEmailLabel.frame = CGRectMake(150, 85, 80, 20);
        userEmailLabel.text = @"Email:";
        userEmailLabel.textColor = [UIColor whiteColor];
        userEmailLabel.backgroundColor = [UIColor clearColor];
        userEmailLabel.font = [UIFont boldSystemFontOfSize:14.0];
        userEmailLabel.textAlignment = UITextAlignmentLeft;
        [self addSubview:userEmailLabel];
        
        // create the username text view
        userEmailTextView = [[UITextField alloc] init];
        userEmailTextView.backgroundColor = [UIColor whiteColor];
        userEmailTextView.font = [UIFont systemFontOfSize:14.0];
        userEmailTextView.textAlignment = UITextAlignmentLeft;
        userEmailTextView.text = @"";
        userEmailTextView.frame = CGRectMake(230, 85, 250, 20);
        [self addSubview:userEmailTextView];
        
        // create the checkbox button
        checkboxImageView = [[UIImageView alloc] init];
        checkboxImageView.image = [UIImage imageNamed:@"checkbox-checked.png"];
        checkboxImageView.frame = CGRectMake(150, 125, 16, 16);
        [self addSubview:checkboxImageView];
        
        // create the label for checkbox
        pushToFacebookLabel = [[UILabel alloc] init];
        pushToFacebookLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        pushToFacebookLabel.frame = CGRectMake(175, 122, 400, 20);
        pushToFacebookLabel.text = @"Automatically update Facebook when I like videos";
        pushToFacebookLabel.backgroundColor = [UIColor clearColor];
        pushToFacebookLabel.font = [UIFont boldSystemFontOfSize:12.0];
        pushToFacebookLabel.textAlignment = UITextAlignmentLeft;
        pushToFacebookLabel.textColor = [UIColor whiteColor];
        [self addSubview:pushToFacebookLabel];
        
        // create the save button
        saveButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
		saveButton.frame = CGRectMake(frame.size.width - 225, frame.size.height-50, 100, 35);
		saveButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
		[saveButton addTarget:self action:@selector(onClickSaveButton:) forControlEvents:UIControlEventTouchUpInside];
		[saveButton setTitle:@"Save" forState:UIControlStateNormal];
		[self addSubview:saveButton];
        
        // create the save button
        cancelButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
		cancelButton.frame = CGRectMake(frame.size.width - 115, frame.size.height-50, 100, 35);
		cancelButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
		[cancelButton addTarget:self action:@selector(onClickCancelButton:) forControlEvents:UIControlEventTouchUpInside];
		[cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
		[self addSubview:cancelButton];
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
        userProfileImageUrl = [userProfileImageUrl stringByAppendingString:@"?type=normal"];
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
    
    [getUserProfileRequest release];
    [getUserProfileResponse release];
    [saveUserProfileRequest release];
    [saveUserProfileResponse release];
    
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
    // get the list of videos
	if (getUserProfileRequest == nil) {
		getUserProfileRequest = [[GetUserProfileRequest alloc] init];
		getUserProfileRequest.errorCallback = [Callback create:self selector:@selector(onGetUserProfileRequestFailed:)];
		getUserProfileRequest.successCallback = [Callback create:self selector:@selector(onGetUserProfileRequestSuccess:)];
	}
	if ([getUserProfileRequest isRequesting]) {
		[getUserProfileRequest cancelRequest];
	}
    
	[getUserProfileRequest doGetUserProfileRequest];	
}

- (void) onGetUserProfileRequestSuccess: (GetUserProfileResponse*)response {
	if (response.success) {
		// save response and get videos
		getUserProfileResponse = [response retain];
        userProfile = getUserProfileResponse.userProfile;
        if (userProfile != nil) {
            nameLabel.text = userProfile.name;
            [self loadUserProfileImage:userProfile.pictureUrl];
            userNameTextView.text = userProfile.userName;
            userEmailTextView.text = userProfile.email;
            checked = (userProfile.preferences.syndicate == 1);
            checkboxImageView.image = [UIImage imageNamed:(checked ? @"checkbox-checked.png" : @"checkbox.png")];
        }
        
        /*[UIView transitionWithView:self.superview duration:1.0 options:UIViewAnimationTransitionCurlUp animations:^{self.hidden = NO;} completion:^(BOOL finished) {}];*/
        [UIView transitionFromView:loadingView toView:self duration:1.0 options:UIViewAnimationOptionLayoutSubviews completion:^(BOOL finished) {
            [loadingView setHidden:YES];
            [self setHidden:NO];
        }];
        // [self setHidden:NO];
		
		LOG_DEBUG(@"get user profile request success");
	} else {
		NSString* errorMessage = [NSString stringWithFormat:@"We failed to retrieve your profile: %@", response.errorMessage];
		
		// show error message
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Failed to retrieve user profile" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		[alertView release];		
		
		LOG_ERROR(@"request success but failed to show user profile: %@", response.errorMessage);
	}
}

- (void) onGetUserProfileRequestFailed: (NSString*)errorMessage {
	NSString* errorString = [NSString stringWithFormat:@"We failed to retrieve your profile: %@", errorMessage];
	
	// show error message
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Failed to retrieve user profile" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
	[alertView release];		
	
	LOG_ERROR(@"get user profile request error: %@", errorMessage);
}

-(void) doSaveUserProfileRequest:(NSDictionary*)data {
    // get the list of videos
	if (saveUserProfileRequest == nil) {
		saveUserProfileRequest = [[SaveUserProfileRequest alloc] init];
		saveUserProfileRequest.errorCallback = [Callback create:self selector:@selector(onSaveUserProfileRequestFailed:)];
		saveUserProfileRequest.successCallback = [Callback create:self selector:@selector(onSaveUserProfileRequestSuccess:)];
	}
	if ([saveUserProfileRequest isRequesting]) {
		[saveUserProfileRequest cancelRequest];
	}
    
	[saveUserProfileRequest doSaveUserProfileRequest:data];
}

-(void) onSaveUserProfileRequestSuccess: (SaveUserProfileResponse*)response {
    if (response.success) {
		// save response and get videos
		saveUserProfileResponse = [response retain];
        [self setHidden:YES];
		
		LOG_DEBUG(@"save user profile request success");
	} else {
		NSString* errorMessage = [NSString stringWithFormat:@"We failed to save your profile: %@", response.errorMessage];
		
		// show error message
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Failed to save user profile" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		[alertView release];		
		
		LOG_ERROR(@"request success but failed to save user profile: %@", response.errorMessage);
	}
}

-(void) onSaveUserProfileRequestFailed: (NSString*)errorMessage {
    NSString* errorString = [NSString stringWithFormat:@"We failed to save your profile: %@", errorMessage];
	
	// show error message
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Failed to save user profile" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
	[alertView release];		
	
	LOG_ERROR(@"save user profile request error: %@", errorMessage);
}

@end
