//
//  GroupViewController.m
//  kaidexing
//
//  Created by 朕 on 16/5/22.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "GroupViewController.h"

@interface GroupViewController()<UIScrollViewDelegate,UITextFieldDelegate>

@property (strong,nonatomic)UIScrollView            *scrollView1;
@property (strong,nonatomic)UIImageView             *shoucangImg;//收藏图片
@property (strong,nonatomic)UILabel                 *shoucangLab;//收藏文字
@property (strong,nonatomic)UITextField             *tuanTextF;//团名字

@end


//------------------------------我要开团------------------------------

@implementation GroupViewController
{
    
    CGFloat   view_H;
    NSString *typeStr;
    
}


-(void)viewDidLoad
{
    self.navigationBarTitleLabel.text=@"我要开团";
    self.view.backgroundColor=UIColorFromRGB(0xefefef);
    view_H=0;
    typeStr=@"1";
    self.scrollView1=[[UIScrollView alloc]initWithFrame:self.view.bounds];
    self.scrollView1.delegate=self;
    self.scrollView1.contentSize=CGSizeMake(WIN_WIDTH, WIN_HEIGHT*1.1);
    [self.view addSubview:self.scrollView1];
 
    [self initview];
}

-(void)initview
{
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 228)];
    headView.backgroundColor=[UIColor whiteColor];
    
    UIImageView  *logoImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 150)];
    [logoImg setUserInteractionEnabled:YES];
    logoImg.backgroundColor=APP_BTN_COLOR;
    logoImg.contentMode=UIViewContentModeScaleAspectFill;
    
    [headView addSubview:logoImg];
    view_H=view_H+150;
    
    //介绍lab
    UILabel  *jieshaoLab=[[UILabel alloc]initWithFrame:CGRectMake(6, view_H+13, WIN_WIDTH/2, 13)];
    jieshaoLab.text=@"报名需要扣除1个积分哦";
    jieshaoLab.textAlignment=NSTextAlignmentLeft;
    jieshaoLab.font=DESC_FONT;
    [headView addSubview:jieshaoLab];
    
    //满多少人参团
    
    UILabel *manLab=[[UILabel alloc]initWithFrame:CGRectMake(6, CGRectGetMaxY(jieshaoLab.frame)+20, 100, 10)];
    manLab.textColor=COLOR_FONT_SECOND;
    NSString *manStr=[NSString stringWithFormat:@"%@%@",@"满10人参团",@"￥"];
    manLab.text=manStr;
    manLab.textAlignment=NSTextAlignmentLeft;
    manLab.font=DESC_FONT;
    CGRect rect2=[manLab.text boundingRectWithSize:CGSizeMake(100,11) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:manLab.font} context:nil];
    manLab.frame=CGRectMake(manLab.frame.origin.x, manLab.frame.origin.y, rect2.size.width, rect2.size.height);
    [self.scrollView1 addSubview:manLab];
    //免费，现价
    UILabel *mianfeiLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(manLab.frame)+2, CGRectGetMaxY(jieshaoLab.frame)+9, 50, 26)];
    mianfeiLab.text=@"100";
    mianfeiLab.textAlignment=NSTextAlignmentLeft;
    mianfeiLab.font=[UIFont systemFontOfSize:22];
    mianfeiLab.textColor=APP_BTN_COLOR;
    CGRect rect3=[mianfeiLab.text boundingRectWithSize:CGSizeMake(100,26) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:mianfeiLab.font} context:nil];
    mianfeiLab.frame=CGRectMake(mianfeiLab.frame.origin.x, mianfeiLab.frame.origin.y, rect3.size.width, rect3.size.height);
    [headView addSubview:mianfeiLab];
    
    //小箭头
    UIImageView *jiantouImg=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(mianfeiLab.frame)+2, CGRectGetMaxY(jieshaoLab.frame)+23, 8, 8)];
    jiantouImg.backgroundColor=APP_BTN_COLOR;
    [headView addSubview:jiantouImg];
    
    //原价
    UILabel *yuanjiaLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(jiantouImg.frame)+3,CGRectGetMaxY(jieshaoLab.frame)+20, 100, 10)];
    yuanjiaLab.textColor=COLOR_FONT_SECOND;
    NSString *yuanjiaStr=[NSString stringWithFormat:@"%@%@",@"原价￥",@"123456"];
    yuanjiaLab.text=yuanjiaStr;
    yuanjiaLab.textAlignment=NSTextAlignmentLeft;
    yuanjiaLab.font=DESC_FONT;
    CGRect rect1=[yuanjiaLab.text boundingRectWithSize:CGSizeMake(100,11) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:yuanjiaLab.font} context:nil];
    yuanjiaLab.frame=CGRectMake(yuanjiaLab.frame.origin.x, yuanjiaLab.frame.origin.y, rect1.size.width, rect1.size.height);
    
    //在加个上面画一条横线
    UIView *x_view=[[UIView alloc]initWithFrame:CGRectMake(25,7, yuanjiaLab.frame.size.width-25, 0.5)];
    x_view.backgroundColor=COLOR_FONT_SECOND;
    [yuanjiaLab addSubview:x_view];
    
    [headView addSubview:yuanjiaLab];
    [self.scrollView1 addSubview:headView];
    view_H=view_H+78;
    
    if ([typeStr isEqualToString:@"1"]) {
        [self initview222];
    }else {
       [self initview2];
    }
}
-(void)initview2
{
    //
    UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(0, view_H, WIN_WIDTH, 215)];
    view1.backgroundColor=UIColorFromRGB(0xefefef);
    
    //我要收藏
    UIView *shoucangView=[[UIView alloc]initWithFrame:CGRectMake(0, 9, WIN_WIDTH, 33)];
    shoucangView.backgroundColor=[UIColor whiteColor];
    
    //我要收藏的图标
    self.shoucangImg=[[UIImageView alloc]initWithFrame:CGRectMake(6, 10, 15, 15)];
    [self.shoucangImg setImage:[UIImage imageNamed:@"collect"]];
    
    //我要收藏的文字
    self.shoucangLab=[[UILabel alloc]initWithFrame:CGRectMake(30, 10, 150, 14)];
    self.shoucangLab.text=@"我要收藏";
    self.shoucangLab.textAlignment=NSTextAlignmentLeft;
    self.shoucangLab.font=DESC_FONT;
    //
    UIButton *shoucangBtn=[[UIButton alloc]initWithFrame:shoucangView.bounds];
    [shoucangBtn addTarget:self action:@selector(shoucangTouch:) forControlEvents:UIControlEventTouchUpInside];

    [shoucangView addSubview:self.shoucangImg];
    [shoucangView addSubview:self.shoucangLab];
    [shoucangView addSubview:shoucangBtn];
    
    //团昵称 和开团，查看我的团view
    
    UIView *tuanView=[[UIView  alloc]initWithFrame:CGRectMake(0, 55, WIN_WIDTH, 149)];
    tuanView.backgroundColor=[UIColor whiteColor];
    
    //团昵称文字lab
    UILabel *tuanLab=[[UILabel alloc]initWithFrame:CGRectMake(6, 10, 68, 16)];
    tuanLab.textAlignment=NSTextAlignmentLeft;
    tuanLab.text=@"团昵称";
    tuanLab.font=COMMON_FONT;
    
    
    //团昵称输入框
    self.tuanTextF=[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tuanLab.frame), 0, 200, 32)];
    self.tuanTextF.placeholder=@"请输入团昵称";
    self.tuanTextF.textAlignment=NSTextAlignmentLeft;
    self.tuanTextF.delegate=self;
    self.tuanTextF.font=COMMON_FONT;
    
    //团昵称输入框下面的线
    UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(6,CGRectGetMaxY(self.tuanTextF.frame), WIN_WIDTH-6, 1)];
    lineView1.backgroundColor=COLOR_LINE;
    
    //我要开团按钮
    UIButton *beginBtn=[[UIButton alloc]initWithFrame:CGRectMake(6, CGRectGetMaxY(lineView1.frame)+17, WIN_WIDTH-12, 30)];
    beginBtn.backgroundColor=APP_BTN_COLOR;
    beginBtn.titleLabel.font=COMMON_FONT;
    beginBtn.layer.masksToBounds=YES;
    beginBtn.layer.cornerRadius=5;
    [beginBtn setTitle:@"我要开团" forState:UIControlStateNormal];
    [beginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [beginBtn addTarget:self action:@selector(beginTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    //查看我的团按钮
    UIButton *lookBtn=[[UIButton alloc]initWithFrame:CGRectMake(6, CGRectGetMaxY(beginBtn.frame)+17, WIN_WIDTH-12, 30)];
    lookBtn.backgroundColor=UIColorFromRGB(0x519ff8);
    lookBtn.titleLabel.font=COMMON_FONT;
    lookBtn.layer.masksToBounds=YES;
    lookBtn.layer.cornerRadius=5;
    [lookBtn setTitle:@"查看我的团" forState:UIControlStateNormal];
    [lookBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [lookBtn addTarget:self action:@selector(lookTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [tuanView addSubview:tuanLab];
    [tuanView addSubview:self.tuanTextF];
    [tuanView addSubview:lineView1];
    [tuanView addSubview:beginBtn];
    [tuanView addSubview:lookBtn];

    
    
    [view1 addSubview:shoucangView];
    [view1 addSubview:tuanView];
    
    [self.scrollView1 addSubview:view1];
    view_H = view_H +215;
    [self initview3];
}

-(void)initview222
{
    UIView*view2_2=[[UIView alloc]initWithFrame:CGRectMake(0, view_H+13, WIN_WIDTH, 88)];
    view2_2.backgroundColor=[UIColor whiteColor];
    
    //共有多少人参加团
    UILabel *numLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 12, WIN_WIDTH, 16)];
    numLab.textAlignment=NSTextAlignmentCenter;
    numLab.font=DESC_FONT;
    NSString *numStr=[NSString stringWithFormat:@"%@%@%@",@"已有",@"1",@"人参团，赶快参加吧!"];
    numLab.text=numStr;
    
    //分享给好友按钮
    UIButton *fenxiangBtn=[[UIButton alloc]initWithFrame:CGRectMake(6,36, WIN_WIDTH-12, 36)];
    fenxiangBtn.backgroundColor=APP_BTN_COLOR;
    fenxiangBtn.titleLabel.font=COMMON_FONT;
    [fenxiangBtn setTitle:@"分享给好友" forState:UIControlStateNormal];
    [fenxiangBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    fenxiangBtn.layer.masksToBounds=YES;
    fenxiangBtn.layer.cornerRadius=5;
    [fenxiangBtn addTarget:self action:@selector(fenxiangTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView4=[[UIView alloc]initWithFrame:CGRectMake(6, CGRectGetMaxY(view2_2.frame)-1, WIN_WIDTH-6, 1)];
    lineView4.backgroundColor=COLOR_LINE;
    
    [view2_2 addSubview:numLab];
    [view2_2 addSubview:fenxiangBtn];
    [view2_2 addSubview:lineView4];
    
    [self.scrollView1 addSubview:view2_2];
    view_H=view_H+101;
    [self initview3];
}



//活动细则，查看图文详情
-(void)initview3
{
    
    UIView *view3=[[UIView alloc]init];
    view3.backgroundColor=[UIColor whiteColor];
    
    //活动细则文字
    UILabel *Lab1=[[UILabel alloc]initWithFrame:CGRectMake(6, 10, 150, 16)];
    Lab1.text=@"活动细则";
    Lab1.textAlignment=NSTextAlignmentLeft;
    Lab1.font=DESC_FONT;
    
    //向下的箭头
    
    UIImageView  *downImg=[[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH-15, 14, 10, 10)];
    downImg.backgroundColor=APP_BTN_COLOR;
    downImg.contentMode=UIViewContentModeScaleAspectFit;
    
    //活动细则文字
    
    UILabel *xizeLab=[[UILabel alloc]initWithFrame:CGRectMake(6, 36, WIN_WIDTH-12, 14)];
    xizeLab.numberOfLines=0;
    xizeLab.textAlignment=NSTextAlignmentLeft;
    xizeLab.text=@"adljalsdlkasdalsdahsfhakshfkhaskhfjkahsfhakshfjkhajskfhjakhfkj";
    xizeLab.font=DESC_FONT;
    xizeLab.textColor=COLOR_FONT_SECOND;
    CGRect rect1=[xizeLab.text boundingRectWithSize:CGSizeMake(WIN_WIDTH-12,100) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:xizeLab.font} context:nil];
    xizeLab.frame=CGRectMake(xizeLab.frame.origin.x, xizeLab.frame.origin.y, rect1.size.width, rect1.size.height);
    
    //细则下面的线
    UIView *lineView2=[[UIView alloc]initWithFrame:CGRectMake(6,CGRectGetMaxY(xizeLab.frame)+19, WIN_WIDTH-6, 1)];
    lineView2.backgroundColor=COLOR_LINE;
    
    //查看图文详情
    
    UILabel *lookImgtextLab=[[UILabel alloc]initWithFrame:CGRectMake(6,CGRectGetMaxY(lineView2.frame)+10, 150, 16)];
    lookImgtextLab.text=@"查看图文详情";
    lookImgtextLab.textAlignment=NSTextAlignmentLeft;
    lookImgtextLab.font=DESC_FONT;
 
    //向右的箭头
    UIImageView  *r_Img=[[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH-15, 14, 10, 10)];
    r_Img.backgroundColor=APP_BTN_COLOR;
    r_Img.contentMode=UIViewContentModeScaleAspectFit;
    
    UIButton *lookimgBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lineView2.frame), WIN_WIDTH, 33)];
    [lookimgBtn addTarget:self action:@selector(lookImgTouch:) forControlEvents:UIControlEventTouchUpInside];
    //查看详情下面的线
    UIView *lineView3=[[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(lineView2.frame)+35, WIN_WIDTH, 1)];
    lineView3.backgroundColor=COLOR_LINE;
    
    
    
    view3.frame=CGRectMake(0, view_H, WIN_WIDTH, 91+xizeLab.frame.size.height);
    
    [view3 addSubview:Lab1];
    [view3 addSubview:downImg];
    [view3 addSubview:xizeLab];
    [view3 addSubview:lineView2];
    [view3 addSubview:lookImgtextLab];
    [view3 addSubview:r_Img];
    [view3 addSubview:lookimgBtn];
    [view3 addSubview:lineView3];
    [self.scrollView1 addSubview:view3];
    view_H=view_H+view3.frame.size.height;
    if ([typeStr isEqualToString:@"1"]) {
        [self initview4];
    }
}

-(void)initview4
{
    UILabel *numLab=[[UILabel alloc]initWithFrame:CGRectMake(6, view_H+7, WIN_WIDTH/2, 16)];
    NSString *numStr=[NSString stringWithFormat:@"%@%@%@",@"已有成员（",@"1",@"人)"];
    numLab.text=numStr;
    numLab.textAlignment=NSTextAlignmentLeft;
    numLab.font=DESC_FONT;
    
    [self.scrollView1 addSubview:numLab];
    view_H=view_H+31;
    
    for (int i=0; i<3; i++) {
        UIView *itemView=[[UIView alloc]initWithFrame:CGRectMake(0, view_H+i*34, WIN_WIDTH, 34)];
        itemView.backgroundColor=[UIColor whiteColor];
        UIImageView *headPortraitImg=[[UIImageView alloc]initWithFrame:CGRectMake(6, 4.5, 25, 25)];
        headPortraitImg.backgroundColor=APP_BTN_COLOR;
        headPortraitImg.layer.masksToBounds=YES;
        headPortraitImg.layer.cornerRadius=12.5;
        
        UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(37, 10, 200, 14)];
        nameLab.textAlignment=NSTextAlignmentLeft;
        nameLab.font=DESC_FONT;
        nameLab.text=@"asdasda";
        
        UIImageView *mingciImg=[[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH-24, 8, 18, 18)];
        mingciImg.backgroundColor=APP_BTN_COLOR;
        mingciImg.layer.masksToBounds=YES;
        mingciImg.layer.cornerRadius=9;
    
        
        [itemView addSubview:headPortraitImg];
        [itemView addSubview:nameLab];
        [itemView addSubview:mingciImg];
        [self.scrollView1 addSubview:itemView];
    }
    
    
}




//点击了我要收藏按钮
-(void)shoucangTouch:(UIButton *)sender
{
    
 
    
}

//点击了我要开团按钮
-(void)beginTouch:(UIButton *)sender
{

    
}

//点击查看我的团按钮
-(void)lookTouch:(UIButton *)sender
{
    
    
}

//点击图文详情
-(void)lookImgTouch:(UIButton *)sender
{
    
    
}

//点击了分享按钮
-(void)fenxiangTouch:(UIButton*)sender
{
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.tuanTextF resignFirstResponder];
}




@end

