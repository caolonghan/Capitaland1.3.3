//
//  PaymentCodeController.m
//  kaidexing
//
//  Created by companycn on 2018/3/7.
//  Copyright © 2018年 dwolf. All rights reserved.
//

#import "PaymentCodeController.h"
#import "NextPaymentCodeController.h"
#import "ShowPayViewController.h"
#import "BankPayProtocolController.h"

@interface PaymentCodeController ()
@property (nonatomic,strong)UIImageView *bgView;


@end

@implementation PaymentCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.hidden = YES;
   

    _bgView = [[UIImageView alloc]initWithFrame:SCREEN_FRAME];
    _bgView.image = [UIImage imageNamed:@"payment"];
    _bgView.userInteractionEnabled=YES;
    [self.view addSubview: _bgView];
    [self createNavagationBar];
    [self createView];
    
    [[NSUserDefaults standardUserDefaults]setObject:@"isFirstOpenBankPay" forKey:@"isFirstOpenBankPay"];
    
}

- (void)createNavagationBar{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, WIN_WIDTH, NAV_HEIGHT)];
    [self.view addSubview:headerView];
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, M_WIDTH(30), M_WIDTH(30))];
    backBtn.titleLabel.font=COMMON_FONT;
    [backBtn setImage:[UIImage imageNamed:@"AR_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:backBtn];
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(WIN_WIDTH/2-30, 0, 60, 30)];
    [headerView addSubview:title];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"付款";
    title.textColor = [UIColor whiteColor];
}
-(void)backAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createView
{
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, WIN_HEIGHT-100-BAR_HEIGHT, WIN_WIDTH, 80)];
    [self.view addSubview:bottomView];
  
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(70, 0, bottomView.width-140,40)];
    [btn setTitle:@"立即开通" forState:UIControlStateNormal];
    [btn.titleLabel setTextColor:[UIColor whiteColor]];
    [btn setBackgroundColor:RGBCOLOR(0, 135, 140)];
    [btn addTarget:self action:@selector(clickToNext:) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    [bottomView addSubview:btn];
  
    UILabel *protLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, bottomView.width, 20)];
    UILabel *protLabel2 =  [[UILabel alloc]initWithFrame:CGRectMake(0, 70, bottomView.width, 20)];
    protLabel1.text = @"立即开通视为同意开通";
    protLabel1.textAlignment = NSTextAlignmentCenter;
    protLabel1.textColor = [UIColor lightGrayColor];
    protLabel1.font = [UIFont systemFontOfSize:12];
    
    protLabel2.text = @"《凯德星app”银联二维码支付“用户服务协议》";
    protLabel2.textColor = [UIColor lightGrayColor];
    protLabel2.textAlignment = NSTextAlignmentCenter;
    protLabel2.font = [UIFont systemFontOfSize:12];
    [bottomView addSubview:protLabel2];
    [bottomView addSubview:protLabel1];
    
    UIButton *protocolBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 50, btn.width,40)];
    [bottomView addSubview:protocolBtn];
    [protocolBtn addTarget:self action:@selector(clickToLookProtocol:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)clickToNext:(UIButton *)sender
{
    
    ShowPayViewController *showVc = [[ShowPayViewController alloc]init];
    showVc.isBack = YES;
    [self.navigationController pushViewController:showVc animated:YES];
}
- (void)clickToLookProtocol:(UIButton *)sender
{
    BankPayProtocolController *banKVc = [[BankPayProtocolController alloc]init];
    [self.navigationController pushViewController:banKVc animated:YES];
}

@end
