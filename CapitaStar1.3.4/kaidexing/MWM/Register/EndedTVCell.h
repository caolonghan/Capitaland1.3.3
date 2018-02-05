//
//  EndedTVCell.h
//  sgSalerReport
//
//  Created by YaoHuiQiu on 16/5/5.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EndedTVCell : UITableViewCell

@property(nonatomic, retain)NSDictionary * dataDic;

@property (weak, nonatomic) IBOutlet UIImageView *coverImgV;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UILabel *dateLab;

@property (weak, nonatomic) IBOutlet UILabel *statusLab;

@end
