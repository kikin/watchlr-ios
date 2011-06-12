//
//  PlayerViewController.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoObject.h"

@interface PlayerViewController : UIViewController<UIWebViewDelegate> {
	UINavigationBar* navigationBar;
	UIWebView* webView;
	UIBarButtonItem* backButton;
}

- (void) setVideo: (VideoObject*)videoObject;
- (void) onClickBackButton;

@end
