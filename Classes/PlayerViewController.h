//
//  PlayerViewController.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoObject.h"

@interface PlayerViewController : UIViewController {
	IBOutlet UINavigationBar* navigationBar;
	IBOutlet UIWebView* webView;
	IBOutlet UIBarButtonItem *backButton;
}

- (void) setVideo: (VideoObject*)videoObject;
- (IBAction)goToPreviousView;

//@property(nonatomic,copy)UINavigationBar* navigationBar;
//@property(nonatomic,copy) UIWebView* webView;
//@property(nonatomic,copy)UIBarButtonItem *backButton;

@end
