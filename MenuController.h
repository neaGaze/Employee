//
//  MenuController.h
//  Employee
//
//  Created by procit on 10/8/13.
//  Copyright (c) 2013 STC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuController : UITableViewController<UITableViewDelegate, UIAlertViewDelegate>

@property (strong,nonatomic) NSMutableArray *menuList;
@end
