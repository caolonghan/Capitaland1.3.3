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
    NSString *phone =[Global sharedClient].phone;
    _phoneLabel.text = [NSString stringWithFormat:@"%@****%@",[phone substringToIndex:3],[phone substringFromIndex:7]];
    self.navigationBarTitleLabel.textColor = [UIColor whiteColor];
    self.navigationBar.backgroundColor = RGBCOLOR(0, 135, 140);
    _getCodeBtn.layer.borderColor = RGBCOLOR(0, 135, 140).CGColor;
}
-(void)redefineBackBtn{
    [self redefineBackBtn:[UIImage imageNamed:@"AR_back"] :CGRectMake(0, 0, 44,44)];
}
- (IBAction)clickToGetCode:(id)sender {
//    {member_id}：会员编号（凯德星2.0提供）
//    {phone_num}：手机号，拉取当前会员登录的手机号（需要DESEncrypt加密）
//    {source}：来源，不传默认1000（需要DESEncrypt加密）
    _makeSureBtn .enabled = NO;
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys: [Global sharedClient].member_id, @"member_id",[DES encryptUseDES: [Global sharedClient].phone],@"phone_num", nil];
    [SVProgressHUD showWithStatus:@"正在获取验证码"];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"unionpay/UnionpayBindCard" tp:@"get_modify_pwd_code"] parameters:params target:self success:^(NSDictionary *dic) {
        _makeSureBtn.enabled = YES;
        [SVProgressHUD showSuccessWithStatus:@"验证码发送成功" duration:1];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
            
            _secondsCountDown = 60;
            
            [_getCodeBtn setTitle:[NSString stringWithFormat:@"(%ld)重发",(long)_secondsCountDown ] forState:UIControlStateNormal];
            
        });
    } failue:^(NSDictionary *dic) {
        NSLog(@"%@",dic[@"msg"]);
        [SVProgressHUD showErrorWithStatus:@"验证码获取失败"];
            _makeSureBtn.enabled = YES;
    }];
    
}
- (IBAction)clickToProving:(id)sender {

    _makeSureBtn.enabled = NO;
    NSString *vilaCode = _codeField.text;
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys: [Global sharedClient].member_id, @"member_id",[DES encryptUseDES: [Global sharedClient].phone],@"phone_num", [DES encryptUseDES:vilaCode],@"vilaCode", nil];
    
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"unionpay/UnionpayBindCard" tp:@"get_verification_code"] parameters:params target:self success:^(NSDictionary *dic) {
        _makeSureBtn.enabled = YES;
        [SVProgressHUD showSuccessWithStatus:@"验证成功" duration:1];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            ResetPasswordViewController *resetVc = [[ResetPasswordViewController alloc]init];
            resetVc.type = 0;
            [self.navigationController pushViewController:resetVc animated:YES];
            
        });
    } failue:^(NSDictionary *dic) {
        NSLog(@"%@",dic[@"msg"]);
        [SVProgressHUD showErrorWithStatus:@"验证失败"];
            _makeSureBtn.enabled = YES;
    }];
   
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
