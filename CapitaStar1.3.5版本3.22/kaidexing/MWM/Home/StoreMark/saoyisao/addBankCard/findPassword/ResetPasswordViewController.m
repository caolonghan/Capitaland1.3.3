//
//  ResetPasswordViewController.m
//  kaidexing
//
//  Created by companycn on 2018/3/7.
//  Copyright © 2018年 dwolf. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "BJPasswordView.h"
#import "ShowPayViewController.h"
#import "FindPasswordViewController.h"
#import "DES.h"
#import "AddBankCardController.h"
#import "SaoMaPayController.h"

@interface ResetPasswordViewController ()<BJPasswordViewDelegate>
@property (nonatomic,strong)NSArray *bankListArray;
@end

@implementation ResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView];
    self.navigationBarTitleLabel.textColor = [UIColor whiteColor];
    self.navigationBar.backgroundColor = RGBCOLOR(0, 135, 140);
}
-(void)redefineBackBtn{
    [self redefineBackBtn:[UIImage imageNamed:@"AR_back"] :CGRectMake(0, 0, 44,44)];
}
- (NSArray*)bankListArray{
    if (!_bankListArray) {
        _bankListArray =[NSArray array];
    }
    return _bankListArray;
}
- (void)createView{
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, NAV_HEIGHT+150, WIN_WIDTH-120, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor lightGrayColor];
    BJPasswordView * bjPass = [[BJPasswordView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(titleLabel.frame)+10, self.view.frame.size.width-20, 45)];
    bjPass.delegate = self;
    bjPass.layer.cornerRadius =5;
    bjPass.layer.masksToBounds = YES;
    bjPass.backgroundColor = [UIColor lightGrayColor];
    UIButton *forgetBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH-100, CGRectGetMaxY(bjPass.frame)+10, 80, 20)];
    [forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetBtn setTitleColor:RGBCOLOR(0, 135, 140) forState:UIControlStateNormal];
    [forgetBtn addTarget:self action:@selector(clickToFindPwd:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:titleLabel];
    [self.view addSubview:forgetBtn];
    [self.view addSubview:bjPass];
    [self.view addSubview:bjPass];
    if (_type ==0) {
        self.navigationBarTitleLabel.text = @"重设支付密码";
        titleLabel.text = @"请设置新密码，用于支付验证";
        forgetBtn.selected = NO;
        [forgetBtn setHidden: YES];
    }else if(_type ==1)
    {
        self.navigationBarTitleLabel.text = @"重设支付密码";
         titleLabel.text = @"请再次输入以确认";
        forgetBtn.selected = NO;
        [forgetBtn setHidden: YES];
    }else if (_type ==2)
    {
        self.navigationBarTitleLabel.text = @"身份验证";
         titleLabel.text = @"请输入支付密码";
      
    }
   
}
- (void)clickToFindPwd:(UIButton *)sender
{
    FindPasswordViewController *findVc = [[FindPasswordViewController alloc]init];
    findVc.phone = _phone;
    [self.navigationController pushViewController:findVc animated:YES];
}
//代理
- (void)validatePass:(NSString *)pass
{
    if (_type ==0) {
        ResetPasswordViewController *resetVc = [[ResetPasswordViewController alloc]init];
        resetVc.type = 1;
        resetVc.pwd = pass;
        [self.navigationController pushViewController:resetVc animated:YES];
    }else if(_type ==1)
    {
        if ([pass isEqualToString:_pwd]) {
             [self resetPwdWithPass:pass];
        }
        else{
            
            [SVProgressHUD showErrorWithStatus:@"密码输入有误"];
        }
       
       
    }else if (_type ==2){
        [self judgePwdIsRightWithPass:pass];
    }
   
}
//重置密码
-(void)resetPwdWithPass:(NSString *)pass{
    NSString *DESCard = [DES encryptUseDES:pass ];
    NSDictionary*diction=[[NSDictionary alloc]initWithObjectsAndKeys:[Global sharedClient].member_id, @"member_id",DESCard,@"pay_pwd",nil];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"unionpay/UnionpayBindCard" tp:@"reset_member_pwd"] parameters:diction target:self success:^(NSDictionary *dic) {
        NSLog(@"%@",dic);
        dispatch_async(dispatch_get_main_queue(), ^{
            
           
            [self back];

            NSLog(@"密码设置成功");
            
            
        });
        
    } failue:^(NSDictionary *dic) {
        
        NSLog(@"失败%@",dic[@"data"][@"respMsg"]);
        [SVProgressHUD  showErrorWithStatus:@"您的密码输入有误"];
    }];
}
//返回
- (void)back{
    if ([Global sharedClient].resetPwdBackWhere ==0) {
        for (UIViewController *controller in self.navigationController.viewControllers) {
        
            if ([controller isKindOfClass:[SaoMaPayController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    }else if ([Global sharedClient].resetPwdBackWhere ==1){
        for (UIViewController *controller in self.navigationController.viewControllers) {
            
            if ([controller isKindOfClass:[ShowPayViewController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    }else{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        ResetPasswordViewController *resetVc = nil;
        resetVc.type =2;
        if ([controller isKindOfClass:[ResetPasswordViewController class]]) {
            resetVc = (ResetPasswordViewController *)controller;
            
            [self.navigationController popToViewController:resetVc animated:YES];
            
        }
    }
        
    }
    
    
}
- (void)judgePwdIsRightWithPass:(NSString *)pass{
    NSString *DESCard = [DES encryptUseDES:pass ];
    NSDictionary*diction=[[NSDictionary alloc]initWithObjectsAndKeys:[Global sharedClient].member_id, @"member_id",DESCard,@"pay_pwd",nil];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"unionpay/UnionpayBindCard" tp:@"get_verification_pwd"] parameters:diction target:self success:^(NSDictionary *dic) {
        NSLog(@"%@",dic);
        dispatch_async(dispatch_get_main_queue(), ^{
            
        AddBankCardController *addVc = [[AddBankCardController alloc]init];
       [self.navigationController pushViewController:addVc animated:YES];
        });
        
    } failue:^(NSDictionary *dic) {
        
        NSLog(@"失败%@",dic[@"data"][@"respMsg"]);
        [SVProgressHUD  showErrorWithStatus:@"您的密码输入有误"];
    }];
}
//- (void)judgeIsFirstBind
//{
//    NSDictionary*diction=[[NSDictionary alloc]initWithObjectsAndKeys:[Global sharedClient].member_id, @"member_id",nil];
//    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"unionpay/UnionpayBindCard" tp:@"get_member_card_list"] parameters:diction target:self success:^(NSDictionary *dic) {
//        NSLog(@"%@",dic);
//        _bankListArray = dic[@"data"];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (_bankListArray.count!=0) {
//                AddBankCardController *addVc = [[AddBankCardController alloc]init];
//                addVc.isfirstBindCard = NO;
//                addVc.cardholderName = _bankListArray[0][@"cardholder_name"];
//                addVc.cardHolderId = _bankListArray[0][@"cardholder_id"];
//                addVc.certifTp = _bankListArray[0][@"certif_tp"];
//                addVc.cardType =_bankListArray[0][@"card_type"];
//
//                [self.navigationController pushViewController:addVc animated:YES];
//            }
//        });
//
//
//    } failue:^(NSDictionary *dic) {
//        NSLog(@"失败%@",dic[@"msg"]);
//        AddBankCardController *addVc = [[AddBankCardController alloc]init];
//        addVc.isfirstBindCard = YES;
//        [self.navigationController pushViewController:addVc animated:YES];
//
//    }];
//}
@end
