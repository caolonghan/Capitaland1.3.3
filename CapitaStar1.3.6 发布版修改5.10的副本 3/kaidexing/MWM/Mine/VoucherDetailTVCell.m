//
//  VoucherDetailTVCell.m
//  kaidexing
//
//  Created by YaoHuiQiu on 16/5/12.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "VoucherDetailTVCell.h"

#import "Const.h"
#import "UIView+UIViewController.h"
#import "VoucherDetailViewController.h"
#import "HeXiaoViewController.h"

@implementation VoucherDetailTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = UIColorFromRGB(0xf0f0f0);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    UIImageView * bgImgV = [[UIImageView alloc] initWithFrame:CGRectMake(7, 0, WIN_WIDTH - 7 - 8, 293)];
    bgImgV.userInteractionEnabled = YES;
    bgImgV.image = [UIImage imageNamed:@"w_bg"];
    
    [self addSubview:bgImgV];
    
    
    _coverIV = [[UIImageView alloc] initWithFrame:CGRectMake(16, 18, 34, 34)];
    _coverIV.layer.cornerRadius = 17;
    _coverIV.layer.masksToBounds = YES;
    _coverIV.backgroundColor = [UIColor cyanColor];
    
    [bgImgV addSubview:_coverIV];
    
    
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_coverIV.frame) + 7, 22, 100, 12)];
    _titleLab.font = COMMON_FONT;
    _titleLab.textColor = COLOR_FONT_BLACK;
    _titleLab.text = @"大创10元现金券";
    
    [bgImgV addSubview:_titleLab];
    
    
    _dateLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_titleLab.frame), CGRectGetMaxY(_titleLab.frame) + 5, 150, 9)];
    _dateLab.font = INFO_FONT;
    _dateLab.textColor = UIColorFromRGB(0xff4609);
    _dateLab.text = @"2015-09-30~2015-12-31";
    
    [bgImgV addSubview:_dateLab];
    
    
    UIImageView * indicatorIV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(bgImgV.bounds) - 15 -7, 28, 7, 12)];
    indicatorIV.backgroundColor = [UIColor cyanColor];
    
    [bgImgV addSubview:indicatorIV];
    
    
    _statusLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(indicatorIV.frame) - 8 - 40, CGRectGetMinY(indicatorIV.frame), 40, 11)];
    _statusLab.font = DESC_FONT;
    _statusLab.textColor = COLOR_FONT_SECOND;
    _statusLab.textAlignment = NSTextAlignmentRight;
    _statusLab.text = @"未使用";
    
    [bgImgV addSubview:_statusLab];
    
    
    UIButton * clearColorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clearColorBtn.frame = CGRectMake(10, 10, CGRectGetWidth(bgImgV.bounds) - 10 - 9, 48);
    clearColorBtn.backgroundColor = [UIColor clearColor];
    [clearColorBtn addTarget:self action:@selector(pushToVoucherDetail:) forControlEvents:UIControlEventTouchUpInside];
    
    [bgImgV addSubview:clearColorBtn];
    
    
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(WIN_WIDTH/2 -87, CGRectGetMaxY(_dateLab.frame) + 23, 40, 13)];
    label.font = DESC_FONT;
    label.textColor = COLOR_FONT_SECOND;
    label.text = @"券号：";
    
    [bgImgV addSubview:label];
    
    _voucherNum = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), CGRectGetMinY(label.frame), 133, 13)];
    _voucherNum.font = COMMON_FONT;
    _voucherNum.textColor = COLOR_FONT_BLACK;
    _voucherNum.text = @"0052 4196 5536";
    [bgImgV addSubview:_voucherNum];
    
    
    _qrCodeIV = [[UIImageView alloc] initWithFrame:CGRectMake(WIN_WIDTH/2-58, CGRectGetMaxY(_voucherNum.frame) + 13, 116, 115)];
    _qrCodeIV.backgroundColor = [UIColor cyanColor];
    
    [bgImgV addSubview:_qrCodeIV];
    
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(WIN_WIDTH/2-61, CGRectGetMaxY(_qrCodeIV.frame) + 15, 122, 38);
    btn.backgroundColor = UIColorFromRGB(0xe0292b);
    btn.layer.cornerRadius = DEFAULT_BUTTON_RADIUS;
    btn.layer.masksToBounds = YES;
    btn.titleLabel.font = COMMON_FONT;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"核销" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(heXiao:) forControlEvents:UIControlEventTouchUpInside];
    
    [bgImgV addSubview:btn];
}

- (void)pushToVoucherDetail:(UIButton *)sender {
    
    NSLog(@"跳转到卡券详情页");
}

- (void)heXiao:(UIButton *)sender {
    
    HeXiaoViewController * hxVC = [[HeXiaoViewController alloc] init];
    
    VoucherDetailViewController * vdVC = (VoucherDetailViewController *)self.viewController;
    
    [vdVC.delegate.navigationController pushViewController:hxVC animated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
