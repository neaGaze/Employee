//
//  CustomGridLayout.m
//  Employee
//
//  Created by procit on 10/4/13.
//  Copyright (c) 2013 STC. All rights reserved.
//

#import "CustomGridLayout.h"

static NSString * const CustomGridLayoutCell = @"CustomGridCell";

@interface CustomGridLayout()
//private property
@property (nonatomic, strong) NSDictionary *layoutInfo;
@end

@implementation CustomGridLayout

@synthesize interItemSpacingY, itemInsets, itemSize, numberOfColumns;

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    self.itemInsets = UIEdgeInsetsMake(22.0f, 22.0f, 13.0f, 22.0f);
    self.itemSize = CGSizeMake(350.0f,350.0f);
    self.interItemSpacingY = 12.0f;
    self.numberOfColumns = 2;
}

/** Delegated method to perform the up-front calculations needed to provide layout information. This is the first method fired after init **/
- (void)prepareLayout
{
    NSMutableDictionary *newLayoutInfo = [NSMutableDictionary dictionary];
    NSMutableDictionary *cellLayoutInfo = [NSMutableDictionary dictionary];
    
    NSInteger sectionCount = [self.collectionView numberOfSections];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0]; //initialize the indexPath
    
    for (NSInteger section = 0; section < sectionCount; section++) {
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        
        for (NSInteger item = 0; item < itemCount; item++) {
            indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            
            //find the attribute of the cell corresponding to the indexPath
            UICollectionViewLayoutAttributes *itemAttributes =
            [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            // customize the frame of the attribute i.e. change the positioning of each cell
            itemAttributes.frame = [self makeFrameAtIndexPath:indexPath];
            
            cellLayoutInfo[indexPath] = itemAttributes;
        }
    }
    
    newLayoutInfo[CustomGridLayoutCell] = cellLayoutInfo;
    
    self.layoutInfo = newLayoutInfo;
}

/** calculates the positioning of each cell using simple maths **/
- (CGRect)makeFrameAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.section / self.numberOfColumns;
    NSInteger column = indexPath.section % self.numberOfColumns;
    
    //This calculates total spaces between the cells
    CGFloat spacingX = self.collectionView.bounds.size.width -
    self.itemInsets.left -
    self.itemInsets.right -
    (self.numberOfColumns * self.itemSize.width);
    
    if (self.numberOfColumns > 1) spacingX = spacingX / (self.numberOfColumns - 1); //calculates the required spacing right after each cell
    
    CGFloat originX = floorf(self.itemInsets.left + (self.itemSize.width + spacingX) * column);// add left margin + (width of cell + spacing between cells) * number of columns, then we get the x-starting point
    
    CGFloat originY = floor(self.itemInsets.top +
                            (self.itemSize.height + self.interItemSpacingY) * row); // same as above, note we  have set spacing for Y as constant because height is irrelevent as it can scroll but width can't
    
    return CGRectMake(originX, originY, self.itemSize.width, self.itemSize.height);
}

/** Delegated default method of UICollectionViewLayout to return the attributes for cells and views that are in the specified rectangle. This is called 3rd in succession to the -(CGSize)collectionViewContentSize **/
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *allAttributes = [NSMutableArray arrayWithCapacity:self.layoutInfo.count];
   
    //traversing through every elements of the layoutInfo dictionary
    [self.layoutInfo enumerateKeysAndObjectsUsingBlock:^(NSString *elementIdentifier,
                                                         NSDictionary *elementsInfo,
                                                         BOOL *stop) {
        [elementsInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath,
                                                          UICollectionViewLayoutAttributes *attributes,
                                                          BOOL *innerStop) {
            if (CGRectIntersectsRect(rect, attributes.frame)) {
                [allAttributes addObject:attributes];
            }
        }];
    }];
    
    return allAttributes;
}

/** Delegated default method of UICollectionViewLayout **/
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.layoutInfo[CustomGridLayoutCell][indexPath];
}

/** Delegated default method of UICollectionViewLayout called to return the overall size of the entire content area based on your initial calculations. This is called 2nd in succession after -(void)prepareLayout method **/
- (CGSize)collectionViewContentSize
{
    NSInteger rowCount = [self.collectionView numberOfSections] / self.numberOfColumns;
    // make sure we count another row if one is only partially filled because the decimal point is directly parsed to its preceding integer. Eg: if(rowCount == 5.99) it is parsed as 5 not 6. So if this case arises we have to increase the value of 5 to 6
    if ([self.collectionView numberOfSections] % self.numberOfColumns) rowCount++;
    
    CGFloat height = self.itemInsets.top +
    rowCount * self.itemSize.height + (rowCount - 1) * self.interItemSpacingY +
    self.itemInsets.bottom; // simple enough just visualize the top margin, bottom margin, height of cell, Y spacing of each cells
    
    return CGSizeMake(self.collectionView.bounds.size.width, height);
}

#pragma mark - Properties

- (void)setItemInsets:(UIEdgeInsets)itemInsets1
{
    if (UIEdgeInsetsEqualToEdgeInsets(itemInsets, itemInsets1)) return;
    
    itemInsets = itemInsets1;
    
    [self invalidateLayout];
}

- (void)setItemSize:(CGSize)itemSize1
{
    if (CGSizeEqualToSize(itemSize, itemSize1)) return;
    
    itemSize = itemSize1;
    
    [self invalidateLayout];
}

- (void)setInterItemSpacingY:(CGFloat)interItemSpacingY1
{
    if (interItemSpacingY == interItemSpacingY1) return;
    
    interItemSpacingY = interItemSpacingY1;
    
    [self invalidateLayout];
}

- (void)setNumberOfColumns:(NSInteger)numberOfColumns1
{
    
    if (numberOfColumns == numberOfColumns1) return;
    
    numberOfColumns = numberOfColumns1;
    
    [self invalidateLayout];
    NSLog(@"column has changed to %d",numberOfColumns);
}
 
 
@end
