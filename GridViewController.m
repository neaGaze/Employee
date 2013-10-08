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

@property(strong,nonatomic) NSMutableArray *grids;
@end

@implementation GridViewController
@synthesize grids, mainViewController;

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
    
    self.collectionView.backgroundColor = [UIColor colorWithWhite:0.25f alpha:1.0f];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;   // iOS 7 specific
    self.title = @"Grid View";
    
    self.grids = [[NSMutableArray alloc] init];
    NSArray *firstArr = @[@"employee.png",@"leave.png"];
    [self.grids addObject:firstArr];
    NSArray *secondGrids = @[@"liverbird.png",@"exit_big.png"];
    [self.grids addObject:secondGrids];
    
 //   [self.collectionView registerNib:[[NSBundle mainBundle] loadNibNamed:@"GridCell" owner:self options:nil][0] forCellWithReuseIdentifier:CellIdentifier];
    [self.collectionView registerClass:[GridCell class] forCellWithReuseIdentifier:CellIdentifier];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView1 cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    GridCell *gridCell = [collectionView1 dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
/*
    if(gridCell == nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        gridCell = nib[0];
    }
    gridCell.backgroundColor = [UIColor whiteColor];
*/
    
//  gridCell.imgView = (UIImageView *)[gridCell viewWithTag:1000];
    
    NSArray *tmpArr = self.grids[indexPath.section];
    NSString *name = tmpArr[indexPath.item];
    NSLog(@"counted at %d and %d is : %@",indexPath.section,indexPath.item,name);
    gridCell.imgView.image = [UIImage imageNamed:name];

    return gridCell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   
    NSArray *innerArrr = self.grids[section];
    return [innerArrr count];
 //   return 2;
}

-(int)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return [self.grids count];
  //  return 5;
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration
{
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
    {
        self.customGridLayout.numberOfColumns = 2;
        
        // On loandscape mode it is likely that the width is stretched, so to normalize that we do this
        CGFloat sideInset = [UIScreen mainScreen].preferredMode.size.width == 1136.0f ?
        45.0f : 25.0f;
        
        self.customGridLayout.itemSize = CGSizeMake(300.0f, 300.0f);
        [self.customGridLayout setItemSize:CGSizeMake(300.0f, 300.0f)];
        CGSize tmpItemSize = CGSizeMake(300.0f, 300.0f);
        NSDictionary *itemSizeDict = @{@"item":[NSValue valueWithCGSize:tmpItemSize]};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ItemSizeChange" object:self userInfo:itemSizeDict];
         // UIEdgeInsets are usually used when the widths are changeable due to reasons such as orientation change
        self.customGridLayout.itemInsets = UIEdgeInsetsMake(22.0f, sideInset, 13.0f, sideInset);
    }
    else
    {
        self.customGridLayout.numberOfColumns = 2;
        self.customGridLayout.itemInsets = UIEdgeInsetsMake(22.0f, 22.0f, 13.0f, 22.0f);
    }
    
  //  [self.customGridLayout invalidateLayout]; // this just marks the layout as invalid and needs to be updated next time
    [self.collectionView reloadData];
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1 && indexPath.item == 1)
    {
        NSLog(@"exit button is at %d section and %d item",indexPath.section,indexPath.item);
      //  [self.navigationController popToViewController:self animated:YES];
        UIAlertView *exitAlert = [[UIAlertView alloc] initWithTitle:@"Exit Dialog" message:@"Do you want to quit?" delegate:self cancelButtonTitle:@"Exit" otherButtonTitles:@"Cancel", nil];
       
        [exitAlert show];
    }
    else
    {
        self.mainViewController = [[EMSViewController alloc] initWithNibName:@"EMSViewController" bundle:nil];
        [self.navigationController pushViewController:[self mainViewController] animated:YES];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
        exit(0);

}

@end
