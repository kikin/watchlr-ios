//
//  LoadingMainView.h
//  KikinVideo
//
//  Created by ludovic cabre on 5/6/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RefreshStatusView : UIView {
	UILabel* refreshStatusLabel;
	UIActivityIndicatorView* refreshStatusIndicator;
    UIImageView* refreshImageView;
}

- (void) setRefreshStatus:(int)refreshStatus;

@end
