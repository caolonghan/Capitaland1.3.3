//
//  ShopTableViewCell.h
//  kaidexing
//
//  Created by 朱巩拓 on 16/6/25.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UIImageView *leftImgView;
@property (weak, nonatomic) IBOutlet UIButton *lkdBtn;
@property (weak, nonatomic) IBOutlet UIButton *lztBtn;
@property (weak, nonatomic) IBOutlet UILabel *lnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ljfLabel;
@property (weak, nonatomic) IBOutlet UILabel *lCountLabel;

@property (weak, nonatomic) IBOutlet UIImageView *rightImgView;
@property (weak, nonatomic) IBOutlet UIButton *rkdBtn;
@property (weak, nonatomic) IBOutlet UIButton *rztBtn;
@property (weak, nonatomic) IBOutlet UILabel *rnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *rjfLabel;
@property (weak, nonatomic) IBOutlet UILabel *rCountLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lkdTrailConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rkdTrailConst;

@end
