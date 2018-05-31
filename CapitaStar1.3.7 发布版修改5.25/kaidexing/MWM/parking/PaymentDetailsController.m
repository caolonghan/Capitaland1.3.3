//
//  PaymentDetailsController.m
//  kaidexing
//
//  Created by 朱巩拓 on 16/7/2.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "PaymentDetailsController.h"
#import "PayResultController.h"
#import "WXApi.h"
#import "DataMD5.h"
#import "WXApiManager.h"
#import "PayTypeViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "AliManager.h"
#import "MLabel.h"

#define view_H M_WIDTH(41)

@interface PaymentDetailsController ()<UIScrollViewDelegate>
@property (strong,nonatomic)UIScrollView   *scrollView1;
@property (strong,nonatomic)NSMutableDictionary    *payDic;
@end

@implementation PaymentDetailsController
{
    CGFloat  uiViewH;
    UIView  *lineView4;
    UILabel *timeHouerNumLab;
    NSInteger  _tag;
    UIButton    *selectBtn;
    UILabel   *jifenLab;
    UILabel   *youhuiLab;
    MLabel   *zhifuLab;
    UILabel   *zhushiLabl;
    NSDictionary   *dataDic;
    int      btnTag;//优惠券选择标记
    NSString      *ticketno;//停车券号
    int      maxIntegral;//最大可用积分
    int      integralBase;////兑换标准
    int      feeMoney;//还需支付金额
    int      jifenMoney;//积分兑换的金额
    int      juanMoney;//优惠券抵用的金额
    int      time_count;//选择条的默认大小 和 积分兑换小时数量
    UIButton    *weixinBtn;
    UIButton    *shuxinBtn;
    UIButton    *zhifuBtn;
    UILabel *itemLab;//积分余额
    NSDictionary    *zhifuDic;
    UISlider *slider;
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarTitleLabel.text=@"停车缴费";
    time_count=0;
    jifenMoney=0;
    juanMoney =0;
    self.payDic=[[NSMutableDictionary alloc]init];
    dataDic=[[NSDictionary alloc]init];
    self.scrollView1=[[UIScrollView alloc]initWithFrame:CGRectMake(0,NAV_HEIGHT,WIN_WIDTH,WIN_HEIGHT-NAV_HEIGHT)];
    self.scrollView1.delegate=self;
    self.scrollView1.scrollEnabled=YES;
    self.scrollView1.contentSize=CGSizeMake(WIN_WIDTH, WIN_HEIGHT*1.7);
    self.scrollView1.backgroundColor=UIColorFromRGB(0xf2f2f2);
    [self.view addSubview:self.scrollView1];
    uiViewH=0;
    [self netWorkRequest];
}

//获取数据
-(void)netWorkRequest{
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:[Global sharedClient].member_id,@"member_id",[Global sharedClient].markID,@"mall_id",_car_no,@"car_no",@"1000",@"source",nil];
    [SVProgressHUD showWithStatus:@"数据加载中"];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"park" tp:@"getparkpaydt"] parameters:params target:self success:^(NSDictionary *dic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@",dic);
            dataDic=dic[@"data"];
            
            maxIntegral =[[Util isNil:dataDic[@"parkpayinfo"][@"maxIntegral"]]intValue];//剩余余额
            integralBase=[[Util isNil:dataDic[@"parkpayinfo"][@"integralBase"]]intValue];//兑换标准
            
            [self createView];
            [SVProgressHUD dismiss];
        });
    } failue:^(NSDictionary *dic) {
    }];
}

-(void)createView{
    NSDictionary *dic=dataDic[@"parkpayinfo"];
    
    UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(0,0,WIN_WIDTH,view_H)];
    view1.backgroundColor=[UIColor whiteColor];
    //车牌
    UILabel *chepaiLab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(10),0,M_WIDTH(170),view_H)];
    chepaiLab.text=@"停车费";
    chepaiLab.textAlignment=NSTextAlignmentLeft;
    chepaiLab.font=DESC_FONT;
    [view1 addSubview:chepaiLab];
    
    UILabel *moneyLab=[[UILabel alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(100), 0, M_WIDTH(90), view_H)];
    moneyLab.text=[NSString stringWithFormat:@"%d元",[[Util isNil:dic[@"fee"]]intValue]];
    moneyLab.textColor=UIColorFromRGB(0xff632b);
    moneyLab.textAlignment=NSTextAlignmentRight;
    moneyLab.font=COMMON_FONT;
    [view1 addSubview:moneyLab];
    
    UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(M_WIDTH(10),view_H-1, WIN_WIDTH-M_WIDTH(10), 1)];
    lineView1.backgroundColor=COLOR_LINE;
    [view1 addSubview:lineView1];
    [self.scrollView1 addSubview:view1];
    
    NSString *timeStr;
    int timeHour = [[Util isNil:dic[@"allTimeSpan"]] intValue]/60;
    if (timeHour==0) {
        timeStr = [NSString stringWithFormat:@"%@分",[Util isNil:dic[@"allTimeSpan"]]];
    }else{
        int timeMinute =[[Util isNil:dic[@"allTimeSpan"]] intValue]%60;
        timeStr = [NSString stringWithFormat:@"%d小时%d分",timeHour,timeMinute];
    }
    
    UIView *itemView2=[[UIView alloc]initWithFrame:CGRectMake(0,view_H, WIN_WIDTH,view_H)];
    itemView2.backgroundColor = [UIColor whiteColor];
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(10),0,M_WIDTH(100),view_H)];
    lab.text=@"停车时长";
    lab.textAlignment=NSTextAlignmentLeft;
    lab.font=DESC_FONT;
    [itemView2 addSubview:lab];
    
    UILabel *lab2=[[UILabel alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(150),0, M_WIDTH(140), view_H)];
    lab2.font=INFO_FONT;
    lab2.textColor=COLOR_FONT_SECOND;
    lab2.textAlignment=NSTextAlignmentRight;
    lab2.text=timeStr;
    [itemView2 addSubview:lab2];
    [self.scrollView1 addSubview:itemView2];
    
    UIView *itemView3=[[UIView alloc]initWithFrame:CGRectMake(0,view_H*2, WIN_WIDTH,view_H)];
    itemView3.backgroundColor = UIColorFromRGB(0xf2f2f2);
    UILabel *lab3=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(10),0,M_WIDTH(100),view_H)];
    lab3.text=@"可用优惠";
    lab3.textAlignment=NSTextAlignmentLeft;
    lab3.font=DESC_FONT;
    [itemView3 addSubview:lab3];
    
    itemLab=[[UILabel alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(150),0, M_WIDTH(140), view_H)];
    itemLab.font=INFO_FONT;
    itemLab.textColor=COLOR_FONT_SECOND;
    itemLab.textAlignment=NSTextAlignmentRight;
    itemLab.text=[NSString stringWithFormat:@"可用积分%d",[[Util isNil:dic[@"maxIntegral"]] intValue]];
    [itemView3 addSubview:itemLab];
    [self.scrollView1 addSubview:itemView3];
    
    
    uiViewH = view_H*3;
    [self createView2];
}

-(void)createView2{
    NSDictionary *dic2=dataDic[@"parkpayinfo"];
    
    UIView *wView=[[UIView alloc]initWithFrame:CGRectMake(0,uiViewH,WIN_WIDTH,M_WIDTH(104))];
    wView.backgroundColor= [UIColor whiteColor];
    [self.scrollView1 addSubview:wView];
    
    UILabel *lab1=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(15),uiViewH + M_WIDTH(15),WIN_WIDTH,M_WIDTH(22))];
    lab1.text=@"积分抵用时长";
    lab1.textAlignment=NSTextAlignmentLeft;
    lab1.font=DESC_FONT;
    [self.scrollView1 addSubview:lab1];
    
    timeHouerNumLab=[[UILabel alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(150),uiViewH+M_WIDTH(16),M_WIDTH(140), M_WIDTH(22))];
    timeHouerNumLab.textColor=UIColorFromRGB(0xff632b);
    timeHouerNumLab.textAlignment=NSTextAlignmentRight;
    timeHouerNumLab.font=INFO_FONT;
    timeHouerNumLab.text=[NSString stringWithFormat:@"%d小时",0];
    [self.scrollView1 addSubview:timeHouerNumLab];
    
    //注释积分兑换规则
    UIView *guizeView = [[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(lab1.frame),M_WIDTH(150),M_WIDTH(24))];
    [self initViewButtom_line:guizeView :[NSString stringWithFormat:@"%@%d%@",@"注 : ",integralBase,@"积分兑换1小时"] :1];
    [self.scrollView1 addSubview:guizeView];
    
    uiViewH = uiViewH + M_WIDTH(56);
    
    UIButton *laftBtn=[[UIButton alloc]initWithFrame:CGRectMake(0,uiViewH, M_WIDTH(40), M_WIDTH(39))];
    [laftBtn setImage:[UIImage imageNamed:@"jian_red"] forState:UIControlStateNormal];
    [laftBtn addTarget:self action:@selector(laftBtnTouch) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView1 addSubview:laftBtn];
    
    UIButton *rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(40),uiViewH, M_WIDTH(40),M_WIDTH(39))];
    [rightBtn setImage:[UIImage imageNamed:@"add_red"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnTouch) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView1 addSubview:rightBtn];
    
    
    NSMutableArray *itmeAry2=[[NSMutableArray alloc]init];
    NSArray *couponList=dataDic[@"couponList"];
    if ([Util isNull:couponList]) {
    }else{
        for (NSDictionary *diction in couponList) {
            [itmeAry2 addObject:[Util isNil:diction[@"title"]]];
        }
    }
    
    slider = [[UISlider alloc] initWithFrame:CGRectMake(M_WIDTH(40), uiViewH, WIN_WIDTH-M_WIDTH(80),M_WIDTH(40))];
    slider.minimumValue = 0;// 设置最小值
    slider.maximumValue = maxIntegral/time_count;// 设置最大值
    slider.value =0;// 设置初始值
    slider.continuous = YES;// 设置可连续变化
    slider.minimumTrackTintColor = APP_BTN_COLOR; //滑轮左边颜色，如果设置了左边的图片就不会显示
    slider.maximumTrackTintColor = COLOR_LINE; //滑轮右边颜色，如果设置了右边的图片就不会显示
    [slider setThumbImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventTouchUpInside];// 针对值变化添加响应方法
    [self.scrollView1 addSubview:slider];
    
    uiViewH = uiViewH +M_WIDTH(48);
    
    _tag=200;
    UIView *itmeView2;
    int fee     = [[Util isNil:dic2[@"fee"]]intValue];
    for (int j=0; j<itmeAry2.count; j++) {
        itmeView2=[[UIView alloc]initWithFrame:CGRectMake(0,uiViewH,WIN_WIDTH,view_H)];
        itmeView2.backgroundColor= [UIColor whiteColor];
        UIView *headLineView = [[UIView alloc]initWithFrame:CGRectMake(M_WIDTH(15),0,WIN_WIDTH-M_WIDTH(15),1)];
        headLineView.backgroundColor = COLOR_LINE;
        [itmeView2 addSubview:headLineView];
        
        UILabel *titlelab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(15), 0, M_WIDTH(250),view_H)];
        titlelab.textAlignment=NSTextAlignmentLeft;
        titlelab.textColor=[UIColor blackColor];
        titlelab.font=DESC_FONT;
        titlelab.text=itmeAry2[j];
        [itmeView2 addSubview:titlelab];
        UIButton *btn= [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(WIN_WIDTH-M_WIDTH(48),M_WIDTH(0.5),M_WIDTH(40),M_WIDTH(40));
        [btn setBackgroundImage:[UIImage imageNamed:@"white_r"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"red_w"] forState:UIControlStateSelected];
        
        btn.tag=200+j;
        if (j==0) {
            //            int amount  = [[Util isNil:dataDic[@"couponList"][0][@"amount"]]intValue];
            if(fee!=0){
                btn.selected = YES;//默认第一个的时候是选中状态
                ticketno=[NSString stringWithFormat:@"%@",[Util isNil:couponList[0][@"ticketNo"]]];
                btnTag=0;
                juanMoney = [[Util isNil:dataDic[@"couponList"][0][@"amount"]]intValue];
                selectBtn = btn;
            }
        }
        [btn addTarget:self action:@selector(xuanzhongTouch:) forControlEvents:UIControlEventTouchUpInside];
        [itmeView2 addSubview:btn];
        [self.scrollView1 addSubview:itmeView2];
        uiViewH = uiViewH + view_H;
    }
    
    UIView *itmeView3=[[UIView alloc]initWithFrame:CGRectMake(0,uiViewH,WIN_WIDTH, view_H)];
    [self initViewButtom_line:itmeView3 :@"折扣详情" :0];
    itmeView3.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self.scrollView1 addSubview:itmeView3];
    
    uiViewH = uiViewH + view_H;
    
    UIView *buttomView = [[UIView alloc]initWithFrame:CGRectMake(0, uiViewH,WIN_WIDTH,M_WIDTH(100))];
    buttomView.backgroundColor =[UIColor whiteColor];
    
    UILabel *itmeLab4=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(15),M_WIDTH(6),WIN_WIDTH,M_WIDTH(39))];
    itmeLab4.text=[NSString stringWithFormat:@"停车金额%d元",fee];
    itmeLab4.textAlignment=NSTextAlignmentLeft;
    itmeLab4.font=DESC_FONT;
    [buttomView addSubview:itmeLab4];
    
    zhifuLab=[[MLabel alloc]initWithFrame:CGRectMake(WIN_WIDTH - M_WIDTH(200),M_WIDTH(6), M_WIDTH(190), M_WIDTH(39))];
    feeMoney=[[Util isNil:dic2[@"fee"]]intValue];
    int firstAmount=0;
    if(itmeAry2.count>0){
        if (fee>0) {
            firstAmount  = [[Util isNil:dataDic[@"couponList"][0][@"amount"]]intValue];
            feeMoney = fee - firstAmount;
        }
    }
    zhifuLab.text=[NSString stringWithFormat:@"%@%d%@",@"应缴纳：",feeMoney,@"元"];
    zhifuLab.textColor=UIColorFromRGB(0xff632b);
    [zhifuLab setAttrColor:0 end:3 color:[UIColor blackColor]];
    zhifuLab.font=DESC_FONT;
    zhifuLab.textAlignment=NSTextAlignmentRight;
    zhifuLab.textColor=COLOR_FONT_SECOND;
    [buttomView addSubview:zhifuLab];
    
    jifenLab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(27),CGRectGetMaxY(itmeLab4.frame), M_WIDTH(250),M_WIDTH(22))];
    jifenLab.text=@"- 积分抵扣0元";
    jifenLab.textAlignment=NSTextAlignmentLeft;
    jifenLab.textColor=COLOR_FONT_SECOND;
    jifenLab.font=INFO_FONT;
    [buttomView addSubview:jifenLab];
    
    youhuiLab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(27),CGRectGetMaxY(jifenLab.frame), M_WIDTH(250), M_WIDTH(22))];
    youhuiLab.text=[NSString stringWithFormat:@"- 停车券抵扣%d元",firstAmount];
    youhuiLab.textAlignment=NSTextAlignmentLeft;
    youhuiLab.textColor=COLOR_FONT_SECOND;
    youhuiLab.font=INFO_FONT;
    [buttomView addSubview:youhuiLab];
    
    [self.scrollView1 addSubview:buttomView];
    
    uiViewH = uiViewH +M_WIDTH(100);
    
    zhifuBtn=[[UIButton alloc]initWithFrame:CGRectMake(M_WIDTH(17),uiViewH+M_WIDTH(23),(WIN_WIDTH-M_WIDTH(51))/2,M_WIDTH(42))];
    zhifuBtn.layer.masksToBounds=YES;
    zhifuBtn.layer.cornerRadius=5;
    zhifuBtn.backgroundColor=APP_BTN_COLOR;
    [zhifuBtn setTitle:@"线下人工缴费" forState:UIControlStateNormal];
    zhifuBtn.titleLabel.font=COOL_FONT;
    [zhifuBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    zhifuBtn.tag=0;
    [zhifuBtn addTarget:self action:@selector(zhifuTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView1 addSubview:zhifuBtn];
    
    weixinBtn=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(zhifuBtn.frame)+M_WIDTH(17),uiViewH+M_WIDTH(23),(WIN_WIDTH-M_WIDTH(51))/2,M_WIDTH(42))];
    weixinBtn.layer.masksToBounds=YES;
    weixinBtn.layer.cornerRadius=5;
    weixinBtn.backgroundColor=APP_BTN_COLOR;
    [weixinBtn setTitle:@"在线支付" forState:UIControlStateNormal];
    weixinBtn.titleLabel.font=COOL_FONT;
    [weixinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    weixinBtn.tag=1;
    [weixinBtn addTarget:self action:@selector(zhifuTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView1 addSubview:weixinBtn];
    self.scrollView1.contentSize=CGSizeMake(WIN_WIDTH, CGRectGetMaxY(weixinBtn.frame)+M_WIDTH(17));
}



-(void)zhifuTouch:(UIButton*)sender{
    weixinBtn.enabled=NO;
    shuxinBtn.enabled=NO;
    NSString *park_idStr=[NSString stringWithFormat:@"%d",[dataDic[@"parkpayinfo"][@"parkId"]intValue]];
    NSString  *jifen=[NSString stringWithFormat:@"%d",[[Util isNil:dataDic[@"parkpayinfo"][@"changeValuePer"]]intValue]*time_count];
    NSString *payNo=[NSString stringWithFormat:@"%d",[[Util isNil:dataDic[@"parkpayinfo"][@"payNo"]] intValue]];
    NSString *moneyStr=[NSString stringWithFormat:@"%d",feeMoney];
    NSString *tpStr;
    NSString *carNo = [_car_no stringByReplacingOccurrencesOfString:@"_" withString:@""];
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:
                             [Global sharedClient].member_id,@"member_id",
                             [Global sharedClient].markID,@"mall_id",
                             park_idStr,@"park_id",
                             moneyStr,@"fee",
                             payNo,@"pay_no",
                             ticketno,@"ticketno",
                             jifen,@"integralToReduce",
                             @"ESITE",@"location_code",
                             carNo,@"carNo",
                             @"1000",@"source",nil];
    [SVProgressHUD showWithStatus:@"数据加载中"];
    
    if (sender.tag==0) {
        tpStr=@"cashpay";
        
    }else{
        tpStr=@"alipay";
    }
    
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"park" tp:tpStr] parameters:params target:self success:^(NSDictionary *dic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@",dic);
            weixinBtn.enabled=YES;
            shuxinBtn.enabled=YES;
            if (sender.tag==0) {
                PayResultController *rvc=[[PayResultController alloc]init];
                rvc.typeStr=@"0";
                rvc.couponreduce=[Util isNil:dic[@"data"][@"couponreduce"]];
                rvc.fee         =[Util isNil:dic[@"data"][@"fee"]];
                rvc.totalReduce =[Util isNil:dic[@"data"][@"totalReduce"]];
                rvc.car_no      =_car_no;
                rvc.parkID      =_parkID;
                [self.delegate.navigationController pushViewController:rvc animated:YES];
            }else{
                zhifuDic = dic[@"data"];
                NSLog(@"生成预付单返回-%@",dic);
                NSString *appScheme   =ALI_APPBack;
                NSString *orderString =zhifuDic[@"returnStr"];
                [AliManager aliMsgOpenURL:nil].aiDelegate=self;
                [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                    NSLog(@"reslut = %@",resultDic);
                }];
            }
            [SVProgressHUD dismiss];
        });
    } failue:^(NSDictionary *dic) {
        weixinBtn.enabled=YES;
        shuxinBtn.enabled=YES;
    }];
}


//支付宝支付返回回调
-(void)setAliMsg:(id)vul{
    if ([vul isEqualToString:@"9000"] || [vul isEqualToString:@"8000"]) {
        [self shuaxinWX];
    }
}


//支付校验
-(void)shuaxinWX{
    if (shuxinBtn!=nil) {
        shuxinBtn.enabled=NO;
    }
    NSString *payNo=[NSString stringWithFormat:@"%d",[[Util isNil:dataDic[@"parkpayinfo"][@"payNo"]] intValue]];
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:[Global sharedClient].member_id,@"member_id",[Global sharedClient].markID,@"mall_id",payNo,@"ketuoOrderNo",nil];
    [SVProgressHUD showWithStatus:@"数据加载中"];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"usercenter" tp:@"ispaysuccess"] parameters:params target:self success:^(NSDictionary *dic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@",dic);
            if (shuxinBtn!=nil) {
                shuxinBtn.enabled=YES;
            }
            PayResultController *rvc=[[PayResultController alloc]init];
            rvc.typeStr=@"1";
            rvc.couponreduce=[Util isNil:zhifuDic[@"couponreduce"]];
            rvc.fee         =[Util isNil:zhifuDic[@"fee"]];
            rvc.totalReduce =[Util isNil:zhifuDic[@"totalReduce"]];
            rvc.parkID      =_parkID;
            rvc.car_no      =_car_no;
            [self.delegate.navigationController pushViewController:rvc animated:YES];
            [SVProgressHUD dismiss];
        });
    } failue:^(NSDictionary *dic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (shuxinBtn!=nil) {
                shuxinBtn.enabled=YES;
            }
            [self shuaxin];
        });
    }];
}
//支付宝支付成功延迟，创建刷新按钮凯德确认之后跳转
-(void)shuaxin{
    if (shuxinBtn==nil) {
        shuxinBtn=[[UIButton alloc]initWithFrame:weixinBtn.bounds];
        shuxinBtn.layer.masksToBounds=YES;
        shuxinBtn.layer.cornerRadius=5;
        shuxinBtn.backgroundColor=UIColorFromRGB(0xe12b2b);
        [shuxinBtn setTitle:@"支付刷新" forState:UIControlStateNormal];
        shuxinBtn.titleLabel.font=COOL_FONT;
        [shuxinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [shuxinBtn addTarget:self action:@selector(shuaxinWX) forControlEvents:UIControlEventTouchUpInside];
        [weixinBtn addSubview:shuxinBtn];
    }
}


//优惠券选中操作
-(void)xuanzhongTouch:(UIButton *)sender{
    //优惠券处理
    int fee     = [[Util isNil:dataDic[@"parkpayinfo"][@"fee"]]intValue];
    if (fee==0) {
        [SVProgressHUD showErrorWithStatus:@"无需使用优惠券"];
        return;
    }
    int index =(int)sender.tag-200;
    NSMutableArray *itmeAry2=[[NSMutableArray alloc]init];
    NSArray *couponList=dataDic[@"couponList"];
    if ([Util isNull:couponList]) {
        [self diyongjuanMoney:0];
        ticketno=@"";
    }else{
        for (NSDictionary *diction in couponList) {
            [itmeAry2 addObject:[Util isNil:diction[@"title"]]];
        }
        if (index==itmeAry2.count) {
            [self diyongjuanMoney:0];
            ticketno=@"";
        }else {
            int money=[[Util isNil:couponList[index][@"amount"]]intValue];
            int  maxIntegral_1 = maxIntegral-jifenMoney;
            if (maxIntegral_1==0) {
                [SVProgressHUD showErrorWithStatus:@"无需使用优惠券"];
                return;
            }
            [self diyongjuanMoney:money];
            ticketno=[NSString stringWithFormat:@"%@",[Util isNil:couponList[index][@"ticketNo"]]];
        }
    }
    
    if(selectBtn != nil){
        selectBtn.selected=NO;
    }
    sender.selected=YES;
    selectBtn=sender;
    btnTag=(int)sender.tag-200;
}


//左边减号的点击事件
-(void)laftBtnTouch{
    if (time_count==0) {
    }else {
        time_count--;
        timeHouerNumLab.text=[NSString stringWithFormat:@"%d小时",time_count];
        int jifen =time_count*integralBase;
        itemLab.text = [NSString stringWithFormat:@"可用积分%d",maxIntegral - jifen];
        int maxIntegral_1= maxIntegral -juanMoney;//积分兑换需要减去优惠券使用的金额
        slider.maximumValue = maxIntegral_1/integralBase;// 设置最大值
        slider.value =time_count;// 设置初始值
        [self jifendikouNUM];
    }
}
//右边加号的点击事件
-(void)rightBtnTouch{
    int fee = [[Util isNil:dataDic[@"parkpayinfo"][@"fee"]]intValue];
    int maxIntegral_1= fee -juanMoney;//积分兑换需要减去优惠券使用的金额
    if (maxIntegral_1>0) {
        if ((maxIntegral-(time_count*integralBase))>0) {
            if (integralBase>0) {
                int maxcount=maxIntegral_1/integralBase;
                if (time_count==maxcount) {
                }else{
                    time_count++;
                    timeHouerNumLab.text=[NSString stringWithFormat:@"%d小时",time_count];
                    int jifen =time_count*integralBase;
                    itemLab.text = [NSString stringWithFormat:@"可用积分%d",maxIntegral - jifen];
                    slider.maximumValue = maxIntegral_1/integralBase;// 设置最大值
                    slider.value =time_count;// 设置初始值
                }
            }
        }
    }
    [self jifendikouNUM];
}

//滑动条上的加减积分兑换金额
- (void)sliderValueChanged:(id)sender {
    int fee = [[Util isNil:dataDic[@"parkpayinfo"][@"fee"]]intValue];
    
    int maxIntegral_1= fee -juanMoney;//积分兑换需要减去优惠券使用的金额
    if (maxIntegral_1==0) {
        time_count=0;
        slider.value=0;
        return;
    }
    if (maxIntegral/integralBase ==0) {
        time_count=0;
        slider.value=0;
        return;
    }
    slider.maximumValue = maxIntegral_1/integralBase;// 设置最大值
    UISlider *slider = (UISlider *)sender;
    float zz = slider.value;
    if (zz>0) {
        int cc =zz;
        float bb =zz-cc;
        if (bb>0) {
            if (bb>0.5) {
                time_count=cc+1;
            }else{
                time_count=cc;
            }
        }else{
            time_count=0;
        }
    }else{
        time_count=0;
    }
    
    slider.value=time_count;
    timeHouerNumLab.text=[NSString stringWithFormat:@"%d小时",time_count];
    itemLab.text = [NSString stringWithFormat:@"可用积分%d",maxIntegral - time_count*integralBase];
    [self jifendikouNUM];
    
}


//积分变动
-(void)jifendikouNUM{
    NSDictionary *dic=dataDic[@"parkpayinfo"];
    jifenLab.text=[NSString stringWithFormat:@"- 积分抵扣%d元",[[Util isNil:dic[@"changeValuePer"]]intValue]*time_count];
    zhushiLabl.text=[NSString stringWithFormat:@"%@%d%@",@"注 : 本次消耗",[[Util isNil:dic[@"integralBase"]]intValue]*time_count,@"积分"];
    jifenMoney =[[Util isNil:dic[@"changeValuePer"]]intValue]*time_count;
    [self zongMoney];
}

//抵用券变动
-(void)diyongjuanMoney:(int)ymoney{
    youhuiLab.text=[NSString stringWithFormat:@"%@%d%@",@"- 停车券抵扣",ymoney,@"元"];
    juanMoney =ymoney;
    [self zongMoney];
}


//总金额变动
-(void)zongMoney{
    NSDictionary *dic=dataDic[@"parkpayinfo"];
    feeMoney=[[Util isNil:dic[@"fee"]]intValue]-juanMoney-jifenMoney;
    zhifuLab.text=[NSString stringWithFormat:@"%@%d%@",@"应缴纳：",feeMoney,@"元"];
    zhifuLab.textColor=UIColorFromRGB(0xff632b);
    [zhifuLab setAttrColor:0 end:3 color:[UIColor blackColor]];
}

//通用View
-(void)initViewButtom_line:(UIView*)buttomLine :(NSString*)labText :(int)type ;
{
    if ([Util isNull:labText]) {
        
    }else{
        UILabel *titlelab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(15), 0, M_WIDTH(250),buttomLine.frame.size.height)];
        titlelab.textAlignment=NSTextAlignmentLeft;
        if (type==0) {
            titlelab.textColor=[UIColor blackColor];
            titlelab.font=DESC_FONT;
        }else {
            titlelab.font=INFO_FONT;
            titlelab.textColor=COLOR_FONT_SECOND;
        }
        titlelab.text=labText;
        [buttomLine addSubview:titlelab];
    }
}

@end

