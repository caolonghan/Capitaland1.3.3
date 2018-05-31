//
//  MembershipCardCView.h
//  kaidexing
//
//  Created by YaoHuiQiu on 16/5/14.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MembershipCardCView : UICollectionView <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property(nonatomic, retain)NSArray * dataArr;
@property(nonatomic, retain)UIImageView * imgV;

@end
