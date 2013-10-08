//
//  CustomGridLayout.h
//  Employee
//
//  Created by procit on 10/4/13.
//  Copyright (c) 2013 STC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomGridLayout : UICollectionViewLayout

@property (nonatomic) UIEdgeInsets itemInsets; // something like margin in android layout
@property (nonatomic) CGSize itemSize;  // width and height of the cell
@property (nonatomic) CGFloat interItemSpacingY;
@property (nonatomic) NSInteger numberOfColumns;    //number of columns in 1 row

- (void)setNewItemSize:(NSNotification *)notif;
@end
