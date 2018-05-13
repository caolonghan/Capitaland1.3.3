//
//  TicketTVCell.m
//  sgSalerReport
//
//  Created by YaoHuiQiu on 16/5/6.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "TicketTVCell.h"

#import "Const.h"

@implementation TicketTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    _bgWhiteView.layer.cornerRadius = 10;
//    _bgWhiteView.layer.masksToBounds = YES;
    _bgWhiteView.layer.borderWidth = 1;
    _bgWhiteView.layer.borderColor = UIColorFromRGB(0xf3f3f3).CGColor;
}

- (void)setDataDic:(NSDictionary *)dataDic {
    
    _dataDic = dataDic;
    
    [self setNeedsLayout];
}

/*
 {
 “merchant_id”:”1”,
 “merchant_name”:”小辉哥火锅”,
 “add_time”:”2016-04-18 15:30”,
 “peopleNum”:”5”,
 “floor_name”:”3层”,
 “tableNum”:”K23”,
 “state”:”1”    state字段：0取号中，4叫号中，5 已就餐，6/7已过号，11已取消，其他 排队中
 }
 */
- (void)layoutSubviews {
    [super layoutSubviews];
    
    _titleLab.text = _dataDic[@"merchant_name"];
    
    _timeLab.text = [NSString stringWithFormat:@"排号时间：%@", _dataDic[@"add_time"]];
    
    _peopleNumLab.text = [NSString stringWithFormat:@"排号人数：%@", _dataDic[@"peopleNum"]];
    
    _locationLab.text = [NSString stringWithFormat:@"%@/%@", _dataDic[@"floor_name"], _dataDic[@"tableNum"]];
    
    if ([_dataDic[@"state"] isEqualToString:@"0"]) {
        
        _statusLab.text = @"取号中";
        _statusLab.textColor = UIColorFromRGB(0x50d7aa);
        _statusImgV.image = [UIImage imageNamed:@""];
        
    } else if ([_dataDic[@"state"] isEqualToString:@"4"]) {
        
        _statusLab.text = @"叫号中";
        _statusLab.textColor = UIColorFromRGB(0x50d7aa);
        _statusImgV.image = [UIImage imageNamed:@""];
        
    } else if ([_dataDic[@"state"] isEqualToString:@"5"]) {
        
        _statusLab.text = @"已就餐";
        _statusLab.textColor = COLOR_FONT_SECOND;
        _statusImgV.image = [UIImage imageNamed:@""];
        
    } else if ([_dataDic[@"state"] isEqualToString:@"6"] || [_dataDic[@"state"] isEqualToString:@"7"]) {
        
        _statusLab.text = @"已过号";
        _statusLab.textColor = COLOR_FONT_SECOND;
        _statusImgV.image = [UIImage imageNamed:@""];
        
    } else if ([_dataDic[@"state"] isEqualToString:@"11"]) {
        
        _statusLab.text = @"已取消";
        _statusLab.textColor = COLOR_FONT_SECOND;
        _statusImgV.image = [UIImage imageNamed:@""];
        
    } else {
        
        _statusLab.text = @"排队中";
        _statusLab.textColor = UIColorFromRGB(0x50d7aa);
        _statusImgV.image = [UIImage imageNamed:@""];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
