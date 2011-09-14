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
		self.backgroundColor = [UIColor whiteColor];
		self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
		self.layer.cornerRadius = 18.0f;
		self.layer.borderWidth = 1.0f;
		self.layer.opacity = 0.8f;
		
		// create the title lable inside
//		titleLabel = [[UILabel alloc] init];
//		titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//		//titleLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;	
//		titleLabel.frame = CGRectMake(0, 10, frame.size.width, 35);
//		titleLabel.text = @"watchlr";
//		titleLabel.textAlignment = UITextAlignmentCenter;
//		titleLabel.backgroundColor = [UIColor clearColor];
//		titleLabel.font = [UIFont boldSystemFontOfSize:28.0];
//		[self addSubview:titleLabel];
        
        watchlrIcon = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - 115) / 2, 10, 115, 27)];
        watchlrIcon.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        watchlrIcon.image = [UIImage imageNamed:@"watchlr_logo_blue.png"];
        [self addSubview:watchlrIcon];
		
		// create the description
		descriptionLabel = [[UILabel alloc] init];
		descriptionLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;	
		descriptionLabel.frame = CGRectMake(30, 50, frame.size.width-60, 70);
		descriptionLabel.text = @"Please login with your Facebook account to access your Video Feed.";
		descriptionLabel.textAlignment = UITextAlignmentCenter;
		descriptionLabel.backgroundColor = [UIColor clearColor];
		descriptionLabel.numberOfLines = 3;
		descriptionLabel.font = [UIFont systemFontOfSize:18.0];
		[self addSubview:descriptionLabel];
		
		// create the description
        footerLabel = [[UILabel alloc] init];
		footerLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth;	
		footerLabel.text = @"For more information, go to http://www.watchlr.com";
		footerLabel.textAlignment = UITextAlignmentCenter;
		footerLabel.backgroundColor = [UIColor clearColor];
		footerLabel.numberOfLines = 1;
		footerLabel.font = [UIFont systemFontOfSize:12.0];
        CGSize footerLabelSize = [footerLabel.text sizeWithFont:footerLabel.font];
        footerLabel.frame = CGRectMake(10, self.frame.size.height - (footerLabelSize.height + 10), frame.size.width - 20, footerLabelSize.height);
		[self addSubview:footerLabel];
        
        // create the facebook login button inside
		loginButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		loginButton.frame = CGRectMake((frame.size.width-150)/2, footerLabel.frame.origin.y-40, 150, 27);
		loginButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
		[loginButton addTarget:self action:@selector(onClickConnectButton:) forControlEvents:UIControlEventTouchUpInside];
		[loginButton setImage:[UIImage imageNamed:@"facebook_signin_img.png"] forState:UIControlStateNormal];
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
    [watchlrIcon removeFromSuperview];
    [descriptionLabel removeFromSuperview];
	[loginButton removeFromSuperview];
    
    watchlrIcon = nil;
    descriptionLabel = nil;
    loginButton = nil;
    
    [super dealloc];
}

@end
