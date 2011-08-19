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

@implementation UserListView

@synthesize openUserProfileCallback;

- (id) initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // create the video table
        userListView = [[UITableView alloc] init];
        userListView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        userListView.rowHeight = 80;
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

- (void) dealloc {
    [openUserProfileCallback release];
	[userListView release];
    [usersList release];
    [super dealloc];
}

// --------------------------------------------------------------------------------
//                             Private Functions
// --------------------------------------------------------------------------------

- (void) updateList:(NSArray*)usersArray withNumberOfUsers:(int)userCount {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    if (usersList != nil) {
        [usersList release];
    }
    
    usersList = [[NSMutableArray alloc] init];
    
    for (NSDictionary* userDic in usersArray) {
        // create video from dictionnary
        UserProfileObject* user = [[[UserProfileObject alloc] initFromDictionary:userDic] autorelease];
        [usersList addObject:user];
    }
    
    [userListView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    
    if ([loadingView isAnimating]) {
        [loadingView stopAnimating];
    }
    
    [pool release];
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
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"UserTableCell";
	
	// try to reuse an id
    UserTableCell* cell = (UserTableCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        // Create the cell
        cell = [[[UserTableCell alloc] initWithStyle:UITableViewCellEditingStyleNone reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        cell.openUserProfileCallback = [Callback create:self selector:@selector(openUserProfile:)];
    }
	
	if (indexPath.row < usersList.count) {
		// Update data for the cell
		UserProfileObject* userProfileObject = [usersList objectAtIndex:indexPath.row];
		[cell setUserObject: userProfileObject];
	}
	
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < usersList.count) {
		// Update data for the cell
		if (openUserProfileCallback != nil) {
            UserProfileObject* userProfileObject = [usersList objectAtIndex:indexPath.row];
            [openUserProfileCallback execute:userProfileObject];
        }
	}
}

// --------------------------------------------------------------------------------
//                             Public Functions
// --------------------------------------------------------------------------------

- (void) updateListWrapper: (NSDictionary*)args {
    [loadingView startAnimating];
    [self updateList:[args objectForKey:@"usersList"] withNumberOfUsers:[[args objectForKey:@"userCount"] integerValue]];
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
