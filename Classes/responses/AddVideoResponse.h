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

@interface AddVideoResponse : DefaultResponse {

}

- (id) initWithResponse: (NSDictionary*)jsonObject;

@property(retain) VideoObject* videoObject;

@end
