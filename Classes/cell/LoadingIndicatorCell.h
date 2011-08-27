//
//  VideoTableCell.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingIndicatorCell: UITableViewCell {
	UIActivityIndicatorView* loadingIndicator;
    UILabel* loadingLabel;
    
    int loadingLabelTextWidth;
    int loadingLabelTextHeight;
}

- (void) showLoadingIndicator;
- (void) hideLoadingIndicator;

@end
