//
//  LoadingMainView.h
//  KikinVideo
//
//  Created by ludovic cabre on 5/6/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonIos/Callback.h"


@interface UIActicityHeadingLabel : UIView {
    UILabel* label1;
    UILabel* label2;
    UILabel* label3;
    UILabel* label4;
    UILabel* label5;
    
    NSArray* links;
    Callback* onUsernameClicked;
}

@property(retain) Callback* onUsernameClicked;

- (void) renderActivityHeading:(NSArray*)activityHeading;

@end