//
//  VideoListRequest.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSON.h"

@interface JsonRequest : NSObject {
	NSURLRequest *urlRequest;
	NSMutableData *responseData;
	
	id errorHandlerObject;
	SEL errorHandlerSelector;
	
	id successHandlerObject;
	SEL successHandlerSelector;
}

- (void) doGetRequest: (NSString *)url params:(NSDictionary*)params;
- (void) setErrorCallback: (id)object callback:(SEL)callback;
- (void) setSuccessCallback: (id)object callback:(SEL)callback;

@property(nonatomic,copy) id errorHandlerObject;
@property(nonatomic) SEL errorHandlerSelector;
@property(nonatomic,copy) id successHandlerObject;
@property(nonatomic) SEL successHandlerSelector;

@end

@interface JsonRequest (Abstract)

- (void) onRequestSuccess: (id)jsonObject;
- (void) onRequestFailed: (NSString*)errorMessage;

@end