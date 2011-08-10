//
//  ErrorMainView.h
//  KikinVideo
//
//  Created by ludovic cabre on 5/6/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CommonIos/Callback.h>

@interface ErrorMainView : UIView {
	UILabel* titleLabel;
	UILabel* errorLabel;
	UIButton* okButton;
}

- (void) setErrorMessage: (NSString*)message;

@property(retain) Callback* clickOkCallback;

@end
