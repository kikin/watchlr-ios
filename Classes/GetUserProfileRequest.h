//
//  DeleteVideoResponse.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/25/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonIos/JsonRequest.h>
#import "GetUserProfileResponse.h"

@interface GetUserProfileRequest : JsonRequest {

}

- (void) doGetUserProfileRequest;
- (id) processReceivedString: (NSString*)receivedString;

@end
