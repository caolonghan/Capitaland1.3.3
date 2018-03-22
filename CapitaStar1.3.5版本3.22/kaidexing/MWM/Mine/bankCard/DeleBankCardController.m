//
//  DeleBankCardController.m
//  kaidexing
//
//  Created by companycn on 2018/3/15.
//  Copyright © 2018年 dwolf. All rights reserved.
//

#import "DeleBankCardController.h"
#import "BankCardView.h"

@interface DeleBankCardController ()
@property (nonatomic,strong)BankCardView *bankCardView;
@end

@implementation DeleBankCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarTitleLabel.text = @"银行卡详情";
    self.navigationBarTitleLabel.textColor =[UIColor whiteColor];
    self.navigationBar.backgroundColor = RGBCOLOR(0, 135, 140);
    [self createView];
}
-(void)redefineBackBtn{
    [self redefineBackBtn:[UIImage imageNamed:@"AR_back"] :CGRectMake(0, 0, 44,44)];
}
- (void)createView
{
    _bankCardView = [[BankCardView alloc]initWithFrame:CGRectMake(15, NAV_HEIGHT+15, WIN_WIDTH-30, 110)];
    _bankCardView.cardStyle = _cardType;
    _bankCardView.bankName = _bankName;
    _bankCardView.cardNo = _cardNo;
    _bankCardView.bankImageUrl = _bankImageUrl;
    [self.view addSubview:_bankCardView];
   
    UIButton *deleBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, WIN_HEIGHT/2-20, WIN_WIDTH-30, 40)];
    [self.view addSubview:deleBtn];
    [deleBtn setTitle:@"解除绑定" forState:UIControlStateNormal];
    [deleBtn setTitleColor:RGBCOLOR(221, 81, 87) forState:UIControlStateNormal];
    [deleBtn addTarget: self action:@selector(clickToDele:) forControlEvents:UIControlEventTouchUpInside];
    deleBtn.layer.borderWidth = 1;
    deleBtn.layer.cornerRadius = 5;
    deleBtn.layer.masksToBounds = YES;
    deleBtn.layer.borderColor = [UIColor colorWithRed:221/255.0 green:81/255.0 blue:87/255.0 alpha:1].CGColor;
}
- (void)clickToDele:(UIButton *)sender
{
    NSDictionary*diction=[[NSDictionary alloc]initWithObjectsAndKeys:[Global sharedClient].member_id, @"member_id",_ides,@"card_id",nil];
    [SVProgressHUD showWithStatus:@"正在加载中"];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"unionpay/UnionpayBindCard" tp:@"del_member_card_info"] parameters:diction target:self success:^(NSDictionary *dic) {
        NSLog(@"%@",dic);
        [SVProgressHUD showSuccessWithStatus:@"解绑成功"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [NSThread sleepForTimeInterval:1];
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    } failue:^(NSDictionary *dic) {
        NSLog(@"失败%@",dic[@"msg"]);
        [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
        
        
    }];
}
@end
