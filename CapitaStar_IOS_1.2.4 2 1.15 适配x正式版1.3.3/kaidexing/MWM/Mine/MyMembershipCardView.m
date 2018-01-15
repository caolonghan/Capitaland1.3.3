//
//  MyMembershipCardView.m
//  kaidexing
//
//  Created by 朱巩拓 on 2017/2/10.
//  Copyright © 2017年 dwolf. All rights reserved.
//

#import "MyMembershipCardView.h"

@interface MyMembershipCardView ()

@end

@implementation MyMembershipCardView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBarTitleLabel.text=@"会员卡";
    self.navigationBarTitleLabel.textColor = [UIColor whiteColor];
    self.navigationBar.backgroundColor=UIColorFromRGB(0x303030);
    self.navigationBarLine.backgroundColor = UIColorFromRGB(0x303030);
    self.view.backgroundColor=UIColorFromRGB(0x303030);
    [self popToViewBtn];
    [self loadData];
}

-(void)popToViewBtn{
    UIButton *btn = [[UIButton alloc]initWithFrame:self.leftBarItemView.bounds];
    [btn setImage:[UIImage imageNamed:@"newWBack"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(popTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.leftBarItemView addSubview:btn];
}

-(void)popTouch:(UIButton*)sender{
    [self.delegate.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
#pragma mark ---请求网络---
-(void)loadData{
    [SVProgressHUD showWithStatus:@"正在努力加载中"];
    NSDictionary*diction=[[NSDictionary alloc]initWithObjectsAndKeys:[Global sharedClient].member_id,@"member_id", @"1000",@"source",nil];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"usercenter" tp:@"vipcard"] parameters:diction  target:self success:^(NSDictionary *dic){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self createView:dic[@"data"]];
            [SVProgressHUD dismiss];
        });
    }failue:^(NSDictionary *dic){
    }];
}


-(void)createView:(NSDictionary*)dic{
    CGFloat view_W = WIN_WIDTH-M_WIDTH(34);
    UIView * rootView = [[UIView alloc]initWithFrame:CGRectMake(M_WIDTH(17),NAV_HEIGHT+M_WIDTH(10),view_W,WIN_HEIGHT-NAV_HEIGHT-M_WIDTH(61))];
    rootView.backgroundColor = [UIColor whiteColor];
    rootView.layer.masksToBounds=YES;
    rootView.layer.cornerRadius=8;
    [self.view addSubview:rootView];
    
    UIImageView *headLogoImg = [[UIImageView alloc]initWithFrame:CGRectMake(M_WIDTH(17),M_WIDTH(6),M_WIDTH(88),M_WIDTH(63))];
    [headLogoImg setImage:[UIImage imageNamed:@"logo01"]];
    [rootView addSubview:headLogoImg];
    
    {//会员卡信息
        if(![Util isNull:dic[@"is_office"]]  && [dic[@"is_office"]  intValue] == 1 ){
            UIImageView *memberImg = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(rootView.frame) - M_WIDTH(100),M_WIDTH(33),M_WIDTH(100),M_WIDTH(25))];
            [memberImg setImage:[UIImage imageNamed:@"office_member"]];
            [rootView addSubview:memberImg];
        }
        
    }
    
    UIImageView *backgroundImg = [[UIImageView alloc]initWithFrame:CGRectMake(0,M_WIDTH(75),view_W,M_WIDTH(90))];
    [backgroundImg setImage:[UIImage imageNamed:@"navRectangle"]];
    
    UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(16),M_WIDTH(20),view_W-M_WIDTH(32),M_WIDTH(22))];
    nameLab.font=BIG_FONT;
    nameLab.textColor= [UIColor whiteColor];
    nameLab.text=[Util isNil:dic[@"parentName"]];
    [backgroundImg addSubview:nameLab];
    
    UILabel *cardLab = [[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(16),CGRectGetMaxY(nameLab.frame),view_W-M_WIDTH(32),M_WIDTH(30))];
    cardLab.textColor=[UIColor whiteColor];
    cardLab.font=BIG_FONT;
    cardLab.text=[NSString stringWithFormat:@"%@",[Util isNil:dic[@"parentMemberNo"]]];
    [backgroundImg addSubview:cardLab];
    [rootView addSubview:backgroundImg];
    
    UIImageView *QRCodeImg = [[UIImageView alloc]initWithFrame:CGRectMake((view_W - M_WIDTH(115))/2,CGRectGetMaxY(backgroundImg.frame)+M_WIDTH(72),M_WIDTH(115),M_WIDTH(115))];
    [QRCodeImg setImageWithURL:[NSURL URLWithString:[Util isNil:dic[@"vipimgurl"]]]];
    [rootView addSubview:QRCodeImg];
    
    UIImageView *buttomImg = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(rootView.frame)/2-M_WIDTH(30)/2,rootView.frame.size.height-M_WIDTH(39),M_WIDTH(30),M_WIDTH(29))];
    [buttomImg setImage:[UIImage imageNamed:@"logo02"]];
    [rootView addSubview:buttomImg];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
