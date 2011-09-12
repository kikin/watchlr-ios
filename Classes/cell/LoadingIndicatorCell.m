//
//  VideoTableCell.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "LoadingIndicatorCell.h"

@implementation LoadingIndicatorCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		// Auto resize the views
        self.contentView.autoresizesSubviews = YES;
        
        // create the loading indicator
		loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:loadingIndicator];
        
        // create the username
		loadingLabel = [[UILabel alloc] init];
		loadingLabel.backgroundColor = [UIColor clearColor];
		loadingLabel.autoresizingMask = UIViewAutoresizingNone;
		loadingLabel.text = @"Loading...";
        if (DeviceUtils.isIphone) {
            loadingLabel.font = [UIFont boldSystemFontOfSize:12];
        } else {
            loadingLabel.font = [UIFont boldSystemFontOfSize:18];
        }
        loadingLabel.numberOfLines = 1;
		[self addSubview:loadingLabel];
        
        loadingLabelTextWidth = [loadingLabel.text sizeWithFont:loadingLabel.font].width;
        loadingLabelTextHeight = [loadingLabel.text sizeWithFont:loadingLabel.font].height;
	}
    return self;
}

- (void) viewWillDisappear {
    if ([loadingIndicator isAnimating])
        [loadingIndicator stopAnimating];
}

- (void) fixSize {
    loadingLabel.frame = CGRectMake((((self.frame.size.width - (loadingLabelTextWidth + 30)) / 2) + 30), ((self.frame.size.height - loadingLabelTextHeight) / 2), loadingLabelTextWidth, loadingLabelTextHeight);
    
    loadingIndicator.frame = CGRectMake((loadingLabel.frame.origin.x - 30), ((self.frame.size.height - 20) / 2), 20, 20); 
}

- (void)showLoadingIndicator {
	[loadingIndicator startAnimating];
}

- (void) hideLoadingIndicator {
    if ([loadingIndicator isAnimating])
        [loadingIndicator stopAnimating];
}

- (void) layoutSubviews {
    [super layoutSubviews];
    [self performSelectorOnMainThread:@selector(fixSize) withObject:nil waitUntilDone:NO];
}

- (void)dealloc {
    if ([loadingIndicator isAnimating])
        [loadingIndicator stopAnimating];

    [loadingIndicator removeFromSuperview];
    [loadingLabel removeFromSuperview];
    
    loadingIndicator = nil;
    loadingLabel = nil;
    
    [super dealloc];
}

@end
