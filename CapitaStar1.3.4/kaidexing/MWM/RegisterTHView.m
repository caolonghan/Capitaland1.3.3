//
//  RegisterTHView.m
//  sgSalerReport
//
//  Created by YaoHuiQiu on 16/5/3.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "RegisterTHView.h"

#import "Const.h"
#import "RegisterViewController.h"
#import "RealDataViewController.h"
#import "PhoneInputViewController.h"
#import "GoViewController.h"

@implementation RegisterTHView

- (void)awakeFromNib {
    
    self.phoneNumTF.delegate = self;
    self.figureVCTF.delegate = self;
    self.msgVCTF.delegate = self;
    self.setPswdTF.delegate = self;
    self.confirmPwTF.delegate = self;
    UIButton *btn=[[UIButton alloc]initWithFrame:_xieyiLab.bounds];
    [btn addTarget:self action:@selector(btnTouch) forControlEvents:UIControlEventTouchUpInside];
//    btn.backgroundColor=[UIColor redColor];
    _xieyiLab.userInteractionEnabled=YES;
    [_xieyiLab addSubview:btn];
    
//    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(event:)];
//    [_xieyiLab addGestureRecognizer:tapGesture];
}

//- (void)event:(UITapGestureRecognizer *)gesture
-(void)btnTouch
{
    GoViewController *oVC=[[GoViewController alloc]init];
    oVC.path=[NSString stringWithFormat:@"%@://passport.capitaland.com.cn/registerAgreement?vip_mall_id=10",[Global sharedClient].HTTP_S];
    [self.viewController.delegate.navigationController pushViewController:oVC animated:YES];
}


- (IBAction)getVerificationCode:(id)sender {
    
    __block UIButton * btn = sender;
    //获取验证码
    NSString * source = @"1000";
    
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:_phoneNumTF.text, @"phone_num", source, @"source", nil];
    NSLog(@"params===%@", params);
    
    //[SVProgressHUD showWithStatus:@"数据请求中"];
    
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"member" tp:@"getregistcode"] parameters:params target:self.viewController success:^(NSDictionary *dic) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //[SVProgressHUD dismiss];
            //弹窗提示短信验证码发送成功
            [SVProgressHUD showSuccessWithStatus:dic[@"data"]];
            
            countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
            
            secondsCountDown = 60;
            
            [btn setTitle:@"重新发送60秒" forState:UIControlStateNormal];
            //btn.enabled
            btn.userInteractionEnabled = NO;
        });
        
    } failue:^(NSDictionary *dic) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //[SVProgressHUD dismiss];
            //弹窗提示错误信息
            [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
            
        });
        
    }];
    
    
}

-(void)timeFireMethod{
    //倒计时-1
    secondsCountDown--;
    
    NSString * str = [NSString stringWithFormat:@"重新发送%ld秒", secondsCountDown];
    [self.getBtn setTitle:str forState:UIControlStateNormal];
    
    if(secondsCountDown==0){
        [countDownTimer invalidate];
        
        [self.getBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.getBtn.userInteractionEnabled = YES;
    }
}

- (BOOL)isBlankString:(NSString *)string {
    
    if (string == nil) {
        return YES;
    }
    if (string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        return YES;
    }
    return NO;
}

- (IBAction)nextStep:(id)sender {
    
    if (![Util isMobileNumber:self.phoneNumTF.text]) {
        
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        return;
    }
    if ([self isBlankString:self.msgVCTF.text]) {
        
        [SVProgressHUD showErrorWithStatus:@"请输入短信息验证码"];
        return;
    }
    if ([self isBlankString:self.setPswdTF.text]) {
        
        [SVProgressHUD showErrorWithStatus:@"请设置登录密码"];
        return;
    }
    if ([self isBlankString:self.confirmPwTF.text]) {
        
        [SVProgressHUD showErrorWithStatus:@"请输入确认登录密码"];
        return;
    }
    if (![self.setPswdTF.text isEqualToString:self.confirmPwTF.text]) {
        
        [SVProgressHUD showErrorWithStatus:@"设置密码和确认密码不一致!"];
        return;
    }

    
    NSString * pass_word = [RSA encryptString:self.confirmPwTF.text publicKey:PublicKey];
    
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:_phoneNumTF.text, @"phone_num", _msgVCTF.text, @"vilaCode", nil];
    [SVProgressHUD showWithStatus:@"数据请求中"];
    
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"member" tp:@"regist1"] parameters:params target:self.viewController success:^(NSDictionary *dic) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"Success-dic===%@", dic);
            //跳转到真实信息填写界面
            RealDataViewController * realDataVC = [[RealDataViewController alloc] init];
            realDataVC.phone_num = self.phoneNumTF.text;
            realDataVC.vilaCode = self.msgVCTF.text;
            realDataVC.pass_word = pass_word; //加密之后密文
            realDataVC.password = _confirmPwTF.text; //加密之前原密码
            
            [self.viewController.delegate.navigationController pushViewController:realDataVC animated:YES];
        });
        [SVProgressHUD dismiss];
        
    } failue:^(NSDictionary *dic) {
    }];
}

- (IBAction)popToLoginVC:(id)sender {
    if ([_typestr isEqualToString:@"1"]) {
        PhoneInputViewController *lvc=[[PhoneInputViewController alloc]init];
        [self.viewController.delegate.navigationController pushViewController:lvc animated:YES];
    }else{
        [self.viewController.delegate.navigationController popViewControllerAnimated:YES];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.phoneNumTF resignFirstResponder];
    [self.figureVCTF resignFirstResponder];
    [self.msgVCTF resignFirstResponder];
    [self.setPswdTF resignFirstResponder];
    [self.confirmPwTF resignFirstResponder];
    
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
