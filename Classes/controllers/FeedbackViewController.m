    //
//  PlayerViewController.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "FeedbackViewController.h"

@implementation FeedbackViewController

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	// create the view
	UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 500, 500)];
	view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	self.view = view;
	[view release];
    
    // self.wantsFullScreenLayout = YES;
	
	// create the toolbar
	UINavigationBar* navigationBar = [[[UINavigationBar alloc] init] autorelease];
	navigationBar.frame = CGRectMake(0, 0, view.frame.size.width, 42);
	navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    navigationBar.tintColor = [UIColor colorWithRed:(12.0/255.0) green:(83.0/255.0) blue:(111.0/255.0) alpha:1.0];
	[view addSubview:navigationBar];
    
    // create the back button
	UIBarButtonItem* backButton = [[[UIBarButtonItem alloc] init] autorelease];
	backButton.title = @"Close";
	backButton.style = UIBarButtonItemStyleBordered;
	backButton.action = @selector(onClickBackButton);
	
	// add the button to the navigation bar
	UINavigationItem* item = [[[UINavigationItem alloc] initWithTitle:@"Feedback"] autorelease];
	item.rightBarButtonItem = backButton;
	[navigationBar pushNavigationItem:item animated:FALSE];
	
    
    // create the video table
	webView = [[UIWebView alloc] init];
	webView.frame = CGRectMake(0, 42, view.frame.size.width, view.frame.size.height-42);
	webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    webView.delegate = self;
	[view addSubview:webView];
    // [view bringSubviewToFront:webView];
    
    loadingView = [[LoadingMainView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-300)/2, (self.view.frame.size.height-55)/2, 300, 55)];
    [view addSubview:loadingView];
    [view bringSubviewToFront:loadingView];
    [loadingView setHidden:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}

- (void) releaseMemory {
    webView.delegate = nil;
    
	[webView removeFromSuperview];
	[loadingView removeFromSuperview];
    
    webView = nil;
    loadingView = nil;
}

- (void)didReceiveMemoryWarning {
    // release memory 
//    [self releaseMemory];
    
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [self releaseMemory];
    [super dealloc];
}

// --------------------------------------------------------------------------------
//                              Callbacks
// --------------------------------------------------------------------------------

- (void) onClickBackButton {
	[webView loadHTMLString:@"<html><body></body></html>" baseURL:nil];
	[self dismissModalViewControllerAnimated:TRUE];
}

// --------------------------------------------------------------------------------
//                          Public Functions
// --------------------------------------------------------------------------------
- (void) loadFeedbackForm {
    NSURL* url = [NSURL URLWithString:@"https://webux.wufoo.com/forms/m7x1p5/"];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObj];
}

// --------------------------------------------------------------------------------
//                          Web view delegates
// --------------------------------------------------------------------------------

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
}

- (void)webViewDidFinishLoad:(UIWebView *)uiWebView {
    [loadingView setHidden:YES];
}

@end
