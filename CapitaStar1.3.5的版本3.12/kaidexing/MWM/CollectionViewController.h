//
//  GridViewController.h
//  EAM
//
//  Created by dwolf on 16/9/9.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "BaseViewController.h"

@protocol CollectionViewControllerDelegate <NSObject>

-(UICollectionViewCell*) drawCell:(NSIndexPath *)indexPath collect:(UICollectionView*) collect;
-(void) didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

-(void)createCollectionHeader:(UIView*)view index:(NSIndexPath*)indexPath;
-(void)createCollectionFooder:(UIView*)view index:(NSIndexPath*)indexPath;

-(CGFloat)setHeaderViewHeight:(NSInteger)indexPath;
-(CGFloat)setFooderViewHeight:(NSInteger)indexPath;

@end

@interface CollectionViewController : BaseViewController{
    UICollectionView* collectionView;
    NSMutableArray* dataArr;
}
@property(nonatomic, retain) UICollectionView* collectionView;
@property(nonatomic, retain) NSMutableArray* dataArr;
//列数
@property int coloumNum;
//两列的距离
@property int itemSpace;
@property UIEdgeInsets edgeInset;
@property int itemHeight;
@property id<CollectionViewControllerDelegate> collectViewDelegate;

@end
