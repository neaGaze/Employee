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
#import "CoreDataController.h"

@interface EMSViewController ()

@end

static int *rowSelected;

@implementation EMSViewController
@synthesize empViewController;
@synthesize arrOfEmp, tableView, getEmployeeUrl, empSearchResult, listQueue, menuController, menuPopover;
@synthesize coreDataController;

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
    coreDataController = [[CoreDataController alloc] init];
    for(Employee *arr in arrOfEmp)
    {
        [self save:arr];
    }
    
    
    self.listQueue = [[NSOperationQueue alloc] init];
    self.listQueue.maxConcurrentOperationCount = 3;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(menuSelector)];
    
 //   singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissEditing)]; //initialize tap view detector to dismiss the Editing of the table
    
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
    NSData *dataReceived = nil;
    if([conn checkInternetConnectivity])
    {
        dataReceived = [conn startHTTP:getEmployeeUrl dictionaryForQuery:dict];
        [conn receiveData:dataReceived];
    }
    else
    {
        NSLog(@"Network unavailable. ");
        
        UIAlertView *connectionAlert = [[UIAlertView alloc] initWithTitle:@"Connection Orientation" message:@"You have accessed through offline process. Do you have the webservice running?or internet access?" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [connectionAlert show];

        NSString *hardCodedJSON = [[NSBundle mainBundle] pathForResource:@"employeeListJSONfile" ofType:nil];
        dataReceived = [[NSData alloc] initWithContentsOfFile:hardCodedJSON];
        [conn receiveData:dataReceived];
    //    NSLog(@"Hard Coded JSON Data: %@",[[NSString alloc] initWithData:dataReceived encoding:NSUTF8StringEncoding]);
    }
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
    
    NSManagedObjectContext *managedObjectContext = [coreDataController managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"EmployeeStore"];
    NSArray *array = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    self.empViewController = [[EmployeeViewController alloc] initWithNibName:@"EmployeeViewController" bundle:nil];
 //   self.empViewController.employee = [arrOfEmp objectAtIndex:indexPath.row]; //if without using Core Data
    self.empViewController.employee = [coreDataController setEmployeesFromCoreData:array[indexPath.row]];
    
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
    
     //[self.view addGestureRecognizer:singleTap];
    
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
    
    UIAlertView *deletePrompt = [[UIAlertView alloc] initWithTitle:@"Confirm Delete" message:@"For some reason the employees will not be deleted even if you press OK. Please assume that it will be deleted." delegate:nil cancelButtonTitle:@"Delete" otherButtonTitles:@"Cancel", nil];
    [deletePrompt show];
    
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
        
        if((shakeCount % 2) == 0)
            [tableView setEditing:YES animated:YES];
        else
            [tableView setEditing:NO animated:NO];
        shakeCount++;
        
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

- (void)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/** Save the employee in the core data **/
- (void)save:(id)sender {
    
    NSManagedObjectContext *context = [coreDataController managedObjectContext];
    Employee *emp = (Employee *)sender;
    
 /*   //first fetch the core data to see of the data is already exiting or not
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"EmployeeStore" inManagedObjectContext:context];
    NSFetchRequest *req = [[NSFetchRequest alloc] init];
    [req setEntity:entityDesc];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"employeeId == %@",[emp empId]];
    [req setPredicate:pred];
    NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc] initWithKey:@"employeeId" ascending:YES];
    NSArray *sortDescs = [[NSArray alloc] initWithObjects:sortDesc, nil];
    [req setSortDescriptors:sortDescs];
    sortDescs = nil;
    sortDesc = nil;
    
    NSError *err = nil;
    NSArray *tmpArr = [context executeFetchRequest:req error:&err];
 */
    NSArray *tmpArr = [coreDataController fetchArray:@"EmployeeStore" withPredicate:[NSString stringWithFormat:@"employeeId == %@",[emp empId]] withSortDesc:@"employeeId" onContext:context];
    
    NSManagedObject *newEmployee;
    if(tmpArr.count != 0)
    {
        //check if the data is already present in the persistent layer, use that managed Object
        newEmployee = tmpArr[0];
        //   req = nil;
    }
    else{
        // If not present, Create a new managed object
        newEmployee = [NSEntityDescription insertNewObjectForEntityForName:@"EmployeeStore" inManagedObjectContext:context];
    }
   
    [newEmployee setValue:[NSNumber numberWithInteger:[[emp empId] integerValue]] forKey:@"employeeId"];
    [newEmployee setValue:[emp empName] forKey:@"employeeName"];
    [newEmployee setValue:[emp empAddress] forKey:@"address"];
    [newEmployee setValue:[emp email] forKey:@"email"];
    [newEmployee setValue:[emp remarks] forKey:@"remarks"];
    [newEmployee setValue:[emp designation] forKey:@"designation"];
    [newEmployee setValue:[NSDecimalNumber decimalNumberWithString:[emp homePhone]] forKey:@"homePhone"];
    [newEmployee setValue:[NSDecimalNumber decimalNumberWithString:[emp mobile]] forKey:@"mobile"];
    [newEmployee setValue:[emp gender] forKey:@"gender"];
    
 //   NSLog(@"MOBILE VALUE BEFORE STORING %@",[NSNumber numberWithInteger:[[emp empId] integerValue]]);
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
