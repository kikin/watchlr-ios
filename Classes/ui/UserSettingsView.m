//
//  ConnectMainView.m
//  KikinVideo
//
//  Created by ludovic cabre on 5/6/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "UserSettingsView.h"
#import <QuartzCore/QuartzCore.h>
#import "UserObject.h"

@implementation UserSettingsView

@synthesize showUserProfileCallback, showFeedbackFormCallback, logoutCallback;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		// add the rounded rect view over the logo
		self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
		self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
		self.layer.cornerRadius = 5.0f;
		self.layer.borderWidth = 1.0f;
		// self.layer.opacity = 0.95f;
        
        // create the profile button
        userProfileButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Settings"]];
        [userProfileButton setSegmentedControlStyle:UISegmentedControlStyleBar];
        [userProfileButton setTintColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0]];
        [userProfileButton setMomentary:YES];
        [userProfileButton addTarget:self action:@selector(onClickProfileButton:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:userProfileButton];
        
        // create the feedback button
        feedbackButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Feedback"]];
        [feedbackButton setSegmentedControlStyle:UISegmentedControlStyleBar];
        [feedbackButton setTintColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0]];
        [feedbackButton setMomentary:YES];
        [feedbackButton addTarget:self action:@selector(onClickFeedbackButton:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:feedbackButton];
        
        // create the logout button
        logoutButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Logout"]];
        [logoutButton setSegmentedControlStyle:UISegmentedControlStyleBar];
        [logoutButton setTintColor:[UIColor colorWithRed:0.8 green:0.3 blue:0.3 alpha:1.0]];
        [logoutButton setMomentary:YES];
        [logoutButton addTarget:self action:@selector(onClickLogoutButton:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:logoutButton];
        
        if (DeviceUtils.isIphone) {
            // create the cancel button
            cancelButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Cancel"]];
            [cancelButton setSegmentedControlStyle:UISegmentedControlStyleBar];
            [cancelButton setTintColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0]];
            [cancelButton setMomentary:YES];
            [cancelButton addTarget:self action:@selector(onClickCancelButton:) forControlEvents:UIControlEventValueChanged];
            [self addSubview:cancelButton];
        }
    }
    return self;
}

- (void) onClickProfileButton: (UIButton*)sender {
    [self setHidden:YES];
    if (showUserProfileCallback != nil) {
        [showUserProfileCallback execute:nil];
    }
}

- (void) onClickFeedbackButton: (UIButton*)sender {
    [self setHidden:YES];
    
    if (showFeedbackFormCallback != nil) {
        [showFeedbackFormCallback execute:nil];
    }
}

- (void) onClickLogoutButton: (UIButton*) sender {
    [self setHidden:YES];
    
    if (logoutCallback != nil) {
        [logoutCallback execute:nil];
    }
}

- (void) onClickCancelButton: (UIButton*) sender {
    [self setHidden:YES];
}

-(void) showUserSettings {
    if (DeviceUtils.isIphone) {
        userProfileButton.frame = CGRectMake(5, self.frame.size.height-135, self.frame.size.width - 10, 35);
        feedbackButton.frame = CGRectMake(5, self.frame.size.height-90, self.frame.size.width - 10, 35);
        logoutButton.frame = CGRectMake(5, self.frame.size.height-180, self.frame.size.width - 10, 35);
        cancelButton.frame = CGRectMake(5, self.frame.size.height-45, self.frame.size.width - 10, 35);
    } else {
        userProfileButton.frame = CGRectMake(self.frame.size.width - 205, self.frame.size.height-135, 200, 35);
        feedbackButton.frame = CGRectMake(self.frame.size.width - 205, self.frame.size.height-90, 200, 35);
        logoutButton.frame = CGRectMake(self.frame.size.width - 205, self.frame.size.height-45, 200, 35);
    }
    
    [self setHidden:NO];
}

-(void) dealloc {
    [userProfileButton release];
    [feedbackButton release];
    [logoutButton release];
    
    [showUserProfileCallback release];
    [showFeedbackFormCallback release];
    [logoutCallback release];
    
    [super dealloc];
}

@end
