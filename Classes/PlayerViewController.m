    //
//  PlayerViewController.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "PlayerViewController.h"

@implementation PlayerViewController

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	// create the view
	UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 500, 500)];
	view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	self.view = view;
	[view release];
	
	// create the toolbar
	navigationBar = [[UINavigationBar alloc] init];
	navigationBar.frame = CGRectMake(0, 0, view.frame.size.width, 42);
	navigationBar.topItem.title = @"Loading video..";
	navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[view addSubview:navigationBar];
	
	// create the back button
	backButton = [[UIBarButtonItem alloc] init];
	backButton.title = @"Back";
	backButton.style = UIBarButtonItemStyleBordered;
	backButton.action = @selector(onClickBackButton);
	
	// add the button to the navigation bar
	UINavigationItem* item = [[UINavigationItem alloc] initWithTitle:@"Title"];
	item.leftBarButtonItem = backButton;
	[navigationBar pushNavigationItem:item animated:FALSE];
	[item release];
	
	// create the video table
	webView = [[UIWebView alloc] init];
	webView.frame = CGRectMake(0, 42, view.frame.size.width, view.frame.size.height-42);
	webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	[view addSubview:webView];
}

- (void) setVideo: (VideoObject*)videoObject {
	// change title
	navigationBar.topItem.title = [@"Playing: " stringByAppendingString:videoObject.title];
	
	// load video in browser
	// NSURL* url = [NSURL URLWithString:videoObject.embedUrl];
    // NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
	// [webView loadRequest:requestObj];	
    // Load HTML5 video
    NSString* javasciptString = [NSString stringWithString:@"function onPageLoad() { try { var vid = document.getElementsByTagName('video'); if (vid && vid.length == 1) { vid = vid[0]; function onVideoLoaded(e) { alert(e.target); e.target.currentTime=30/*"];
    javasciptString = [javasciptString stringByAppendingFormat:@"%f", videoObject.seek];
    javasciptString = [javasciptString stringByAppendingString:@"*/; vid.play(); }; vid.addEventListener('loadedmetadata', onVideoLoaded, false); } else { var iframe = document.getElementsByTagName('iframe'); if(iframe && iframe.length == 1) {var vidElem = iframe[0]; vidElem = vidElem.contentWindow.document.getElementsByTagName('video'); var vidElem = vidElem.item(); /*alert(vidElem.currentTime); var str = ''; for (var i in vidElem) { str += i + ': ' + vidElem[i] + '\\r\\n'; }; alert(str);*/ } } } catch (err) { alert(err); } }; window.onload = onPageLoad;"];
    LOG_DEBUG(@"javascript = %@", javasciptString);
    
    NSString* htmlString = [[[[[NSString stringWithString:@"<html><body>"] stringByAppendingString:videoObject.htmlCode] stringByAppendingString:@"<script type='text/javascript'>"] stringByAppendingString:javasciptString ] stringByAppendingString:@"</script></body></html>"];
    LOG_DEBUG(@"htmlcode = %@", htmlString);
    [webView setMediaPlaybackRequiresUserAction:NO];
    [webView setAllowsInlineMediaPlayback:YES];
    [webView loadHTMLString:htmlString baseURL:nil];
    
    
    // Excecute javascript to play the video.
    // if (videoObject.htmlCode 
    // javasciptString = [webView stringByEvaluatingJavaScriptFromString:javasciptString];
    // javasciptString = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
    // LOG_DEBUG(@"javascript result = %@", javasciptString);
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

- (void)dealloc {
	[navigationBar release];
	[webView release];
	[backButton release];
    [super dealloc];
}

@end
