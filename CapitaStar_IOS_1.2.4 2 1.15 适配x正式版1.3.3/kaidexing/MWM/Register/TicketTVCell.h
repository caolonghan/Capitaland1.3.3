//
//  TicketTVCell.h
//  sgSalerReport
//
//  Created by YaoHuiQiu on 16/5/6.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TicketTVCell : UITableViewCell

@property(nonatomic, retain)NSDictionary * dataDic;

@property (weak, nonatomic) IBOutlet UIView *bgWhiteView;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (weak, nonatomic) IBOutlet UILabel *peopleNumLab;

@property (weak, nonatomic) IBOutlet UILabel *locationLab;

@property (weak, nonatomic) IBOutlet UIImageView *statusImgV;

@property (weak, nonatomic) IBOutlet UILabel *statusLab;

@end
