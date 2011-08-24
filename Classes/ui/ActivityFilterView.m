//
//  ConnectMainView.m
//  KikinVideo
//
//  Created by ludovic cabre on 5/6/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "ActivityFilterView.h"
#import <QuartzCore/QuartzCore.h>

@implementation ActivityFilterView

@synthesize optionSelectedCallback;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		// add the rounded rect view over the logo
		self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
		self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
		self.layer.cornerRadius = 5.0f;
		self.layer.borderWidth = 1.0f;
		// self.layer.opacity = 0.95f;
        
        // create the all activities button
        allActivities = [[UILabel alloc] init];
        allActivities.text = @"All Sources";
        allActivities.textColor = [UIColor whiteColor];
        allActivities.backgroundColor = [UIColor colorWithRed:(12.0/255.0) green:(83.0/255.0) blue:(111.0/255.0) alpha:1.0];
        allActivities.textAlignment = UITextAlignmentCenter;
        allActivities.layer.borderWidth = 1.0f;
        allActivities.font = [UIFont boldSystemFontOfSize:15];
        [self addSubview:allActivities];
        
        // create the facebook only activities button
        facebookOnlyActivities = [[UILabel alloc] init];
        facebookOnlyActivities.text = @"Facebook Only";
        facebookOnlyActivities.textColor = [UIColor colorWithRed:(12.0/255.0) green:(83.0/255.0) blue:(111.0/255.0) alpha:1.0];
        facebookOnlyActivities.backgroundColor = [UIColor whiteColor];
        facebookOnlyActivities.textAlignment = UITextAlignmentCenter;
        facebookOnlyActivities.layer.borderWidth = 1.0f;
        facebookOnlyActivities.font = [UIFont boldSystemFontOfSize:15];
        [self addSubview:facebookOnlyActivities];
        
        // create the watchlr only activities button
        watchlrOnlyActivities = [[UILabel alloc] init];
        watchlrOnlyActivities.text = @"Watchlr Only";
        watchlrOnlyActivities.textColor = [UIColor colorWithRed:(12.0/255.0) green:(83.0/255.0) blue:(111.0/255.0) alpha:1.0];
        watchlrOnlyActivities.backgroundColor = [UIColor whiteColor];
        watchlrOnlyActivities.textAlignment = UITextAlignmentCenter;
        watchlrOnlyActivities.layer.borderWidth = 1.0f;
        watchlrOnlyActivities.font = [UIFont boldSystemFontOfSize:15];
        [self addSubview:watchlrOnlyActivities];
    }
    return self;
}

-(void) dealloc {
    [allActivities release];
    [facebookOnlyActivities release];
    [watchlrOnlyActivities release];
    
    [optionSelectedCallback release];
    [super dealloc];
}

// --------------------------------------------------------------------------------
//                             Touch event Functions
// --------------------------------------------------------------------------------

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *myTouch in touches)
    {
        CGPoint touchLocation = [myTouch locationInView:self];
        
        CGRect allActivitiesRect = [allActivities bounds];
        allActivitiesRect = [allActivities convertRect:allActivitiesRect toView:self];
        if (CGRectContainsPoint(allActivitiesRect, touchLocation)) {
            if (optionSelectedCallback != nil) {
                [optionSelectedCallback execute:[NSNumber numberWithInt:ALL]];
            }
        }
        
        CGRect facebookOnlyActivitiesRect = [facebookOnlyActivities bounds];
        facebookOnlyActivitiesRect = [facebookOnlyActivities convertRect:facebookOnlyActivitiesRect toView:self];
        if (CGRectContainsPoint(facebookOnlyActivitiesRect, touchLocation)) {
            if (optionSelectedCallback != nil) {
                [optionSelectedCallback execute:[NSNumber numberWithInt:FACEBOOK_ONLY]];
            }
        }
        
        CGRect watchlrOnlyActivitiesRect = [watchlrOnlyActivities bounds];
        watchlrOnlyActivitiesRect = [watchlrOnlyActivities convertRect:watchlrOnlyActivitiesRect toView:self];
        if (CGRectContainsPoint(watchlrOnlyActivitiesRect, touchLocation)) {
            if (optionSelectedCallback != nil) {
                [optionSelectedCallback execute:[NSNumber numberWithInt:WATCHLR_ONLY]];
            }
        }
    }
}

// --------------------------------------------------------------------------------
//                             Public Functions
// --------------------------------------------------------------------------------

- (void) showActivityFilterOptions:(ActivityType) activityType {
    allActivities.frame = CGRectMake(0, 0, self.frame.size.width, 35);
    facebookOnlyActivities.frame = CGRectMake(0, 35, self.frame.size.width, 35);
    watchlrOnlyActivities.frame = CGRectMake(0, 70, self.frame.size.width, 35);
    
    switch (activityType) {
        case ALL: {
            allActivities.textColor = [UIColor whiteColor];
            allActivities.backgroundColor = [UIColor colorWithRed:(12.0/255.0) green:(83.0/255.0) blue:(111.0/255.0) alpha:1.0];
            
            facebookOnlyActivities.textColor = [UIColor colorWithRed:(12.0/255.0) green:(83.0/255.0) blue:(111.0/255.0) alpha:1.0];
            facebookOnlyActivities.backgroundColor = [UIColor whiteColor];
            
            watchlrOnlyActivities.textColor = [UIColor colorWithRed:(12.0/255.0) green:(83.0/255.0) blue:(111.0/255.0) alpha:1.0];
            watchlrOnlyActivities.backgroundColor = [UIColor whiteColor];
            
            break;
        }
            
        case FACEBOOK_ONLY: {
            allActivities.textColor = [UIColor colorWithRed:(12.0/255.0) green:(83.0/255.0) blue:(111.0/255.0) alpha:1.0];
            allActivities.backgroundColor = [UIColor whiteColor];
            
            facebookOnlyActivities.textColor = [UIColor whiteColor];
            facebookOnlyActivities.backgroundColor = [UIColor colorWithRed:(12.0/255.0) green:(83.0/255.0) blue:(111.0/255.0) alpha:1.0];
            
            watchlrOnlyActivities.textColor = [UIColor colorWithRed:(12.0/255.0) green:(83.0/255.0) blue:(111.0/255.0) alpha:1.0];
            watchlrOnlyActivities.backgroundColor = [UIColor whiteColor];
            
            break;
        }
            
        case WATCHLR_ONLY: {
            allActivities.textColor = [UIColor colorWithRed:(12.0/255.0) green:(83.0/255.0) blue:(111.0/255.0) alpha:1.0];
            allActivities.backgroundColor = [UIColor whiteColor];
            
            facebookOnlyActivities.textColor = [UIColor colorWithRed:(12.0/255.0) green:(83.0/255.0) blue:(111.0/255.0) alpha:1.0];
            facebookOnlyActivities.backgroundColor = [UIColor whiteColor];
            
            watchlrOnlyActivities.textColor = [UIColor whiteColor];
            watchlrOnlyActivities.backgroundColor = [UIColor colorWithRed:(12.0/255.0) green:(83.0/255.0) blue:(111.0/255.0) alpha:1.0];
            
            break;
        }
            
        default:
            break;
    }
    
    
    [self setHidden:NO];
}


@end
