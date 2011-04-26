//
//  ConsoleLogger.h
//  KikinIos
//
//  Created by ludovic cabre on 4/14/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Logger.h"

@interface ConsoleLogger : Logger {

}

- (void)log: (int)_level from:(NSString*)_from text:(NSString*)_text;
- (void)event: (NSString*)type from:(NSString*)from value:(NSString*)value;

@end
