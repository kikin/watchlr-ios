//
//  LinkDeviceResponse.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/25/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DefaultResponse.h"

@interface TrackerResponse : DefaultResponse {

}

- (id) initWithResponse: (NSDictionary*)jsonObject;

@end
