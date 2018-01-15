//
//  EndedTVCell.m
//  sgSalerReport
//
//  Created by YaoHuiQiu on 16/5/5.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "EndedTVCell.h"

#import "Const.h"

@implementation EndedTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDataDic:(NSDictionary *)dataDic {
    
    _dataDic = dataDic;
    
    [self setNeedsLayout];
}

/*
 {
 “id”:”1”,
 “img_url”:”/webupload/1530-2/Activity/images/201508/201508011730476396.jpg”,
 “name”:”清仓大处理,全场五折优惠”,
 “dateLine”:”2016-04-18~2016-04-25”,
 “start_time”:”2016-04-18”,
 “end_time”:”2016-04-25”,
 “status”:”2”,  status=1进行中，status=2活动过期
 “summary”:”清仓大处理”
 }
 */
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_coverImgV setImageWithURL:[NSURL URLWithString:_dataDic[@"img_url"]]];
    
    _titleLab.text = _dataDic[@"name"];
    
    NSString* startTime = _dataDic[@"start_time"];
    if(startTime.length > 10){
        startTime = [startTime substringToIndex:10];
    }
    
    NSString* endTime = [Util isNil:_dataDic[@"end_time"]] ;
    if( endTime.length > 10){
        endTime = [endTime substringToIndex:10];
    }
    _dateLab.text = [NSString stringWithFormat:@"%@~%@", startTime, endTime];
    
    if ([_dataDic[@"status"] intValue ] == 1) {
        
        _statusLab.text = @"进行中";
    } else {
        _statusLab.text = @"已结束";
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
