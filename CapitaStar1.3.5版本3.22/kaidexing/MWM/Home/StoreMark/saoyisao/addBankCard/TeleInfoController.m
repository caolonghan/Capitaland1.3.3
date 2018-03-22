//
//  TeleInfoController.m
//  kaidexing
//
//  Created by companycn on 2018/3/7.
//  Copyright © 2018年 dwolf. All rights reserved.
//

#import "TeleInfoController.h"
#import "PayPasswordViewController.h"
#import "DES.h"
#import "ShowPayViewController.h"
@interface TeleInfoController ()
@property (nonatomic,strong)NSTimer *countDownTimer;
@property (nonatomic,assign)NSInteger secondsCountDown;

@end

@implementation TeleInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.heightConstraints.constant = NAV_HEIGHT;
    self.navigationBarTitleLabel.text = @"手机短信验证";
    
    self.tishiLabel.text =[NSString stringWithFormat:@"请输入手机号%@xxxx%@收到的短信验证码",[_cardHolderPhone substringToIndex:3],[_cardHolderPhone substringFromIndex:7]];
}
- (IBAction)clickToTime:(id)sender {
    _timeBtn.enabled = NO;
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys: [Global sharedClient].member_id, @"member_id",[DES encryptUseDES: _cardNum],@"card_no",_cardHolderPhone,@"phone", nil];
    [SVProgressHUD showWithStatus:@"正在获取验证码"];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"unionpay/UnionpayBindCard" tp:@"bind_unionpay_card"] parameters:params target:self success:^(NSDictionary *dic) {
        [SVProgressHUD showSuccessWithStatus:@"验证码发送成功" duration:1];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
            
            _secondsCountDown = 60;
            
            [_timeBtn setTitle:[NSString stringWithFormat:@"（%ld）重发",(long)_secondsCountDown ] forState:UIControlStateNormal];
            
        });
    } failue:^(NSDictionary *dic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _timeBtn.enabled = YES;
        });
    }];
}


-(void)timeFireMethod{
    //倒计时-1
    _secondsCountDown--;
    
    [_timeBtn setTitle:[NSString stringWithFormat:@"（%ld）重发",(long)_secondsCountDown ] forState:UIControlStateNormal];
    
    if(_secondsCountDown==0){
        [_countDownTimer invalidate];
        
        [_timeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
        _timeBtn.enabled = YES;
    }
}
- (IBAction)clickToError:(id)sender {
}
- (IBAction)clickToNext:(id)sender {
    //验证验证码
    _nextBtn.enabled = NO;
    NSString *code = _codeField.text;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Global sharedClient].member_id,@"member_id",[DES encryptUseDES: _cardHolderPhone],@"phone_num",[DES encryptUseDES: code],@"vilaCode", nil];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"unionpay/UnionpayBindCard" tp:@"get_verification_code"] parameters:params target:self success:^(NSDictionary *dic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _nextBtn.enabled = YES;
            
            [self judgeBindCard];
            
        });
    } failue:^(NSDictionary *dic) {
        [SVProgressHUD showErrorWithStatus:@"手机验证码错误"];
    }];
    
}

- (void)judgeBindCard{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Global sharedClient].member_id,@"member_id", nil];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"unionpay/UnionpayBindCard" tp:@"is_set_unionpay_cardpwd"] parameters:params target:self success:^(NSDictionary *dic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            for (UIViewController *viewController in self.navigationController.viewControllers) {
                
                if ([viewController isKindOfClass:[ShowPayViewController class]]) {
                    [self.navigationController popToViewController:viewController animated:YES];
                }
                
            }
            
           
        });
    } failue:^(NSDictionary *dic) {
        PayPasswordViewController *payVc= [[PayPasswordViewController alloc]init];
        payVc.type =0;
        [self.navigationController pushViewController:payVc animated:YES];
    }];
    
}

@end
