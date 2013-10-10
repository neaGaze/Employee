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

@synthesize connection;
@synthesize emp,empName,empAddr,empEmail,empMobile,empDesignation,empHomePhone,empRemarks,empGender;
@synthesize relationship, relationshipLabel, gpaSlider, gpaLabel, qualificationButton, qualificationLabel;
@synthesize qualificationList, pickerView, chkBox, ios, xml, json;

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
    self.view.backgroundColor = [UIColor colorWithWhite:0.25f alpha:1.0f];
    self.title = @"Edit Employee";
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
    
    self.qualificationList = [[NSArray alloc] init];
    self.qualificationList = @[@"Primary School",@"High School",@"Bachelors Degree",@"Masters Degree or above"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)]; //initialize tap view detector to dismiss the keyboard or Picker View
    [self.view addGestureRecognizer:tap];   //add the tap gesture detector to the current view
    
   // [self.navigationItem.backBarButtonItem setAction:@selector(editEmployee:)];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self performSelector:@selector(editEmployee)];
    NSDictionary *id = @{@"id":[emp empId]};
  //  [[NSNotificationCenter defaultCenter] postNotificationName:@"editResultNotification" object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"editResultNotification" object:self userInfo:id];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView1 didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView1 deselectRowAtIndexPath:indexPath animated:YES];
}

/** to dismiss keyboard or Picker View when clicked outside the View **/
-(void)dismissKeyboard{
    [empName resignFirstResponder];
    [empAddr resignFirstResponder];
    [empEmail resignFirstResponder];
    [empHomePhone resignFirstResponder];
    [empMobile resignFirstResponder];
    [empDesignation resignFirstResponder];
    [empRemarks resignFirstResponder];
    pickerView.hidden = YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

/** Change the selected Segmented control **/
-(IBAction)didGenderChange:(id)sender{
    UISegmentedControl *segment = (UISegmentedControl *)sender;
    NSLog(@"Selected Segment: %@",[segment titleForSegmentAtIndex:[segment selectedSegmentIndex]]);
}

/** to change the relationship status when clicked on the UISwitch **/
-(IBAction)toggleSwitch:(id)sender{
    if(relationship.on)
        relationshipLabel.text = @"In Relationship / Married";
    else
        relationshipLabel.text = @"Single";
}

/** change the label of GPA according to the slider change **/
-(IBAction)sliderValueChanged:(id)sender{
    gpaLabel.text = [[NSString alloc] initWithFormat:@"%.2f",[gpaSlider value]];
}

/** A delegated method of UIPickerViewDelegate that gives the number of items in a single row **/
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

/** A delegated method of UIPickerViewDelegate that gives the size of the picker View **/
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [qualificationList count];
}

/** A delegated method of UIPickerViewDelegate that populates the row of the pickerVIew **/
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger) component
{
    return [qualificationList objectAtIndex:row];
}

/** When the button is clicked the PickerView is toggled **/
-(IBAction)showPicker{
    pickerView.hidden = !pickerView.hidden; //toggle the Picker View
}

/** When the picker row is selected, the label is changed **/
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    qualificationLabel.text = qualificationList[row];
}


/** To perform delete operation **/
-(void)editEmployee{
    connection = [Connection init];
    NSString* editUrl = @"EditEmployee";
    
    NSString *gend;
    if(empGender.selectedSegmentIndex == 0)
        gend = @"Male";
    else if(empGender.selectedSegmentIndex == 1)
        gend = @"Female";
    else
        gend = @"Others";
   
    NSDictionary *tempDict = [NSDictionary dictionaryWithObjectsAndKeys:[emp empId],@"EmployeeId",[empName text],@"EmployeeName",[empHomePhone text],@"HomePhone",[empDesignation text],@"Designation",[empRemarks text],@"Remarks",[empMobile text],@"Mobile",gend,@"Gender",[empAddr text],@"Address",[empEmail text],@"Email", nil];
    NSDictionary *dict = @{@"employee":tempDict};
    NSData *temp = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *tmpStr = [[NSString alloc] initWithData:temp encoding:NSUTF8StringEncoding];
    
    NSLog(@"Edit Query sent: %@",tmpStr);
    NSData *dataReceived = [connection startHTTP:editUrl dictionaryForQuery:dict];
    NSString *stringData = [[NSString alloc] initWithData:dataReceived encoding:NSUTF8StringEncoding];
    NSLog(@"edit Result: %@",stringData);
    
  //  [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)checked{
    [chkBox checkBoxClicked];
}
-(IBAction)checked1{
    [ios checkBoxClicked];
}
-(IBAction)checked2{
    [xml checkBoxClicked];
}
-(IBAction)checked3{
    [json checkBoxClicked];
}
@end
