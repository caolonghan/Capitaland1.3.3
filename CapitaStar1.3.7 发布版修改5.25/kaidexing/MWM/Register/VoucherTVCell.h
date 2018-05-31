//
//  VoucherTVCell.h
//  kaidexing
//
//  Created by YaoHuiQiu on 16/5/12.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VoucherTVCell : UITableViewCell

@property(nonatomic, retain)NSDictionary * dataDic;

@property(nonatomic, copy)NSString * imageName;

@property(nonatomic, strong)UIImageView * voucherIV;
@property(nonatomic, strong)UILabel * titleLab;
@property(nonatomic, strong)UILabel * subTitleLab;
@property(nonatomic, strong)UILabel * dateLab;
@property(nonatomic, strong)UILabel * countLab;
@property(nonatomic, strong)UIImageView * promptIV; //快过期提示
@property(nonatomic, strong)UIImageView * indicatorIV;

@end
