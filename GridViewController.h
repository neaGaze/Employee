//
//  GridViewController.h
//  Employee
//
//  Created by procit on 10/4/13.
//  Copyright (c) 2013 STC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomGridLayout.h"
#import "EMSViewController.h"

static NSString * const CellIdentifier = @"CustomGridCell";

@interface GridViewController : UICollectionViewController<UICollectionViewDataSource,
UICollectionViewDelegate, UIAlertViewDelegate>

@property (strong,nonatomic) IBOutlet UICollectionView *collectionView;
@property(strong,nonatomic) IBOutlet CustomGridLayout *customGridLayout;
@property(strong,nonatomic) EMSViewController *mainViewController;
@end
