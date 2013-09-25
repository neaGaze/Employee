//
//  EmployeeEditController.h
//  Employee
//
//  Created by STC on 9/25/13.
//  Copyright (c) 2013 STC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Employee.h"

@interface EmployeeEditController : UITableViewController

@property (strong, nonatomic) IBOutlet UISegmentedControl *empGender;
@property (strong, nonatomic) IBOutlet UITextField *empRemarks;
@property (strong, nonatomic) IBOutlet UITextField *empDesignation;
@property (strong, nonatomic) IBOutlet UISwitch *relationship;
@property (strong, nonatomic) IBOutlet UITextField *empHomePhone;
@property (strong, nonatomic) IBOutlet UITextField *empMobile;
@property (strong, nonatomic) IBOutlet UILabel *relationshipLabel;
@property (strong, nonatomic) IBOutlet UITextField *empEmail;
@property (strong, nonatomic) IBOutlet UITextField *empAddr;
@property (strong, nonatomic) IBOutlet UITextField *empName;

@property (strong,nonatomic) Employee *emp;

-(IBAction)didGenderChange:(id)sender;
-(IBAction)toggleSwitch:(id)sender;
@end
