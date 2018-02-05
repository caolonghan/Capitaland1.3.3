//
//  ScoreTVCell.m
//  kaidexing
//
//  Created by YaoHuiQiu on 16/5/15.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "ScoreTVCell.h"

#import "Const.h"

@implementation ScoreTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        self.backgroundColor = UIColorFromRGB(0xf0f0f0);
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    _whiteView = [[UIView alloc] initWithFrame:CGRectMake(8, 0, WIN_WIDTH - 8 * 2, 135)];
    _whiteView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:_whiteView];
    
    
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(8, 14, 251, 11)];
    _titleLab.font = COMMON_FONT;
    _titleLab.textColor = COLOR_FONT_BLACK;
    _titleLab.text = @"titleLab";
    
    [_whiteView addSubview:_titleLab];
    
    
    _statusLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(_whiteView.bounds) - 8 - 29, CGRectGetMinY(_titleLab.frame), 29, 11)];
    _statusLab.font = DESC_FONT;
    _statusLab.textColor = COLOR_FONT_SECOND;
    
    [_whiteView addSubview:_statusLab];
    
    
    _dateLab = [[UILabel alloc] initWithFrame:CGRectMake(8, CGRectGetMaxY(_titleLab.frame) + 7, 251, 11)];
    _dateLab.font = DESC_FONT;
    _dateLab.textColor = COLOR_FONT_SECOND;
    
    [_whiteView addSubview:_dateLab];
    
    
    _grayLineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_dateLab.frame) + 9, CGRectGetWidth(_whiteView.bounds), 1)];
    _grayLineView.backgroundColor = COLOR_LINE;
    
    [_whiteView addSubview:_grayLineView];
    
    
    _titleLab_1 = [[UILabel alloc] initWithFrame:CGRectMake(8, CGRectGetMaxY(_grayLineView.frame) + 10, CGRectGetWidth(self.bounds) - 16, 21)];
    _titleLab_1.font = COMMON_FONT;
    _titleLab_1.textColor = COLOR_FONT_SECOND;
    _titleLab_1.numberOfLines = 0;
    
    
    [_whiteView addSubview:_titleLab_1];
}

- (void)setDataDic:(NSDictionary *)dataDic {
    
    _dataDic = dataDic;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _titleLab.text = _dataDic[@"title"];
    
    NSString* time = [_dataDic[@"add_time"] stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    
    if(time.length > 19){
        time = [time substringToIndex:19];
    }
    
    _dateLab.text = time;
    
    _statusLab.text = _dataDic[@"Is_read"];
    if ([[_dataDic[@"is_read"] stringValue] isEqualToString:@"0"]) {
        
        _statusLab.textColor = [UIColor redColor];
    }else{
        _statusLab.textColor = COLOR_FONT_SECOND;
    }
    NSString * str = _dataDic[@"msg"];
    NSString * str1;
    NSString * str2;
    str1 = [str stringByReplacingOccurrencesOfString:@"</p>" withString:@"\n"];
    
    NSRange range = [str1 rangeOfString:@"<"];
    while(range.location != NSNotFound){
        NSRange endRange = [str1 rangeOfString:@">"];
        range.length = endRange.location + 1 - range.location;
        str1 = [str1 stringByReplacingCharactersInRange:range withString:@""];
        range = [str1 rangeOfString:@"<"];
    }
    
    range = NSMakeRange(str1.length - 1, 1);
    NSString* subStr = [str1 substringWithRange:range];
    while ([subStr isEqualToString:@"\r"] || [subStr isEqualToString:@"\n"]) {
        str1 = [str1 stringByReplacingCharactersInRange:range withString:@""];
        range = NSMakeRange(str1.length - 1, 1);
        subStr = [str1 substringWithRange:range];
    }
    range = NSMakeRange(0, 1);
    subStr = [str1 substringWithRange:range];
    while ([subStr isEqualToString:@"\r"] || [subStr isEqualToString:@"\n"]) {
        str1 = [str1 stringByReplacingCharactersInRange:range withString:@""];
        range = NSMakeRange(0, 1);
        subStr = [str1 substringWithRange:range];
    }
    
    
    //    \n
    _titleLab_1.text =str1;
    
    CGRect rect1=[_titleLab_1.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.bounds) - 16,CGRectGetHeight(_whiteView.frame) - 8) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_titleLab_1.font} context:nil];
    _titleLab_1.frame=CGRectMake(_titleLab_1.frame.origin.x, _titleLab_1.frame.origin.y, rect1.size.width, rect1.size.height);
    
    CGRect rect = _whiteView.frame;
    rect.size.height = CGRectGetMaxY(_titleLab_1.frame) + 8;
    _whiteView.frame = rect;
    
//    CGRect frame = self.frame;
//    frame.size.height = CGRectGetMaxY(_titleLab_1.frame) + 8;
//    self.frame = frame;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
