//
//  LoadingMainView.m
//  KikinVideo
//
//  Created by ludovic cabre on 5/6/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "RefreshStatusView.h"
#import <QuartzCore/QuartzCore.h>

@implementation RefreshStatusView

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		// configure the view
		self.backgroundColor = [UIColor colorWithRed:(12.0/255.0) green:(83.0/255.0) blue:(111.0/255.0) alpha:0.8];
		self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
		// self.layer.cornerRadius = 18.0f;
		self.layer.borderWidth = 1.0f;
		self.layer.opacity = 0.8f;
		
		// add the spinner
		refreshStatusIndicator = [[UIActivityIndicatorView alloc] init];
		refreshStatusIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
		// refreshStatusIndicator.frame = CGRectMake(50, 12, 30, 30);
		// [refreshStatusIndicator startAnimating];
        [refreshStatusIndicator setHidden:YES];
		[self addSubview:refreshStatusIndicator];
        
        // add the image
        refreshImageView = [[UIImageView alloc] init];
        [refreshImageView setHidden:YES];
		[self addSubview:refreshImageView];
        
		// add the loading text
		refreshStatusLabel = [[UILabel alloc] init];
		refreshStatusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		// refreshStatusLabel.frame = CGRectMake(40, frame.size.height - 40, frame.size.width-50, 30);
		refreshStatusLabel.textAlignment = UITextAlignmentCenter;
		refreshStatusLabel.backgroundColor = [UIColor clearColor];
		refreshStatusLabel.font = [UIFont boldSystemFontOfSize:20.0];
        refreshStatusLabel.textColor = [UIColor whiteColor];
		[self addSubview:refreshStatusLabel];			
    }
    return self;
}

- (void) setRefreshStatus:(int)refreshStatus {
    switch (refreshStatus) {
        case 0: {
            refreshStatusLabel.text = @"";
            [refreshImageView setHidden:YES];
            [refreshStatusIndicator stopAnimating];
            [refreshStatusIndicator setHidden:YES];
            break;
        }
            
        case 1: {
            refreshStatusLabel.text = @"Pull down to Refresh...";
            [refreshStatusIndicator setHidden:YES];
            [refreshStatusIndicator stopAnimating];
            [refreshImageView setHidden:NO];
            [refreshImageView setImage:[UIImage imageNamed:@"whiteArrow.png"]];
            break;
        }
            
        case 2: {
            refreshStatusLabel.text = @"Release to Refresh...";
            [refreshStatusIndicator setHidden:YES];
            [refreshStatusIndicator stopAnimating];
            [refreshImageView setHidden:NO];
            [refreshImageView setImage:[UIImage imageNamed:@"whiteArrowUp.png"]];
            break;
        }
            
        case 3: {
            refreshStatusLabel.text = @"Refreshing...";
            [refreshImageView setHidden:YES];
            [refreshStatusIndicator setHidden:NO];
            [refreshStatusIndicator startAnimating];
            [refreshImageView setImage:[UIImage imageNamed:@"whiteArrow.png"]];
            break;
        }
            
        case 4: {
            refreshStatusLabel.text = @"";
            [refreshImageView setHidden:YES];
            [refreshStatusIndicator stopAnimating];
            [refreshStatusIndicator setHidden:YES];
            refreshStatusLabel.text = @"Refreshed...";
            break;
        }
            
        default:
            break;
    }
}

- (void) layoutSubviews {
    [super layoutSubviews];
    refreshStatusLabel.frame = CGRectMake((self.frame.size.width - 300) / 2, self.frame.size.height - 45, 300, 30);
    refreshStatusIndicator.frame = CGRectMake(refreshStatusLabel.frame.origin.x - 60, self.frame.size.height - 45, 30, 30);
    
    if (!refreshImageView.hidden)
        refreshImageView.frame = CGRectMake(refreshStatusLabel.frame.origin.x - 60, self.frame.size.height - 45, 30, 30);
}

- (void)dealloc {
	[refreshStatusIndicator release];
	[refreshStatusLabel release];
    [super dealloc];
}

@end
