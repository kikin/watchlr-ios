//
//  PlayerViewController.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingMainView.h"
#import "WatchlrViewController.h"

@interface WebViewController : WatchlrViewController<UIWebViewDelegate> {
	UIWebView* webView;
	LoadingMainView* loadingView;
}

- (void) loadUrl:(NSString*)urlString;

@end
