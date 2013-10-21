//
//  CoreDataController.h
//  Employee
//
//  Created by procit on 10/18/13.
//  Copyright (c) 2013 STC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Employee.h"

@interface CoreDataController : NSObject

@property(nonatomic,strong) NSManagedObjectContext *context;

- (NSManagedObjectContext *)managedObjectContext;
-(Employee *)setEmployeesFromCoreData:(NSManagedObject *)empFromCoreData;
-(NSArray *)fetchArray:(NSString *)entityName withPredicate:(NSString *)predicate withSortDesc:(NSString *)key onContext:(NSManagedObjectContext *)cont;
@end
