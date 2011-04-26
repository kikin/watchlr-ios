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

@interface DeleteVideoResponse : DefaultResponse {
	VideoObject* videoObject;
}

- (id) initWithResponse: (NSDictionary*)jsonObject;

@property(nonatomic,assign) VideoObject* videoObject;

@end
