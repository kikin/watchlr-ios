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
		self.layer.cornerRadius = 5.0f;
		
        if (DeviceUtils.isIphone) {
            UIScreen *screen = [UIScreen mainScreen];
            BOOL isHighRes;
            
            if ([screen respondsToSelector:@selector(scale)]) {
                isHighRes = ([screen scale] > 1);
            } else {
                isHighRes = NO;
            }
            
            if (isHighRes) {
                self.layer.borderWidth = 0.2f;
            } else {
                self.layer.borderWidth = 0.4f;
            }
        }
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
    CGPoint topCenter = CGPointMake(CGRectGetMidX(currentBounds), 0);
    CGPoint midCenter = CGPointMake(CGRectGetMidX(currentBounds), CGRectGetMaxY(currentBounds));
    CGContextDrawLinearGradient(currentContext, glossGradient, topCenter, midCenter, kCGGradientDrawsBeforeStartLocation);
    
    CGGradientRelease(glossGradient);
    CGColorSpaceRelease(rgbColorspace); 
}

- (void)dealloc {
    [super dealloc];
}

@end
