//
//  SearchDetailsCell.m
//  sgSalerReport
//
//  Created by 朱巩拓 on 16/5/7.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "SearchDetailsCell.h"
#import "Const.h"
@implementation SearchDetailsCell



-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    //美食
//    self.bigImgView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 77, 55)];
    if ([reuseIdentifier isEqualToString:@"cellID1"]) {

        self.nameLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.bigImgView.frame)+8, 10, 153, 14)];
        self.nameLab.text=@"";
        self.nameLab.textAlignment=NSTextAlignmentLeft;
        self.nameLab.font=COMMON_FONT;
        self.nameLab.textColor = COLOR_FONT_BLACK;
        
        
        //促销
        UILabel *cuLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.nameLab.frame)+5, 11, 11, 12)];
        cuLab.backgroundColor=UIColorFromRGB(0xf1ba25);
        cuLab.text=@"促";
        cuLab.font=DESC_FONT;
        [self addSubview:cuLab];
        
        //排
        UILabel *paiLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(cuLab.frame)+7, 11, 11, 12)];
        paiLab.backgroundColor=UIColorFromRGB(0xaabeb);
        paiLab.text=@"排";
        paiLab.font=DESC_FONT;
        [self addSubview:paiLab];
        
        //美食餐饮标志
        UIImageView *img_Up=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.bigImgView.frame)+8, CGRectGetMaxY(self.nameLab.frame)+8, 12, 9)];
        [img_Up setImage:[UIImage imageNamed:@"chushi"]];
        
        //店铺介绍
        self.explainLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.bigImgView.frame)+20, CGRectGetMaxY(self.nameLab.frame)+8, 100, 12)];
        self.explainLab.text=@"美食餐饮";
        self.explainLab.textAlignment=NSTextAlignmentLeft;
        self.explainLab.font=DESC_FONT;
        self.explainLab.textColor=COLOR_FONT_SECOND;
        
        //地址图标
        UIImageView *img_Down=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.bigImgView.frame)+8, CGRectGetMaxY(img_Up.frame)+6,9, 10)];
        [img_Down setImage:[UIImage imageNamed:@"diqu"]];
        
        //店铺地址
        self.addressLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.bigImgView.frame)+20, CGRectGetMaxY(self.explainLab.frame)+5, 100, 12)];
        self.addressLab.text=@"凯德之梦";
        self.addressLab.font=DESC_FONT;
        self.addressLab.textColor=COLOR_FONT_SECOND;
        self.addressLab.textAlignment=NSTextAlignmentLeft;
        
        //地图标记右边的线
        UIView *cell_line_Y=[[UIView alloc]initWithFrame:CGRectMake(WIN_WIDTH-52, 15, 0.5, 36)];
        cell_line_Y.backgroundColor=UIColorFromRGB(0x999999);
        
        //地图箭头
        UIImageView *mapImg=[[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH-35, 25, 16, 16)];
        [mapImg setImage:[UIImage imageNamed:@"juli_red"]];
        
        
        
        
        [self addSubview:self.bigImgView];
        [self addSubview:self.nameLab];
        [self addSubview:img_Up];
        [self addSubview:self.explainLab];
        [self addSubview:img_Down];
        [self addSubview:self.addressLab];
        [self addSubview:cell_line_Y];
        [self addSubview:mapImg];
        
        
        
    }else if([reuseIdentifier isEqualToString:@"cellID3"]) {
        //商场找店
        self.bigImgView=[[UIImageView alloc]initWithFrame:CGRectMake(M_WIDTH(10), M_WIDTH(10), M_WIDTH(77), M_WIDTH(55))];
        
        self.nameLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.bigImgView.frame)+M_WIDTH(8), M_WIDTH(9),SCREEN_FRAME.size.width - M_WIDTH(10) - CGRectGetMaxX(self.bigImgView.frame)- M_WIDTH(8), M_WIDTH(16))];
        self.nameLab.textAlignment=NSTextAlignmentLeft;
        self.nameLab.font=COOL_FONT;
        
        //店铺的类型
        self.explainLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.bigImgView.frame)+8, CGRectGetMaxY(self.nameLab.frame)+M_WIDTH(8), M_WIDTH(100), M_WIDTH(12))];
        self.explainLab.textAlignment=NSTextAlignmentLeft;
        self.explainLab.font=INFO_FONT;
        self.explainLab.textColor=[UIColor blackColor];
        
        
        //地址图标
        UIImageView *img_Down=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.bigImgView.frame)+8,CGRectGetMaxY(self.bigImgView.frame)-M_WIDTH(13),M_WIDTH(10), M_WIDTH(13))];
         [img_Down setImage:[UIImage imageNamed:@"diqu"]];
        img_Down.contentMode = UIViewContentModeScaleAspectFill;
        img_Down.clipsToBounds = YES;
        
        //店铺地址
        self.addressLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(img_Down.frame)+M_WIDTH(2), CGRectGetMaxY(self.bigImgView.frame)-M_WIDTH(12), M_WIDTH(100), M_WIDTH(12))];
        self.addressLab.font=INFO_FONT;
        self.addressLab.textColor=COLOR_FONT_SECOND;
        self.addressLab.textAlignment=NSTextAlignmentLeft;
        
        UIView *view_x=[[UIView alloc]initWithFrame:CGRectMake(M_WIDTH(10),M_WIDTH(75),WIN_WIDTH, 1)];
        view_x.backgroundColor=COLOR_LINE;
        [self addSubview:view_x];
        
        [self addSubview:self.bigImgView];
        [self addSubview:self.nameLab];
        [self addSubview:self.explainLab];
        [self addSubview:img_Down];
        [self addSubview:self.addressLab];
        
        
        
    }else if([reuseIdentifier isEqualToString:@"cellID4"]) {
        
        //美食cell
        UIView *rootView=[[UIView alloc]initWithFrame:CGRectMake(M_WIDTH(9),0,WIN_WIDTH-M_WIDTH(18),M_WIDTH(91))];
        rootView.backgroundColor=[UIColor whiteColor];
        self.bigImgView=[[UIImageView alloc]initWithFrame:CGRectMake(M_WIDTH(11), M_WIDTH(11), M_WIDTH(85), M_WIDTH(61))];
        
        //标题
        self.nameLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.bigImgView.frame)+M_WIDTH(5),M_WIDTH(9),rootView.frame.size.width -M_WIDTH(110), M_WIDTH(16))];
        self.nameLab.textAlignment=NSTextAlignmentLeft;
        self.nameLab.font=COOL_FONT;
        
        //是否推荐img
        self.istuijianIMG=[[UIImageView alloc]initWithFrame:CGRectMake(rootView.frame.size.width-M_WIDTH(35),0,M_WIDTH(26),M_WIDTH(32))];
        self.istuijianIMG.contentMode=UIViewContentModeScaleAspectFit;
        self.istuijianIMG.userInteractionEnabled=YES;
        [self.istuijianIMG setImage:[UIImage imageNamed:@"recommend"]];
        
        //人均
        self.explainLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.bigImgView.frame)+M_WIDTH(5), CGRectGetMaxY(self.nameLab.frame)+M_WIDTH(5),M_WIDTH(50), M_WIDTH(12))];
        self.explainLab.textColor=[UIColor blackColor];
        self.explainLab.textAlignment=NSTextAlignmentCenter;
        self.explainLab.font=INFO_FONT;
        self.explainLab.layer.masksToBounds=YES;
        self.explainLab.layer.cornerRadius=self.explainLab.frame.size.height/2;
        
        //地址图标
        UIImageView *img_Down1=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.bigImgView.frame)+M_WIDTH(5),CGRectGetMaxY(self.bigImgView.frame)-M_WIDTH(14), M_WIDTH(11), M_WIDTH(12))];
        [img_Down1 setImage:[UIImage imageNamed:@"location"]];
        
        //店铺地址
        self.addressLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(img_Down1.frame)+M_WIDTH(2),CGRectGetMaxY(self.bigImgView.frame)-M_WIDTH(13), M_WIDTH(100), M_WIDTH(12))];
        self.addressLab.font=INFO_FONT;
        self.addressLab.textColor=COLOR_FONT_SECOND;
        self.addressLab.textAlignment=NSTextAlignmentLeft;
        
        //距离
        self.juliLab=[[UILabel alloc]initWithFrame:CGRectMake(rootView.frame.size.width-M_WIDTH(150),CGRectGetMaxY(self.bigImgView.frame)-M_WIDTH(13),M_WIDTH(135),M_WIDTH(13))];
        self.juliLab.font=INFO_FONT;
        self.juliLab.textColor=COLOR_FONT_SECOND;
        self.juliLab.textAlignment=NSTextAlignmentRight;
        
        UIView *buttomView =[[UIView alloc]initWithFrame:CGRectMake(0,M_WIDTH(83),WIN_WIDTH-M_WIDTH(18),M_WIDTH(8))];
        buttomView.backgroundColor = UIColorFromRGB(0xf3f3f3);
        
        [rootView addSubview:self.bigImgView];
        [rootView addSubview:self.nameLab];
//        [rootView addSubview:self.istuijianIMG];
        [rootView addSubview:self.explainLab];
        [rootView addSubview:img_Down1];
        [rootView addSubview:self.addressLab];
        [rootView addSubview:self.juliLab];
        [rootView addSubview:buttomView];
        [self addSubview:rootView];
        
    }else if([reuseIdentifier isEqualToString:@"cellID5"]) {
        
        self.bigImgView=[[UIImageView alloc]initWithFrame:CGRectMake(8,8,69, 50)];
        self.bigImgView.contentMode=UIViewContentModeScaleAspectFit;
        self.bigImgView.clipsToBounds = YES;
        
        self.nameLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.bigImgView.frame)+10,13,180,14)];
        self.nameLab.text=@"时尚迷你风扇";
        self.nameLab.textAlignment=NSTextAlignmentLeft;
        self.nameLab.font=COMMON_FONT;
      
        //需要兑换的星币数量
        self.explainLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.bigImgView.frame)+10, CGRectGetMaxY(self.nameLab.frame)+13, 135, 13)];
        self.explainLab.text=@"1000星币";
        self.explainLab.textAlignment=NSTextAlignmentLeft;
        self.explainLab.font=DESC_FONT;
        self.explainLab.textColor=UIColorFromRGB(0xff4100);
        
        [self addSubview:self.bigImgView];
        [self addSubview:self.nameLab];
        [self addSubview:self.explainLab];

        
    } else if([reuseIdentifier isEqualToString:@"cellID6"]) {
        //城市内找店
        self.bigImgView=[[UIImageView alloc]initWithFrame:CGRectMake(M_WIDTH(10), M_WIDTH(5.5), M_WIDTH(77), M_WIDTH(55))];
        
        self.nameLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.bigImgView.frame)+M_WIDTH(6), M_WIDTH(8),M_WIDTH(190), M_WIDTH(16))];
        self.nameLab.textAlignment=NSTextAlignmentLeft;
        self.nameLab.font=COOL_FONT;
        
        UIImageView *img_up=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.bigImgView.frame)+M_WIDTH(7),CGRectGetMaxY(self.nameLab.frame)+M_WIDTH(8),M_WIDTH(12), M_WIDTH(13))];
        [img_up setImage:[UIImage imageNamed:@"chushi"]];
        
        
        //店铺的类型
        self.explainLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.bigImgView.frame)+M_WIDTH(8), CGRectGetMaxY(self.nameLab.frame)+M_WIDTH(10),M_WIDTH(190), M_WIDTH(12))];
        self.explainLab.textAlignment=NSTextAlignmentLeft;
        self.explainLab.font=INFO_FONT;
        self.explainLab.textColor=[UIColor blackColor];
        
        
        //地址图标
        UIImageView *img_Down1=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.bigImgView.frame)+M_WIDTH(7),M_WIDTH(47),M_WIDTH(10), M_WIDTH(13))];
        [img_Down1 setImage:[UIImage imageNamed:@"diqu"]];
        
        //店铺地址
        self.addressLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(img_Down1.frame)+2, CGRectGetMaxY(self.explainLab.frame)+M_WIDTH(4), M_WIDTH(190), M_WIDTH(12))];
        self.addressLab.font=INFO_FONT;
        self.addressLab.textColor=COLOR_FONT_SECOND;
        self.addressLab.textAlignment=NSTextAlignmentLeft;
        
        UIView *y_linView1=[[UIView  alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(52), M_WIDTH(10), M_WIDTH(1), M_WIDTH(42))];
        y_linView1.backgroundColor=COLOR_LINE;
        
//        chushi
        //地图箭头
        UIImageView *mapImg=[[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(35), M_WIDTH(25), M_WIDTH(16), M_WIDTH(16))];
        [mapImg setImage:[UIImage imageNamed:@"juli_red"]];
        
        
        UIView  *view_x=[[UIView alloc]initWithFrame:CGRectMake(0,M_WIDTH(65), WIN_WIDTH, M_WIDTH(1))];
        view_x.backgroundColor=COLOR_LINE;
        [self addSubview:view_x];
        
        
        [self addSubview:self.bigImgView];
        [self addSubview:self.nameLab];
        [self addSubview:self.explainLab];
//        [self addSubview:img_up];
        [self addSubview:img_Down1];
        [self addSubview:self.addressLab];
        [self addSubview:y_linView1];
        [self addSubview:mapImg];
        
        
    }
    
    
    
    self.bigImgView.contentMode=UIViewContentModeScaleAspectFill;
    self.bigImgView.clipsToBounds = YES;
    return self;
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
