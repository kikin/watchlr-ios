//
//  PListFile.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/25/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "PListFile.h"


@implementation PListFile

@synthesize fileName;

- (id) init: (NSString*)name
{
	self = [super init];
	if (self != nil) {
		fileName = [[name copy] retain];
	}
	return self;
}

- (NSDictionary*) load {
	id plist = nil;
	NSString *error;
	NSPropertyListFormat format;
	
	NSString* localizedPath = [self getPath]; //[[NSBundle mainBundle] pathForResource:[self getPath] ofType:@"plist"];
	NSData* plistData = [NSData dataWithContentsOfFile:localizedPath];
	if (plistData != nil) {
		plist = [NSPropertyListSerialization propertyListFromData:plistData mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&error];  
		if (!plist) {
			NSLog(@"Error reading plist from file '%s', error = '%s'", [localizedPath UTF8String], [error UTF8String]);
			[error release];
		}
	}
	
	return plist;
}

- (NSString*) getPath {
	NSArray* path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
	NSString* documentsDirectory = [path objectAtIndex:0];
	NSString* ret = [documentsDirectory stringByAppendingPathComponent: [self.fileName stringByAppendingString: @".plist"]];
	return ret;
}

- (void) save: (NSDictionary*)pList {
	NSError* error2;
	NSString *error;
	NSString* localizedPath = [self getPath]; //[[NSBundle mainBundle] pathForResource:[self getPath] ofType:@"plist"];  
	NSData* xmlData = [NSPropertyListSerialization dataFromPropertyList:pList format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];  
	if (xmlData) {  
		NSLog(@"xml=%@", [NSString stringWithUTF8String: [xmlData bytes]]);
		BOOL success = [xmlData writeToFile:localizedPath options:NSDataWritingAtomic error:&error2];  
		if (success == NO) {
			NSLog(@"Error writing plist to file '%s', error = '%s'", [localizedPath UTF8String], [error2 localizedDescription]);  
			[error2 release];  
		}
	} else {
		NSLog(@"Error writing plist to file '%s', error = '%s'", [localizedPath UTF8String], [error UTF8String]);  
		[error release];  
	}
}

@end
