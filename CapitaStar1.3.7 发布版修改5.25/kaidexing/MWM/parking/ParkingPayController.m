//
//  ParkingPayController.m
//  kaidexing
//
//  Created by 朱巩拓 on 16/7/1.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "ParkingPayController.h"
#import "PaymentDetailsController.h"
@interface ParkingPayController ()<UIScrollViewDelegate>
@property (strong,nonatomic)UIScrollView        *scrollView1;
@property (strong,nonatomic)NSDictionary        *dataDic;
@end

@implementation ParkingPayController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarTitleLabel.text=@"快速缴费";
    self.dataDic=[[NSDictionary alloc]init];
    self.scrollView1=[[UIScrollView alloc]initWithFrame:CGRectMake(0,NAV_HEIGHT,WIN_WIDTH,WIN_HEIGHT-NAV_HEIGHT)];
    self.scrollView1.delegate=self;
    self.scrollView1.scrollEnabled=YES;
    self.scrollView1.contentSize=CGSizeMake(WIN_WIDTH, WIN_HEIGHT);
    [self.view addSubview:self.scrollView1];
 
    [self chaxunNet];
}

//查询车位接口
-(void)chaxunNet{
    _car_no=[_car_no stringByReplacingOccurrencesOfString:@"_" withString:@""];
//    _car_no=@"鲁BJ72L8";
//    [Global sharedClient].markID
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:_car_no,@"car_no",[Global sharedClient].markID,@"mall_id",nil];
    [SVProgressHUD showWithStatus:@"数据加载中"];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"park" tp:@"getparkedInfo"] parameters:params target:self success:^(NSDictionary *dic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@",dic);
            self.dataDic=dic[@"data"];
            [self createView];
            [SVProgressHUD dismiss];
        });
    } failue:^(NSDictionary *dic) {
        
    }];
}

-(void)createView
{
    UIImageView *headView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, M_WIDTH(173))];
   
    [headView setImageWithURL:[NSURL URLWithString:[Util isNil:_dataDic[@"imgUrl"]]]placeholderImage:[UIImage imageNamed:@"carimg"]];
    [self.scrollView1 addSubview:headView];
    
    UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(headView.frame),WIN_WIDTH,M_WIDTH(48))];
    view1.backgroundColor=[UIColor whiteColor];
    
    //车牌
    UILabel *chepaiLab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(10), 0, M_WIDTH(150), M_WIDTH(48))];
    chepaiLab.text=[NSString stringWithFormat:@"%@%@",@"车牌 : ",_car_no];
    chepaiLab.textAlignment=NSTextAlignmentLeft;
    chepaiLab.font=DESC_FONT;
    [view1 addSubview:chepaiLab];
    
    //停车费
    UILabel *tingcheLab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(202),M_WIDTH(15),M_WIDTH(50),M_WIDTH(18))];
    tingcheLab.textAlignment=NSTextAlignmentCenter;
    tingcheLab.text=@"停车费";
    tingcheLab.textColor=UIColorFromRGB(0xff632b);
    tingcheLab.layer.masksToBounds=YES;
    tingcheLab.layer.cornerRadius=3;
    tingcheLab.layer.borderColor=UIColorFromRGB(0xff632b).CGColor;
    tingcheLab.layer.borderWidth=1;
    tingcheLab.font=INFO_FONT;
    [view1 addSubview:tingcheLab];
    
    UILabel *moneyLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tingcheLab.frame)+M_WIDTH(8), 0, M_WIDTH(50), M_WIDTH(48))];
    moneyLab.text=[NSString stringWithFormat:@"%@%@",@"￥",[Util isNil:_dataDic[@"fee"]] ];//@"￥400";
    moneyLab.textColor=UIColorFromRGB(0xff632b);
    moneyLab.textAlignment=NSTextAlignmentLeft;
    moneyLab.font=COMMON_FONT;
    [view1 addSubview:moneyLab];
    
    UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(0, M_WIDTH(48)-1, WIN_WIDTH, 1)];
    lineView1.backgroundColor=COLOR_LINE;
    [view1 addSubview:lineView1];
    [self.scrollView1 addSubview:view1];
    
    UIView *colorView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(view1.frame), WIN_WIDTH, M_WIDTH(11)-1)];
    colorView.backgroundColor=UIColorFromRGB(0xf0f0f0);
    [self.scrollView1 addSubview:colorView];
    
    UIView *lineView2=[[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(colorView.frame)-1,WIN_WIDTH,1)];
    lineView2.backgroundColor=COLOR_LINE;
    [self.scrollView1 addSubview:lineView2];
    
    NSArray *array=[[NSArray alloc]initWithObjects:@"停车场编号：",@"停车地点：",@"入场时间：",@"停车时长：", nil];
    NSArray *array2=[[NSArray alloc]initWithObjects:[NSString stringWithFormat:@"%d",[[Util isNil:_dataDic[@"parkId"]]intValue]],[Util isNil:_dataDic[@"parkName"]],[Util isNil:_dataDic[@"joinTime"]],@"2小时15分",nil];
    UIView *itemView;
    for (int i=0; i<array.count; i++) {
        itemView=[[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(lineView2.frame)+i*M_WIDTH(43), WIN_WIDTH,M_WIDTH(43))];
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(10),M_WIDTH(14),M_WIDTH(100),M_WIDTH(14))];
        lab.text=array[i];
        lab.textAlignment=NSTextAlignmentLeft;
        lab.font=DESC_FONT;
        CGRect rect1=[lab.text boundingRectWithSize:CGSizeMake(M_WIDTH(200),M_WIDTH(11)) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:lab.font} context:nil];
        lab.frame=CGRectMake(lab.frame.origin.x,(M_WIDTH(43)-rect1.size.height)/2,rect1.size.width,rect1.size.height);
        [itemView addSubview:lab];
        UILabel *lab2=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lab.frame),0, M_WIDTH(200),M_WIDTH(43))];
        if (i==0) {
            lab2.font=DESC_FONT;
        }else {
            lab2.font=INFO_FONT;
            lab2.textColor=COLOR_FONT_SECOND;
        }
        lab2.textAlignment=NSTextAlignmentLeft;
        lab2.text=array2[i];
        [itemView addSubview:lab2];
        UIView *lineView3=[[UIView alloc]initWithFrame:CGRectMake(0,M_WIDTH(43)-1, WIN_WIDTH, 1)];
        lineView3.backgroundColor=COLOR_LINE;
        [itemView addSubview:lineView3];
        [self.scrollView1 addSubview:itemView];
    }
    UIButton *jiaofeiBtn=[[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH/2-M_WIDTH(68),CGRectGetMaxY(itemView.frame)+M_WIDTH(23),M_WIDTH(136), M_WIDTH(43))];
    jiaofeiBtn.layer.masksToBounds=YES;
    jiaofeiBtn.layer.cornerRadius=5;
    jiaofeiBtn.backgroundColor=APP_BTN_COLOR;
    [jiaofeiBtn setTitle:@"快速缴费" forState:UIControlStateNormal];
    [jiaofeiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [jiaofeiBtn addTarget:self action:@selector(jiaofeiTouch) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView1 addSubview:jiaofeiBtn];
}


-(void)jiaofeiTouch{
    NSLog(@"点击了快速缴费");
    PaymentDetailsController *vc=[[PaymentDetailsController alloc]init];
    vc.car_no=_car_no;
    vc.parkID=_park_idStr;
    vc.mall_id=_mall_id;
    [self.delegate.navigationController pushViewController:vc animated:YES];
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
