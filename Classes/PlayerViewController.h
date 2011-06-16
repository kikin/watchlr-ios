//
//  PlayerViewController.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoObject.h"
#import "SeekVideoRequest.h"

@interface PlayerViewController : UIViewController<UIWebViewDelegate, UIAlertViewDelegate> {
	UINavigationBar* navigationBar;
	UIWebView* webView;
	UIBarButtonItem* backButton;
    
    SeekVideoRequest* seekRequest;
    VideoObject* video;
    
    bool showAlert;
}

// @property(retain) VideoObject* video;

- (void) setVideo: (VideoObject*)videoObject;
- (void) onClickBackButton;

- (void) onSwipeGesture: (UIGestureRecognizer*)sender;

@end
