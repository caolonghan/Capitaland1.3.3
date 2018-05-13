//
//  MembershipCardCVCell.m
//  kaidexing
//
//  Created by YaoHuiQiu on 16/5/14.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "MembershipCardCVCell.h"

#import "Const.h"

@implementation MembershipCardCVCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    _bgImgV = [[UIImageView alloc] initWithFrame:CGRectMake((WIN_WIDTH-M_WIDTH(224))/2, M_WIDTH(90), M_WIDTH(224), M_WIDTH(338))];
    _bgImgV.layer.cornerRadius = DEFAULT_BUTTON_RADIUS;
    _bgImgV.layer.masksToBounds = YES;
    
    [self addSubview:_bgImgV];
    
    
    _qrCodeImgV = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(_bgImgV.frame) - M_WIDTH(140)) / 2, M_WIDTH(15), M_WIDTH(140), M_WIDTH(140))];
    
    [_bgImgV addSubview:_qrCodeImgV];
    
    
    //91.5-30.5 bgImgV.Height-91.5-30.5 183 61
    _view = [[UIView alloc] initWithFrame:CGRectMake(M_WIDTH(-61), CGRectGetHeight(_bgImgV.bounds) - M_WIDTH(122), M_WIDTH(183), M_WIDTH(61))];
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI / 2);
    _view.transform = transform;
    
    [_bgImgV addSubview:_view];
    
    _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(_view.bounds) - M_WIDTH(20) - M_WIDTH(100), M_WIDTH(8), M_WIDTH(100), M_WIDTH(20))];
    _nameLab.font = COMMON_FONT;
    _nameLab.textAlignment = NSTextAlignmentRight;
    _nameLab.text = @"";
    
    [_view addSubview:_nameLab];
    
    
    _cardNoLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(_view.bounds) - M_WIDTH(20) - M_WIDTH(150), CGRectGetMaxY(_nameLab.frame) + M_WIDTH(4), M_WIDTH(150), M_WIDTH(20))];
    _cardNoLab.textAlignment = NSTextAlignmentRight;
    _cardNoLab.font = COMMON_FONT;
    _cardNoLab.text = @"";
    
    [_view addSubview:_cardNoLab];
}

- (void)setDataDic:(NSDictionary *)dataDic {
    
    _dataDic = dataDic;
    
    [self setNeedsLayout];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    _bgImgV.image = [UIImage imageNamed:_bgImgName];
    [_qrCodeImgV setImageWithURL:[Util makeUIImageViewUrlWithString:_dataDic[@"capital_member_card"]]];
    _nameLab.text = _dataDic[@"spark_name"];
    _cardNoLab.text = _dataDic[@"spark_member_number"];
}

@end
