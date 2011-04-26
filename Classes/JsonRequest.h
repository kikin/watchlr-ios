//
//  JsonRequest.h
//  KikinIos
//
//  Created by ludovic cabre on 4/1/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSON.h"
#import "Callback.h"

@interface JsonRequest : NSObject {
	NSMutableData* responseData;
	NSURLConnection* urlConnection;
	NSLock* connectionLock;
	Callback* errorCallback;
	Callback* successCallback;
}

- (void) doGetRequest: (NSString *)url params:(NSMutableDictionary*)params;
- (bool) isRequesting;
- (void) cancelRequest;

@property(retain) Callback* errorCallback;
@property(retain) Callback* successCallback;

@end

@interface JsonRequest (Abstract)

- (void) onRequestSuccess: (id)jsonObject;
- (void) onRequestFailed: (NSString*)errorMessage;

@end
