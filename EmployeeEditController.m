//
//  EmployeeEditController.m
//  Employee
//
//  Created by STC on 9/25/13.
//  Copyright (c) 2013 STC. All rights reserved.
//

#import "EmployeeEditController.h"

@interface EmployeeEditController ()

@end

@implementation EmployeeEditController
@synthesize emp,empName,empAddr,empEmail,empMobile,empDesignation,empHomePhone,empRemarks,empGender;
@synthesize relationship, relationshipLabel;
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
    // Do any additional setup after loading the view from its nib.
    
    empName.text = [emp empName];
    empAddr.text = [emp empAddress];
    empEmail.text = [emp email];
    empMobile.text = [NSString stringWithFormat:@"%@",[emp mobile]];
    empHomePhone.text = [NSString stringWithFormat:@"%@",[emp homePhone]];
    empDesignation.text = [emp designation];
    empRemarks.text = [emp remarks];
    if([emp.gender isEqualToString:@"Male"])
        empGender.selectedSegmentIndex = 0;
    else if([emp.gender isEqualToString:@"Female"])
        empGender.selectedSegmentIndex = 1;
    else
        empGender.selectedSegmentIndex = 2;
    
    [empGender addTarget:self action:@selector(didGenderChange:) forControlEvents:UIControlEventValueChanged];
   
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView1 didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView1 deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)dismissKeyboard{
    [empName resignFirstResponder];
    [empAddr resignFirstResponder];
    [empEmail resignFirstResponder];
    [empHomePhone resignFirstResponder];
    [empMobile resignFirstResponder];
    [empDesignation resignFirstResponder];
    [empRemarks resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(IBAction)didGenderChange:(id)sender{
    UISegmentedControl *segment = (UISegmentedControl *)sender;
    NSLog(@"Selected Segment: %@",[segment titleForSegmentAtIndex:[segment selectedSegmentIndex]]);
}

-(IBAction)toggleSwitch:(id)sender{
    if(relationship.on)
        relationshipLabel.text = @"In Relationship / Married";
    else
        relationshipLabel.text = @"Single";
}

@end
