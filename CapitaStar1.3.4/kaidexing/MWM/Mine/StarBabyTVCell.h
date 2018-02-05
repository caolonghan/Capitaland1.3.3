//
//  StarBabyTVCell.h
//  kaidexing
//
//  Created by YaoHuiQiu on 16/5/11.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StarBabyTVCell : UITableViewCell

@property(nonatomic, retain)NSDictionary * dataDic;

@property(nonatomic, strong)UILabel * titleLab;
@property(nonatomic, strong)UILabel * dateLab;
@property(nonatomic, strong)UILabel * starScoreLab;

@end
