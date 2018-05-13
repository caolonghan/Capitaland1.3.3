//
//  PayResultController.m
//  kaidexing
//
//  Created by 朱巩拓 on 16/7/2.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "PayResultController.h"
#import "GoViewController.h"

@interface PayResultController ()
@property (strong,nonatomic)UIView      *rootView1;
@end

@implementation PayResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.leftBarItemView.hidden=YES;
    self.navigationBarTitleLabel.text=@"支付成功";
    [self creatrView_1];
}

-(void)creatrView_1
{
    self.rootView1=[[UIView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, WIN_WIDTH, WIN_HEIGHT-NAV_HEIGHT)];
    self.rootView1.backgroundColor=[UIColor whiteColor];
    CGFloat  img_H=M_WIDTH(55);
    if ([_typeStr isEqualToString:@"1"]) {
        UIImageView *chenggongImg=[[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH/2 -img_H/2, M_WIDTH(89), img_H, img_H)];
        [chenggongImg setImage:[UIImage imageNamed:@"zhifuchenggong"]];
        [self.rootView1 addSubview:chenggongImg];
        
        UILabel *chenggongLab=[[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(chenggongImg.frame)+M_WIDTH(20), WIN_WIDTH, M_WIDTH(27))];
        chenggongLab.textColor=UIColorFromRGB(0xe12b2b);
        chenggongLab.textAlignment=NSTextAlignmentCenter;
        chenggongLab.font=BIG_FONT;
        chenggongLab.text=@"成功支付";
        [self.rootView1 addSubview:chenggongLab];
    }else {
        UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(0,M_WIDTH(75), WIN_WIDTH, M_WIDTH(24))];
        titleLab.text=@"您还需支付";
        titleLab.textAlignment=NSTextAlignmentCenter;
        titleLab.textColor=UIColorFromRGB(0xe22929);
        titleLab.font=BIG_FONT;
        [self.rootView1 addSubview:titleLab];
        
        UILabel *moneyLab=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLab.frame)+M_WIDTH(58), WIN_WIDTH, M_WIDTH(32))];
        moneyLab.textColor=UIColorFromRGB(0xfe652e);
        moneyLab.textAlignment=NSTextAlignmentCenter;
        moneyLab.text=[NSString stringWithFormat:@"%@%d",@"￥",[_fee intValue]];
        moneyLab.font=[UIFont systemFontOfSize:28];
        [self.rootView1 addSubview:moneyLab];
        
        UILabel *jianjieLab=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(moneyLab.frame), WIN_WIDTH, M_WIDTH(26))];
        jianjieLab.text=[NSString stringWithFormat:@"%@%d%@%d%@",@"*积分折扣",[_couponreduce intValue],@"元，优惠券抵扣",[_totalReduce intValue],@"元"];
        jianjieLab.textAlignment=NSTextAlignmentCenter;
        jianjieLab.textColor=COLOR_FONT_SECOND;
        jianjieLab.font=DESC_FONT;
        [self.rootView1 addSubview:jianjieLab];
        
        
    }
    
    
    UIView *buttomView=[[UIView alloc]initWithFrame:CGRectMake(0,M_WIDTH(252), WIN_WIDTH, M_WIDTH(500))];
    UILabel *tishiLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, M_WIDTH(15))];
    tishiLab.text=@"温馨提示";
    tishiLab.textAlignment=NSTextAlignmentCenter;
    tishiLab.font=INFO_FONT;
    [buttomView addSubview:tishiLab];
    
    UILabel *shuomingLab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(10),CGRectGetMaxY(tishiLab.frame)+M_WIDTH(12), WIN_WIDTH-M_WIDTH(20), M_WIDTH(20))];
    shuomingLab.textAlignment=NSTextAlignmentCenter;
    shuomingLab.text=@"请15分钟内离场，超时额度需另附现金";
    shuomingLab.font=DESC_FONT;
    [buttomView addSubview:shuomingLab];
    
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH/2-M_WIDTH(80),M_WIDTH(110),M_WIDTH(160), M_WIDTH(43))];
    btn.layer.masksToBounds=YES;
    btn.layer.cornerRadius=5;
    btn.titleLabel.font=COMMON_FONT;
    btn.backgroundColor=APP_BTN_COLOR;
    [btn setTitle:@"返回个人中心" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(popRootView) forControlEvents:UIControlEventTouchUpInside];
    [buttomView addSubview:btn];
    
    UIButton *btn2=[[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH/2-M_WIDTH(80),CGRectGetMaxY(btn.frame)+M_WIDTH(11),M_WIDTH(160), M_WIDTH(43))];
    btn2.layer.masksToBounds=YES;
    btn2.layer.cornerRadius=5;
    btn2.layer.borderColor=APP_BTN_COLOR.CGColor;
    btn2.layer.borderWidth=2;
    btn2.titleLabel.font=COMMON_FONT;
    [btn2 setTitle:@"我要找车" forState:UIControlStateNormal];
    [btn2 setTitleColor:APP_BTN_COLOR forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(zhaocheTouch) forControlEvents:UIControlEventTouchUpInside];
    [buttomView addSubview:btn2];
    
    
    [self.rootView1 addSubview:buttomView];
    [self.view addSubview:self.rootView1];
}

-(void)popRootView
{
    [Global sharedClient].action=@"10";
    [self.delegate.navigationController popToRootViewControllerAnimated:NO];
}



-(void)zhaocheTouch
{
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:_parkID,@"park_id",nil];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"usercenter" tp:@"findcar"] parameters:params target:self success:^(NSDictionary *dic) {
        dispatch_async(dispatch_get_main_queue(), ^{
        GoViewController *gvc=[[GoViewController alloc]init];
        NSString *path = dic[@"data"];
        gvc.path= path;
        [self.delegate.navigationController pushViewController:gvc animated:YES];
        });
    } failue:^(NSDictionary *dic) {
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
