//
//  MenuController.m
//  Employee
//
//  Created by procit on 10/8/13.
//  Copyright (c) 2013 STC. All rights reserved.
//

#import "MenuController.h"
#import "MenuCell.h"

@interface MenuController ()

@end

@implementation MenuController
@synthesize menuList =_menuList;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _menuList = [NSMutableArray array];
        
        [_menuList addObject:@"Delete Employees"];
        [_menuList addObject:@"Send Messages"];
        [_menuList addObject:@"Exit"];
        
        self.clearsSelectionOnViewWillAppear = NO;
        
        //Calculate how tall the view should be by multiplying
        //the individual row height by the total number of rows.
        NSInteger rowsCount = [_menuList count];
        NSInteger singleRowHeight = [self.tableView.delegate tableView:self.tableView
                                               heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        NSInteger totalRowsHeight = rowsCount * singleRowHeight;
        
        //Calculate how wide the view should be by finding how
        //wide each string is expected to be
        CGFloat largestLabelWidth = 0;
        for (NSString *colorName in _menuList) {
            //Checks size of text using the default font for UITableViewCell's textLabel.
            CGSize labelSize = [colorName sizeWithFont:[UIFont boldSystemFontOfSize:20.0f]];
            if (labelSize.width > largestLabelWidth) {
                largestLabelWidth = labelSize.width;
            }
        }
        
        //Add a little padding to the width
        CGFloat popoverWidth = largestLabelWidth + 100;
        
        //Set the property to tell the popover container how big this view will be.
        self.contentSizeForViewInPopover = CGSizeMake(popoverWidth, totalRowsHeight);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_menuList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"MenuCell";
    
    UINib *cellNib = [UINib nibWithNibName:CellIdentifier bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:CellIdentifier];

    MenuCell *cell = (MenuCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
   
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil][0];
    }
    
    cell.backgroundColor = [UIColor grayColor];
    cell.menuImage = (UIImageView *)[cell viewWithTag:50];
    cell.menuLabel = (UILabel *)[cell viewWithTag:51];
    
    if([_menuList[indexPath.row] isEqualToString:@"Delete Employees"])
        cell.menuImage.image = [UIImage imageNamed:@"delete_user.png"];
    else if([_menuList[indexPath.row] isEqualToString:@"Send Messages"])
        cell.menuImage.image = [UIImage imageNamed:@"edit_user.png"];
    else if([_menuList[indexPath.row] isEqualToString:@"Exit"])
        cell.menuImage.image = [UIImage imageNamed:@"exit.png"];
    
    cell.menuLabel.text = _menuList[indexPath.row];
    
    return cell;
}

#pragma  mark - Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selectedList = [_menuList objectAtIndex:indexPath.row];
    
    //Set the color object based on the selected color name.
    if ([selectedList isEqualToString:@"Delete Employees"]) {
        NSLog(@"Delete Employees Clicked");
        
    } else if ([selectedList isEqualToString:@"Send Messages"]){
        NSLog(@"Send Message Clicked");
    } else if ([selectedList isEqualToString:@"Exit"]) {
        NSLog(@"Exit Clicked");
        UIAlertView *exitAlert = [[UIAlertView alloc] initWithTitle:@"Exit Dialog" message:@"Do you want to quit?" delegate:self cancelButtonTitle:@"Exit" otherButtonTitles:@"Cancel", nil];
        
        [exitAlert show];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma  mark - Alert View Click Detect
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
        exit(0);
    
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 */

@end
