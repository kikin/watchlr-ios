//
//  Request.h
//  CommonIos
//
//  Created by ludovic cabre on 5/3/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSON.h"
#import "Callback.h"

@interface Request : NSObject {
	NSMutableData* responseData;
	NSURLConnection* urlConnection;
	NSLock* connectionLock;
	Callback* errorCallback;
	Callback* successCallback;
}

- (void) doGetRequest: (NSString *)url params:(NSMutableDictionary*)params;
- (id) processReceivedString: (NSString*)receivedString;
- (bool) isRequesting;
- (void) cancelRequest;
- (void) onRequestSuccess: (id)jsonObject;
- (void) onRequestFailed: (NSString*)errorMessage;

@property(retain) Callback* errorCallback;
@property(retain) Callback* successCallback;

@end
