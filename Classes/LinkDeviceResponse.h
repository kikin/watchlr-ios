//
//  LinkDeviceResponse.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/25/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LinkDeviceResponse : NSObject {
	NSString*		userId;
}

- (id) initWithResponse: (id)jsonObject;

@property(nonatomic,copy) NSString* userId;

@end
