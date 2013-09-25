//
//  Employee.m
//  Employee
//
//  Created by STC on 9/24/13.
//  Copyright (c) 2013 STC. All rights reserved.
//

#import "Employee.h"

@implementation Employee
@synthesize empAddress,empId,empName,gender,email,designation,remarks,homePhone,mobile;

-(Employee *)initWithDict:(NSDictionary *)dict{
    
    if(self = [super init]){
        self.empId = [dict objectForKey:@"EmployeeId"];
        self.empName = [dict objectForKey:@"EmployeeName"];
        self.empAddress = [dict objectForKey:@"Address"];
        self.remarks = [dict objectForKey:@"Remarks"];
        self.designation = [dict objectForKey:@"Designation"];
        self.email = [dict objectForKey:@"Email"];
        self.gender = [dict objectForKey:@"Gender"];
        self.homePhone = [dict objectForKey:@"HomePhone"];
        self.mobile = [dict objectForKey:@"Mobile"];
    }
    return self;
}
@end
