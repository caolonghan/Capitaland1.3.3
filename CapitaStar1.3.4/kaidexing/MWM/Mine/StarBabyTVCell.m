//
//  StarBabyTVCell.m
//  kaidexing
//
//  Created by YaoHuiQiu on 16/5/11.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "StarBabyTVCell.h"

#import "Const.h"

@implementation StarBabyTVCell

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
    
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(M_WIDTH(15), 14,M_WIDTH(200) , 14)];
    _titleLab.font = DESC_FONT;
    _titleLab.textColor = COLOR_FONT_BLACK;
    _titleLab.text = @"凯德购物星2.0";
    [self addSubview:_titleLab];
    
    
    _dateLab = [[UILabel alloc] initWithFrame:CGRectMake(M_WIDTH(15),CGRectGetMaxY(_titleLab.frame)+5,M_WIDTH(100),11)];
    _dateLab.font = INFO_FONT;
    _dateLab.textColor = COLOR_FONT_SECOND;
    [self addSubview:_dateLab];
    
    
    _starScoreLab = [[UILabel alloc] initWithFrame:CGRectMake(WIN_WIDTH - M_WIDTH(116), 14, M_WIDTH(100), 10)];
    _starScoreLab.font = DESC_FONT;
    _starScoreLab.textColor = UIColorFromRGB(0xff7800);
    _starScoreLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:_starScoreLab];
    
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 55, WIN_WIDTH, 1)];
    view.backgroundColor = COLOR_LINE;
    
    [self addSubview:view];
}

- (void)setDataDic:(NSDictionary *)dataDic {
    
    _dataDic = dataDic;
    
    [self setNeedsLayout];
}

/*
 {”description”:”凯德龙之梦闵行”,
 “origin_count”:”500”,
 “change_count”:”-500”,
 “creat_time”:”2016-04-14 18:26:30”,
 }
 */
- (void)layoutSubviews {
    [super layoutSubviews];
    
    _titleLab.text = _dataDic[@"description"];
    
    NSString * creat_time = _dataDic[@"creat_time"];
    if(![Util isNull:creat_time] && creat_time.length > 10){
        //_dateLab.text = [creat_time substringWithRange:NSMakeRange(5, 5)];
        _dateLab.text = _dataDic[@"creat_time"];
    }
    _dateLab.text = _dataDic[@"creat_time"];
    int chagneCount = [_dataDic[@"change_count"] intValue];
    NSString* countStr = @"";
    if(chagneCount > 0 ){
        countStr = [NSString stringWithFormat:@"+%d", chagneCount ];
    }else{
        countStr = [NSString stringWithFormat:@"%d", chagneCount ];
    }
    _starScoreLab.text = countStr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
