//
//  EmployeeViewController.m
//  Employee
//
//  Created by STC on 9/24/13.
//  Copyright (c) 2013 STC. All rights reserved.
//

#import "EmployeeViewController.h"
#import "EmployeeEditController.h"

@interface EmployeeViewController ()

@end

@implementation EmployeeViewController
@synthesize name,address,email,gender,designation,remarks,homePhone,mobile;
@synthesize employee;

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
    
    name.text = [employee empName];
    address.text = [employee empAddress];
    email.text = [employee email];
    gender.text = [employee gender];
    mobile.text = [NSString stringWithFormat:@"%@",[employee mobile]];
    homePhone.text = [NSString stringWithFormat:@"%@",[employee homePhone]];
    designation.text = [employee designation];
    remarks.text = [employee remarks];
    
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

@end
