//
//  GridViewController.m
//  Employee
//
//  Created by procit on 10/4/13.
//  Copyright (c) 2013 STC. All rights reserved.
//

#import "GridViewController.h"
#import "GridCell.h"

@interface GridViewController ()

@end

@implementation GridViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
  //  [self.collectionView registerClass:[GridCell class] forCellWithReuseIdentifier:@"GridCell1"];
    self.collectionView.backgroundColor = [UIColor colorWithWhite:0.25f alpha:1.0f];
    
    [self.collectionView registerClass:[GridCell class] forCellWithReuseIdentifier:CellIdentifier];
    
   

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView1 cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    GridCell *gridCell = [collectionView1 dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
//    if(gridCell == nil){
//        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GridCell1" owner:self options:nil];
//        gridCell = nib[0];
//    }
//    gridCell.backgroundColor = [UIColor whiteColor];
    return gridCell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 5;
}

-(int)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 10;
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration
{
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        self.customGridLayout.numberOfColumns = 3;
        
        // handle insets for iPhone 4 or 5
        CGFloat sideInset = [UIScreen mainScreen].preferredMode.size.width == 1136.0f ?
        45.0f : 25.0f;
        
        self.customGridLayout.itemInsets = UIEdgeInsetsMake(22.0f, sideInset, 13.0f, sideInset);
        
    } else {
        self.customGridLayout.numberOfColumns = 2;
        self.customGridLayout.itemInsets = UIEdgeInsetsMake(22.0f, 22.0f, 13.0f, 22.0f);
    }
}

@end
