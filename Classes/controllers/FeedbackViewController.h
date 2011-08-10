//
//  PlayerViewController.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingMainView.h"

@interface FeedbackViewController : UIViewController<UIWebViewDelegate> {
	UINavigationBar* navigationBar;
	UIWebView* webView;
	UIBarButtonItem* backButton;
    
    LoadingMainView* loadingView;
}

- (void) onClickBackButton;
- (void) loadFeedbackForm;

@end
