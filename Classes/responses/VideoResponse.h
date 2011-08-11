//
//  LinkDeviceResponse.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/25/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoObject.h"
#import "DefaultResponse.h"

@interface VideoResponse : DefaultResponse {
    NSDictionary* videoResponse;
}

@property(retain) NSDictionary* videoResponse;

- (id) initWithResponse: (NSDictionary*)jsonObject;

@end
