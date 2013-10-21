//
//  CoreDataController.m
//  Employee
//
//  Created by procit on 10/18/13.
//  Copyright (c) 2013 STC. All rights reserved.
//

#import "CoreDataController.h"

@implementation CoreDataController

@synthesize context;

-(CoreDataController *)init
{
    if(self == nil)
    {
        self = [self init];
    }
    return self;
}

- (NSManagedObjectContext *)managedObjectContext {
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

/** fill up the employee object from core data and return the employee object **/
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

/** fetch the existing data in the Core data in the persistent layer **/
-(NSArray *)fetchArray:(NSString *)entityName withPredicate:(NSString *)predicate withSortDesc:(NSString *)key onContext:(NSManagedObjectContext *)cont
{
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:entityName inManagedObjectContext:cont];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];

    NSPredicate *pred = [NSPredicate predicateWithFormat:predicate];
    [request setPredicate:pred];

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    sortDescriptors = nil;
    sortDescriptor = nil;

    NSError *error = nil;
    NSArray *tmpArr = [cont executeFetchRequest:request error:&error];
    return  tmpArr;
}

@end
