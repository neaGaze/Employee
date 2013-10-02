//
//  EmployeeEditController.h
//  Employee
//
//  Created by STC on 9/25/13.
//  Copyright (c) 2013 STC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Employee.h"
#import "Connection.h"
#import "CheckBox.h"

@interface EmployeeEditController : UITableViewController<UIPickerViewDataSource,UIPickerViewDelegate>

@property (strong,nonatomic) Connection *connection;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) IBOutlet UIButton *qualificationButton;
@property (strong, nonatomic) IBOutlet UILabel *qualificationLabel;
@property (strong, nonatomic) IBOutlet UILabel *gpaLabel;
@property (strong, nonatomic) IBOutlet UISlider *gpaSlider;
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
@property(strong,nonatomic) IBOutlet CheckBox *chkBox;
@property(strong,nonatomic) IBOutlet CheckBox *ios;
@property(strong,nonatomic) IBOutlet CheckBox *xml;
@property(strong,nonatomic) IBOutlet CheckBox *json;

@property(strong,nonatomic) NSArray *qualificationList;
@property (strong,nonatomic) Employee *emp;

-(IBAction)didGenderChange:(id)sender;
-(IBAction)toggleSwitch:(id)sender;
-(IBAction)sliderValueChanged:(id)sender;
-(IBAction)showPicker;
-(IBAction)checked;
-(IBAction)checked1;
-(IBAction)checked2;
-(IBAction)checked3;
-(void)editEmployee;
@end
