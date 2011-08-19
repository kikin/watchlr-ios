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
	navigationBar = [[UINavigationBar alloc] init];
	navigationBar.frame = CGRectMake(0, 0, view.frame.size.width, 42);
	navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    navigationBar.tintColor = [UIColor colorWithRed:(12.0/255.0) green:(83.0/255.0) blue:(111.0/255.0) alpha:1.0];
	[view addSubview:navigationBar];
    
    // create the back button
	backButton = [[UIBarButtonItem alloc] init];
	backButton.title = @"Close";
	backButton.style = UIBarButtonItemStyleBordered;
	backButton.action = @selector(onClickBackButton);
	
	// add the button to the navigation bar
	UINavigationItem* item = [[UINavigationItem alloc] initWithTitle:@"Feedback"];
	item.rightBarButtonItem = backButton;
	[navigationBar pushNavigationItem:item animated:FALSE];
	[item release];
    
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

- (void) onClickBackButton {
	[webView loadHTMLString:@"<html><body></body></html>" baseURL:nil];
	[self dismissModalViewControllerAnimated:TRUE];
}

- (void)viewDidLoad {
	[super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void) loadFeedbackForm {
    NSURL* url = [NSURL URLWithString:@"https://webux.wufoo.com/forms/m7x1p5/"];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObj];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
}

- (void)webViewDidFinishLoad:(UIWebView *)uiWebView {
    [loadingView setHidden:YES];
}

- (void)dealloc {
    webView.delegate = nil;
	[navigationBar release];
	[webView release];
	[backButton release];
    [loadingView release];
    [super dealloc];
}

@end
