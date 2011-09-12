//
//  ConnectMainView.m
//  KikinVideo
//
//  Created by ludovic cabre on 5/6/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "SavedVideosListView.h"
#import <QuartzCore/QuartzCore.h>
#import "VideoTableCell.h"
#import "LoadingIndicatorCell.h"

@implementation SavedVideosListView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return self;
}

- (void)dealloc {
    [super dealloc];
}

// --------------------------------------------------------------------------------
//                       TableView delegates/datasource
// --------------------------------------------------------------------------------

//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
//	return @"Remove";
//}
//
//- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath {
//	return UITableViewCellEditingStyleDelete;
//}
//
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//	return YES;
//}
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//	// get the video item
//	if (indexPath.row < videosList.count) {
//		VideoObject* video = [videosList objectAtIndex:indexPath.row];
//        [self performSelector:@selector(onVideoRemoved:) withObject:video];
//	}
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"VideoTableCell";
	
	// try to reuse an id
    VideoTableCell* cell = (VideoTableCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        // Create the cell
        cell = [[[VideoTableCell alloc] initWithStyle:UITableViewCellEditingStyleDelete reuseIdentifier:CellIdentifier] autorelease];
		cell.playVideoCallback = [Callback create:self selector:@selector(playVideo:)];
        cell.likeVideoCallback = [Callback create:self selector:@selector(onVideoLiked:)];
        cell.unlikeVideoCallback = [Callback create:self selector:@selector(onVideoUnliked:)];
        cell.addVideoCallback = [Callback create:self selector:@selector(onVideoSaved:)];
        cell.removeVideoCallback = [Callback create:self selector:@selector(onVideoRemoved:)];
        cell.viewSourceCallback = [Callback create:self selector:@selector(onViewSourceClicked:)];
        cell.viewDetailCallback = [Callback create:self selector:@selector(getVideoDetail:)];
    }
    
    if (indexPath.row < videosList.count) {
        // Update data for the cell
        VideoObject* videoObject = [videosList objectAtIndex:indexPath.row];
        [cell setVideoObject: videoObject shouldAllowVideoRemoval:YES];
        
        if (indexPath.row == (videosList.count - 1)) {
            if (loadMoreState != LOADING) {
                loadMoreState = LOADING;
                [self performSelector:@selector(loadMoreData)];
            }
        }
    } else if (indexPath.row == videosList.count && loadMoreState == LOADING) {
        static NSString* LoadingCellIdentifier = @"LoadingCell";
        LoadingIndicatorCell* loadingCell = (LoadingIndicatorCell*)[tableView dequeueReusableCellWithIdentifier:LoadingCellIdentifier];
        if (loadingCell == nil) {
            loadingCell = [[[LoadingIndicatorCell alloc] initWithStyle:UITableViewCellEditingStyleNone reuseIdentifier:LoadingCellIdentifier] autorelease];
        }
        
        [loadingCell showLoadingIndicator];
        return loadingCell;
    }
	
    return cell;
}


@end
