//
//  DeviceUtils.m
//  CommonIos
//
//  Created by ludovic cabre on 5/4/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "DeviceUtils.h"

@implementation DeviceUtils

+ (BOOL) isIpad {
	return [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad;
}

+ (BOOL) isIphone {
	return [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone;
}

+ (NSString*) version {
    return [[UIDevice currentDevice] systemVersion];
}

+ (OSMemoryNotificationLevel) currentMemoryLevel {
#if !TARGET_IPHONE_SIMULATOR
	return OSMemoryNotificationCurrentLevel();
#else
	// the simulator does not have memory limits..!
	return OSMemoryNotificationLevelNormal;
#endif
}
	
@end
