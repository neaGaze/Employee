//
//  EmployeeEditController.m
//  Employee
//
//  Created by STC on 9/25/13.
//  Copyright (c) 2013 STC. All rights reserved.
//

#import "EmployeeEditController.h"
#import "EMSViewController.h"
#import "CoreDataController.h"

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
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Employee View" style:UIBarButtonItemStyleBordered target:self action:@selector(confirmExit:)] ;
}

-(void)confirmExit:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Do you want to change the Details" message:@"Your changes will be queried in web service. Do you want to continue?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
    [alert show];
}

-(void)viewWillDisappear:(BOOL)animated{
  /**
   Called When this view is popped from the navigation Controller
   **/
    [super viewDidDisappear:animated];
    
    NSDictionary *id = @{@"id":[emp empId]};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"editResultNotification" object:self userInfo:id];  //transmit the employee Id in the userInfo dictionary
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
-(NSNumber *)editEmployee{
    connection = [Connection init];
    NSString* editUrl = @"EditEmployee";
    
    if(![connection checkInternetConnectivity]) // if network can't be found return error
        return 0;
    
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
    
    NSError *error = [[NSError alloc] init];
    
    NSDictionary *editRes = [NSJSONSerialization JSONObjectWithData:dataReceived options:kNilOptions error:&error];
    
    NSNumber *editBool = [editRes objectForKey:@"EditEmployeeResult"];
    NSLog(@"EDIT RESULT: %@",editBool);
    
    return editBool;
    
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

# pragma mark - Core Data part

- (void)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/** Save the employee in the core data **/
- (void)save:(id)sender {
//    NSManagedObjectContext *context = [self managedObjectContext];
    Employee *empLocal = (Employee *)sender;
    
    NSError *err = nil;

    CoreDataController *coreDataController = [[CoreDataController alloc] init];
    NSManagedObjectContext *context = [coreDataController managedObjectContext];
    
    NSArray *tmpArr = [coreDataController fetchArray:@"EmployeeStore" withPredicate:[NSString  stringWithFormat:@"employeeId == %@",[empLocal empId]] withSortDesc:@"employeeId" onContext:context];
   /*
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"EmployeeStore" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"employeeId == %@",[empLocal empId]];
    [request setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"employeeId" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    sortDescriptors = nil;
    sortDescriptor = nil;
    
    NSArray *tmpArr = [context executeFetchRequest:request error:&error];
 */
    NSManagedObject *editedEmployee = tmpArr[0];
    Employee *entity = [coreDataController setEmployeesFromCoreData:tmpArr[0]];
        NSLog(@"%dth object: %@",[tmpArr count],entity.empName);
    
    entity.empAddress = empAddr.text;
    entity.remarks = empRemarks.text;
    entity.designation = empDesignation.text;
    entity.homePhone = [NSNumber numberWithChar:empHomePhone.text];
    entity.mobile = [NSNumber numberWithChar:empMobile.text];
    
    [editedEmployee setValue:empAddr.text forKey:@"address"];
    [editedEmployee setValue:empRemarks.text forKey:@"remarks"];
    [editedEmployee setValue:empDesignation.text forKey:@"designation"];
    [editedEmployee setValue:[NSDecimalNumber decimalNumberWithString:empHomePhone.text] forKey:@"homePhone"];
    [editedEmployee setValue:[NSDecimalNumber decimalNumberWithString:empMobile.text] forKey:@"mobile"];
    
 //   request = nil;
    
    // Save the object to persistent store
    if (![context save:&err]) {
        NSLog(@"Can't Save! %@ %@", err, [err localizedDescription]);
    }
    NSLog(@"Saved Edited Employee !!!");
    
    //}
    [context refreshObject:tmpArr[0] mergeChanges:YES];
   
    [self dismissViewControllerAnimated:YES completion:nil];
}

# pragma mark - UIAlertView delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        NSNumber *editBoolean = [self performSelector:@selector(editEmployee)]; // query web service for Editing Employee content
        
        if([editBoolean integerValue] == 1) // if employee Edit is success, save the new info into Core Data
            [self save:emp];
        else
            [self performSelector:@selector(connErrorPrompt)];
            
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)connErrorPrompt
{
    UIAlertView *connPrompt = [[UIAlertView alloc] initWithTitle:@"Error while Saving !!" message:@"Error while saving because the network couldnot be found" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [connPrompt show];
}

@end
