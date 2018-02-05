//
//  MembershipCardCView.m
//  kaidexing
//
//  Created by YaoHuiQiu on 16/5/14.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "MembershipCardCView.h"

#import "MembershipCardCVCell.h"
#import "Const.h"

static NSString * identifier = @"MembershipCardCVCell";

@implementation MembershipCardCView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        
        self.dataSource = self;
        self.delegate = self;
        
        self.backgroundColor = UIColorFromRGB(0xfafafa);
        self.pagingEnabled = YES;
        self.showsVerticalScrollIndicator = NO;
        
        [self registerClass:[MembershipCardCVCell class] forCellWithReuseIdentifier:identifier];
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MembershipCardCVCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (indexPath.item == 0) {
        
        cell.bgImgName = @"凯德星";
    } else {
        cell.bgImgName = @"我的会员卡多张";
    }
    cell.dataDic = _dataArr[indexPath.item];
    
    if (indexPath.item + 1 == _dataArr.count) {
        
        self.imgV.hidden = YES;
    } else {
        self.imgV.hidden = NO;
    }
    
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
