//
//  StarScoreTVCell.m
//  kaidexing
//
//  Created by YaoHuiQiu on 16/5/11.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "StarScoreTVCell.h"

#import "Const.h"

@implementation StarScoreTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(8, 14, 200, 10)];
    _titleLab.font = DESC_FONT;
    _titleLab.textColor = COLOR_FONT_BLACK;
    _titleLab.text = @"上海来福士广场";
    [self addSubview:_titleLab];
    
    
    _dateLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_titleLab.frame), CGRectGetMaxY(_titleLab.frame) + 7, 100, 10)];
    _dateLab.font = INFO_FONT;
    _dateLab.textColor = COLOR_FONT_SECOND;
    _dateLab.text = @"08-08";
    [self addSubview:_dateLab];
    
    
    _starScoreLab = [[UILabel alloc] initWithFrame:CGRectMake(WIN_WIDTH - 8 - 100, 14, 100, 10)];
    _starScoreLab.font = INFO_FONT;
    _starScoreLab.textColor = UIColorFromRGB(0xff7800);
    _starScoreLab.textAlignment = NSTextAlignmentRight;
    _starScoreLab.text = @"+100";
    [self addSubview:_starScoreLab];
    
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(8, 55, WIN_WIDTH - 8, 1)];
    view.backgroundColor = COLOR_LINE;
    
    [self addSubview:view];
}

- (void)setDataDic:(NSDictionary *)dataDic {
    
    _dataDic = dataDic;
    
    [self setNeedsLayout];
}
/*
 {”description”:”凯德龙之梦闵行”,
 “origin_count”:”+500”,
 “change_count”:”0”,
 “creat_time”:”2016-03-14 18:26:30”,
 }*/
- (void)layoutSubviews {
    [super layoutSubviews];
    
    _titleLab.text = [NSString stringWithFormat:@"%@",_dataDic[@"description"]];
    
//    NSString * creat_time = _dataDic[@"creat_time"];
//    _dateLab.text = [creat_time substringWithRange:NSMakeRange(5, 5)];
    _dateLab.text = [NSString stringWithFormat:@"%@",_dataDic[@"creat_time"]];
    
    _starScoreLab.text = [NSString stringWithFormat:@"%@",_dataDic[@"origin_count"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
