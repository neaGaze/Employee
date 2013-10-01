//
//  EmployeeViewController.h
//  Employee
//
//  Created by STC on 9/24/13.
//  Copyright (c) 2013 STC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Employee.h"
#import "Connection.h"

@interface EmployeeViewController : UIViewController
{
    Connection *connec;
}
@property (nonatomic,strong) IBOutlet UILabel *name;
@property (nonatomic,strong) IBOutlet UILabel *address;
@property (nonatomic,strong) IBOutlet UILabel *gender;
@property (nonatomic,strong) IBOutlet UILabel *email;
@property (nonatomic,strong) IBOutlet UILabel *designation;
@property (nonatomic,strong) IBOutlet UILabel *remarks;
@property (nonatomic,strong) IBOutlet UILabel *homePhone;
@property (nonatomic,strong) IBOutlet UILabel *mobile;
@property (nonatomic,retain) Employee *employee;

-(void)gotoEdit;
-(void)reloadView:(NSNotification *)notification;
@end
