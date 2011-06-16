    //
//  MostViewedViewController.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "KikinVideoViewController.h"
#import "LoginViewController.h"
#import "UserObject.h"
#import "FeedbackViewController.h"

@implementation KikinVideoToolBar

- (void) layoutSubviews {
    [super layoutSubviews];
    if (!kikinLogo) {
        for (UIView* imageView in self.subviews) {
            if ([imageView isKindOfClass:[UIImageView class]]) {
                kikinLogo = [imageView retain];
            }
        }
    }
    
    kikinLogo.frame = CGRectMake(((self.frame.size.width / 2) - 50), ((self.frame.size.height / 2) - 14), 100, 28);
}

-(void) dealloc {
    [kikinLogo release];
    [super dealloc];
}

@end

@implementation KikinVideoViewController

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	// create the view
	UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 500, 500)];
	view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	self.view = view;
	[view release];
    
    // create the toolbar
	topToolbar = [[KikinVideoToolBar alloc] init];
    topToolbar.frame = CGRectMake(0, 0, self.view.frame.size.width, 42);
    topToolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    topToolbar.tintColor = [UIColor colorWithRed:(12.0/255.0) green:(83.0/255.0) blue:(111.0/255.0) alpha:1.0];
    
    UIImageView* kikinLogo = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"kikin_logo_with_name.png"]] autorelease];
    [topToolbar insertSubview:kikinLogo atIndex:0];
    [topToolbar setAutoresizesSubviews:YES];
    
	NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:3];
    
    // create a spacer
    UIBarButtonItem* spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [buttons addObject:spacer];
    [spacer release];
	
	// create the disconnect button
	accountButton = [[UIBarButtonItem alloc] init];
	accountButton.title = @"Account";
	accountButton.style = UIBarButtonItemStyleBordered;
	accountButton.action = @selector(onClickAccount);
	[buttons addObject:accountButton];
	
    // add the buttons to the bar
    [topToolbar setItems:buttons];
    [buttons release];

    // create the video table
    videosTable = [[UITableView alloc] init];
    videosTable.frame = CGRectMake(0, 42, view.frame.size.width, view.frame.size.height-42);
    videosTable.rowHeight = DeviceUtils.isIphone ? 100 : 150;
    videosTable.delegate = self;
    videosTable.dataSource = self;
    videosTable.allowsSelection = NO;
    videosTable.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    videosTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:videosTable];

    userProfileView = [[UserProfileView alloc] initWithFrame:CGRectMake((view.frame.size.width-500)/2, (view.frame.size.height-210)/2, 500, 210)];
	userProfileView.hidden = YES;
    [self.view addSubview:userProfileView];
    
    userSettingsView = [[UserSettingsView alloc] initWithFrame:CGRectMake((view.frame.size.width - 210), topToolbar.frame.size.height, 210, 145)];
	userSettingsView.hidden = YES;
    userSettingsView.showUserProfileCallback = [Callback create:self selector:@selector(showUserProfile)];
    userSettingsView.showFeedbackFormCallback = [Callback create:self selector:@selector(showFeedbackForm)];
    userSettingsView.logoutCallback = [Callback create:self selector:@selector(logoutUser)];
	[self.view addSubview:userSettingsView];
    
    refreshStatusView = [[RefreshStatusView alloc] initWithFrame:CGRectMake(0.0f, topToolbar.frame.size.height, self.view.frame.size.width, 60.0f)];
    refreshStatusView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:refreshStatusView];
    [self.view bringSubviewToFront:refreshStatusView];
    [refreshStatusView setHidden:YES];
    state = REFRESH_NONE;
    
    [self.view addSubview:topToolbar];
    [self.view bringSubviewToFront:topToolbar];
    
    // settingsMenu = [[UIViewController alloc] init];
    
    
    // get the event when the app comes back
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void) playVideo:(VideoObject *)videoObject {
    if (videoObject != nil) {
        PlayerViewController* playerViewController = [[PlayerViewController alloc] init];
        playerViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentModalViewController:playerViewController animated:YES];
        [playerViewController setVideo:videoObject];
        [playerViewController release];
    }
}

- (void) showUserProfile {
    [userProfileView showUserProfile];
}

- (void) showFeedbackForm {
    FeedbackViewController* feedbackViewController = [[FeedbackViewController alloc] init];
    feedbackViewController.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    [self presentModalViewController:feedbackViewController animated:YES];
    
    [feedbackViewController loadFeedbackForm];
    [feedbackViewController release];
}

- (void) logoutUser {
    // erase userId
	UserObject* userObject = [UserObject getUser];
	userObject.sessionId = nil;
    [self dismissModalViewControllerAnimated:TRUE];
}

- (void) onClickRefresh {
    // Sub class will implement this method
}


- (void) onClickAccount {
    if (userSettingsView.hidden) {
        userSettingsView.frame = CGRectMake(self.view.frame.size.width - 210, topToolbar.frame.size.height, userSettingsView.frame.size.width, userSettingsView.frame.size.height);
        [userSettingsView showUserSettings];
    } else {
        userSettingsView.hidden = YES;
    }
    //[settingsMenu setMenuVisible:YES animated:YES];
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    if (!userSettingsView.hidden) {
        userSettingsView.frame = CGRectMake(self.view.frame.size.width - 210, topToolbar.frame.size.height, userSettingsView.frame.size.width, userSettingsView.frame.size.height);
        // [userSettingsView showUserSettings];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	
}

- (void)dealloc {
	// stop observing events
	[[NSNotificationCenter defaultCenter] removeObserver:self];	

	// release memory
	[videos release];
	[accountButton release];
	[videosTable release];
	[topToolbar release];
    [userProfileView release];
    [userSettingsView release];
    [refreshStatusView release];
    
    [super dealloc];
}

// --------------------------------------------------------------------------------
// TableView delegates/datasource
// --------------------------------------------------------------------------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (videos != nil) {
		return [videos count];
	} else {
		return 0;
	}
}

- (void) onDeleteRequestSuccess: (DeleteVideoResponse*)response {
	if (response.success) {
		VideoObject* videoObject = response.videoObject;
		
		NSUInteger idx = [videos indexOfObject:videoObject];
		LOG_DEBUG(@"delete idx = %ld %ld", idx, videoObject);
		[videos removeObjectAtIndex:idx];
		
		[videosTable beginUpdates];
		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
		[videosTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
						   withRowAnimation:UITableViewRowAnimationFade];
		[videosTable endUpdates];
	} else {
		NSString* errorMessage = [NSString stringWithFormat:@"We failed to delete this video: %@", response.errorMessage];
		
		// show error message
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Failed to delete" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		[alertView release];
		
		LOG_ERROR(@"request success but failed to delete video: %@", response.errorMessage);
	}
}

- (void) onDeleteRequestFailed: (NSString*)errorMessage {		
	NSString* errorString = [NSString stringWithFormat:@"We failed to delete this video: %@", errorMessage];
	
	// show error message
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Failed to delete" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
	
	LOG_ERROR(@"failed to delete video: %@", errorMessage);
}

- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath {
	return UITableViewCellEditingStyleDelete;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// unselect row
	[tableView deselectRowAtIndexPath:indexPath animated:TRUE];
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y < 0 && scrollView.contentOffset.y > -60) {
        if (refreshStatusView.hidden)
            refreshStatusView.hidden = NO;
        
        if (state != PULLING_DOWN) {
            state = PULLING_DOWN;
            [refreshStatusView setRefreshStatus:PULLING_DOWN];
        }
        
        refreshStatusView.frame = CGRectMake(refreshStatusView.frame.origin.x, topToolbar.frame.size.height, self.view.frame.size.width, -scrollView.contentOffset.y);
        
    } else if (scrollView.contentOffset.y >= 0) {
        
        if (!refreshStatusView.hidden) {
            refreshStatusView.hidden = YES;
            [refreshStatusView setRefreshStatus:REFRESH_NONE];
        }
        
        state = REFRESH_NONE;
        
    } else if (scrollView.contentOffset.y <= -60) {
        if (state < RELEASING) {
            state = RELEASING;
            [refreshStatusView setRefreshStatus:RELEASING];
        }
        
        refreshStatusView.frame = CGRectMake(refreshStatusView.frame.origin.x, topToolbar.frame.size.height - 60 - scrollView.contentOffset.y, self.view.frame.size.width, 60);
    }
    
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.y <= -65) {
        state = REFRESHING;
        [refreshStatusView setRefreshStatus:REFRESHING];
        scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        [self onClickRefresh];
    }
}

@end
