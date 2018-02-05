//
//  VoucherTVCell.m
//  kaidexing
//
//  Created by YaoHuiQiu on 16/5/12.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "VoucherTVCell.h"

#import "Const.h"

@implementation VoucherTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = UIColorFromRGB(0xfafafa);
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    UIImageView * bgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_FRAME.size.width - 20, 78)];
    bgView.image = [UIImage imageNamed:@"sawtooth_bg"];
   // bgView.contentMode =  UIViewContentModeScaleAspectFill;
  //  bgView.clipsToBounds = YES;
    
    [self addSubview:bgView];
    
    
    _voucherIV = [[UIImageView alloc] initWithFrame:CGRectMake(10 + 19, 23, 34, 34)];
    _voucherIV.layer.cornerRadius = 17;
    _voucherIV.layer.masksToBounds = YES;
    _voucherIV.contentMode =  UIViewContentModeScaleAspectFill;
    _voucherIV.clipsToBounds = YES;

    
    [bgView addSubview:_voucherIV];
    
    
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_voucherIV.frame) + 8, 19, SCREEN_FRAME.size.width - CGRectGetMaxX(_voucherIV.frame) - _voucherIV.frame.size.width - 10, 12)];
    _titleLab.font = COMMON_FONT;
    _titleLab.textColor = COLOR_FONT_BLACK;
    _titleLab.text = @"";
    
    [bgView addSubview:_titleLab];
    
    
    _subTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_titleLab.frame), CGRectGetMaxY(_titleLab.frame) + 6, SCREEN_FRAME.size.width - CGRectGetMinX(_titleLab.frame) - 5 - 10, 11)];
    _subTitleLab.font = DESC_FONT;
    _subTitleLab.textColor = COLOR_FONT_BLACK;
    _subTitleLab.text = @"";
    
    [bgView addSubview:_subTitleLab];
    
    
    _dateLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_titleLab.frame), CGRectGetMaxY(_subTitleLab.frame) + 6, SCREEN_FRAME.size.width - CGRectGetMinX(_titleLab.frame) - 5 - 10, 10)];
    _dateLab.font = INFO_FONT;
    _dateLab.textColor = UIColorFromRGB(0xff4609);
    _dateLab.text = @"";
    
    [bgView addSubview:_dateLab];
    
    
    _indicatorIV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(bgView.bounds)-16-6, 36, 6, 10)];
    _indicatorIV.image = [UIImage imageNamed:@"Arrow_kdx"];
    
    [bgView addSubview:_indicatorIV];
    
    
    _promptIV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(bgView.bounds)-30-57, 10, 57, 57)];
    _promptIV.image = [UIImage imageNamed:@"signet"];
    _promptIV.hidden = YES;
    
    [bgView addSubview:_promptIV];
    
    
    _countLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_indicatorIV.frame)-6-30, CGRectGetMinY(_indicatorIV.frame),30, 10)];
    _countLab.font = DESC_FONT;
    _countLab.textAlignment=NSTextAlignmentRight;
    _countLab.textColor = COLOR_FONT_SECOND;
    _countLab.text = @"";
    
    [bgView addSubview:_countLab];
}

- (void)setDataDic:(NSDictionary *)dataDic {
    
    _dataDic = dataDic;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //卡券类型，可用、已使用、过期，快过期
    if ([_dataDic[@"coupons_type"]  integerValue] == 0) {
        //0：代金券
        if ([_dataDic[@"status"]  integerValue]  == 0 ) {
            
            _imageName = @"coupon";
            
        } else if ([_dataDic[@"status"]  integerValue]  == 1 || [_dataDic[@"status"]  integerValue]  == 2 ) {
            
            _imageName = @"gray_coupon";
            
        } else if ([_dataDic[@"status"]  integerValue]  == 3) {
            
            _imageName = @"coupon";
            _promptIV.hidden = NO;
        }
        
    } else if ([_dataDic[@"coupons_type"]  integerValue] == 1) {
        //1：抵用券
        if ([_dataDic[@"status"]  integerValue]  == 0) {
            
            _imageName = @"voucher";
            
        } else if ([_dataDic[@"status"]  integerValue]  == 1 || [_dataDic[@"status"]  integerValue]  == 2) {
            
            _imageName = @"gray_voucher";
            
        } else if ([_dataDic[@"status"]  integerValue]  == 3) {
            
            _imageName = @"voucher";
            _promptIV.hidden = NO;
        }
        
    } else if ([_dataDic[@"coupons_type"] integerValue] == 2 ) {
        //2：停车券
        if ([_dataDic[@"status"]  integerValue]  == 0) {
            
            _imageName = @"parking coupon";
            
        } else if ([_dataDic[@"status"]  integerValue]  == 1 || [_dataDic[@"status"]  integerValue]  == 2) {
            
            _imageName = @"gray_parking";
            
        } else if ([_dataDic[@"status"]  integerValue]  == 3) {
            
            _imageName = @"parking coupon";
            _promptIV.hidden = NO;
        }
    }
    _voucherIV.image = [UIImage imageNamed:_imageName];
    
    _titleLab.text = _dataDic[@"title"];
    
    //@"适用商户-上海来福士广场等";
    _subTitleLab.text = [NSString stringWithFormat:@"适用商户-%@", _dataDic[@"mall_name"]];
    
    NSString* startDataStr = @"";
    NSString* endDataStr = @"";
    if(![Util isNull:_dataDic[@"start_time"]]){
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy/M/d H:mm:ss";
        NSData* startDt = [formatter dateFromString:_dataDic[@"start_time"]];
        NSData* endDate = [formatter dateFromString:_dataDic[@"end_time"]];
        formatter.dateFormat = @"yyyy/M/d";
        startDataStr = [formatter stringFromDate:startDt];
        endDataStr = [formatter stringFromDate:endDate];
        
    }
    _dateLab.text = [NSString stringWithFormat:@"%@~%@", startDataStr, endDataStr];
    
    _countLab.text = [NSString stringWithFormat:@"%@", _dataDic[@"num"] ];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
