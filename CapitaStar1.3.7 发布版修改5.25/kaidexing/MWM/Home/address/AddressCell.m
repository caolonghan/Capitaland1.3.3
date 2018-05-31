//
//  AddressCell.m
//  kaidexing
//
//  Created by 朱巩拓 on 16/5/14.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "AddressCell.h"
#import "Const.h"
@implementation AddressCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier index:(NSInteger)index
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if ([reuseIdentifier isEqualToString:@"cellID1"]) {
        
        self.nameLab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(10), M_WIDTH(14), M_WIDTH(150), M_WIDTH(17))];
        self.nameLab.textAlignment=NSTextAlignmentLeft;
        self.nameLab.font=COMMON_FONT;
        [self addSubview:self.nameLab];
        
        self.phoneLab=[[UILabel alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(120), M_WIDTH(14), M_WIDTH(113), M_WIDTH(17))];
        self.phoneLab.textAlignment=NSTextAlignmentRight;
        self.phoneLab.font=COMMON_FONT;
        [self addSubview:self.phoneLab];
        
        self.dizhiLab=[[UILabel alloc]initWithFrame:CGRectMake(10,CGRectGetMaxY(self.nameLab.frame)+M_WIDTH(10),WIN_WIDTH-M_WIDTH(20), M_WIDTH(15))];
        self.dizhiLab.textAlignment=NSTextAlignmentLeft;
        self.dizhiLab.font=DESC_FONT;
        self.dizhiLab.textColor=COLOR_FONT_SECOND;
        [self addSubview:self.dizhiLab];
        
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.dizhiLab.frame)+M_WIDTH(13), WIN_WIDTH, 1)];
        lineView.backgroundColor=COLOR_LINE;
        [self addSubview:lineView];
        
        //是否为默认地址状态
        self.zhuangtaiImg=[[UIImageView alloc]initWithFrame:CGRectMake(M_WIDTH(10), CGRectGetMaxY(lineView.frame)+M_WIDTH(12), M_WIDTH(18), M_WIDTH(18))];
        [self.zhuangtaiImg setUserInteractionEnabled:YES];
        
        self.zhuangtaiLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.zhuangtaiImg.frame)+M_WIDTH(7), CGRectGetMaxY(lineView.frame)+M_WIDTH(13),M_WIDTH(120),M_WIDTH(16))];
        self.zhuangtaiLab.textAlignment=NSTextAlignmentLeft;
        self.zhuangtaiLab.textColor=[UIColor blackColor];
        self.zhuangtaiLab.font=COMMON_FONT;
        [self addSubview:self.zhuangtaiImg];
        [self addSubview:self.zhuangtaiLab];
   
        UIButton *zhuangtaiBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, M_WIDTH(75), M_WIDTH(150), M_WIDTH(30))];
        zhuangtaiBtn.titleLabel.font=COMMON_FONT;
        [zhuangtaiBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        zhuangtaiBtn.tag=index;
        [zhuangtaiBtn addTarget:self action:@selector(zhuangtaiTouch:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:zhuangtaiBtn];
        //编辑
        UIButton *bianjiImg=[[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(155), CGRectGetMaxY(lineView.frame)+M_WIDTH(8), M_WIDTH(65), M_WIDTH(25))];
        bianjiImg.tag=index;
        [bianjiImg setBackgroundImage:[UIImage imageNamed:@"editor"] forState:UIControlStateNormal];
        [bianjiImg addTarget:self action:@selector(bianjiTouch:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bianjiImg];
     
        //删除
        UIButton *shanchuImg=[[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(80), CGRectGetMaxY(lineView.frame)+M_WIDTH(8),M_WIDTH(65),M_WIDTH(25))];
        shanchuImg.tag=index;
        [shanchuImg setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        [shanchuImg addTarget:self action:@selector(deleteTouch:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:shanchuImg];
   
        
    }else if([reuseIdentifier isEqualToString:@"cellID2"]){
        
        self.nameLab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(10),M_WIDTH( 14), M_WIDTH(60), M_WIDTH(17))];
        self.nameLab.textAlignment=NSTextAlignmentLeft;
        self.nameLab.font=COMMON_FONT;
        [self addSubview:self.nameLab];
        
        self.phoneLab=[[UILabel alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(120), M_WIDTH(14), M_WIDTH(113), M_WIDTH(17))];
        self.phoneLab.textAlignment=NSTextAlignmentRight;
        self.phoneLab.font=COMMON_FONT;
        [self addSubview:self.phoneLab];
        
        //默认文字
        
        UILabel *morenLab=[[UILabel alloc]initWithFrame:CGRectMake(10,CGRectGetMaxY(self.nameLab.frame)+M_WIDTH(10), M_WIDTH(37), M_WIDTH(15))];
        NSString *string=[NSString stringWithFormat:@"%@%@%@",@"[",@"默认",@"]"];
        morenLab.text=string;
        morenLab.textColor=[UIColor redColor];
        morenLab.textAlignment=NSTextAlignmentLeft;
        morenLab.font=DESC_FONT;
        [self addSubview:morenLab];
        
        
        self.dizhiLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxY(morenLab.frame),CGRectGetMaxY(self.nameLab.frame)+M_WIDTH(10),WIN_WIDTH-M_WIDTH(65),M_WIDTH(30))];
        self.dizhiLab.textAlignment=NSTextAlignmentLeft;
        self.dizhiLab.font=DESC_FONT;
        self.dizhiLab.numberOfLines=2;
        self.dizhiLab.textColor=COLOR_FONT_SECOND;
        [self addSubview:self.dizhiLab];
        
        
    }else if([reuseIdentifier isEqualToString:@"cellID3"]){
        
        self.nameLab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(10), M_WIDTH(14), M_WIDTH(60), M_WIDTH(17))];
        self.nameLab.textAlignment=NSTextAlignmentLeft;
        self.nameLab.font=COMMON_FONT;
        [self addSubview:self.nameLab];
        
        self.phoneLab=[[UILabel alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(120), M_WIDTH(14), M_WIDTH(113), M_WIDTH(17))];
        self.phoneLab.textAlignment=NSTextAlignmentRight;
        self.phoneLab.font=COMMON_FONT;
        [self addSubview:self.phoneLab];
        
        self.dizhiLab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(10),CGRectGetMaxY(self.nameLab.frame),WIN_WIDTH-M_WIDTH(20), M_WIDTH(30))];
        self.dizhiLab.textAlignment=NSTextAlignmentLeft;
        self.dizhiLab.font=DESC_FONT;
        self.dizhiLab.textColor=COLOR_FONT_SECOND;
        [self addSubview:self.dizhiLab];

        
    }

    
    return  self;
}

-(void)zhuangtaiTouch:(UIButton*)sender
{
    if (sender.tag==0) {
    }else {
        int indexint=(int)sender.tag;
        NSString *str=[NSString stringWithFormat:@"%d",indexint];
        if (_dizhiDelegate &&[_dizhiDelegate respondsToSelector:@selector(setMoren:)]) {
            [_dizhiDelegate setMoren:str];
        }
    }
}


-(void)bianjiTouch:(UIButton*)sender
{
    int indexint=(int)sender.tag;
    NSString *str=[NSString stringWithFormat:@"%d",indexint];
    if (_dizhiDelegate &&[_dizhiDelegate respondsToSelector:@selector(setbianji:)]) {
        [_dizhiDelegate setbianji:str];
    }
}

-(void)deleteTouch:(UIButton*)sender
{
    int indexint=(int)sender.tag;
    NSString *str=[NSString stringWithFormat:@"%d",indexint];
    if (_dizhiDelegate &&[_dizhiDelegate respondsToSelector:@selector(setdelete:)]) {
        [_dizhiDelegate setdelete:str];
    }
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
