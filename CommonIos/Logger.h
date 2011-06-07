//
//  Logger.h
//  KikinIos
//
//  Created by ludovic cabre on 4/14/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Logger : NSObject {
	int level;
}

+ (void)flush;
+ (void)setLogger: (Logger*) instance;
+ (void)event: (NSString*)type location:(NSString*)location, ...;
+ (void)event: (NSString*)type from:(NSString*)from value:(NSString*)value;
+ (void)log: (int)level from:(const char*)from format:(NSString*)format, ...;
+ (NSString*)levelToString:(int)level;

@property int level;

@end

@interface Logger (Abstract)

- (void)flush;
- (void)log: (int)level from:(NSString*)from text:(NSString*)text;
- (void)event: (NSString*)type from:(NSString*)from value:(NSString*)value;

@end

#define LOG_CALL() [Logger log:LOGGER_TRACE from:__PRETTY_FUNCTION__ format:@"l.%ld", __LINE__];
#define LOG_DEBUG(fmt, ...) [Logger log:LOGGER_DEBUG from:__PRETTY_FUNCTION__ format:fmt, ##__VA_ARGS__];
#define LOG_INFO(fmt, ...) [Logger log:LOGGER_INFO from:__PRETTY_FUNCTION__ format:fmt, ##__VA_ARGS__];
#define LOG_WARN(fmt, ...) [Logger log:LOGGER_WARN from:__PRETTY_FUNCTION__ format:fmt, ##__VA_ARGS__];
#define LOG_ERROR(fmt, ...) [Logger log:LOGGER_ERROR from:__PRETTY_FUNCTION__ format:fmt, ##__VA_ARGS__];
#define LOG_FATAL(fmt, ...) [Logger log:LOGGER_FATAL from:__PRETTY_FUNCTION__ format:fmt, ##__VA_ARGS__];
#define LOG_FLUSH() [Logger flush];

#define LOG_EVENT(type, loc, ...) [Logger event:type location:loc, ##__VA_ARGS__, nil];

enum { LOGGER_TRACE, LOGGER_DEBUG, LOGGER_INFO, LOGGER_WARN, LOGGER_ERROR, LOGGER_FATAL };

