//
//  LoadingMainView.m
//  KikinVideo
//
//  Created by ludovic cabre on 5/6/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "LoadingMainView.h"
#import <QuartzCore/QuartzCore.h>

@implementation LoadingMainView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		// configure the view
		self.backgroundColor = [UIColor colorWithRed:215.0/255.0 green:235.0/255.0 blue:255.0/255.0 alpha:1.0];
		self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
		self.layer.cornerRadius = 18.0f;
		self.layer.borderWidth = 1.0f;
		self.layer.opacity = 0.8f;
		
		// add the spinner
		loadingSpinner = [[UIActivityIndicatorView alloc] init];
		loadingSpinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
		loadingSpinner.frame = CGRectMake(50, 12, 30, 30);
		[loadingSpinner startAnimating];
		[self addSubview:loadingSpinner];
		
		// add the loading text
		loadingLabel = [[UILabel alloc] init];
		loadingLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		loadingLabel.frame = CGRectMake(40, 10, frame.size.width-50, 35);
		loadingLabel.text = @"Loading..";
		loadingLabel.textAlignment = UITextAlignmentCenter;
		loadingLabel.backgroundColor = [UIColor clearColor];
		loadingLabel.font = [UIFont boldSystemFontOfSize:28.0];
		[self addSubview:loadingLabel];			
    }
    return self;
}

- (void)dealloc {
	[loadingSpinner release];
	[loadingLabel release];
    [super dealloc];
}

@end
