//
//  EMSViewController.m
//  Employee
//
//  Created by STC on 9/24/13.
//  Copyright (c) 2013 STC. All rights reserved.
//

#import "EMSViewController.h"
#import "EmployeeCell.h"

@interface EMSViewController ()
    
@end

static int *rowSelected;

@implementation EMSViewController
@synthesize empViewController;
@synthesize arrOfEmp, tableView, getEmployeeUrl, empSearchResult;

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
    
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:100];// similar to view.getTag() in android
    UILabel *addressLabel = (UILabel *)[cell viewWithTag:101];// similar to view.getTag() in android
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
    
    self.empViewController = [[EmployeeViewController alloc] initWithNibName:@"EmployeeViewController" bundle:nil];
    self.empViewController.employee = [arrOfEmp objectAtIndex:indexPath.row];
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

@end
