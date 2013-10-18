//
//  EMSViewController.m
//  Employee
//
//  Created by STC on 9/24/13.
//  Copyright (c) 2013 STC. All rights reserved.
//

#import "EMSViewController.h"
#import "EmployeeCell.h"
#import "Employee.h"

@interface EMSViewController ()
    
@end

static int *rowSelected;

@implementation EMSViewController
@synthesize empViewController;
@synthesize arrOfEmp, tableView, getEmployeeUrl, empSearchResult, listQueue, menuController, menuPopover;

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
	// Do any additional setup after loading the view, typically from a nib.
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;   // iOS 7 specific
    self.title = @"Employees";
    [self callConnection];
    
    arrOfEmp = [[conn employees] mutableCopy];
    if(arrOfEmp == nil){
        NSLog(@"array Empty");
    }
    else{
        NSLog(@"Array returned with employee");
    }
    
    /** To save the Employee array into core data **/
    for(Employee *arr in arrOfEmp)
    {
       // [self save:arr];
    }
    
    
    self.listQueue = [[NSOperationQueue alloc] init];
    self.listQueue.maxConcurrentOperationCount = 3;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(menuSelector)];
}

-(void)viewWillAppear:(BOOL)animated{
    [self becomeFirstResponder];
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

/** Call the httpConnection to the web service **/
- (void)callConnection{
    //conn = [[Connection alloc] init];
    conn = [Connection init];
    getEmployeeUrl = @"GetEmployeeList";
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"1bde13e5-65cd-425b-b1ce-ffaf2ce54269",@"userLoginId",@"20130706101010",@"modifiedDateTime", nil];
    NSData *dataReceived = [conn startHTTP:getEmployeeUrl dictionaryForQuery:dict];
    [conn receiveData:dataReceived];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/** populate the table cell with the data source values **/
-(UITableViewCell *) tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"EmployeeCell";
    
    EmployeeCell *cell = (EmployeeCell *)[tableView1 dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EmployeeCell" owner:self options:nil];//Remember nib is just like R file in android
        cell = [nib objectAtIndex:0];
    }
    
    __weak EMSViewController *weakSelf = self;
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        
        UILabel *nameLabel = (UILabel *)[cell viewWithTag:100];// similar to view.getTag() in android
        UILabel *addressLabel = (UILabel *)[cell viewWithTag:101];// similar to view.getTag() in android
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // then set them via the main queue if the cell is still visible.
            if ([weakSelf.tableView.indexPathsForVisibleRows containsObject:indexPath]) {
                EmployeeCell *cell =
                (EmployeeCell *)[weakSelf.tableView cellForRowAtIndexPath:indexPath];
                
                if (tableView1 == self.searchDisplayController.searchResultsTableView)
                {
                    nameLabel.text = [[empSearchResult objectAtIndex:indexPath.row] empName];
                    addressLabel.text = [[empSearchResult objectAtIndex:indexPath.row] empAddress];
                    
                }
                else{
                    nameLabel.text = [[arrOfEmp objectAtIndex:indexPath.row] empName];
                    addressLabel.text = [[arrOfEmp objectAtIndex:indexPath.row] empAddress];
                }
                
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
            }
        });
    }];
    
    [self.listQueue addOperation:operation];
  
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellBackground.png"]];
//    imageView.frame = CGRectMake(0, 78*indexPath.row, 320, cell.frame.size.height);
//    [tableView addSubview:imageView];
//    [tableView sendSubviewToBack:imageView];
    return cell;
}

/** Default function for returning the number of cell **/
-(NSInteger) tableView:(UITableView *)tableView1 numberOfRowsInSection:(NSInteger)section{
    if (tableView1 == self.searchDisplayController.searchResultsTableView)
        return [empSearchResult count];
    else
        return [arrOfEmp count];
}

/** When the table row is selected **/
-(void)tableView:(UITableView *)tableView1 didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"EmployeeStore"];
    NSArray *array = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    self.empViewController = [[EmployeeViewController alloc] initWithNibName:@"EmployeeViewController" bundle:nil];
 //   self.empViewController.employee = [arrOfEmp objectAtIndex:indexPath.row]; //if without using Core Data
    self.empViewController.employee = [self setEmployeesFromCoreData:array[indexPath.row]];
    
    [[self navigationController] pushViewController:empViewController animated:YES];
    rowSelected = indexPath.row;
    [tableView1 deselectRowAtIndexPath:indexPath animated:YES];
    
}

/** For auto rotate upon flip **/
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}




/** perform predicate for search operation on the search result **/
- (void)filterContentForSearchText:(NSString*)searchText
{
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"empName CONTAINS[cd] %@",
                                    searchText];
    
    empSearchResult = [[arrOfEmp filteredArrayUsingPredicate:resultPredicate] copy];
    
    
}

/** delegation of search function **/
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString];
    return YES;
}

/** Delegate for putting the header section as NSString **/
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
   
    return @"List of Employees";
}

/** Set the height of the row of the table **/
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 78;
}

/* For editing the table row. Now we implement the delete */
- (void)tableView:(UITableView *)tableView1 commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
 
    if(editingStyle == UITableViewCellEditingStyleDelete){
        NSLog(@"Delete Employee gesture detected at %d",indexPath.row);
        [self deleteEmployee:[arrOfEmp objectAtIndex:indexPath.row]];
        [tableView1 reloadData];
    }
}

/** To perform delete operation **/
-(void)deleteEmployee:(Employee *)delEmp{
    conn = [Connection init];
    NSString* deleteUrl = @"DeleteEmployee";
    NSNumber *id = [delEmp empId];
    NSDictionary *tempDict = [NSDictionary dictionaryWithObjectsAndKeys:id,@"employeeId", nil];
    NSArray *tempArr = @[tempDict];
    NSDictionary *dict = @{@"DeleteEmployee":tempArr};
    NSData *temp = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *tmpStr = [[NSString alloc] initWithData:temp encoding:NSUTF8StringEncoding];
    
    NSLog(@"Delete Query sent: %@",tmpStr);
    NSData *dataReceived = [conn startHTTP:deleteUrl dictionaryForQuery:dict];
    // [conn receiveData:dataReceived];
    NSString *stringData = [[NSString alloc] initWithData:dataReceived encoding:NSUTF8StringEncoding];
    NSLog(@"delete Result: %@",stringData);
}

+(int)currentRow{
    return rowSelected;
}

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    if(event.subtype == UIEventSubtypeMotionShake){
        NSLog(@"Shake detected!!!!");
    }
    if([super respondsToSelector:@selector(motionEnded:withEvent:)])
        [super motionEnded:motion withEvent:event];
}

-(BOOL)canBecomeFirstResponder{
    return YES;
}

-(void)menuSelector
{
    if (menuController == nil) {
        //Create the ColorPickerViewController.
        menuController = [[MenuController alloc] initWithStyle:UITableViewStylePlain];
        
        //Set this VC as the delegate.
       // menuController.delegate = self;
    }
    
    if (self.menuPopover == nil) {
        
        self.menuPopover = [[UIPopoverController alloc] initWithContentViewController:self.menuController];
        [self.menuPopover presentPopoverFromBarButtonItem:(UIBarButtonItem *)self.navigationItem.rightBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
    else
    {
        //The color picker popover is showing. Hide it.
        [self.menuPopover dismissPopoverAnimated:YES];
        self.menuPopover = nil;
    }
}

# pragma mark - Core Data part

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/** Save the employee in the core data **/
- (void)save:(id)sender {
    NSManagedObjectContext *context = [self managedObjectContext];
    Employee *emp = (Employee *)sender;    
    // Create a new managed object
    NSManagedObject *newEmployee = [NSEntityDescription insertNewObjectForEntityForName:@"EmployeeStore" inManagedObjectContext:context];
    
    [newEmployee setValue:[NSNumber numberWithInt:[emp empId]] forKey:@"employeeId"];
    [newEmployee setValue:[emp empName] forKey:@"employeeName"];
    [newEmployee setValue:[emp empAddress] forKey:@"address"];
    [newEmployee setValue:[emp email] forKey:@"email"];
    [newEmployee setValue:[emp remarks] forKey:@"remarks"];
    [newEmployee setValue:[emp designation] forKey:@"designation"];
    [newEmployee setValue:[NSDecimalNumber decimalNumberWithString:[emp homePhone]] forKey:@"homePhone"];
    [newEmployee setValue:[NSDecimalNumber decimalNumberWithString:[emp mobile]] forKey:@"mobile"];
    [newEmployee setValue:[emp gender] forKey:@"gender"];
   // NSLog(@"MOBILE VALUE BEFORE STORING %@",[NSDecimalNumber decimalNumberWithString:[emp mobile]]);
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

/** Convert from core data to Employee object **/
-(Employee *)setEmployeesFromCoreData:(NSManagedObject *)empFromCoreData
{
    Employee *tempEmp = [[Employee alloc] init];
    
    tempEmp.empId = [empFromCoreData valueForKey:@"employeeId"];
    tempEmp.empName = [empFromCoreData valueForKey:@"employeeName"];
    tempEmp.empAddress = [empFromCoreData valueForKey:@"address"];
    tempEmp.email = [empFromCoreData valueForKey:@"email"];
    tempEmp.remarks = [empFromCoreData valueForKey:@"remarks"];
    tempEmp.designation = [empFromCoreData valueForKey:@"designation"];
    tempEmp.homePhone = [empFromCoreData valueForKey:@"homePhone"];
    tempEmp.mobile = [empFromCoreData valueForKey:@"mobile"];
    tempEmp.gender = [empFromCoreData valueForKey:@"gender"];
    
    return tempEmp;
}

@end
