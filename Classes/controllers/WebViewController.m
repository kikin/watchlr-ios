    //
//  PlayerViewController.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "WebViewController.h"

@implementation WebViewController

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[super loadView];
    
    // create the video table
	webView = [[UIWebView alloc] init];
	webView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
	webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    webView.delegate = self;
	[self.view addSubview:webView];
    [self.view sendSubviewToBack:webView];
    
    loadingView = [[LoadingMainView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-300)/2, (self.view.frame.size.height-55)/2, 300, 55)];
    [self.view addSubview:loadingView];
    [self.view bringSubviewToFront:loadingView];
    [loadingView setHidden:NO];
}

- (void) loadUrl:(NSString*)urlString {
    LOG_DEBUG(@"OPening url:'%@'", urlString);
    NSURL* url = [NSURL URLWithString:urlString];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObj];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    LOG_DEBUG(@"Failed because:%@", [error description]);
}

- (void)webViewDidFinishLoad:(UIWebView *)uiWebView {
    [loadingView setHidden:YES];
}

- (void) didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    webView.delegate = nil;
    
	[webView removeFromSuperview];
    [loadingView removeFromSuperview];
    
    webView = nil;
    loadingView = nil;
    
    [super dealloc];
}

- (BOOL) shouldRotate {
    return NO;
}

@end
