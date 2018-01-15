//
//  LineUpViewCell.m
//  kaidexing
//
//  Created by 朱巩拓 on 16/5/24.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "LineUpViewCell.h"
#import "Const.h"
@implementation LineUpViewCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    //美食
    if ([reuseIdentifier isEqualToString:@"cellID1"]) {

        
        self.bigImgView=[[UIImageView alloc]initWithFrame:CGRectMake(M_WIDTH(6),M_WIDTH(6),M_WIDTH(85),M_WIDTH(63))];
        self.bigImgView.contentMode = UIViewContentModeScaleAspectFit;
        self.bigImgView.clipsToBounds = YES;
        
        
        self.nameLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.bigImgView.frame)+M_WIDTH(10),M_WIDTH(10),M_WIDTH(190),M_WIDTH(16))];
        self.nameLab.textAlignment=NSTextAlignmentLeft;
        self.nameLab.font=COOL_FONT;
        
        //店铺的类型
        self.explainLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.bigImgView.frame)+M_WIDTH(10), CGRectGetMaxY(self.nameLab.frame)+M_WIDTH(8),M_WIDTH(160),M_WIDTH(12))];
        self.explainLab.textAlignment=NSTextAlignmentLeft;
        self.explainLab.font=INFO_FONT;
        self.explainLab.textColor=COLOR_FONT_SECOND;
        
        //桌
        UILabel *zhuoLab=[[UILabel alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(50), CGRectGetMaxY(self.nameLab.frame)+M_WIDTH(10), M_WIDTH(50), M_WIDTH(14))];
        zhuoLab.textAlignment=NSTextAlignmentLeft;
        zhuoLab.text=@"桌";
        zhuoLab.font=DESC_FONT;
        zhuoLab.textColor=[UIColor redColor];
        //在等待
        UILabel *dengLab=[[UILabel alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(50), CGRectGetMaxY(self.explainLab.frame)+M_WIDTH(5), M_WIDTH(100), M_WIDTH(14))];
        dengLab.text=@"在等待";
        dengLab.font=DESC_FONT;
        dengLab.textAlignment=NSTextAlignmentLeft;
        
        
        //地址图标
        UIImageView *img_Down=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.bigImgView.frame)+M_WIDTH(10),CGRectGetMaxY(self.explainLab.frame)+M_WIDTH(10),M_WIDTH(8),M_WIDTH(11))];
        img_Down .contentMode=UIViewContentModeScaleAspectFit;
        [img_Down setImage:[UIImage imageNamed:@"diqu"]];
        
        //店铺地址
        self.addressLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(img_Down.frame)+M_WIDTH(2), CGRectGetMaxY(self.explainLab.frame)+M_WIDTH(9), M_WIDTH(100), M_WIDTH(12))];
        self.addressLab.font=DESC_FONT;
        self.addressLab.textColor=COLOR_FONT_SECOND;
        self.addressLab.textAlignment=NSTextAlignmentLeft;
        
        //
        self.renshuLab=[[UILabel alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(112), CGRectGetMaxY(self.nameLab.frame)+M_WIDTH(11), M_WIDTH(50), M_WIDTH(27))];
        self.renshuLab.textAlignment=NSTextAlignmentRight;
        self.renshuLab.textColor=[UIColor redColor];
        self.renshuLab.font=[UIFont systemFontOfSize:M_WIDTH(30)];
        
        UIView* lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(M_WIDTH(6), M_WIDTH(74), SCREEN_FRAME.size.width-M_WIDTH(6),M_WIDTH(1)) ;
        lineView.backgroundColor = DEFAULT_LINE_COLOR;
        
        
        [self addSubview:self.bigImgView];
        [self addSubview:self.nameLab];
        [self addSubview:self.explainLab];
        [self addSubview:self.renshuLab];
        [self addSubview:zhuoLab];
        [self addSubview:img_Down];
        [self addSubview:self.addressLab];
        [self addSubview:dengLab];
        [self addSubview:lineView];

        
    }
    
   
    return self;
}
@end
