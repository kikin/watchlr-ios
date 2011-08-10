//
//  PListFile.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/25/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "PListFile.h"


@implementation PListFile

- (id) init: (NSString*)name {
	if ((self = [super init])) {
		fileName = [name retain];
	}
	return self;
}

- (NSDictionary*) load {
	id plist = nil;
	NSString *error;
	NSPropertyListFormat format;
	
	NSString* localizedPath = [self getPath];
	NSData* plistData = [NSData dataWithContentsOfFile:localizedPath];
	if (plistData != nil) {
		plist = [NSPropertyListSerialization propertyListFromData:plistData mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&error];  
		if (!plist) {
			LOG_ERROR(@"failed to read plist from file '%@', error = '%@'", localizedPath, error);
			[error release];
		}
	}
	
	return plist;
}

- (NSString*) getPath {
	NSArray* path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
	NSString* documentsDirectory = [path objectAtIndex:0];
	NSString* ret = [documentsDirectory stringByAppendingPathComponent: [fileName stringByAppendingString: @".plist"]];
	return ret;
}

- (void) save: (NSDictionary*)pList {
	NSError* error2;
	NSString *error;
	NSString* localizedPath = [self getPath];
	NSData* xmlData = [NSPropertyListSerialization dataFromPropertyList:pList format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
	if (xmlData) {
		// LOG_DEBUG(@"xml=%@", [NSString stringWithUTF8String: [xmlData bytes]]);
		BOOL success = [xmlData writeToFile:localizedPath options:NSDataWritingAtomic error:&error2];  
		if (success == NO) {
			LOG_ERROR(@"Error writing plist to file '%@', error = '%@'", localizedPath, error2);
			[error2 release];
		}
	} else {
		LOG_ERROR(@"failed to write plist to file '%@', error = '%@'", localizedPath, error);  
		[error release];  
	}
}

- (void) dealloc {
	[fileName release];
	[super dealloc];
}


@end
