//
//  CheckBox.m
//  Employee
//
//  Created by procit on 10/1/13.
//  Copyright (c) 2013 STC. All rights reserved.
//

#import "CheckBox.h"

@implementation CheckBox

@synthesize isChecked;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self setImage:[UIImage imageNamed:@"checkbox_not_ticked.png"] forState:UIControlStateNormal];
        [self addTarget:self action:@selector(checkBoxClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

-(void)checkBoxClicked{
    if(self.isChecked == NO)
    {
        self.isChecked = YES;
        [self setImage:[UIImage imageNamed:@"checkbox_ticked.png"] forState:UIControlStateNormal];
    }
    else{
        self.isChecked = NO;
        [self setImage:[UIImage imageNamed:@"checkbox_not_ticked.png"] forState:(UIControlStateNormal)];
    }
}

@end
