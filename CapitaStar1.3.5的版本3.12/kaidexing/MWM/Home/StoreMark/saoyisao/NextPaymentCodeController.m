//
//  NextPaymentCodeController.m
//  kaidexing
//
//  Created by companycn on 2018/3/7.
//  Copyright © 2018年 dwolf. All rights reserved.
//

#import "NextPaymentCodeController.h"
#import "BankListController.h"
#import "AddBankCardController.h"

@interface NextPaymentCodeController ()

@end

@implementation NextPaymentCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarTitleLabel.text = @"付款码";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self showAlertView];
}
- (void)showAlertView
{
    UIView *alertView = [[UIView alloc]initWithFrame:CGRectMake(50, 250, WIN_WIDTH-100, 180)];
    
    [self.view addSubview:alertView];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, alertView.width-20, 60)];
    label.numberOfLines = 2;
    label.text = @"您尚未绑定银行卡，绑定银行卡后可以向商家付款";
    label.font = [UIFont systemFontOfSize:15];
    [alertView addSubview:label];
    
    UIButton *bankBtn = [[UIButton alloc]initWithFrame:CGRectMake(alertView.width/2-60, 80, 120, 60)];
    [bankBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [bankBtn setTitle:@"查看支付银行" forState:UIControlStateNormal];
    [bankBtn setTitleColor:APP_BTN_COLOR forState:UIControlStateNormal];
    [bankBtn addTarget:self action:@selector(clickToBank:) forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:bankBtn];
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, alertView.height-40, alertView.width/2, 40)];
    UIButton *goBind = [[UIButton alloc]initWithFrame:CGRectMake(alertView.width/2, alertView.height-40, alertView.width/2, 40)];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [goBind setTitle:@"去绑卡" forState:UIControlStateNormal];
    [goBind setTitleColor:APP_BTN_COLOR forState:UIControlStateNormal];
    backBtn.layer.borderColor = [UIColor grayColor].CGColor;
    goBind.layer.borderColor = [UIColor grayColor].CGColor;
    backBtn.layer.borderWidth = 1;
    goBind.layer.borderWidth = 1;
    
    [backBtn addTarget:self action:@selector(clickToBack) forControlEvents:UIControlEventTouchUpInside];
    [goBind addTarget:self action:@selector(clickToBindCard) forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:goBind];
    [alertView addSubview:backBtn];
}
- (void)clickToBank:(UIButton *)sender{
    BankListController *bankVc= [[BankListController alloc]init];
    [self.navigationController pushViewController:bankVc animated:YES];
}
- (void)clickToBack{
    
}
- (void)clickToBindCard
{
    AddBankCardController *AddVc = [[AddBankCardController alloc]init];
    [self.navigationController pushViewController:AddVc animated:YES];
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
