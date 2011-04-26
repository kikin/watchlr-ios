//
//  DefaultResponse.h
//  KikinVideo
//
//  Created by ludovic cabre on 4/25/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DefaultResponse : NSObject {
	BOOL success;
	NSString* errorMessage;
}

- (NSString*) errorMessage;
- (BOOL) success;
- (id) initWithResponse: (id)jsonObject;

@end
