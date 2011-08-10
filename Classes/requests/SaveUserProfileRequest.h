//
//  DeleteVideoResponse.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/25/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonIos/JsonRequest.h>
#import "SaveUserProfileResponse.h"

@interface SaveUserProfileRequest : JsonRequest {

}

- (void) doSaveUserProfileRequest:(NSDictionary*)userProfile;
- (id) processReceivedString: (NSString*)receivedString;

@end
