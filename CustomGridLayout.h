//
//  CustomGridLayout.h
//  Employee
//
//  Created by procit on 10/4/13.
//  Copyright (c) 2013 STC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomGridLayout : UICollectionViewLayout

@property (nonatomic) UIEdgeInsets itemInsets;
@property (nonatomic) CGSize itemSize;
@property (nonatomic) CGFloat interItemSpacingY;
@property (nonatomic) NSInteger numberOfColumns;
@end
