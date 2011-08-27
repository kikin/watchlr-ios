//
//  ErrorMainView.h
//  KikinVideo
//
//  Created by ludovic cabre on 5/6/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CommonIos/Callback.h>

/** Loading more users. */
typedef enum {
    LOAD_MORE_USERS_NONE,
    LOADING_USERS,
    LOADED_USERS
} LoadMoreUsersState;

@interface UserListView : UIView<UITableViewDelegate, UITableViewDataSource> {
    UITableView*                userListView;
    UIActivityIndicatorView*    loadingView;
    
    NSMutableArray*             usersList;
    
    LoadMoreUsersState          loadMoreState;
    bool                        loadedAllUsers;
    bool                        isRefreshing;
}

@property(retain) Callback* openUserProfileCallback;
@property(retain) Callback* loadMoreDataCallback;

- (void)    updateListWrapper: (NSDictionary*)args;
- (int)     count;
- (void)    resetLoadingStatus;
- (void)    didReceiveMemoryWarning;

@end
