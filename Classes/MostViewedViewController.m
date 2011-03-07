    //
//  MostViewedViewController.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "MostViewedViewController.h"
#import "VideoListRequest.h"
#import "UserObject.h"
#import "DeleteVideoRequest.h"

@implementation MostViewedViewController

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	[self doVideoListRequest];
}

- (void)doVideoListRequest {
	// get the list of videos
	VideoListRequest* request = [[VideoListRequest alloc] init];
	[request setErrorCallback:self callback:@selector(onListRequestFailed:)];
	[request setSuccessCallback:self callback:@selector(onListRequestSuccess:)];
	[request doGetVideoListRequest];	
}

- (IBAction) onClickRefresh {
	[self doVideoListRequest];
}

- (IBAction) onClickDisctonnect {
	// erase userId
	UserObject* userObject = [UserObject getUser];
	userObject.userId = nil;
	
	[self dismissModalViewControllerAnimated:TRUE];
}

- (void) onListRequestSuccess: (VideoListResponse*)response {
	NSLog(@"-- onListRequestSuccess");
	videoListResponse = response;
	[listTableView reloadData];
}

- (void) onListRequestFailed: (NSString*)errorMessage {
	NSLog(@"-- onLinkRequestFailed %@", errorMessage);
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (videoListResponse != nil) {
		NSLog(@"nb videos: %ld", ([[videoListResponse videos] count]));
		return [[videoListResponse videos] count];
	} else {
		NSLog(@"nb videos: 0 (response not yet there)");
		return 0;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150; 
}

- (void)onClickDeleteVideo:(VideoObject*)video {
	DeleteVideoRequest* request = [[DeleteVideoRequest alloc] init];
	[request setErrorCallback:self callback:@selector(onDeleteRequestFailed:)];
	[request setSuccessCallback:self callback:@selector(onDeleteRequestSuccess:)];
	[request doDeleteVideoRequest:video];
}

- (void) onDeleteRequestSuccess: (DeleteVideoResponse*)response {
	VideoObject* videoObject = response.videoObject;
	
	NSUInteger idx = [[videoListResponse videos] indexOfObject:videoObject];
	
	[[videoListResponse videos] removeObjectAtIndex:idx];
	
	[listTableView beginUpdates];
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
	[listTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
					 withRowAnimation:UITableViewRowAnimationFade];
	[listTableView endUpdates];	

	//[self doVideoListRequest];
}

- (void) onDeleteRequestFailed: (NSString*)errorMessage {
	NSLog(@"-- onDeleteRequestFailed %@", errorMessage);
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"VideoTableCell";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        // Create a temporary UIViewController to instantiate the custom cell.
        UIViewController *temporaryController = [[UIViewController alloc] initWithNibName:CellIdentifier bundle:nil];
        // Grab a pointer to the custom cell.
        cell = (VideoTableCell *)temporaryController.view;
		[((VideoTableCell*)cell) setDeleteCallback:self callback:@selector(onClickDeleteVideo:)];
		
        // Release the temporary UIViewController.
        [temporaryController release];
    }
	
	// Change data for the cell
	VideoObject* videoObject = [[videoListResponse videos] objectAtIndex:[indexPath row]];
	[((VideoTableCell*)cell) setVideoObject: videoObject];
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// play the selected video
	VideoObject* videoObject = [[videoListResponse videos] objectAtIndex:[indexPath row]];
	playerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	[self presentModalViewController:playerViewController animated:YES];
	[playerViewController setVideo:videoObject];
}


@end
