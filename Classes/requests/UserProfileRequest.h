//
//  DeleteVideoResponse.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/25/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonIos/JsonRequest.h>

@interface UserProfileRequest : JsonRequest {

}

- (void) getUserProfile;
- (void) updateUserProfile:(NSDictionary*)userProfile;
- (void) getUserProfile:(int)userId;
- (void) getUserProfileForName:(NSString*)username;
- (void) getPeopleUserFollows:(int)userId forPage:(int)page withFollowersCount:(int)followersCount;
- (void) getPeopleFollowingUser:(int)userId forPage:(int)page withFollowingCount:(int)followingCount;
- (void) getLikedVideosByUser:(int)userId forPage:(int)page withVideosCount:(int)videosCount;
- (void) followUser:(int) userId;
- (void) unfollowUser:(int) userId;

- (id) processReceivedString: (NSString*)receivedString;

@end
