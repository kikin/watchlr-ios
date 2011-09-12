//
//  DeviceUtils.h
//  CommonIos
//
//  Created by ludovic cabre on 5/4/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <libkern/OSMemoryNotification.h>

@interface DeviceUtils : NSObject {
    
}

+ (BOOL) isIpad;
+ (BOOL) isIphone;
+ (NSString*) version;
+ (OSMemoryNotificationLevel) currentMemoryLevel;

@end
