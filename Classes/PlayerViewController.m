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
    
    // self.wantsFullScreenLayout = YES;
	
	// create the toolbar
	navigationBar = [[UINavigationBar alloc] init];
	navigationBar.frame = CGRectMake(0, 0, view.frame.size.width, 42);
	navigationBar.topItem.title = @"Loading video..";
	navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    navigationBar.tintColor = [UIColor colorWithRed:(12.0/255.0) green:(83.0/255.0) blue:(111.0/255.0) alpha:1.0];
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
    webView.delegate = self;
	[view addSubview:webView];
    [view bringSubviewToFront:webView];
}

- (void) setVideo: (VideoObject*)videoObject {
	// change title
	navigationBar.topItem.title = videoObject.title;
	
	// load video in browser
	// NSURL* url = [NSURL URLWithString:videoObject.embedUrl];
    // NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
	// [webView loadRequest:requestObj];	
    // Load HTML5 video
    NSString* javasciptString = [NSString stringWithString:@"function onPageLoad() { try { var vid = document.getElementsByTagName('video'); if (vid && vid.length == 1) { vid = vid[0]; vid.kkMetaDataLoaded = false; function onDurationChange(e) { try { if (e.target.duration > 30 && e.target.kkMetaDataLoaded) { /*e.target.currentTime=30*//*"];
    javasciptString = [javasciptString stringByAppendingFormat:@"%f", videoObject.seek];
    javasciptString = [javasciptString stringByAppendingString:@"*/; e.target.play(); } } catch (e) { alert('Duration Change:' + e); } }; function onMetadataLoaded(e) { try { e.target.kkMetaDataLoaded = true; var dur = e.target.duration; if (dur > 60) { alert(dur); e.target.focus(); if(e.target.controller) { var controller = e.target.controller; controller.currentTime=30; } else { e.target.currentTime=30; } e.target.kkMetaDataLoaded = false; e.target.play(); } } catch (er) { alert('Meta data loded:' + er); } }; vid.addEventListener('durationchange', onDurationChange, false); vid.addEventListener('canplay', onMetadataLoaded, false); vid.load(); } } catch (err) { alert('Page load:' + err); } }; window.onload = onPageLoad;"];
    LOG_DEBUG(@"javascript = %@", javasciptString);
    
    NSRegularExpression* regex = [[NSRegularExpression alloc] initWithPattern:@"youtube" options:NSRegularExpressionCaseInsensitive error:nil];
	NSArray* matches = [regex matchesInString:videoObject.htmlCode options:0 range:NSMakeRange(0, [videoObject.htmlCode length])];
	[regex release];
    NSString* htmlCode = [NSString stringWithString:videoObject.htmlCode];
    if (matches != nil && [matches count] > 0) {
        htmlCode = /*[*/[htmlCode stringByReplacingOccurrencesOfString:@"autoplay=1" withString:@"autoplay=1&start=30"]/* stringByAppendingFormat:@"%f", videoObject.seek]*/;
    } else {
        htmlCode = /*[*/[htmlCode stringByReplacingOccurrencesOfString:@"controls" withString:@"controls"]/* stringByAppendingFormat:@"%f", videoObject.seek]*/;
    }
    
    NSString* htmlString = [[[[[NSString stringWithString:@"<html><head><meta name='viewport' content='width=device-width' /></head><body>"] stringByAppendingString:htmlCode] stringByAppendingString:@"<script type='text/javascript'>"] stringByAppendingString:javasciptString ] stringByAppendingString:@"</script></body></html>"];
    LOG_DEBUG(@"htmlcode = %@", htmlString);
    [webView setMediaPlaybackRequiresUserAction:NO];
    [webView setAllowsInlineMediaPlayback:YES];
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    [webView loadHTMLString:htmlString baseURL:baseURL];
    [webView becomeFirstResponder];
    // [baseURL release];
    
    // Excecute javascript to play the video.
    // if (videoObject.htmlCode 
    // javasciptString = [webView stringByEvaluatingJavaScriptFromString:javasciptString];
    // javasciptString = [webView stringByEvaluatingJavaScriptFromString:@"document.childNodes.length"];
    LOG_DEBUG(@"javascript result = %@", javasciptString);
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

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    LOG_DEBUG(@"failed to load page. Reason:%@", [error localizedDescription]);
}

- (void)webViewDidFinishLoad:(UIWebView *)uiWebView {
    for (UIView *view in [uiWebView subviews]) {
        // Verify the subview is a UIScrollView
        if([view isKindOfClass:[UIScrollView class]]) {
            // Cast in UIScroolView and Zoom
            LOG_DEBUG(@"SubView is a scroll view : true");
        } else {
            LOG_DEBUG(@"SubView is a scroll view : false");
        }
        // LOG_DEBUG(@"View: %@", [view ])
    }
    
    LOG_DEBUG(@"Number of subviews %d", [[uiWebView subviews] count]);
}

- (void)dealloc {
    webView.delegate = nil;
	[navigationBar release];
	[webView release];
	[backButton release];
    [super dealloc];
}



@end
