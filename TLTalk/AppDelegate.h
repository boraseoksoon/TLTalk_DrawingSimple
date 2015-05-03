//
//  AppDelegate.h
//  TLTalk
//
//  Created by SeoksoonJang on 5/1/15.
//  Copyright (c) 2015 SeoksoonJang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"
#import "DrawToolViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) DrawToolViewController * leftMenu;
@property (strong, nonatomic) UIWindow *window;


@end

