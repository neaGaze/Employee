//
//  EMSViewController.h
//  Employee
//
//  Created by STC on 9/24/13.
//  Copyright (c) 2013 STC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmployeeViewController.h"
#import "Employee.h"
#import "Connection.h"
#import "MenuController.h"

@interface EMSViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
     Connection *conn;
}
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property(nonatomic,retain) NSMutableArray *arrOfEmp;
@property(nonatomic,retain) NSString *getEmployeeUrl;
@property (nonatomic,retain) NSArray *empSearchResult;
@property(strong,nonatomic) EmployeeViewController *empViewController;
@property (strong,nonatomic) NSOperationQueue *listQueue;
@property (strong,nonatomic) MenuController *menuController;
@property(strong,nonatomic) UIPopoverController *menuPopover;

-(void)deleteEmployee:(Employee *)delEmp;
+(int)currentRow;
@end
