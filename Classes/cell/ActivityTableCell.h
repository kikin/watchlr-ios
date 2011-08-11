//
//  VideoTableCell.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "VideoTableCell.h"
#import "ActivityObject.h"

/*@interface UIHtmlLabel:UIView {
    NSString* link;
    
    UILabel* label1;
    UILabel* label2;
    UILabel* label3;
}

- (void) drawHtmlString:(NSString*)string;

@end*/

@interface ActivityTableCell : VideoTableCell<UIWebViewDelegate> {
    UIImageView* addVideoImageView;
    UIImageView* userImageView;
    UIWebView* activityHeading;
    
    ActivityObject* activityObject;
    Callback* addVideoCallback;
}

@property(retain) Callback* addVideoCallback;

- (void) setActivityObject: (ActivityObject*)activity;
- (void) updateSaveButton: (ActivityObject*)activity;

@end
