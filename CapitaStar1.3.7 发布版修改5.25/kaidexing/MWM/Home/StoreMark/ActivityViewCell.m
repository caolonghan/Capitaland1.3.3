//
//  ActivityViewCell.m
//  kaidexing
//
//  Created by 朱巩拓 on 16/5/17.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "ActivityViewCell.h"
#import "Const.h"


@implementation ActivityViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
//    int movePad = M_WIDTH(5);
    
    if([reuseIdentifier isEqualToString:@"cellID1"]) {
        
        UIView *rootView=[[UIView alloc]initWithFrame:CGRectMake(M_WIDTH(9),0,WIN_WIDTH-M_WIDTH(18),M_WIDTH(83))];
        rootView.backgroundColor=[UIColor whiteColor];
        
        self.bigImgView=[[UIImageView alloc]initWithFrame:CGRectMake(M_WIDTH(11), M_WIDTH(11), M_WIDTH(85), M_WIDTH(61))];

        self.bigImgView.contentMode=UIViewContentModeScaleAspectFill;
        self.bigImgView.clipsToBounds = YES;
        
        self.nameLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.bigImgView.frame)+M_WIDTH(5),M_WIDTH(9), M_WIDTH(80), M_WIDTH(16))];
        self.nameLab.textAlignment=NSTextAlignmentLeft;
        self.nameLab.font=COOL_FONT;

        
        //店铺的类型
        self.juliLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.bigImgView.frame)+M_WIDTH(5), CGRectGetMaxY(self.nameLab.frame)+M_WIDTH(5),M_WIDTH(50), M_WIDTH(12))];
        self.juliLab.textAlignment=NSTextAlignmentLeft;
        self.juliLab.font=INFO_FONT;
        self.juliLab.textColor=COLOR_FONT_SECOND;
        self.juliLab.layer.masksToBounds=YES;
        self.juliLab.layer.cornerRadius=self.juliLab.frame.size.height/2;
        
        //地址图标
        self.img_Down=[[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(75),CGRectGetMaxY(self.bigImgView.frame)-M_WIDTH(11) ,M_WIDTH(6), M_WIDTH(10))];
        [self.img_Down setImage:[UIImage imageNamed:@"location"]];
        
        //店铺地址
        self.addressLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.img_Down.frame)+M_WIDTH(2), CGRectGetMaxY(self.bigImgView.frame)-M_WIDTH(14) , M_WIDTH(100), M_WIDTH(13))];
        self.addressLab.font=INFO_FONT;
        self.addressLab.textColor=COLOR_FONT_SECOND;
        self.addressLab.textAlignment=NSTextAlignmentLeft;
        
        
        [self addSubview:self.bigImgView];
        [self addSubview:self.nameLab];
        [self addSubview:self.juliLab];
        [self addSubview:self.img_Down];
        [self addSubview:self.addressLab];
        UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(0, M_WIDTH(74), WIN_WIDTH,1)];
        lineView1.backgroundColor=COLOR_LINE;
        [self addSubview:lineView1];
        
        
    }else if([reuseIdentifier isEqualToString:@"cellID2"]) {
        UIView *rootView=[[UIView alloc]initWithFrame:CGRectMake(0,0,WIN_WIDTH,M_WIDTH(189))];
        rootView.backgroundColor=[UIColor whiteColor];
        
        self.bigImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,rootView.frame.size.width,M_WIDTH(150))];
        self.bigImgView.contentMode=UIViewContentModeScaleAspectFill;
        self.bigImgView.clipsToBounds = YES;
    
//        UIImageView *img1=[[UIImageView alloc]initWithFrame:CGRectMake(0,M_WIDTH(9),M_WIDTH(68),M_WIDTH(24))];
//        [img1 setImage:[UIImage imageNamed:@"announcement"]];
//        [self.bigImgView addSubview:img1];
        
        self.nameLab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(10),CGRectGetMaxY(self.bigImgView.frame),M_WIDTH(210),M_WIDTH(39))];
        
        self.nameLab.textAlignment=NSTextAlignmentLeft;
        self.nameLab.font=COMMON_FONT;
        
        //地址图标
//        self.img_Down=[[UIImageView alloc]initWithFrame:CGRectMake(M_WIDTH(13),CGRectGetMaxY(self.nameLab.frame)+M_WIDTH(3) ,M_WIDTH(12), M_WIDTH(13.5))];
//        [self.img_Down setImage:[UIImage imageNamed:@"location"]];
//        [rootView addSubview:self.img_Down];
        
        //店铺地址
//        self.addressLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.img_Down.frame)+M_WIDTH(2), CGRectGetMaxY(self.bigImgView.frame)+M_WIDTH(3) , M_WIDTH(100), M_WIDTH(12))];
//        self.addressLab.font=INFO_FONT;
//        self.addressLab.textColor=COLOR_FONT_SECOND;
//        self.addressLab.textAlignment=NSTextAlignmentLeft;
//        [rootView addSubview:self.addressLab];
        
        self.huodongType=[[UILabel alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(78),CGRectGetMaxY(_bigImgView.frame) + M_WIDTH(9),M_WIDTH(67),M_WIDTH(20))];
        self.huodongType.textColor=APP_BTN_COLOR;
        self.huodongType.textAlignment=NSTextAlignmentCenter;
        self.huodongType.layer.masksToBounds=YES;
        self.huodongType.layer.cornerRadius=self.huodongType.frame.size.height/2;
        self.huodongType.layer.borderColor = APP_BTN_COLOR.CGColor;
        self.huodongType.layer.borderWidth =1;
        self.huodongType.font=INFO_FONT;
        
        
//        UIImageView *img2=[[UIImageView alloc]initWithFrame:CGRectMake(rootView.frame.size.width-M_WIDTH(65),CGRectGetMaxY(self.bigImgView.frame)+M_WIDTH(16),M_WIDTH(65),M_WIDTH(26))];
//        [img2 setImage:[UIImage imageNamed:@"collection"]];
//        [rootView addSubview:img2];
        
        
        [rootView addSubview:self.bigImgView];
        [rootView addSubview:self.nameLab];
        [rootView addSubview:self.huodongType];
        [self addSubview:rootView];
    }

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
