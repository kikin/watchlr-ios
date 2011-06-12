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
    
	[self.view addSubview:topToolbar];
	
	NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:3];
	
	// create the disconnect button
	disconnectButton = [[UIBarButtonItem alloc] init];
	disconnectButton.title = @"Disconnect";
	disconnectButton.style = UIBarButtonItemStyleBordered;
	disconnectButton.action = @selector(onClickDisctonnect);
	[buttons addObject:disconnectButton];
	
	// create the refresh button
	/*refreshButton = [[UIBarButtonItem alloc] init];
	refreshButton.title = @"Refresh list";
	refreshButton.style = UIBarButtonItemStyleBordered;
	refreshButton.action = @selector(onClickRefresh);
	[buttons addObject:refreshButton];*/
	
     
    // create a spacer
    /*UIBarButtonItem* spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [buttons addObject:spacer];
    [spacer release]; 
    
    UIImageView * kikinLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"kikin_logo.png"]];
    [buttons addObject:kikinLogo];*/
    
    
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

    // get the event when the app comes back
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void) playVideo:(VideoObject *)videoObject {
    if (videoObject != nil) {
        PlayerViewController* playerViewController = [[PlayerViewController alloc] init];
        playerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentModalViewController:playerViewController animated:YES];
        [playerViewController setVideo:videoObject];
        [playerViewController release];
    }
}

- (void) onClickDisctonnect {
	// erase userId
	UserObject* userObject = [UserObject getUser];
	userObject.sessionId = nil;

	[self dismissModalViewControllerAnimated:TRUE];
}

- (void) onClickRefresh {
    // Sub class will implement this method
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
	[disconnectButton release];
	// [refreshButton release];
	[videosTable release];
	[topToolbar release];
	
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

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.y <= -65) {
        [self onClickRefresh];
    }
}


@end
