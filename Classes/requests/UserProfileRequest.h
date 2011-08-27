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
- (void) getUserProfile:(NSString*)username;
- (void) getPeopleUserFollows:(NSString*)username forPage:(int)page withFollowersCount:(int)followersCount;
- (void) getPeopleFollowingUser:(NSString*)username forPage:(int)page withFollowingCount:(int)followingCount;
- (void) getLikedVideosByUser:(NSString*)username forPage:(int)page withVideosCount:(int)videosCount;
- (void) followUser:(int) userId;
- (void) unfollowUser:(int) userId;

- (id) processReceivedString: (NSString*)receivedString;

@end
