//
//  ConfirmPaymentView.m
//  kaidexing
//
//  Created by 朱巩拓 on 2016/12/25.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "ConfirmPaymentView.h"
#import "Const.h"

//view宽度
#define VIEW_W M_WIDTH(250)
//view高度
#define VIEW_H M_WIDTH(210)
//view边缘
#define VIEW_edge (WIN_WIDTH-VIEW_W)/2
//view顶部文字高度
#define HEADView_H M_WIDTH(44)


@implementation ConfirmPaymentView{
    NSDictionary *dataDiction;
}


//使用
/*
 {
    confirmPayView =[[UIView alloc]initWithFrame:self.view.bounds];
    confirmPayView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];

    ConfirmPaymentView *conView=[[ConfirmPaymentView alloc]initWithFrame:CGRectMake((WIN_WIDTH-M_WIDTH(250))/2,WIN_HEIGHT/4,M_WIDTH(250),M_WIDTH(200)) data:nil];
    conView.backgroundColor=[UIColor whiteColor];
    conView.cDelegate=self;
    conView.layer.masksToBounds=YES;
    conView.layer.cornerRadius=8;
    [confirmPayView addSubview:conView];
    [self.view addSubview:confirmPayView];
}
 
 -(void)paymentEvent:(id)vul{
 [confirmPayView removeFromSuperview];
 if (![Util isNull:vul]) {
 //请求支付宝
 
 }
 }
 
 
*/

-(instancetype)initWithFrame:(CGRect)frame data:(NSDictionary *)dataDic{
    
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        dataDiction = dataDic;
        [self createView:dataDic];
    }
    return self;
    
}


-(void)createView:(NSDictionary*)dic{
    
    UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, VIEW_W,VIEW_H)];
    view.backgroundColor=[UIColor whiteColor];
    
    CGFloat iconH =HEADView_H/3;
    CGFloat iconTop = (HEADView_H-iconH)/2;
    
    UIImageView *iconImg = [[UIImageView alloc]initWithFrame:CGRectMake(iconTop,iconTop,iconH,iconH)];
    [iconImg setImage:[UIImage imageNamed:@"zhifuclose"]];
    [view addSubview:iconImg];
    
    UIButton *delBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, HEADView_H,HEADView_H)];
    [delBtn addTarget:self action:@selector(delTouch:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:delBtn];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(HEADView_H,0,VIEW_W-2*HEADView_H,HEADView_H)];
    titleLab.text=@"订单支付";
    titleLab.font=BIG_FONT;
    titleLab.textAlignment=NSTextAlignmentCenter;
    [view addSubview:titleLab];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0,HEADView_H-1,VIEW_W,1)];
    lineView.backgroundColor = COLOR_LINE;
    [view addSubview:lineView];
    
    UILabel *commodityLab = [[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(lineView.frame)+M_WIDTH(15), VIEW_W,M_WIDTH(20))];
//    commodityLab.text=[NSString stringWithFormat:@"%@",dataDiction[@"data"][@"name"]];
//    commodityLab.text=@"现金商品支付";
    commodityLab.textColor=COLOR_FONT_SECOND;
    commodityLab.textAlignment = NSTextAlignmentCenter;
    commodityLab.font=COMMON_FONT;
    [view addSubview:commodityLab];
    
    UILabel *moneyLab = [[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(commodityLab.frame),VIEW_W,M_WIDTH(45))];
    moneyLab.text=[NSString stringWithFormat:@"￥%@",dataDiction[@"data"][@"total_amount"]];
    moneyLab.textAlignment=NSTextAlignmentCenter;
    moneyLab.font=[UIFont systemFontOfSize:35];
    [view addSubview:moneyLab];
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(15,HEADView_H+M_WIDTH(90)-1,VIEW_W,1)];
    lineView2.backgroundColor = COLOR_LINE;
    [view addSubview:lineView2];
    
    
    UIButton *okBtn = [[UIButton alloc]initWithFrame:CGRectMake(15,CGRectGetMaxY(lineView2.frame)+HEADView_H/3,VIEW_W-30,HEADView_H)];
    okBtn.backgroundColor = APP_BTN_COLOR;
    [okBtn setTitle:@"确认支付" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    okBtn.layer.masksToBounds=YES;
    okBtn.layer.cornerRadius=5;
    okBtn.titleLabel.font=COMMON_FONT;
    [okBtn addTarget:self action:@selector(zhifuTouch:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:okBtn];
    
    [self addSubview:view];
}


-(void)zhifuTouch:(UIButton*)sender{
    if (_cDelegate &&[_cDelegate respondsToSelector:@selector(paymentEvent:)]) {
        [_cDelegate paymentEvent:dataDiction];
    }
}

-(void)delTouch:(UIButton*)sender{
    if (_cDelegate &&[_cDelegate respondsToSelector:@selector(paymentEvent:)]) {
        [_cDelegate paymentEvent:nil];
    }
}



@end
