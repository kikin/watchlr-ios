//
//  MainViewController.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/25/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MainViewController : UIViewController {
	IBOutlet UIWindow *window;
	IBOutlet UITabBarController* tabBarController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController* tabBarController;

@end
