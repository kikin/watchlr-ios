//
//  ConnectMainView.h
//  KikinVideo
//
//  Created by ludovic cabre on 5/6/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CommonIos/Callback.h>

@interface ConnectMainView : UIView {
	UIImageView* watchlrIcon;
	UILabel* descriptionLabel;
    UILabel* footerLabel;
    UIButton* footerLabelLink;
	UIButton* loginButton;
}

@property(retain) Callback* clickConnectCallback;

@end
