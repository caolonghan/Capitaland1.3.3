//
//  MembershipCardCVCell.h
//  kaidexing
//
//  Created by YaoHuiQiu on 16/5/14.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MembershipCardCVCell : UICollectionViewCell

@property(nonatomic, retain)NSDictionary * dataDic;
@property(nonatomic, copy)NSString * bgImgName;

@property(nonatomic, retain)UIImageView * bgImgV;
@property(nonatomic, retain)UIImageView * qrCodeImgV;
@property(nonatomic, retain)UIView * view;
@property(nonatomic, retain)UILabel * nameLab;
@property(nonatomic, retain)UILabel * cardNoLab;

@end
