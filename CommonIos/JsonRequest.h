//
//  JsonRequest.h
//  KikinIos
//
//  Created by ludovic cabre on 4/1/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Request.h"

@interface JsonRequest : Request {

}

- (id) processReceivedString: (NSString*)receivedString;

@end
