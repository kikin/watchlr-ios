//
//  ConnectMainView.m
//  KikinVideo
//
//  Created by ludovic cabre on 5/6/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "ConnectMainView.h"
#import <QuartzCore/QuartzCore.h>

@implementation ConnectMainView

@synthesize clickConnectCallback;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		// add the rounded rect view over the logo
		self.backgroundColor = [UIColor colorWithRed:215.0/255.0 green:235.0/255.0 blue:255.0/255.0 alpha:1.0];
		self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
		self.layer.cornerRadius = 18.0f;
		self.layer.borderWidth = 1.0f;
		self.layer.opacity = 0.8f;
		
		// create the title lable inside
		titleLabel = [[UILabel alloc] init];
		titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		//titleLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;	
		titleLabel.frame = CGRectMake(0, 10, frame.size.width, 35);
		titleLabel.text = @"kikin video";
		titleLabel.textAlignment = UITextAlignmentCenter;
		titleLabel.backgroundColor = [UIColor clearColor];
		titleLabel.font = [UIFont boldSystemFontOfSize:28.0];
		[self addSubview:titleLabel];
		
		// create the description
		descriptionLabel = [[UILabel alloc] init];
		descriptionLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;	
		descriptionLabel.frame = CGRectMake(30, 50, frame.size.width-60, 70);
		descriptionLabel.text = @"Access kikin video from your iPad by login on facebook. Go to http://video.kikin.com for more information.";
		descriptionLabel.textAlignment = UITextAlignmentCenter;
		descriptionLabel.backgroundColor = [UIColor clearColor];
		descriptionLabel.numberOfLines = 3;
		descriptionLabel.font = [UIFont systemFontOfSize:18.0];
		[self addSubview:descriptionLabel];
		
		// create the facebook login button inside
		loginButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
		loginButton.frame = CGRectMake((frame.size.width-200)/2, frame.size.height-50, 200, 35);
		loginButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
		[loginButton addTarget:self action:@selector(onClickConnectButton:) forControlEvents:UIControlEventTouchUpInside];
		[loginButton setTitle:@"Connect with Facebook" forState:UIControlStateNormal];
		[self addSubview:loginButton];
		
		if (DeviceUtils.isIphone) {
			descriptionLabel.numberOfLines = 4;
		}
    }
    return self;
}

- (void) onClickConnectButton: (UIButton*)sender {
	if (clickConnectCallback) {
		[clickConnectCallback execute:self];
	}
}

- (void)dealloc {
	[loginButton release];
    [super dealloc];
}

@end
