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

@interface PaymentCodeController ()
@property (nonatomic,strong)UIImageView *bgView;
@end

@implementation PaymentCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.hidden = YES;
   
    self.navigationBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    _bgView = [[UIImageView alloc]initWithFrame:SCREEN_FRAME];
    _bgView.image = [UIImage imageNamed:@"bg"];
    _bgView.userInteractionEnabled=YES;
    [self.view addSubview: _bgView];
    [self createNavagationBar];
    [self createView];
    
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
    title.text = @"付款";
    title.textColor = [UIColor whiteColor];
}
-(void)backAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createView
{
    UILabel *titleLabel1= [[UILabel alloc]initWithFrame:CGRectMake(40, WIN_HEIGHT/2-110, WIN_WIDTH-80,100)];
    UILabel *titleLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(40, WIN_HEIGHT/2+10, WIN_WIDTH-80,100)];
    titleLabel1.text = @"开通付款码";
    titleLabel2.text = @"支付拿积分";
    titleLabel1.textColor = [UIColor whiteColor];
    titleLabel2.textColor = [UIColor whiteColor];
    titleLabel1.font = [UIFont systemFontOfSize:60];
    titleLabel2.font = [UIFont systemFontOfSize:60];
    titleLabel1.textAlignment = NSTextAlignmentCenter;
    titleLabel2.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel1];
    [self.view addSubview:titleLabel2];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(50, WIN_HEIGHT-200, WIN_WIDTH-100, 80)];
    [self.view addSubview:bottomView];
  
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, bottomView.frame.size.width-40,40)];
    [btn setTitle:@"立即开通" forState:UIControlStateNormal];
    [btn.titleLabel setTextColor:[UIColor lightGrayColor]];
    [btn.layer setBorderWidth:1];
    [btn.layer setBorderColor:[UIColor whiteColor].CGColor];
    [btn addTarget:self action:@selector(clickToNext:) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    [bottomView addSubview:btn];
    UIButton *circleBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 50, 20, 20)];
    [circleBtn setImage:[UIImage imageNamed:@"Rectangle 9 Copy"] forState:UIControlStateSelected];
    [circleBtn setImage:[UIImage imageNamed:@"Rectangle 9"] forState:UIControlStateNormal];
    circleBtn.selected = YES;
    [bottomView addSubview:circleBtn];
    UILabel *protocolLabel = [[UILabel alloc]initWithFrame:CGRectMake(45, 50, bottomView.frame.size.width-45,20)];
    [bottomView addSubview:protocolLabel];
    protocolLabel.text = @"我同意《XX用户协议》";
    [protocolLabel setTextColor:[UIColor lightGrayColor]];
}
-(void)clickToNext:(UIButton *)sender
{
    ShowPayViewController *showVc = [[ShowPayViewController alloc]init];
    showVc.isBack = YES;
    [self.navigationController pushViewController:showVc animated:YES];
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
