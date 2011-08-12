//
//  VideoTableCell.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "VideoTableCell.h"
#import "ActivityObject.h"
#import "UIActivityHeadingLabel.h"

// ---------------------------------------------------------------------------
//                         Activity table cell
// ---------------------------------------------------------------------------
@interface ActivityTableCell : VideoTableCell {
    UIImageView* addVideoImageView;
    UIImageView* userImageView;
    UIActicityHeadingLabel* activityHeading;
    
    ActivityObject* activityObject;
    Callback* addVideoCallback;
}

@property(retain) Callback* addVideoCallback;

- (void) setActivityObject: (ActivityObject*)activity;
- (void) updateSaveButton: (ActivityObject*)activity;

@end
