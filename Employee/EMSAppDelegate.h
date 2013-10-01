//
//  EMSAppDelegate.h
//  Employee
//
//  Created by STC on 9/24/13.
//  Copyright (c) 2013 STC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmployeeViewController.h"

@class EMSViewController;

@interface EMSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic) UINavigationController *navController;
@property (strong, nonatomic) EMSViewController *viewController;
@property(strong,nonatomic) EmployeeViewController *empViewController;
@end
