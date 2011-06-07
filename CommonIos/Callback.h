//
//  Callback.h
//  KikinIos
//
//  Created by ludovic cabre on 4/4/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Callback : NSObject {
	id handlerObject;
	SEL handlerSelector;
}

- (id) init: (id)object selector:(SEL)selector;
- (void) dealloc;
- (id) execute: (id)parameter;
+ (id) create: (id)object selector:(SEL)selector;

@property(assign) id handlerObject;
@property() SEL handlerSelector;

@end
