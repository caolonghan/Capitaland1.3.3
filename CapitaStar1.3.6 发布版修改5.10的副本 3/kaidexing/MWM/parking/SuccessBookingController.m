//
//  SuccessBookingController.m
//  kaidexing
//
//  Created by 朱巩拓 on 16/6/29.
//  Copyright © 2016年 dwolf. All rights reserved.
//


//---------------------成功锁定界面（支付定金之后的界面，和不需要定金的界面）-----------------------

#import "SuccessBookingController.h"
#import "ParkingPayController.h"
#import "GoViewController.h"
#import "MLabel.h"

@interface SuccessBookingController ()

@property (strong,nonatomic)UIView  *rootView2;//支付成功的底层视图

@end

@implementation SuccessBookingController
{
    UILabel *timeLab_1;
    UILabel *timeLab_2;
    NSTimer *time;
    int     shijianNum;//一共多少秒
    NSDictionary *dataDic;
    MLabel *shuomingLab_1;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarTitleLabel.text=@"成功预订";
    self.view.backgroundColor=UIColorFromRGB(0xf1f4f4);
    dataDic=[[NSDictionary alloc]init];
    [self loadData];
}
//
- (void)loadData {
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:_park_id,@"park_id",_car_no,@"car_no",nil];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"park" tp:@"reserveparksuc"] parameters:params target:self success:^(NSDictionary *dic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            dataDic=dic[@"data"];
            [self createHeadView_2];
        });
    } failue:^(NSDictionary *dic) {
    }];
}

//预定车位成功的视图
-(void)createHeadView_2
{
    self.rootView2=[[UIView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, WIN_WIDTH,WIN_HEIGHT-NAV_HEIGHT)];
    UIImageView *headView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, M_WIDTH(210))];
    [headView setImage:[UIImage imageNamed:@"bolang"]];
    
    UIImageView *pImg=[[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH/2-M_WIDTH(20.5),M_WIDTH(38),M_WIDTH(41),M_WIDTH(41))];
    [pImg setImage:[UIImage imageNamed:@"duigou_red"]];
    [headView addSubview:pImg];
    
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(pImg.frame)+M_WIDTH(26),WIN_WIDTH,M_WIDTH(17))];
    titleLab.textAlignment=NSTextAlignmentCenter;
    titleLab.font=COMMON_FONT;
    NSString *str111=@"预定成功";
    int  reserve_money=[[Util isNil:dataDic[@"reserve_money"]]intValue];
    NSString *str222=[NSString stringWithFormat:@"%@%d",@"￥",reserve_money];
    [self colorLab:titleLab :str111 :@"" :nil];
    [headView addSubview:titleLab];

    
    
    UILabel *shengyuLab=[[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(titleLab.frame)+M_WIDTH(35),M_WIDTH(155),M_WIDTH(23))];
    shengyuLab.text=@"剩余时间:";
    shengyuLab.textAlignment=NSTextAlignmentRight;
    shengyuLab.font=COOL_FONT;
    shengyuLab.textColor=UIColorFromRGB(0x3cc676);
    [headView addSubview:shengyuLab];
    
    
    
    timeLab_1=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(shengyuLab.frame)+M_WIDTH(5),CGRectGetMaxY(titleLab.frame)+M_WIDTH(35), M_WIDTH(18),M_WIDTH(23))];
    timeLab_1.textColor=[UIColor whiteColor];
    timeLab_1.textAlignment=NSTextAlignmentCenter;
    timeLab_1.backgroundColor=UIColorFromRGB(0x3cc676);
    timeLab_1.layer.masksToBounds=YES;
    timeLab_1.layer.cornerRadius=3;
    timeLab_1.font=COOL_FONT;
    [headView addSubview:timeLab_1];
    
    timeLab_2=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(timeLab_1.frame)+M_WIDTH(2),CGRectGetMaxY(titleLab.frame)+M_WIDTH(35), M_WIDTH(18),M_WIDTH(23))];
    timeLab_2.textColor=[UIColor whiteColor];
    timeLab_2.textAlignment=NSTextAlignmentCenter;
    timeLab_2.backgroundColor=UIColorFromRGB(0x3cc676);
    timeLab_2.layer.masksToBounds=YES;
    timeLab_2.layer.cornerRadius=3;
    timeLab_2.font=COOL_FONT;
    [headView addSubview:timeLab_2];
    
    int  restTimeint=[[Util isNil:dataDic[@"RestTime"]]intValue];
    shijianNum=restTimeint*60+60;
    time =[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES]; //启动倒计时后会每秒钟调用一次方法
    
    UILabel *fengzhongLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(timeLab_2.frame)+M_WIDTH(2), CGRectGetMaxY(titleLab.frame)+M_WIDTH(35), M_WIDTH(50), M_WIDTH(23))];
    fengzhongLab.textAlignment=NSTextAlignmentLeft;
    fengzhongLab.textColor=UIColorFromRGB(0x3cc676);
    fengzhongLab.text=@"分钟";
    fengzhongLab.font=COOL_FONT;
    [headView addSubview:fengzhongLab];
    
    [self.rootView2 addSubview:headView];
    
    MLabel *shuomingLab_0=[[MLabel alloc]initWithFrame:CGRectMake(M_WIDTH(15),CGRectGetMaxY(headView.frame)+M_WIDTH(20), WIN_WIDTH-M_WIDTH(30), M_WIDTH(17))];
    shuomingLab_0.font=DESC_FONT;
    shuomingLab_0.numberOfLines=0;
    NSString *shopnamestr  = [Util isNil:dataDic[@"parkname"]];
    NSString *parkspacestr = [Util isNil:dataDic[@"parkspace"]];
    shuomingLab_0.text=[NSString stringWithFormat:@"%@%@%@%@%@",@"恭喜您！已成功预定",shopnamestr,@"B2M",parkspacestr,@"车位"];
    shuomingLab_0.maxHeight=100;
    [shuomingLab_0 autoSize];
    [self.rootView2 addSubview:shuomingLab_0];
    
    
    shuomingLab_1=[[MLabel alloc]initWithFrame:CGRectMake(M_WIDTH(15),CGRectGetMaxY(shuomingLab_0.frame)+M_WIDTH(8), WIN_WIDTH-M_WIDTH(30), M_WIDTH(17))];
    shuomingLab_1.font=DESC_FONT;
    shuomingLab_1.text=@"请于30分钟内到达指定车位，过期已预订车位将被取消";
    shuomingLab_1.textColor=[UIColor redColor];
    shuomingLab_1.numberOfLines=0;
    shuomingLab_1.maxHeight=200;
    [shuomingLab_1 autoSize];
    [self.rootView2 addSubview:shuomingLab_1];
    
    
    MLabel *addresslabMsg = [[MLabel alloc]initWithFrame:CGRectMake(M_WIDTH(15),CGRectGetMaxY(shuomingLab_1.frame)+M_WIDTH(8),WIN_WIDTH-M_WIDTH(30),M_WIDTH(17))];
    addresslabMsg.text=@"注：请从台柳路入口驶入B2M的VIP区域";
    addresslabMsg.font=DESC_FONT;
    addresslabMsg.textColor = [UIColor redColor];
    addresslabMsg.maxHeight=100;
    [addresslabMsg autoSize];
    [self.rootView2 addSubview:addresslabMsg];

//    请于30分钟内到达指定车位，过期已预订车位将被取消
    
//    UILabel *shuoming_2=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(15),CGRectGetMaxY(shuomingLab_1.frame)+M_WIDTH(8), WIN_WIDTH-M_WIDTH(30), M_WIDTH(17))];
//    shuoming_2.font=DESC_FONT;
//    shuoming_2.textAlignment=NSTextAlignmentLeft;
//    shuoming_2.textColor=[UIColor redColor];
//    shuoming_2.numberOfLines=0;
//    shuoming_2.text=@"※请在五分钟内支付定金，逾期已锁定车位将被取消";
//    CGRect rect2=[shuoming_2.text boundingRectWithSize:CGSizeMake(WIN_WIDTH-M_WIDTH(30),M_WIDTH(40)) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:shuoming_2.font} context:nil];
//    shuoming_2.frame=CGRectMake(shuoming_2.frame.origin.x, shuoming_2.frame.origin.y, rect2.size.width, rect2.size.height);
//    [self.rootView2 addSubview:shuoming_2];
    
    
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(M_WIDTH(15),CGRectGetMaxY(addresslabMsg.frame)+M_WIDTH(50), WIN_WIDTH-M_WIDTH(30), M_WIDTH(38))];
    btn.backgroundColor=UIColorFromRGB(0xdf2b2a);
    [btn setTitle:@"如何到达停车场" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.layer.masksToBounds=YES;
    btn.layer.cornerRadius=5;
    [btn addTarget:self action:@selector(daodaTouch) forControlEvents:UIControlEventTouchUpInside];
    [self.rootView2 addSubview:btn];
    [self.view addSubview:self.rootView2];
}

-(void)timeFireMethod
{
    if (shijianNum>0) {
        shijianNum--;
        if (shijianNum<60) {
            timeLab_1.text=@"0";
            timeLab_2.text=@"0";
        }else if(shijianNum<3600){
            int time_m=shijianNum/60;
            int time_1=time_m/10;
            int time_2=time_m%10;
            timeLab_1.text=[NSString stringWithFormat:@"%d",time_1];
            timeLab_2.text=[NSString stringWithFormat:@"%d",time_2];
//            shuomingLab_1.text=[NSString stringWithFormat:@"%@%d%@",@"※请于",time_m,@"分钟内到达指定车位，逾期无效，且定金将不返还"];
//            CGRect rect1=[shuomingLab_1.text boundingRectWithSize:CGSizeMake(WIN_WIDTH-M_WIDTH(30),M_WIDTH(40)) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:shuomingLab_1.font} context:nil];
//            shuomingLab_1.frame=CGRectMake(shuomingLab_1.frame.origin.x, shuomingLab_1.frame.origin.y, rect1.size.width, rect1.size.height);
        }
    }else {
        timeLab_1.text=@"0";
        timeLab_2.text=@"0";
//        shuomingLab_1.text=[NSString stringWithFormat:@"%@%@%@",@"※请于",@"0",@"分钟内到达指定车位，逾期无效，且定金将不返还"];
//        CGRect rect1=[shuomingLab_1.text boundingRectWithSize:CGSizeMake(WIN_WIDTH-M_WIDTH(30),M_WIDTH(40)) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:shuomingLab_1.font} context:nil];
//        shuomingLab_1.frame=CGRectMake(shuomingLab_1.frame.origin.x, shuomingLab_1.frame.origin.y, rect1.size.width, rect1.size.height);
    }
}


//如何到达停车场
-(void)daodaTouch{
    NSLog(@"如何到达停车场");
    GoViewController*pvc=[[GoViewController alloc]init];
    pvc.path=dataDic[@"arrive"];
    [self.delegate.navigationController pushViewController:pvc animated:YES];
}

//
-(void)colorLab:(UILabel *)lab :(NSString*)str1 :(NSString *)str2 :(NSString*)str3
{
    int  str1_l   =(int)str1.length;
    int  str2_l   =(int)str2.length;
    
    NSString    *labText = [NSString stringWithFormat:@"%@%@%@",str1,str2,[Util isNil:str3]];
    lab.text             = labText;
    lab.attributedText   = [Util getAttrColor:lab.text begin:str1_l end:str2_l color:[UIColor redColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
