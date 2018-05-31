//
//  MyCollectionTableViewCell.m
//  kaidexing
//
//  Created by 朱巩拓 on 16/5/11.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "MyCollectionTableViewCell.h"
#import "Const.h"
@implementation MyCollectionTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
     if ([reuseIdentifier isEqualToString:@"cellID1"]) {
        self.bigImgView=[[UIImageView alloc]initWithFrame:CGRectMake(M_WIDTH(8),M_WIDTH(8),M_WIDTH(83), M_WIDTH(59))];
        self.bigImgView.contentMode=UIViewContentModeScaleAspectFill;
        self.bigImgView.clipsToBounds = YES;
        
        self.nameLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.bigImgView.frame)+M_WIDTH(10), M_WIDTH(8),M_WIDTH(120), M_WIDTH(20))];
        self.nameLab.textColor=[UIColor blackColor];
        self.nameLab.textAlignment=NSTextAlignmentLeft;
        self.nameLab.font=COMMON_FONT;
       

        //说明
        self.explainLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.bigImgView.frame)+M_WIDTH(8), CGRectGetMaxY(self.nameLab.frame)+M_WIDTH(10), M_WIDTH(180), M_WIDTH(13))];
        self.explainLab.textAlignment=NSTextAlignmentLeft;
        self.explainLab.font=DESC_FONT;
        //线
        
         //地址图标
         self.img_Down1=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.bigImgView.frame)+M_WIDTH(8),CGRectGetMaxY(self.bigImgView.frame)-M_WIDTH(14),M_WIDTH(10),M_WIDTH(13))];
//         [self.img_Down1 setImage:[UIImage imageNamed:@"diqu"]];
         
         //店铺地址
         self.addressLab=[[UILabel alloc]init];
         self.addressLab.font=DESC_FONT;
         self.addressLab.textColor=COLOR_FONT_SECOND;

         self.addressLab.textAlignment=NSTextAlignmentLeft;
         self.addressLab.frame=CGRectMake(CGRectGetMaxX(self.img_Down1.frame)+M_WIDTH(2),CGRectGetMaxY(self.bigImgView.frame)-M_WIDTH(14), M_WIDTH(150), M_WIDTH(12));
         
         UIView *lineview=[[UIView alloc]initWithFrame:CGRectMake(M_WIDTH(8),M_WIDTH(74), WIN_WIDTH-M_WIDTH(8), 1)];
         lineview.backgroundColor=COLOR_LINE;
        [self addSubview:self.bigImgView];
        [self addSubview:self.nameLab];
        [self addSubview:self.explainLab];
        [self addSubview:self.img_Down1];
        [self addSubview:self.addressLab];
        [self addSubview:lineview];
         
         
  }else if ([reuseIdentifier isEqualToString:@"cellID2"]) {
      
      
      //积分名字
      self.nameLab=[[UILabel alloc]initWithFrame:CGRectMake(10, 15, 260, 15)];
      self.nameLab.textAlignment=NSTextAlignmentLeft;
      self.nameLab.font=COMMON_FONT;
//      self.nameLab.text=@"PASDA ASDASDAF ASFDASDFASDA ";
      
      //积分状态
      self.zhuangtaiLab=[[UILabel alloc]initWithFrame:CGRectMake(WIN_WIDTH-50, 15,50, 15)];
      self.zhuangtaiLab.textAlignment=NSTextAlignmentLeft;
      self.zhuangtaiLab.font=COMMON_FONT;
      self.zhuangtaiLab.textColor=COLOR_FONT_SECOND;
//      self.zhuangtaiLab.text=@"已通过";
      
      //积分日期
      self.riqiLab=[[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.nameLab.frame)+5, 260, 15)];
      self.riqiLab.textAlignment=NSTextAlignmentLeft;
      self.riqiLab.font=DESC_FONT;
      self.riqiLab.textColor=COLOR_FONT_SECOND;
//      self.riqiLab.text=@"2016年04月15日  12.09";
      
      //积分数量
      self.jifenLab=[[UILabel alloc]initWithFrame:CGRectMake(10,CGRectGetMaxY(self.riqiLab.frame)+5, 260, 15)];
      self.jifenLab.textAlignment=NSTextAlignmentLeft;
      self.jifenLab.font=COMMON_FONT;
//      self.jifenLab.text=@"200 ";
      
      UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 80.5, WIN_WIDTH, 0.5)];
      lineView.backgroundColor=COLOR_LINE;

      
      [self addSubview:self.nameLab];
      [self addSubview:self.zhuangtaiLab];
      [self addSubview:self.riqiLab];
      [self addSubview:self.jifenLab];
      [self addSubview:lineView];
  }
    
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setDataDic:(NSDictionary *)dataDic {
    
    _dataDic = dataDic;
    
    [self setNeedsLayout];
}
/*
 {
 “ImageName”:””,
 “ReceiptCaptureDate”:””,
 “FriendlyStatus”:””,
 “QualifiedStatus”:””,
 “Mall”:””,
 “Merchant”:””,
 “Amount”:””,
 “Description”:””
 }
 */
- (void)layoutSubviews {
    [super layoutSubviews];
    
   // _nameLab.text = _dataDic[@"ImageName"];
    if( [Util isNull:_dataDic] || _dataDic == nil || _dataDic.allKeys.count == 0){
        return;
    }
    
    NSString * ReceiptCaptureDate = _dataDic[@"ReceiptCaptureDate"];
    NSString * str1 = [ReceiptCaptureDate substringToIndex:16];
    NSString * str2 = [str1 stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSDate * date = [dateFormatter dateFromString:str2];
    dateFormatter.dateFormat = @"yyyy年MM月dd日 HH:mm";
    NSString * dateStr = [dateFormatter stringFromDate:date];
//    NSString * dateStr = [dateStr ];
    
    _nameLab.text  =[Util isNil:_dataDic[@"Mall"]];
    _riqiLab.text = [NSString stringWithFormat:@"%@", dateStr];
    
    _jifenLab.text = [Util isNil:_dataDic[@"Description"]];
    
    _zhuangtaiLab.text = _dataDic[@"FriendlyStatus"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
