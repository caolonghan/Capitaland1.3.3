//
//  ScoreTVCell.h
//  kaidexing
//
//  Created by YaoHuiQiu on 16/5/15.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreTVCell : UITableViewCell

@property(nonatomic, retain)NSDictionary * dataDic;

@property(nonatomic, retain)UIView * whiteView;
@property(nonatomic, retain)UILabel * titleLab;
@property(nonatomic, retain)UILabel * statusLab;
@property(nonatomic, retain)UILabel * dateLab;
@property(nonatomic, retain)UIView * grayLineView;
@property(nonatomic, retain)UILabel * titleLab_1;

@end
