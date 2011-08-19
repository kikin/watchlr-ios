//
//  ConnectMainView.m
//  KikinVideo
//
//  Created by ludovic cabre on 5/6/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "SavedVideosListView.h"
#import <QuartzCore/QuartzCore.h>

@implementation SavedVideosListView

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

// --------------------------------------------------------------------------------
//                       TableView delegates/datasource
// --------------------------------------------------------------------------------

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
	return @"Remove";
}

- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath {
	return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	// get the video item
	if (indexPath.row < videosList.count) {
		VideoObject* video = [videosList objectAtIndex:indexPath.row];
        [self performSelector:@selector(onVideoRemoved:) withObject:video];
	}
}

@end
