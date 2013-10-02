//
//  CheckBox.h
//  Employee
//
//  Created by procit on 10/1/13.
//  Copyright (c) 2013 STC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckBox : UIButton
{
    BOOL isChecked;
}

@property (nonatomic,assign) BOOL isChecked;
-(void)checkBoxClicked;

@end
