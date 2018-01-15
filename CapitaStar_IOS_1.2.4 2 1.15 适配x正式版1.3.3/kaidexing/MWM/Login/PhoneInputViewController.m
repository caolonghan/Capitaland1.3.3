//
//  PhoneInputViewController.m
//  kaidexing
//
//  Created by dwolf on 2017/4/22.
//  Copyright © 2017年 dwolf. All rights reserved.
//

#import "PhoneInputViewController.h"
#import "NotLoggedInController.h"
#import "LocationUtil.h"
#import "IndexMallVM.h"
#import "WXApiRequestHandler.h"
#import "WXApiManager.h"
#import "GoViewController.h"
@interface PhoneInputViewController ()

@end

@implementation PhoneInputViewController{
    @private
    int secondsCountDown;
    NSTimer* countDownTimer;
    //定位工具类
    LocationUtil* loc;
    IndexMallVM* indexMallVM;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    indexMallVM = [[IndexMallVM alloc] init];
    [self initView];
}

-(void) initView{
    self.navigationBarLine.hidden = YES;
    _netBtn.layer.cornerRadius = DEFAULT_BUTTON_RADIUS;
    _codeView.layer.cornerRadius = DEFAULT_BUTTON_RADIUS;
    
    [_phoeTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    //对srcollView添加点击响应
    UITapGestureRecognizer *sigleTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGesture:)];
    sigleTapRecognizer.numberOfTapsRequired = 1;
    [_scrollview addGestureRecognizer:sigleTapRecognizer];
    switch (_type) {
        case 1:{//登录获取验证码
            if(!_isReg){
                [_netBtn setTitle:@"登录" forState:UIControlStateNormal];
            }else{
                [_netBtn setTitle:@"下一步" forState:UIControlStateNormal];
            }
            
            _codeBtn.hidden = NO;
            _codeBtn.layer.cornerRadius = DEFAULT_BUTTON_RADIUS;
            _phoeTF.placeholder = @"请输入验证码";
            break;
        }
        case 2:{//登录获取验证码
            [_netBtn setTitle:@"注册" forState:UIControlStateNormal];
            _phoeTF.placeholder = @"姓名";
            _phoeTF.keyboardType = UIKeyboardTypeDefault;
        }
            
        default:
            break;
    }
    
    //注册底部没有账号请注册点击事件
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onRegOrLogin:)];
    [self.regView addGestureRecognizer:tap];
    if(_isReg){
        _regLabel.text = @"已有账号  立即登录";
    }
    [_regLabel setAttrColor:_regLabel.text.length - 4 end:4 color:APP_BTN_COLOR];
    [_regLabel setUnderLine: _regLabel.text.length - 4 end:4];
    
    //微信登录绑定
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onWXLogin:)];
    [self.wxImgView addGestureRecognizer:tap];
    
}

-(void)onWXLogin:(UITapGestureRecognizer*) tap{
    [WXApiManager sharedManager].delegate = self;
    [WXApiRequestHandler sendAuthRequestScope:@"snsapi_userinfo" State:@"123" OpenID:nil InViewController:self];
}

-(void) managerDidRecvAuthResponse:(SendAuthResp*)authResp{
    NSLog(@"%@",authResp.code);
}

-(void) onRegOrLogin:(UITapGestureRecognizer*) tap{
    if(_isReg){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self popToViewController:_type + 1];
        });
        return;
    }
    PhoneInputViewController* vc = [[PhoneInputViewController alloc] init];
    if(!_isReg){
        vc.isReg = true;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)handleTapGesture:( UITapGestureRecognizer *)tapRecognizer
{
    int tapCount = tapRecognizer.numberOfTapsRequired;
    // 先取消任何操作???????这句话存在的意义？？？
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    switch (tapCount){
        case 1:
            [_phoeTF resignFirstResponder];
            break;
            //        case 2:
            //           [self handleDoubleTap:tapRecognizer];
            break;
    }
}



-(void)textFieldDidChange :(UITextField *)theTextField{
    if (_phoeTF.text.length > 10) {
        dispatch_async(dispatch_get_main_queue(), ^{
        _phoeTF.text = [_phoeTF.text substringToIndex:11];
        });
    }
    NSLog( @"text changed: %@", theTextField.text);
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

- (IBAction)onNext:(id)sender {
    _netBtn.enabled = NO;
    switch (_type) {
        case 0:
        {
            NSString* phoneNum = _phoeTF.text;
            if([Util isNull:phoneNum]){
                [SVProgressHUD showErrorWithStatus:@"手机号码不能为空！"];
                _netBtn.enabled = YES;
                return;
            }
            PhoneInputViewController* vc = [[PhoneInputViewController alloc] init];
            vc.type = 1;
            vc.isReg = _isReg;
            vc.phone = phoneNum;
            
            [self.navigationController pushViewController:vc animated:YES];
            _netBtn.enabled = YES;
            break;
        }
        case 1:
        {
            _code = _phoeTF.text;
            if([Util isNull:_code]){
                [SVProgressHUD showErrorWithStatus:@"请输入短信验证码！"];
                _netBtn.enabled = YES;
                return;
            }
            if(!_isReg){
                [self login];
            }else{
                PhoneInputViewController* vc = [[PhoneInputViewController alloc] init];
                vc.type = 2;
                vc.phone = _phone;
                vc.code = _code;
                vc.isReg = _isReg;
                [self.navigationController pushViewController:vc animated:YES];
                _netBtn.enabled = YES;
            }
            
            break;
            
        }
        case 2:{
            _name = _phoeTF.text;
            if([Util isNull:_name]){
                [SVProgressHUD showErrorWithStatus:@"请输入真实姓名！"];
                _netBtn.enabled = YES;
                return;
            }
            [self login];
        }
            
        default:
            break;
    }
}

-(void)timeFireMethod{
    //倒计时-1
    secondsCountDown--;
    
    _codeLabel.text = [NSString stringWithFormat:@"%d",secondsCountDown ];
    
    if(secondsCountDown==0){
        [countDownTimer invalidate];
        
        _codeView.hidden = YES;
        _codeLabel.text = @"0";
        _codeBtn.enabled = YES;
    }
}


//获取短信验证码
-(IBAction)getCode:(id)sender{
    _codeBtn.enabled = NO;
    
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys: _phone, @"phone_num", @"1000", @"source",@"APP",@"tag_code", nil];
    [SVProgressHUD showWithStatus:@"正在获取验证码"];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"member" tp:@"getlogincode"] parameters:params target:self success:^(NSDictionary *dic) {
        [SVProgressHUD showSuccessWithStatus:@"验证码发送成功" duration:1];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
            
            secondsCountDown = 60;
            
            _codeView.hidden = NO;
            _codeLabel.text = [NSString stringWithFormat:@"%d",secondsCountDown ];
            
        });
    } failue:^(NSDictionary *dic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _codeBtn.enabled = YES;
        });
    }];
}

-(void) login{
    
    int isReg = 0;
    if(_isReg){
        isReg = 1;
    }

    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:
                             _phone, @"phone_num",
                             _code,@"vilaCode",
                             @(isReg),@"isregist",
                             @"1000", @"source",_name,@"truthName",
                             nil];
    
    
    [SVProgressHUD showWithStatus:@"登录中"];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"member" tp:@"nopwdlogin"] parameters:params target:self success:^(NSDictionary *dic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            NSDictionary * dataDic = dic[@"data"];
            [self signInData:dataDic password:nil];
            [self location];
            [self backToAdv];
            
       
        });
        
        
        
    } failue:^(NSDictionary *dic) {
        _netBtn.enabled = YES;
    }];
}

-(void) afterLoc:(NSString *)city loc:(CLLocation *)loc{
    if(loc.coordinate.latitude == 0 && loc.coordinate.longitude == 0){
        return;
    }
    //    if(_cllocation2 != nil){
    //        return;
    //    }
    //    _cllocation2=loc;
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString* lng = [NSString stringWithFormat:@"%f",loc.coordinate.longitude];
    NSString* lat = [NSString stringWithFormat:@"%f",loc.coordinate.latitude];
    [userDefaults setValue:lng forKey:@"cllocation_lng"];
    [userDefaults setValue:lat forKey:@"cllocation_lat"];
    LocationModel* locModel = [[LocationModel alloc] init];
    locModel.lat = lat;
    locModel.lng = lng;
    [self getMallList:locModel];

}

-(void) getMallList:(LocationModel*) locModel{
    [indexMallVM getMallList:locModel];
    [indexMallVM.successObject subscribeNext:^(id data) {
        MallInfoModel* mallInfo = indexMallVM.nearMall;
        //没有最近商城则要进入选择列表页
        if(mallInfo == nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                NotLoggedInController *vc = [[NotLoggedInController alloc]init];
                [self.delegate.navigationController pushViewController:vc animated:YES];
                _netBtn.enabled = YES;
                _codeView.hidden = YES;
            });
        }else{
            [self popData:mallInfo];
        }
    }];
}

//获取定位
-(void)  location{
    loc=  [[LocationUtil alloc] init];
    loc.locDelegate = self;
    [loc isLocate];
}

//用户代理选择
-(void)userLocChoice:(int)type{
    if (type == 5 || type == 6) {
        
        }else{
            if (type == 1 || type==nil) {
                
            }else{
                //用户不开定位
                dispatch_async(dispatch_get_main_queue(), ^{
                    NotLoggedInController *vc = [[NotLoggedInController alloc]init];
                    [self.delegate.navigationController pushViewController:vc animated:YES];
                    _netBtn.enabled = YES;
                    _codeView.hidden = YES;
                });
            }
        }
    
}

-(void)popData:(MallInfoModel*)mallInfo{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *mall_id=mallInfo.mall_id;
    [Global sharedClient].markID        = mall_id;
    [Global sharedClient].markCookies   = mallInfo.mall_id_des;
    [Global sharedClient].markPrefix    = mallInfo.mall_url_prefix;
    [Global sharedClient].shopName      = mallInfo.mall_name;
    [userDefaults setObject:mall_id                 forKey:@"mall_id"];
    [userDefaults setObject:mallInfo.mall_name       forKey:@"mall_name"];
    [userDefaults setObject:mallInfo.mall_url_prefix forKey:@"mall_url_prefix"];
    [userDefaults setObject:mallInfo.mall_id_des   forKey:@"mall_id_des"];
    
    [Global sharedClient].pushLoadData = @"1";
    [Global sharedClient].isLoginPush = @"1";
    [self.delegate.navigationController popToRootViewControllerAnimated:YES];
}


@end
