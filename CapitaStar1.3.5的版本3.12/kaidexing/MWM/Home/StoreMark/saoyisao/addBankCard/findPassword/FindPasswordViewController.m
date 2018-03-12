//
//  FindPasswordViewController.m
//  kaidexing
//
//  Created by companycn on 2018/3/7.
//  Copyright © 2018年 dwolf. All rights reserved.
//

#import "FindPasswordViewController.h"
#import "ResetPasswordViewController.h"
#import "DES.h"

@interface FindPasswordViewController ()
@property (nonatomic,strong)NSTimer *countDownTimer;
@property (nonatomic,assign)NSInteger secondsCountDown;

@end

@implementation FindPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarTitleLabel.text = @"找回支付密码";
    _phoneLabel.text = [NSString stringWithFormat:@"%@xxxx%@",[_phone substringToIndex:3],[_phone substringFromIndex:7]];
   // _phoneLabel.text =
}
- (IBAction)clickToGetCode:(id)sender {
//    {member_id}：会员编号（凯德星2.0提供）
//    {phone_num}：手机号，拉取当前会员登录的手机号（需要DESEncrypt加密）
//    {source}：来源，不传默认1000（需要DESEncrypt加密）
    _makeSureBtn .enabled = NO;
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys: [Global sharedClient].member_id, @"member_id",[DES encryptUseDES: _phone],@"phone_num", nil];
    [SVProgressHUD showWithStatus:@"正在获取验证码"];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"unionpay/UnionpayBindCard" tp:@"get_modify_pwd_code"] parameters:params target:self success:^(NSDictionary *dic) {
        [SVProgressHUD showSuccessWithStatus:@"验证码发送成功" duration:1];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
            
            _secondsCountDown = 60;
            
            [_getCodeBtn setTitle:[NSString stringWithFormat:@"（%ld）重发",(long)_secondsCountDown ] forState:UIControlStateNormal];
            
        });
    } failue:^(NSDictionary *dic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _makeSureBtn.enabled = YES;
        });
    }];
    
}
- (IBAction)clickToProving:(id)sender {

    ResetPasswordViewController *resetVc = [[ResetPasswordViewController alloc]init];
    resetVc.type = 0;
    [self.navigationController pushViewController:resetVc animated:YES];
}

-(void)timeFireMethod{
    //倒计时-1
    _secondsCountDown--;
    
     [_getCodeBtn setTitle:[NSString stringWithFormat:@"（%ld）重发",(long)_secondsCountDown ] forState:UIControlStateNormal];
    
    if(_secondsCountDown==0){
        [_countDownTimer invalidate];
        
        [_getCodeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
        _getCodeBtn.enabled = YES;
    }
}



@end
