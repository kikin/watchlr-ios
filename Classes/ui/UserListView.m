//
//  ErrorMainView.m
//  KikinVideo
//
//  Created by ludovic cabre on 5/6/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "UserListView.h"
#import <QuartzCore/QuartzCore.h>
#import "UserTableCell.h"
#import "UserProfileObject.h"
#import "UserProfileView.h"
#import "LoadingIndicatorCell.h"

@implementation UserListView

@synthesize openUserProfileCallback, loadMoreDataCallback;

- (id) initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // create the video table
        userListView = [[UITableView alloc] init];
        userListView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        userListView.rowHeight = 70;
        userListView.delegate = self;
        userListView.dataSource = self;
        userListView.allowsSelection = NO;
        userListView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        userListView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self addSubview:userListView];
        
        // create the loading indicator
        loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        if (DeviceUtils.isIphone) {
            loadingView.frame = CGRectMake((self.frame.size.width - 50) / 2, (self.frame.size.height - 50) / 2, 50, 50);
        } else {
            loadingView.frame = CGRectMake((self.frame.size.width - 100) / 2, (self.frame.size.height - 100) / 2, 100, 100);
        }
        
        loadingView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [loadingView startAnimating];
        [self addSubview:loadingView];
        [self bringSubviewToFront:loadingView];
    }
    return self;
}

- (void) didReceiveMemoryWarning {
    [usersList release];
    usersList = nil;
}

- (void) dealloc {
    [openUserProfileCallback release];
    [loadMoreDataCallback release];
	[userListView removeFromSuperview];
    
    if (usersList != nil) 
        [usersList release];
    
    openUserProfileCallback = nil;
    loadMoreDataCallback = nil;
    userListView = nil;
    usersList = nil;
    
    [super dealloc];
}

// --------------------------------------------------------------------------------
//                             Private Functions
// --------------------------------------------------------------------------------

- (void) updateList:(NSArray*)usersArray isRefreshing:(bool)refreshing numberOfUsers:(int)userCount andLastPageRequested:(int)lastPageRequested {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    isRefreshing = refreshing;
    if (usersList == nil) {
        // This is the first time we are loading videos
        // we should create the new videos list element.
        usersList = [[NSMutableArray alloc] init];
        
        for (NSDictionary* userDic in usersArray) {
            // create user from dictionnary
            UserProfileObject* user = [[[UserProfileObject alloc] initFromDictionary:userDic] autorelease];
            [usersList addObject:user];
        }
        
        if ((lastPageRequested * 20) < userCount) {
            loadedAllUsers = false;
        } else {
            loadedAllUsers = true;            
        }
        
    } else if (isRefreshing) {
        // We are doing this odd logic intead of replacing all the user elements 
        // because we don't want to make extra calls to fetch user profile image, 
        // everytime user refreshes their list or switch between tabs
        
        // user wants to refresh the list
        // insert only those videos which are never inserted
        NSUInteger firstMatchedUserIndex = NSNotFound;
        if ([usersList count] > 0) {
            for (int i = 0; i < [usersList count]; i++) {
                UserProfileObject* user = [usersList objectAtIndex:i];
                firstMatchedUserIndex = [usersArray indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                    if ([[(NSDictionary*)(obj) objectForKey:@"id"] intValue] == user.userId) {
                        *stop = YES;
                        return YES;
                    }
                    return NO;
                }];
                
                if (firstMatchedUserIndex != NSNotFound) {
                    break;
                }
                
                [usersList removeObject:user];
                i--;
            }
            
        }
        
        // if none of the items matched in the received list and 
        // the existing list, then we have removed all the items from
        // the existing list. So, now we set the first matched index to 0
        // so users list can fill all the new users we received.
        if (firstMatchedUserIndex == NSNotFound) {
            firstMatchedUserIndex = 0;
        }
        
        // add all the videos to the list that were not present before
        for (int i = 0; i < firstMatchedUserIndex; i++) {
            // create video from dictionnary
            UserProfileObject* user = [[[UserProfileObject alloc] initFromDictionary:[usersArray objectAtIndex:i]] autorelease];
            [usersList insertObject:user atIndex:i];
        }
        
        int lastSavedUserListItemProcessedIndex = [usersList count];
        for (int i = firstMatchedUserIndex, j = firstMatchedUserIndex; 
             (i < [usersList count] && j < [usersList count]);) 
        {
            NSDictionary* newUserListItem = (NSDictionary*)[usersArray objectAtIndex:i];
            UserProfileObject* savedUserListItem = (UserProfileObject*)[usersList objectAtIndex:j];
            
            if ([[newUserListItem objectForKey:@"id"] intValue] == savedUserListItem.userId) {
                [savedUserListItem updateFromDictionary:newUserListItem];
                j++;
                i++;
            } else {
                [usersList removeObject:savedUserListItem];
            }
            
            lastSavedUserListItemProcessedIndex = j;
        }
        
        if (lastSavedUserListItemProcessedIndex < [usersList count]) {
            NSRange range = NSMakeRange(lastSavedUserListItemProcessedIndex, ([usersList count] - lastSavedUserListItemProcessedIndex));
            [usersList removeObjectsInRange:range];
            loadedAllUsers = false;
        }
        
        if (lastSavedUserListItemProcessedIndex < [usersList count]) {
            for (int i = lastSavedUserListItemProcessedIndex; i < [usersArray count]; i++) {
                // create video from dictionnary
                UserProfileObject* user = [[[UserProfileObject alloc] initFromDictionary:[usersArray objectAtIndex:i]] autorelease];
                [usersList insertObject:user atIndex:i];
            }
            loadedAllUsers = false;
        }
        
        // NOTE: please don't update lastPageRequested over here
        //       otherwise it will screw the logic for loading more videos.
        //       Refresh can request for more than 10 videos in the
        //       single page. So updating it here will screw the last page 
        //       requested number. If you really want to update the last page 
        //       requested over here. Then my suggestion would be to divide
        //       the videos count with 10 and then update the page number accordingly.
    } else { 
        
        // Remove the loading indicator
        if ([userListView numberOfRowsInSection:0] > [usersList count]) {
            [userListView beginUpdates];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[usersList count] inSection:0];
            [userListView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                  withRowAnimation:UITableViewRowAnimationNone];
            [userListView endUpdates];
        }
        
        // Appending the videos retreived to the list
        for (NSDictionary* userDic in usersArray) {
            // create video from dictionnary
            UserProfileObject* user = [[[UserProfileObject alloc] initFromDictionary:userDic] autorelease];
            [usersList addObject:user];
        }
        
        loadMoreState = LOADED_USERS;
        if ((lastPageRequested * 20) < userCount) {
            loadedAllUsers = false;
        } else {
            loadedAllUsers = true;            
        }
    }
    
    //LOG_DEBUG(@"Sending message to main thread to update videos list");
    [userListView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    
    loadMoreState = LOAD_MORE_USERS_NONE;
    isRefreshing = false;
    
    if ([loadingView isAnimating]) {
        [loadingView stopAnimating];
    }
    
    [pool release];
}

- (void) loadMoreData {
    if (!loadedAllUsers) {
        if (loadMoreDataCallback != nil) {
            [loadMoreDataCallback execute:nil];
        } else {
            loadMoreState = LOADED_USERS;
        }
    } else {
        loadMoreState = LOADED_USERS;
    }
}

// --------------------------------------------------------------------------------
//                      User Profile requests
// --------------------------------------------------------------------------------

- (void) openUserProfile:(UserProfileObject*)userProfile {
    if (openUserProfileCallback != nil) {
        [openUserProfileCallback execute:userProfile];
    }
}

// --------------------------------------------------------------------------------
//                      Table view delegate
// --------------------------------------------------------------------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (usersList != nil) {
		return [usersList count];
	} else {
		return 0;
	}
    
    if (usersList != nil) {
        if (loadMoreState == LOADING_USERS || loadedAllUsers) {
            return [usersList count];
        } else {
            return [usersList count] + 1;
        }
	} else {
		return 0;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"UserTableCell";
	
	// try to reuse an id
    UserTableCell* cell = (UserTableCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        // Create the cell
        cell = [[[UserTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.openUserProfileCallback = [Callback create:self selector:@selector(openUserProfile:)];
    }
	
	if (indexPath.row < usersList.count) {
		// Update data for the cell
		UserProfileObject* userProfileObject = [usersList objectAtIndex:indexPath.row];
		[cell setUserObject: userProfileObject];
        
        if (indexPath.row == (usersList.count - 1)) {
            if (loadMoreState != LOADING_USERS) {
                loadMoreState = LOADING_USERS;
                [self loadMoreData];
            }
        }
        
	} else if (indexPath.row == usersList.count && loadMoreState == LOADING_USERS) {
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == usersList.count)
        return 40;
    
    return 70;
}

// --------------------------------------------------------------------------------
//                             Public Functions
// --------------------------------------------------------------------------------

- (void) updateListWrapper: (NSDictionary*)args {
    if ((usersList == nil) || ([usersList count] == 0)) {
        [loadingView startAnimating];
    }
    
    [self updateList:[args objectForKey:@"usersList"] isRefreshing:[[args objectForKey:@"isRefreshing"] boolValue] numberOfUsers:[[args objectForKey:@"userCount"] integerValue] andLastPageRequested:[[args objectForKey:@"lastPageRequested"] integerValue]];
}

- (int) count {
    return (usersList != nil) ? [usersList count] : 0;
}

- (void) resetLoadingStatus {
    if ([loadingView isAnimating]) {
        [loadingView stopAnimating];
    }
}

@end
