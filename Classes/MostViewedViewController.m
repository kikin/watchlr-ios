    //
//  MostViewedViewController.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "MostViewedViewController.h"
#import "LoginViewController.h"
#import "UserObject.h"

@implementation MostViewedViewController

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	// create the view
	UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 500, 500)];
	view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	self.view = view;
	[view release];
	
	// create the toolbar
	topToolbar = [[UIToolbar alloc] init];
	topToolbar.frame = CGRectMake(0, 0, view.frame.size.width, 42);
	topToolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[view addSubview:topToolbar];
	
	NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:3];
	
	// create the disconnect button
	disconnectButton = [[UIBarButtonItem alloc] init];
	disconnectButton.title = @"Disconnect";
	disconnectButton.style = UIBarButtonItemStyleBordered;
	disconnectButton.action = @selector(onClickDisctonnect);
	[buttons addObject:disconnectButton];
	
	// create a spacer
	UIBarButtonItem* spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	[buttons addObject:spacer];
	[spacer release];
	
	// create the refresh button
	refreshButton = [[UIBarButtonItem alloc] init];
	refreshButton.title = @"Refresh list";
	refreshButton.style = UIBarButtonItemStyleBordered;
	refreshButton.action = @selector(onClickRefresh);
	[buttons addObject:refreshButton];
	
	// add the buttons to the bar
	[topToolbar setItems:buttons];
	[buttons release];
	
	// create the video table
	videosTable = [[UITableView alloc] init];
	videosTable.frame = CGRectMake(0, 42, view.frame.size.width, view.frame.size.height-42);
	videosTable.rowHeight = DeviceUtils.isIphone ? 100 : 150;
	videosTable.delegate = self;
	videosTable.dataSource = self;
	videosTable.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	[view addSubview:videosTable];
	
	// get the event when the app comes back
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
	
	// request video lsit
	[self doVideoListRequest];
}

- (void)doVideoListRequest {
	// get the list of videos
	if (videoListRequest == nil) {
		videoListRequest = [[VideoListRequest alloc] init];
		videoListRequest.errorCallback = [Callback create:self selector:@selector(onListRequestFailed:)];
		videoListRequest.successCallback = [Callback create:self selector:@selector(onListRequestSuccess:)];
	}
	if ([videoListRequest isRequesting]) {
		[videoListRequest cancelRequest];
	}
	[videoListRequest doGetVideoListRequest];	
}

- (void) onClickRefresh {
	[self doVideoListRequest];
}

- (void) onApplicationBecomeActive: (NSNotification*)notification {
	[self doVideoListRequest];
}

- (void) onClickDisctonnect {
	// erase userId
	UserObject* userObject = [UserObject getUser];
	userObject.sessionId = nil;
	
	//LoginViewController* loginViewController = [[LoginViewController alloc] init];
	//[UIView transitionFromView:self.view toView:loginViewController.view duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished){
	//	if (finished) {
	//	}
	//}];

	[self dismissModalViewControllerAnimated:TRUE];
}

- (void) onListRequestSuccess: (VideoListResponse*)response {
	if (response.success) {
		// save response and get videos
		videoListResponse = [response retain];
		videos = [[NSMutableArray arrayWithArray:[response videos]] retain];
		
		// refresh the table
		[videosTable reloadData];
		
		LOG_DEBUG(@"list request success");
	} else {
		NSString* errorMessage = [NSString stringWithFormat:@"We failed to retrieve your videos: %@", response.errorMessage];
		
		// show error message
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Failed to retrieve videos" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		[alertView release];		
		
		LOG_ERROR(@"request success but failed to list videos: %@", response.errorMessage);
	}
}

- (void) onListRequestFailed: (NSString*)errorMessage {
	NSString* errorString = [NSString stringWithFormat:@"We failed to retrieve your videos: %@", errorMessage];
	
	// show error message
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Failed to retrieve videos" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
	[alertView release];		
	
	LOG_ERROR(@"list request error: %@", errorMessage);
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
	[videoListRequest release];
	[videoListResponse release];
	[disconnectButton release];
	[refreshButton release];
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

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
	return @"Remove from queue";
}

- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath {
	return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (deleteVideoRequest == nil) {
		// create a delete request if not already done
		deleteVideoRequest = [[DeleteVideoRequest alloc] init];
		deleteVideoRequest.errorCallback = [Callback create:self selector:@selector(onDeleteRequestFailed:)];
		deleteVideoRequest.successCallback = [Callback create:self selector:@selector(onDeleteRequestSuccess:)];
	}
	
	// get the video item
	if (indexPath.row < videos.count) {
		VideoObject* video = [videos objectAtIndex:indexPath.row];
		
		// cancel any current request
		if ([deleteVideoRequest isRequesting]) {
			[deleteVideoRequest cancelRequest];
		}
		
		LOG_DEBUG(@"delete idx = %ld %ld", indexPath.row, video);
		
		// do the request
		[deleteVideoRequest doDeleteVideoRequest:video];
	}
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"VideoTableCell";
	
	// try to reuse an id
    VideoTableCell* cell = (VideoTableCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        // Create the cell
        cell = [[[VideoTableCell alloc] initWithStyle:UITableViewCellEditingStyleDelete reuseIdentifier:CellIdentifier] autorelease];
		cell.deleteCallback = [Callback create:self selector:@selector(onClickDeleteVideo:)];
    }
	
	if (indexPath.row < videos.count) {
		// Update data for the cell
		VideoObject* videoObject = [videos objectAtIndex:indexPath.row];
		[cell setVideoObject: videoObject];
	}
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// unselect row
	[tableView deselectRowAtIndexPath:indexPath animated:TRUE];
	
	// play the selected video
	if (indexPath.row < videos.count) {
		// Update data for the cell
		VideoObject* videoObject = [videos objectAtIndex:indexPath.row];
		PlayerViewController* playerViewController = [[PlayerViewController alloc] init];
		playerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
		[self presentModalViewController:playerViewController animated:YES];
		[playerViewController setVideo:videoObject];
		[playerViewController release];
	}
}


@end
