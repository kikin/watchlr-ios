//
//  ErrorMainView.m
//  KikinVideo
//
//  Created by ludovic cabre on 5/6/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "ErrorMainView.h"
#import <QuartzCore/QuartzCore.h>

@implementation ErrorMainView

@synthesize clickOkCallback;

- (id) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		// configure the view
		self.backgroundColor = [UIColor colorWithRed:215.0/255.0 green:235.0/255.0 blue:255.0/255.0 alpha:1.0];
		self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
		self.layer.cornerRadius = 18.0f;
		self.layer.borderWidth = 1.0f;
		self.layer.opacity = 0.8f;
		
		// add the loading text
		titleLabel = [[UILabel alloc] init];
		titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		titleLabel.frame = CGRectMake(10, 10, frame.size.width-20, 35);
		titleLabel.text = @"An error occured";
		titleLabel.textAlignment = UITextAlignmentCenter;
		titleLabel.backgroundColor = [UIColor clearColor];
		titleLabel.font = [UIFont boldSystemFontOfSize:28.0];
		[self addSubview:titleLabel];
		
		// add the error text
		errorLabel = [[UILabel alloc] init];
		errorLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		errorLabel.frame = CGRectMake(10, 50, frame.size.width-20, 70);
		errorLabel.text = @"this this the error message";
		errorLabel.textColor = [UIColor redColor];
		errorLabel.textAlignment = UITextAlignmentCenter;
		errorLabel.backgroundColor = [UIColor clearColor];
		errorLabel.numberOfLines = 3;
		errorLabel.font = [UIFont boldSystemFontOfSize:18.0];
		[self addSubview:errorLabel];
		
		okButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
		okButton.frame = CGRectMake((frame.size.width-200)/2, frame.size.height-50, 200, 35);
		okButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
		[okButton addTarget:self action:@selector(onClickOkButton:) forControlEvents:UIControlEventTouchUpInside];
		[okButton setTitle:@"Ok" forState:UIControlStateNormal];
		[self addSubview:okButton];		
    }
    return self;
}

- (void) setErrorMessage: (NSString*)message {
	errorLabel.text = message;
}

- (void) onClickOkButton: (id)sender {
	if (clickOkCallback) {
		[clickOkCallback execute:self];
	}
}

- (void) dealloc {
	[okButton release];
	[errorLabel release];
	[titleLabel release];
    [super dealloc];
}

@end
