//
//  MsgTVCell.m
//  kaidexing
//
//  Created by YaoHuiQiu on 16/5/10.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "MsgTVCell.h"

#import "Const.h"

@implementation MsgTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = UIColorFromRGB(0xf0f0f0);
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    _whiteView = [[UIView alloc] initWithFrame:CGRectMake(8, 0, CGRectGetWidth(self.bounds) - 8 * 2, 135)];
    _whiteView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:_whiteView];
    
    
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(8, 14, 251, 11)];
    _titleLab.font = COMMON_FONT;
    _titleLab.textColor = COLOR_FONT_BLACK;
    
    [_whiteView addSubview:_titleLab];
    
    
    _statusLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_titleLab.frame) + 8, CGRectGetMinY(_titleLab.frame), 29, 11)];
    _statusLab.font = DESC_FONT;
    _statusLab.textColor = UIColorFromRGB(0xff5757);
    
    [_whiteView addSubview:_statusLab];
    
    
    _dateLab = [[UILabel alloc] initWithFrame:CGRectMake(8, CGRectGetMaxY(_titleLab.frame) + 7, 251, 11)];
    _dateLab.font = INFO_FONT;
    _dateLab.textColor = COLOR_FONT_SECOND;
    
    [_whiteView addSubview:_dateLab];
    
    
    _grayLineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_dateLab.frame) + 9, CGRectGetWidth(self.bounds), 1)];
    _grayLineView.backgroundColor = COLOR_LINE;
    
    [_whiteView addSubview:_grayLineView];
    
    
    _titleLab_1 = [[UILabel alloc] initWithFrame:CGRectMake(8, CGRectGetMaxY(_grayLineView.frame) + 10, 251, 12)];
    _titleLab_1.font = COMMON_FONT;
    _titleLab_1.textColor = COLOR_FONT_SECOND;
    
    [_whiteView addSubview:_titleLab_1];
    
    
    _dateLab_1 = [[UILabel alloc] initWithFrame:CGRectMake(8, CGRectGetMaxY(_titleLab_1.frame) + 4, 251, 11)];
    _dateLab_1.font = COMMON_FONT;
    _dateLab_1.textColor = COLOR_FONT_SECOND;
    
    [_whiteView addSubview:_dateLab_1];
    
    
    _titleLab_2 = [[UILabel alloc] initWithFrame:CGRectMake(8, CGRectGetMaxY(_dateLab_1.frame) + 9, 251, 12)];
    _titleLab_2.font = COMMON_FONT;
    _titleLab_2.textColor = COLOR_FONT_BLACK;
    
    [_whiteView addSubview:_titleLab_2];
    
    
    _subtitleLab = [[UILabel alloc] initWithFrame:CGRectMake(8, CGRectGetMaxY(_titleLab_2.frame) + 4, 251, 11)];
    _subtitleLab.font = COMMON_FONT;
    _subtitleLab.textColor = COLOR_FONT_SECOND;
    
    [_whiteView addSubview:_subtitleLab];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
