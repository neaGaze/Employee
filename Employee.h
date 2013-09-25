//
//  Employee.h
//  Employee
//
//  Created by STC on 9/24/13.
//  Copyright (c) 2013 STC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Employee : NSObject

@property (nonatomic,retain) NSString *empName;
@property (nonatomic,retain) NSString *empAddress;
@property (nonatomic,retain) NSString *email;
@property (nonatomic,retain) NSString *gender;
@property (nonatomic,retain) NSString *designation;
@property (nonatomic,retain) NSString *remarks;
@property (nonatomic,retain) NSNumber *homePhone;
@property (nonatomic,retain) NSNumber *mobile;
@property (nonatomic,retain) NSNumber *empId;

- (Employee *)initWithDict:(NSDictionary *)dict;
@end
