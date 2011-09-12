//
//  ConnectMainView.m
//  KikinVideo
//
//  Created by ludovic cabre on 5/6/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "UIBubbleView.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIBubbleView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
//    self.layer.borderWidth = 1.0f;
//    self.layer.borderColor = [UIColor colorWithRed:(225.0/255.0) green:(225.0/255.0) blue:(225.0/255.0) alpha:1.0].CGColor;
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat radius = self.layer.cornerRadius;
    
    if (radius > self.bounds.size.width/2.0) radius = self.bounds.size.width/2.0;
    if (radius > self.bounds.size.height/2.0) radius = self.bounds.size.height/2.0;
    
    CGFloat minx = CGRectGetMinX(self.bounds);
//    CGFloat midx = CGRectGetMidX(self.bounds);
    CGFloat maxx = CGRectGetMaxX(self.bounds);
    CGFloat miny = CGRectGetMinY(self.bounds) + 7;
//    CGFloat midy = CGRectGetMidY(self.bounds);
    CGFloat maxy = CGRectGetMaxY(self.bounds);
    
    /*
     CGContextMoveToPoint(context, minx, midy);
     CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
     CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
     CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
     CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
     */
    
    CGContextMoveToPoint(context, minx, miny);
    CGContextAddLineToPoint(context, minx + 5, miny);
    CGContextAddLineToPoint(context, minx + 10, miny - 7);
    CGContextAddLineToPoint(context, minx + 15, miny);
    CGContextAddLineToPoint(context, maxx, miny);
    CGContextAddLineToPoint(context, maxx, maxy);
    CGContextAddLineToPoint(context, minx, maxy);
    CGContextAddLineToPoint(context, minx, miny);
    
    CGContextClosePath(context);
    
    [[UIColor colorWithRed:(200.0/255.0) green:(200.0/255.0) blue:(200.0/255.0) alpha:1.0] setStroke];
//    [[UIColor clearColor] setFill];
    CGContextDrawPath(context, kCGPathStroke);
}


- (void)dealloc {
    [super dealloc];
}

@end
