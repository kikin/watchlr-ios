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
    showAlert = true;
    
    /*UISwipeGestureRecognizer* swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeGesture:)];
    [webView setGestureRecognizers:[NSArray arrayWithObject:swipeGestureRecognizer]];*/
}

- (void) setVideo: (VideoObject*)videoObject {
	// change title
    video = [videoObject retain];
	navigationBar.topItem.title = video.title;
    
	// [webView loadRequest:requestObj];	
    // Load HTML5 video
    NSString* javasciptString = [NSString stringWithFormat:
       @"function onPageLoad() {"
        "   try { "
        "       var seek = %f;"
        "       if (seek > 0) {"
        //"           alert('seek:' + seek); "
        "           var vid = document.getElementsByTagName('video'); "
        "           if (vid && vid.length == 1) { "
        "               vid = vid[0]; "
        "               vid.kkMetaDataLoaded = false; "
        "               function onDurationChange(e) { "
        "                   try { "
        "                       if ((e.target.duration > seek) && (e.target.kkMetaDataLoaded)) { "
        "                           e.target.currentTime = seek; "
        "                           e.target.play(); "
        "                       } "
        "                   } catch (e) { } "
        "               } "
        "               function onCanPlay(e) { "
        "                   try { "
        //"                       alert('Video can play');"
        "                       e.target.kkMetaDataLoaded = true; "
        "                       var dur = e.target.duration; "
        "                       if (dur > seek) { "
        "                           alert('Resuming video'); "
        "                           window.focus(); "
        "                           e.target.focus(); "
        "                           if(e.target.controller) { "
        "                               var controller = e.target.controller; "
        "                               controller.currentTime = seek; "
        "                           } else { "
        "                               e.target.currentTime = seek; "
        "                           } "
        "                       } "
        "                   } catch (er) { } "
        "                   e.target.kkMetaDataLoaded = false; "
        "                   e.target.play(); "
        "               } "
        "               function onPause(e) { "
        "                   try { "
        "                       alert(e.target.seek);"
        "                   } catch (e) { } "
        "               } "
        "               vid.addEventListener('durationchange', onDurationChange, false); "
        "               vid.addEventListener('canplay', onCanPlay, false); "
        "               vid.load(); "
        "           } "
        "       } "
        "   } catch (err) { } "
        "} "
        "window.onload = onPageLoad;", video.seek];
    LOG_DEBUG(@"javascript = %@", javasciptString);
    
    NSString* htmlCode = video.htmlCode;
    if (htmlCode != nil && ([htmlCode length] > 0)) {
        
        NSString* htmlString = [NSString stringWithFormat:
                                @"<html>"
                                "   <head><meta name='viewport' content='width=device-width' />"
                                "   </head>"
                                "   <body>"
                                "       %@"
                                "       <script type='text/javascript'>"
                                "           %@"
                                "       </script>"
                                "   </body>"
                                "</html>", 
                                htmlCode, javasciptString];
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
        // LOG_DEBUG(@"javascript result = %@", javasciptString);
    } else {
        // show error message
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Unable to load video." message:@"" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        alertView.delegate = self;
        [alertView show];
        [alertView release];
    }
    
    
}

- (void) onClickBackButton {
    NSString* javascriptString = [NSString stringWithString:
      @"function getVideoPauseTime() {                              "
       "    try {                                                   "
       "        var vid = document.getElementsByTagName('video');   "
       "        if (vid && vid.length == 1) {                       "
       "            vid = vid[0];                                   "
       "            if (vid && !vid.ended) {                        "
       "                return vid.currentTime;                     "
       "            }                                               "
       "        }                                                   "
       "    } catch (getVideoTimePauseError) {                      "
       "        alert(getVideoTimePauseError);                      "
       "    }                                                       "
       "    return 0;                                               "
       "}                                                           "
       "window.videoPauseTime =  getVideoPauseTime();               "
    ];
    
    [webView stringByEvaluatingJavaScriptFromString:javascriptString];
    NSString* videoPauseTime = [webView stringByEvaluatingJavaScriptFromString:@"window.videoPauseTime"];
    if ([videoPauseTime floatValue] > 0) {
        videoPauseTime = [NSString stringWithFormat:@"%.2f", [videoPauseTime floatValue]];
        if (seekRequest == nil) {
            seekRequest = [[SeekVideoRequest alloc] init];
        }
        
        if ([seekRequest isRequesting]) {
            [seekRequest cancelRequest];
        }
        
        [seekRequest doSeekVideoRequest:video andTime:videoPauseTime];
        video.seek = [videoPauseTime doubleValue];
    } else {
        LOG_DEBUG(@"Either video ended or we were not able to find the current time of the video.");
    }
    
    showAlert = false;
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

- (UIControl *)findButtonInView:(UIView *)view {
    UIControl *button = nil;
    
    if ([view isMemberOfClass:[UIControl class]]) {
        return (UIControl *)view;
    }
    
    if (view.subviews && [view.subviews count] > 0) {
        for (UIView *subview in view.subviews) {
            button = [self findButtonInView:subview];
            if (button) return button;
        }
    }
    return button;
}


- (void)webViewDidFinishLoad:(UIWebView *)uiWebView {
    LOG_DEBUG(@"Page loaded");
    /*NSString* javasciptString = [NSString stringWithFormat:
        @"function onPageLoad() {                                                                  \n"
        "   try {                                                                                  \n"
        "       var vid = document.getElementsByTagName('video');                                  \n"
        "       if (vid && vid.length == 1) {                                                      \n"
        "           vid = vid[0];                                                                  \n"
        "           var seek = %f;                                                                 \n"
        "           if (seek > 0) {                                                                \n"
        "               vid.kkCanPlay = false;                                                     \n"
        "               function onDurationChange(e) {                                             \n"
        "                   alert('Duration changed'); try {                                                                  \n"
        "                       if ((e.target.duration > seek) && (e.target.kkCanPlay)) {          \n"
        "                           e.target.kkCanPlay = false;                                    \n"
        "                           e.target.currentTime = seek;                                   \n"
        "                           e.target.play();                                               \n"
        "                       } else {alert('Cannot play on duration change.');}                                                                 \n"
        "                   } catch (e) { alert(e); }                                                        \n"
        "               }                                                                          \n"
        "               function onCanPlay(e) {                                                    \n"
        "                   alert('can play video');try {                                                                  \n"
        "                       e.target.kkCanPlay = true;                                         \n"
        "                       var dur = e.target.duration;                                       \n"
        "                       if (dur > seek) {                                                  \n"
        "                           alert('Resuming');                                             \n"
        "                           window.focus();                                                \n"
        "                           e.target.focus();                                              \n"
        "                           if (e.target.controller) {                                     \n"
        "                               var controller = e.target.controller;                      \n"
        "                               controller.currentTime = seek;                             \n"
        "                           } else {                                                       \n"
        "                               e.target.currentTime = 30.2;                               \n"
        "                           }                                                              \n"
        "                           e.target.kkCanPlay = false;                                    \n"
        "                           e.target.play();                                               \n"
        "                       }                                                                  \n"
        "                   } catch (er) {                                                         \n"
        "                       alert(er);e.target.kkCanPlay = false;                                        \n"
        "                       e.target.play();                                                   \n"
        "                   }                                                                      \n"
        "               }                                                                          \n"
        "               alert(vid.readyState); if (vid.readyState < 4) {                                                  \n"
        "                   vid.addEventListener('durationchange', onDurationChange, false);       \n"
        "                   vid.addEventListener('canplaythrough', onCanPlay, false);                     \n"
        "                   vid.play();                                                            \n"
        "               } else {                                                                   \n"
        "                   if (vid.duration < seek) {                                             \n"
        "                       vid.kkCanPlay = true;                                              \n"
        "                       vid.addEventListener('durationchange', onDurationChange, false);   \n"
        "                   } else {                                                               \n"
        "                       try {                                                              \n"
        "                           vid.currentTime = seek;                                        \n"
        "                       } catch (seekError) {alert(seekError); }                                            \n"
        "                       vid.kkCanPlay = false;                                             \n"
        "                       vid.playVideo();                                                        \n"
        "                   }                                                                      \n"
        "               }                                                                          \n"
        "           } else {                                                                       \n"
        "               alert('seek is 0.'); vid.kkCanPlay = false;                                                     \n"
        "               vid.play();                                                                \n"
        "           }                                                                              \n"
        "       } else { alert('Video elemnt not found'); }                                                                                  \n"
        "   } catch (err) { alert(err); }                                                          \n"
        "}                                                                                         \n"
        "onPageLoad(); alert('On page load');", 30.0f];
    
    LOG_DEBUG(@"Javascript String:\n%@", javasciptString);
    [self.view bringSubviewToFront:webView];
    [webView stringByEvaluatingJavaScriptFromString:javasciptString];
    if (showAlert) {
        // show error message
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Resuming Video" message:@"" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        alertView.delegate = self;
        // [alertView show];
        [alertView release];
    }*/
    
    [webView setMediaPlaybackRequiresUserAction:NO];
    [webView setAllowsInlineMediaPlayback:YES];
    UIControl *b = [self findButtonInView:uiWebView];
    [b sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	/*float seek = 30.0f;
    if (buttonIndex == 0) {
		LOG_DEBUG(@"user pressed Cancel");
        seek = 0.0f;
	} else {
        LOG_DEBUG(@"user pressed Ok");
    }
	
    NSString* javasciptString = [NSString stringWithFormat:
         @"function onPageLoad() {                                                                  \n"
         "   try {                                                                                  \n"
         "       var vid = document.getElementsByTagName('video');                                  \n"
         "       if (vid && vid.length == 1) {                                                      \n"
         "           vid = vid[0];                                                                  \n"
         "           var seek = %f;                                                                 \n"
         "           if (seek > 0) {                                                                \n"
         "               vid.kkCanPlay = false;                                                     \n"
         "               function onDurationChange(e) {                                             \n"
         "                   try {                                                                  \n"
         "                       if ((e.target.duration > seek) && (e.target.kkCanPlay)) {          \n"
         "                           e.target.kkCanPlay = false;                                    \n"
         "                           e.target.currentTime = seek;                                   \n"
         "                           e.target.play();                                               \n"
         "                       }                                                                  \n"
         "                   } catch (e) { }                                                        \n"
         "               }                                                                          \n"
         "               function onCanPlay(e) {                                                    \n"
         "                   try {                                                                  \n"
         "                       e.target.kkCanPlay = true;                                         \n"
         "                       var dur = e.target.duration;                                       \n"
         "                       if (dur > seek) {                                                  \n"
         // "                           alert('Resuming');                                             \n"
         "                           window.focus();                                                \n"
         "                           e.target.focus();                                              \n"
         "                           if (e.target.controller) {                                     \n"
         "                               var controller = e.target.controller;                      \n"
         "                               controller.currentTime = seek;                             \n"
         "                           } else {                                                       \n"
         "                               e.target.play(); setTimeout(function() {try {e.target.pause(); e.target.currentTime = 30.2;e.target.play(); } catch (sErr) { alert(sErr); }}, 5);                               \n"
         "                           }                                                              \n"
         "                           //e.target.kkCanPlay = false;                                    \n"
         "                           //e.target.play();                                               \n"
         "                       }                                                                  \n"
         "                   } catch (er) {                                                         \n"
         "                       alert(er);e.target.kkCanPlay = false;                                        \n"
         "                       e.target.play();                                                   \n"
         "                   }                                                                      \n"
         "               }                                                                          \n"
         "               if (vid.readyState < 4) {                                                  \n"
         "                   vid.addEventListener('durationchange', onDurationChange, false);       \n"
         "                   vid.addEventListener('canplaythrough', onCanPlay, false);                     \n"
         "                   vid.load();                                                            \n"
         "               } else {                                                                   \n"
         "                   if (vid.duration < seek) {                                             \n"
         "                       vid.kkCanPlay = true;                                              \n"
         "                       vid.addEventListener('durationchange', onDurationChange, false);   \n"
         "                   } else {                                                               \n"
         "                       try {                                                              \n"
         "                           vid.currentTime = seek;                                        \n"
         "                       } catch (seekError) { }                                            \n"
         "                       vid.kkCanPlay = false;                                             \n"
         "                       vid.play();                                                        \n"
         "                   }                                                                      \n"
         "               }                                                                          \n"
         "           } else {                                                                       \n"
         "               vid.kkCanPlay = false;                                                     \n"
         "               vid.play();                                                                \n"
         "           }                                                                              \n"
         "       }                                                                                  \n"
         "   } catch (err) { }                                                                      \n"
         "}                                                                                         \n"
         "onPageLoad();", seek];
    
    LOG_DEBUG(@"Javascript String:\n%@", javasciptString);
    [self.view bringSubviewToFront:webView];
    [webView stringByEvaluatingJavaScriptFromString:javasciptString];*/
}

- (void) onSwipeGesture:(UIGestureRecognizer *)sender {
    UISwipeGestureRecognizerDirection swipeDirection = ((UISwipeGestureRecognizer*)sender).direction;
    if (swipeDirection == UISwipeGestureRecognizerDirectionRight) {
        LOG_DEBUG(@"Swiped Right");
    } else if (swipeDirection == UISwipeGestureRecognizerDirectionLeft) {
        LOG_DEBUG(@"Swiped Left");
    }
}


- (void)dealloc {
    webView.delegate = nil;
    [video release];
    [seekRequest release];
	[navigationBar release];
	[webView release];
	[backButton release];
    [super dealloc];
}



@end
