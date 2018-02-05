//
//  SuccessLockingController.m
//  kaidexing
//
//  Created by 朱巩拓 on 16/7/9.
//  Copyright © 2016年 dwolf. All rights reserved.
//


//--------------------------需要支付定金的界面-----------------------------


#import "SuccessLockingController.h"
#import "WXApi.h"
#import "DataMD5.h"
#import "WXApiManager.h"
#import "SuccessBookingController.h"
#import "PayTypeViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "AliManager.h"


@interface SuccessLockingController()
@property (strong,nonatomic)UIView  *rootView1;//将要支付的底层视图
@property (strong,nonatomic)NSMutableDictionary    *payDic;
@property (strong,nonatomic)NSDictionary           *dataDic;
@end

@implementation SuccessLockingController
{
    UILabel *timeLab;
    NSTimer *timer;
    int     shijianNum;//一共多少秒
    UIButton *zhifuBtn;
    UIButton *zhifuBtn2;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarTitleLabel.text=@"成功预订";
    self.dataDic=[[NSDictionary alloc]init];
    self.payDic=[[NSMutableDictionary alloc]init];
    self.view.backgroundColor=UIColorFromRGB(0xf1f4f4);
   
    [self loadData];
}

- (void)loadData {
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:[Global sharedClient].member_id,@"member_id",@"41",@"mall_id",_park_id,@"park_id",nil];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"park" tp:@"lockpark"] parameters:params target:self success:^(NSDictionary *dic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.dataDic=dic[@"data"];
            [self createHeadView_1];
        });
    } failue:^(NSDictionary *dic) {
    }];
}

//将要预定车位的视图
-(void)createHeadView_1
{
    self.rootView1=[[UIView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, WIN_WIDTH,WIN_HEIGHT-NAV_HEIGHT)];
    UIImageView *headView=[[UIImageView alloc]initWithFrame:CGRectMake(0,0, WIN_WIDTH, M_WIDTH(210))];
    [headView setImage:[UIImage imageNamed:@"bolang"]];
    //    headView.backgroundColor=[UIColor whiteColor];
    
    UIImageView *pImg=[[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH/2-M_WIDTH(20.5), M_WIDTH(38), M_WIDTH(41), M_WIDTH(41))];
    [pImg setImage:[UIImage imageNamed:@"tingche_P"]];
    [headView addSubview:pImg];
    
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(pImg.frame)+M_WIDTH(14), WIN_WIDTH, M_WIDTH(17))];
    titleLab.textAlignment=NSTextAlignmentCenter;
    titleLab.font=COMMON_FONT;
    titleLab.text=@"已成功帮您锁定";
    [headView addSubview:titleLab];
    
    UILabel *shoppingLab=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLab.frame)+M_WIDTH(6), WIN_WIDTH, M_WIDTH(19))];
    NSString *str1=[Util isNil:_dataDic[@"park_name"]];
    NSString *str2=[Util isNil:_dataDic[@"park_space"]];
    shoppingLab.font=COMMON_FONT;
    [self colorLab:shoppingLab :str1 :str2:nil];
    shoppingLab.textAlignment=NSTextAlignmentCenter;
    [headView addSubview:shoppingLab];
    
    UILabel *shengyuLab=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(shoppingLab.frame)+M_WIDTH(23), M_WIDTH(160), M_WIDTH(23))];
    shengyuLab.text=@"剩余时间:";
    shengyuLab.textAlignment=NSTextAlignmentRight;
    shengyuLab.font=COOL_FONT;
    shengyuLab.textColor=UIColorFromRGB(0x3cc676);
    [headView addSubview:shengyuLab];
    
    timeLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(shengyuLab.frame)+M_WIDTH(5),CGRectGetMaxY(shoppingLab.frame)+M_WIDTH(22), M_WIDTH(18),M_WIDTH(23))];
    timeLab.textColor=[UIColor whiteColor];
    timeLab.textAlignment=NSTextAlignmentCenter;
    timeLab.backgroundColor=UIColorFromRGB(0x3cc676);
    timeLab.layer.masksToBounds=YES;
    timeLab.layer.cornerRadius=3;
    timeLab.font=COOL_FONT;
    shijianNum=[[Util isNil:_dataDic[@"restSecendTime"]] intValue];
    int time_zz=shijianNum/60;
    
    timer =[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
    timeLab.text=[NSString stringWithFormat:@"%d",time_zz];
    [headView addSubview:timeLab];
    
    UILabel *fengzhongLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(timeLab.frame)+M_WIDTH(2), CGRectGetMaxY(shoppingLab.frame)+M_WIDTH(23), M_WIDTH(50), M_WIDTH(23))];
    fengzhongLab.textAlignment=NSTextAlignmentLeft;
    fengzhongLab.textColor=UIColorFromRGB(0x3cc676);
    fengzhongLab.text=@"分钟";
    fengzhongLab.font=COOL_FONT;
    [headView addSubview:fengzhongLab];
    
    [self.rootView1 addSubview:headView];
    
    UILabel *shuomingLab_1=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(15),CGRectGetMaxY(headView.frame)+M_WIDTH(20), WIN_WIDTH-M_WIDTH(30), M_WIDTH(17))];
    NSString *str11=@"您还需支付";
    int money =[[Util isNil:_dataDic[@"reserve_money"]] intValue];
    NSString *str22=[NSString stringWithFormat:@"%d%@",money,@"元定金"];
    NSString *str33=@",支付完成即可成功预定车位。";
    [self colorLab:shuomingLab_1 :str11 :str22 :str33];
    shuomingLab_1.font=DESC_FONT;
    shuomingLab_1.numberOfLines=0;
    CGRect rect1=[shuomingLab_1.text boundingRectWithSize:CGSizeMake(WIN_WIDTH-M_WIDTH(30),M_WIDTH(40)) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:shuomingLab_1.font} context:nil];
    shuomingLab_1.frame=CGRectMake(shuomingLab_1.frame.origin.x, shuomingLab_1.frame.origin.y, rect1.size.width, rect1.size.height);
    [self.rootView1 addSubview:shuomingLab_1];
    
    UILabel *shuoming_2=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(15),CGRectGetMaxY(shuomingLab_1.frame)+M_WIDTH(8), WIN_WIDTH-M_WIDTH(30), M_WIDTH(17))];
    shuoming_2.font=DESC_FONT;
    shuoming_2.textAlignment=NSTextAlignmentLeft;
    shuoming_2.textColor=[UIColor redColor];
    shuoming_2.numberOfLines=0;
    shuoming_2.text=[NSString stringWithFormat:@"%@%d%@",@"※请在",time_zz,@"分钟内支付定金，逾期已锁定车位将被取消"];
    CGRect rect2=[shuoming_2.text boundingRectWithSize:CGSizeMake(WIN_WIDTH-M_WIDTH(30),M_WIDTH(40)) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:shuoming_2.font} context:nil];
    shuoming_2.frame=CGRectMake(shuoming_2.frame.origin.x, shuoming_2.frame.origin.y, rect2.size.width, rect2.size.height);
    [self.rootView1 addSubview:shuoming_2];
    
    
    zhifuBtn=[[UIButton alloc]initWithFrame:CGRectMake(M_WIDTH(15), CGRectGetMaxY(shuoming_2.frame)+M_WIDTH(29), WIN_WIDTH-M_WIDTH(30), M_WIDTH(38))];
    zhifuBtn.backgroundColor=UIColorFromRGB(0xdf2b2a);
    [zhifuBtn setTitle:@"立即支付" forState:UIControlStateNormal];
    [zhifuBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    zhifuBtn.layer.masksToBounds=YES;
    zhifuBtn.layer.cornerRadius=5;
    [zhifuBtn addTarget:self action:@selector(zhifuTouch) forControlEvents:UIControlEventTouchUpInside];
    [self.rootView1 addSubview:zhifuBtn];
    [self.view addSubview:self.rootView1];
}


-(void)timeFireMethod{
    if (shijianNum>0) {
        shijianNum--;
        if (shijianNum<60) {

        }else if(shijianNum<3600){
            int time_m=shijianNum/60;
            timeLab.text=[NSString stringWithFormat:@"%d",time_m];
        }
    }else {
        timeLab.text=[NSString stringWithFormat:@"%d",0];
        [timer setFireDate:[NSDate distantFuture]];
    }
}

//立即支付按钮
-(void)zhifuTouch
{
    if (shijianNum>0) {
       [self zhifuloadData];
    }else{
        [self showMsg:@"您已逾期，请返回重新预定" afterOK:^{
            [self.delegate.navigationController popViewControllerAnimated:YES];
        }];
    }
}

//立即支付请求数据
- (void)zhifuloadData {
    
    zhifuBtn.enabled=NO;
    [SVProgressHUD showWithStatus:@"正在加载中"];
//    int reserve_money=[[Util isNil:_dataDic[@"reserve_money"]]intValue];
    NSString *reserve_money=@"0.01";
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:[Global sharedClient].member_id,@"member_id",_park_id,@"park_id",[Global sharedClient].markID,@"mall_id",reserve_money,@"reserve_money",nil];
    
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"usercenter" tp:@"aliprepay"] parameters:params target:self success:^(NSDictionary *dic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@",dic);
            NSString *appScheme   = ALI_APPBack;
            NSString *orderString = [Util isNil:dic[@"data"][@"msg"]];
            [AliManager aliMsgOpenURL:nil].aiDelegate=self;
            [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                NSLog(@"reslut = %@",resultDic);
                
            }];
            
            [SVProgressHUD dismiss];
            
        });
    } failue:^(NSDictionary *dic) {
    }];

    
   

    
}

//支付宝支付返回回调
-(void)setAliMsg:(id)vul{
    if ([vul isEqualToString:@"9000"] || [vul isEqualToString:@"8000"]) {
        
    }
}


//-(void)managerDidRayResp:(PayResp *)response{
//    [self pushToSuccess];
//}
//-(void)shuaxinTouch{
//    [self pushToSuccess];
//}
//
//-(void)pushToSuccess
//{
//    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:[Global sharedClient].member_id,@"member_id",@"41",@"mall_id",_park_id,@"park_id",nil];
//    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"usercenter" tp:@"isprepaysuccess"] parameters:params target:self success:^(NSDictionary *dic) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            SuccessBookingController *sVC=[[SuccessBookingController alloc]init];
//            sVC.park_id=_park_id;
//            sVC.car_no=_car_no;
//            [self.delegate.navigationController pushViewController:sVC animated:YES];
//        });
//    } failue:^(NSDictionary *dic) {
//        if (zhifuBtn2==nil) {
//            zhifuBtn2=[[UIButton alloc]initWithFrame:zhifuBtn.bounds];
//            zhifuBtn2.backgroundColor=UIColorFromRGB(0xdf2b2a);
//            [zhifuBtn2 setTitle:@"刷新" forState:UIControlStateNormal];
//            [zhifuBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            zhifuBtn2.layer.masksToBounds=YES;
//            zhifuBtn2.layer.cornerRadius=5;
//            [zhifuBtn2 addTarget:self action:@selector(shuaxinTouch) forControlEvents:UIControlEventTouchUpInside];
//            [zhifuBtn addSubview:zhifuBtn2];
//         }
//      }];
//}


-(void)colorLab:(UILabel *)lab :(NSString*)str1 :(NSString *)str2 :(NSString*)str3
{
    int  str1_l   =(int)str1.length;
    int  str2_l   =(int)str2.length;
    
    NSString    *labText = [NSString stringWithFormat:@"%@%@%@",str1,str2,[Util isNil:str3]];
    lab.text             = labText;
    lab.attributedText   = [Util getAttrColor:lab.text begin:str1_l end:str2_l color:[UIColor redColor]];
}

//时间戳
-(UInt32)time_date
{
    // 将当前时间转化成时间戳
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    UInt32 timeStamp =[timeSp intValue];
    return timeStamp;
}




@end
