//
//  PayTypeViewController.m
//  kaidexing
//
//  Created by 朱巩拓 on 2016/10/19.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "PayTypeViewController.h"
#import "DataMD5.h"
#import "WXApiManager.h"
#import "SuccessBookingController.h"
#import "PayResultController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "AliManager.h"
@interface PayTypeViewController ()
@property(strong,nonatomic)NSDictionary *payDic;
@end

@implementation PayTypeViewController{
    
    UIImageView *seImg1;
    UIImageView *seImg2;
    int payType;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.payDic=[[NSDictionary alloc]init];
    self.navigationBarTitleLabel.text=@"缴费支付";
    self.view.backgroundColor=UIColorFromRGB(0xf3f3f3);
    [self createHeadView];
    
}

-(void)createHeadView{
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0,NAV_HEIGHT,WIN_WIDTH,M_WIDTH(43))];
    headView.backgroundColor=[UIColor whiteColor];
    
    UILabel  *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(12),0,M_WIDTH(150),M_WIDTH(43))];
    titleLab.text=@"需要支付停车费用";
    titleLab.textAlignment=NSTextAlignmentLeft;
    titleLab.font=DESC_FONT;
    [headView addSubview:titleLab];
    
    UILabel *moneyLable=[[UILabel alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(150),0,M_WIDTH(135),M_WIDTH(43))];
    moneyLable.textColor=[UIColor redColor];
    moneyLable.textAlignment=NSTextAlignmentRight;
    moneyLable.font=DESC_FONT;
    moneyLable.text=[NSString stringWithFormat:@"￥%@",@"20.00"];
    [headView addSubview:moneyLable];
    [self.view addSubview:headView];
    
    
    UILabel  *titleLab2=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(12),CGRectGetMaxY(headView.frame),M_WIDTH(150),M_WIDTH(36))];
    titleLab2.text=@"选择支付方式";
    titleLab2.textAlignment=NSTextAlignmentLeft;
    titleLab2.font=INFO_FONT;
    [self.view addSubview:titleLab2];
    
    UILabel *moneyLable2=[[UILabel alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(150),CGRectGetMaxY(headView.frame),M_WIDTH(135),M_WIDTH(43))];
    moneyLable2.textColor=COLOR_FONT_SECOND;
    moneyLable2.textAlignment=NSTextAlignmentRight;
    moneyLable2.font=INFO_FONT;
    moneyLable2.text=[NSString stringWithFormat:@"￥%@",@"20.00"];
    [self.view addSubview:moneyLable2];
    
    NSArray *imgAry=[[NSArray alloc]initWithObjects:@"",@"",nil];//
    NSArray *titleAry=[[NSArray alloc]initWithObjects:@"微信支付",@"支付宝支付",nil];//@"银联支付",
    seImg1   = [[UIImageView alloc]init];
    seImg2   = [[UIImageView alloc]init];
    payType=0;
    for (int j=0; j<imgAry.count; j++) {
        
        UIView*  iconView=[[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(titleLab2.frame)+M_WIDTH(44)*j,WIN_WIDTH,M_WIDTH(44))];
        iconView.backgroundColor=[UIColor whiteColor];
        UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(M_WIDTH(13),(iconView.frame.size.height-M_WIDTH(21))/2,M_WIDTH(24),M_WIDTH(21))];
        [img setImage:[UIImage imageNamed:@""]];
        [iconView addSubview:img];
        
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(img.frame)+M_WIDTH(13), 0,M_WIDTH(200),iconView.frame.size.height)];
        lab.text=titleAry[j];
        lab.font=DESC_FONT;
        lab.textAlignment=NSTextAlignmentLeft;
        [iconView addSubview:lab];
        
        if (j==0) {
            seImg1.frame=CGRectMake(WIN_WIDTH-M_WIDTH(28),(iconView.frame.size.height-M_WIDTH(13))/2, M_WIDTH(13), M_WIDTH(13));
            [seImg1 setImage:[UIImage imageNamed:@""]];
            [iconView addSubview:seImg1];
            UIView  *lineView4=[[UIView alloc]initWithFrame:CGRectMake(M_WIDTH(13),iconView.frame.size.height-0.5,WIN_WIDTH-M_WIDTH(13),0.5)];
            lineView4.backgroundColor=COLOR_LINE;
            [iconView addSubview:lineView4];
            
        }else if(j==1){
            seImg2.frame=CGRectMake(WIN_WIDTH-M_WIDTH(28),(iconView.frame.size.height-M_WIDTH(13))/2, M_WIDTH(13), M_WIDTH(13));
            [seImg2 setImage:[UIImage imageNamed:@""]];
            [iconView addSubview:seImg2];
        }
        
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(event:)];
        [iconView addGestureRecognizer:tapGesture];
        UIView *tapView1 = [tapGesture view];
        tapView1.tag = j;
        
        [self.view addSubview:iconView];
    }
    
    UIButton *querenBtn=[[UIButton alloc]initWithFrame:CGRectMake(M_WIDTH(18),CGRectGetMaxY(titleLab2.frame)+M_WIDTH(102),WIN_WIDTH-M_WIDTH(36),M_WIDTH(42))];
    [querenBtn setTitle:@"确认支付" forState:UIControlStateNormal];
    [querenBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    querenBtn.layer.masksToBounds=YES;
    querenBtn.layer.cornerRadius=3;
    querenBtn.backgroundColor=UIColorFromRGB(0xf15152);
    [querenBtn addTarget:self action:@selector(querenTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:querenBtn];
}

-(void)querenTouch:(UIButton*)sender{
//    
//    if (payType ==0) {
//        NSString *path;
//        NSDictionary * params;
//        if ([_viewType isEqualToString:@"0"]) {
//            path=[Util makeRequestUrl:@"usercenter" tp:@"prepay"];
//             params = [NSDictionary dictionaryWithObjectsAndKeys:[Global sharedClient].member_id,@"member_id",_park_id,@"park_id",_mall_id,@"mall_id",_moneyStr,@"reserve_money",nil];
//        }else{
//            path=[Util makeRequestUrl:@"usercenter" tp:@"pay"];
//        }
//       
//        [SVProgressHUD showWithStatus:@"正在加载中"];
//        [HttpClient requestWithMethod:@"POST" path:path parameters:params target:self success:^(NSDictionary *dic) {
//            NSLog(@"生成预付单返回-%@",dic);
//            PayReq *request = [[PayReq alloc] init];
//            [WXApiManager sharedManager].delegate=self;
//            request.partnerId = @"1359970902";
//            request.prepayId  = [Util isNil:dic[@"data"][@"prepay_id"]];
//            request.package   = @"Sign=WXPay";
//            request.nonceStr  = [Util isNil:dic[@"data"][@"nonce_str"]];
//            request.timeStamp = [self time_date];
//            
//            [self.payDic setValue:WX_APP_ID         forKey:@"appid"];
//            [self.payDic setValue:request.prepayId  forKey:@"prepayid"];
//            [self.payDic setValue:request.partnerId forKey:@"partnerid"];
//            [self.payDic setValue:request.package   forKey:@"package"];
//            [self.payDic setValue:request.nonceStr  forKey:@"noncestr"];
//            [self.payDic setValue:[NSString stringWithFormat:@"%u",(unsigned int)request.timeStamp] forKey:@"timestamp"];
//            // 签名加密
//            DataMD5 *md5 = [[DataMD5 alloc] init];
//            request.sign=[md5 createMD5SingForPay:WX_APP_ID partnerid:request.partnerId prepayid:request.prepayId package:request.package noncestr:request.nonceStr timestamp:request.timeStamp];
//            request.sign=[md5 createMD5SingForPay:self.payDic];
//            [WXApiManager sharedManager].delegate=self;
//            [WXApi sendReq:request];
//            [SVProgressHUD dismiss];
//            
//        } failue:^(NSDictionary *dic) {
//        }];
//        
//    }else{
//        
//        [SVProgressHUD showWithStatus:@"正在加载中"];
//        [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"member" tp:@"alipaysign"] parameters:_dataDic target:self success:^(NSDictionary *dic) {
//            NSLog(@"生成预付单返回-%@",dic);
//
//            [SVProgressHUD dismiss];
//            
//        } failue:^(NSDictionary *dic) {
//        }];
//    }
}

-(void)setAliMsg:(id)vul{
    if ([vul isEqualToString:@"9000"]) {
        
    }else if ([vul isEqualToString:@"8000"]) {
        
    }else if ([vul isEqualToString:@"7000"]) {
        
    }else if ([vul isEqualToString:@"6000"]) {
        
    }
    
}

//-(void)managerDidRayResp:(PayResp *)response{
//    if (_viewType==0) {
//        
//        [self pushToSuccess];
//    }else{
//     
//        [self shuaxinWX];
//    }
//}


//预定金微信支付成功返回验证
-(void)pushToSuccess{
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:[Global sharedClient].member_id,@"member_id",@"41",@"mall_id",_park_id,@"park_id",nil];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"usercenter" tp:@"isprepaysuccess"] parameters:params target:self success:^(NSDictionary *dic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            SuccessBookingController *sVC=[[SuccessBookingController alloc]init];
            sVC.park_id=_park_id;
            sVC.car_no=_car_no;
            [self.delegate.navigationController pushViewController:sVC animated:YES];
        });
    } failue:^(NSDictionary *dic) {
      }];
}
//停车完成微信付款成功之后的校验
-(void)shuaxinWX{
    NSString *payNo=[NSString stringWithFormat:@"%d",[_payNo intValue]];
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"member_id",@"1111",@"mall_id",payNo,@"ketuoOrderNo",nil];
    [SVProgressHUD showWithStatus:@"数据加载中"];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"usercenter" tp:@"ispaysuccess"] parameters:params target:self success:^(NSDictionary *dic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@",dic);
            PayResultController *rvc=[[PayResultController alloc]init];
            rvc.typeStr=@"1";
            rvc.car_no=_car_no;
            [self.delegate.navigationController pushViewController:rvc animated:YES];
            [SVProgressHUD dismiss];
        });
    } failue:^(NSDictionary *dic) {
    }];
}

-(void)event:(UITapGestureRecognizer*)tag{
    UITapGestureRecognizer *singleTap = (UITapGestureRecognizer *)tag;
    NSInteger index = singleTap.view.tag;
    payType=(int)index;
    
    if (index == 0) {
        
        [seImg1 setImage:[UIImage imageNamed:@""]];
        [seImg2 setImage:[UIImage imageNamed:@""]];

    }else if (index == 1){
        [seImg1 setImage:[UIImage imageNamed:@""]];
        [seImg2 setImage:[UIImage imageNamed:@""]];
    }
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
