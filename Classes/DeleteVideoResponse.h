//
//  LinkDeviceResponse.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/25/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoObject.h"


@interface DeleteVideoResponse : NSObject {
	VideoObject* videoObject;
}

- (id) initWithResponse: (id)jsonObject;

@property(nonatomic,assign) VideoObject* videoObject;

@end
