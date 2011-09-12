//
//  ConnectMainView.m
//  KikinVideo
//
//  Created by ludovic cabre on 5/6/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "UICustomButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation UICustomButton

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		// add the rounded rect view over the logo
//		self.backgroundColor = [UIColor colorWithRed:215.0/255.0 green:235.0/255.0 blue:255.0/255.0 alpha:1.0];
		self.layer.cornerRadius = 5.0f;
		self.layer.borderWidth = 0.2f;

//        CAGradientLayer *gradient = [CAGradientLayer layer];
//        gradient.frame = self.bounds;
//        gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[UIColor blackColor] CGColor], nil];
//        [self.layer insertSublayer:gradient atIndex:0];
//        self.layer.shadowRadius = 5.0f;
//		self.layer.opacity = 0.8f;
        

		
    }
    return self;
}


- (void)drawRect:(CGRect)rect 
{
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGGradientRef glossGradient;
    CGColorSpaceRef rgbColorspace;
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = { (235.0/255.0), (235.0/255.0), (235.0/255.0), 0.00,  // Start color
        (235.0/255.0), (235.0/255.0), (235.0/255.0), 1.0 }; // End color
    
    rgbColorspace = CGColorSpaceCreateDeviceRGB();
    glossGradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);
    
    CGRect currentBounds = self.bounds;
    CGPoint topCenter = CGPointMake(CGRectGetMidX(currentBounds), 0.0f);
    CGPoint midCenter = CGPointMake(CGRectGetMidX(currentBounds), CGRectGetMaxY(currentBounds));
    CGContextDrawLinearGradient(currentContext, glossGradient, topCenter, midCenter, 0);
    
    CGGradientRelease(glossGradient);
    CGColorSpaceRelease(rgbColorspace); 
}

- (void)dealloc {
    [super dealloc];
}

@end
