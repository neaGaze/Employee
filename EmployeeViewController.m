//
//  EmployeeViewController.m
//  Employee
//
//  Created by STC on 9/24/13.
//  Copyright (c) 2013 STC. All rights reserved.
//

#import "EmployeeViewController.h"
#import "EmployeeEditController.h"
#import "EMSViewController.h"

@interface EmployeeViewController ()

@end

@implementation EmployeeViewController
@synthesize name,address,email,gender,designation,remarks,homePhone,mobile;
@synthesize employee;

NSDictionary *idReceiver;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.25f alpha:1.0f];
    self.title = @"Employee View";
    name.text = [employee empName];
    address.text = [employee empAddress];
    email.text = [employee email];
    gender.text = [employee gender];
    mobile.text = [NSString stringWithFormat:@"%@",[employee mobile]];
    homePhone.text = [NSString stringWithFormat:@"%@",[employee homePhone]];
    designation.text = [employee designation];
    remarks.text = [employee remarks];

    /*
    name.text = [employeeFromCoreData valueForKey:@"employeeName"];
    address.text = [employeeFromCoreData valueForKey:@"address"];
    email.text = [employeeFromCoreData valueForKey:@"email"];
    gender.text = [employeeFromCoreData valueForKey:@"gender"];
    mobile.text = [NSString stringWithFormat:@"%@",[employeeFromCoreData valueForKey:@"mobile"]];
    homePhone.text = [NSString stringWithFormat:@"%@",[employeeFromCoreData valueForKey:@"homePhone"]];
    designation.text = [employeeFromCoreData valueForKey:@"designation"];
    remarks.text = [employeeFromCoreData valueForKey:@"remarks"];
  */
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(gotoEdit)];
}

/** prepare for the view to be resumed **/
-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"Employee View is gonna appear again");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadView:) name:@"editResultNotification" object:nil];
}

/** Like the activity resume in android **/
-(void)viewDidAppear:(BOOL)animated
{
    
    name.text = [employee empName];
    address.text = [employee empAddress];
    email.text = [employee email];
    gender.text = [employee gender];
    mobile.text = [NSString stringWithFormat:@"%@",[employee mobile]];
    homePhone.text = [NSString stringWithFormat:@"%@",[employee homePhone]];
    designation.text = [employee designation];
    remarks.text = [employee remarks];
     /*
    name.text = [employeeFromCoreData valueForKey:@"employeeName"];
    address.text = [employeeFromCoreData valueForKey:@"address"];
    email.text = [employeeFromCoreData valueForKey:@"email"];
    gender.text = [employeeFromCoreData valueForKey:@"gender"];
    mobile.text = [NSString stringWithFormat:@"%@",[employeeFromCoreData valueForKey:@"mobile"]];
    homePhone.text = [NSString stringWithFormat:@"%@",[employeeFromCoreData valueForKey:@"homePhone"]];
    designation.text = [employeeFromCoreData valueForKey:@"designation"];
    remarks.text = [employeeFromCoreData valueForKey:@"remarks"];
  */
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(gotoEdit)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if(employee != nil)
        employee = nil;
}

-(void)gotoEdit{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"EmployeeEditController" bundle:nil];
    EmployeeEditController *editController = [storyboard instantiateViewControllerWithIdentifier:@"empEditStoryboard"];
    editController.emp = employee;
    [[self navigationController] pushViewController:editController animated:YES];
}

-(void)reloadView:(NSNotification *) notification {
    NSLog(@"Call vayo jasto xa");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    idReceiver = [notification.userInfo copy];
    NSNumber *i = [notification.userInfo objectForKey:@"id"];
    NSLog(@"emp Id: %@",i);
    
    connec = [Connection init];
    NSString *getEmployeeUrl = @"GetEmployeeList";
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"1bde13e5-65cd-425b-b1ce-ffaf2ce54269",@"userLoginId",@"20130706101010",@"modifiedDateTime", nil];
    NSData *dataReceived = [connec startHTTP:getEmployeeUrl dictionaryForQuery:dict];
    [connec receiveData:dataReceived];
    
    int k = [EMSViewController currentRow];
    employee = [connec employees][k] ;
     //[self r];
}

@end
