//
//  LoginViewController.m
//  kaidexing
//
//  Created by 朱巩拓 on 2016/11/7.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "NewRegisterController.h"
#import "PFUIKit.h"
#import "ThirdRegisterController.h"
#import "NotLoggedInController.h"
#import "ChoiceMarketController.h"
#import "PhoneInputViewController.h"
#import "SetInViewController.h"
#import "inputInfoViewController.h"
#import "LogininputViewController.h"
#import <UMSocialCore/UMSocialCore.h>
#import "LocationUtil.h"
#import "LocationModel.h"
#import "IndexMallVM.h"
#import "uploadPicViewController.h"
#import "MalllistViewController.h"
#import "StoreDetailsController.h"
#import "GoViewController.h"


#import "WXApiRequestHandler.h"
#import "WXApiManager.h"
#import "AFNetworking.h"
#import <AFNetworking/AFNetworking.h>

#import "WXCamerasViewViewController.h"


@interface LoginViewController ()<LocationDelegate,WXApiManagerDelegate>

@end

@implementation LoginViewController{
    NSString * password;
    UIImageView *bgView;
    
    LocationUtil* loc;
    SendAuthResp* authResp;
    BOOL shouldPush;
    uploadPicViewController *up;
}
- (void)managerDidRecvAuthResponse:(SendAuthResp *)response
{
    authResp = response;

    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys: authResp.code,@"code", nil];
    [SVProgressHUD showWithStatus:@"正在获取数据"];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
   
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"member" tp:@"wxlogin"] parameters:params target:self success:^(NSDictionary *dic) {
        [SVProgressHUD dismiss];
        NSDictionary * dataDic = dic[@"data"];
        
//        [self signInData:dataDic password:nil];
        
        if ([dataDic[@"is_office"] intValue]) {
            //办公楼会员
            [self vip:dataDic];
        }else{
            [self signInData:dataDic password:nil];
            [self location];
       
        }
        
    } failue:^(NSDictionary *dic) {
        
        if ([dic[@"result"] integerValue] == 2) {
            NSLog(@"caocoaoaocaocaonin已你一一一我");
            [SVProgressHUD showErrorWithStatus:@"请先绑定账号"];
            LogininputViewController *login = [[LogininputViewController alloc]init];
            login.type = code;
            login.advStr = self.advStr;
            login.unionid = dic[@"data"][@"unionid"];
            [self.navigationController pushViewController:login animated:YES];
        }}];
}
- (void)vip:(NSDictionary *)dataDic
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", nil];
    NSString *accessUrlStr = [NSString stringWithFormat:@"%@/api/v1/token",APIDOMAIN];
    
    [SVProgressHUD showWithStatus:@"获取数据中"];
     NSLog(@"参数hah%@",TOKENPARAMS);
    //@{@"email":@"www@126.com",@"password":@"admin123"}
    [manager POST:accessUrlStr parameters:TOKENPARAMS progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString* token = responseObject[@"token"];
        [[NSUserDefaults standardUserDefaults]setObject:responseObject[@"token"] forKey:@"token"];
        
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
        NSString *url = [NSString stringWithFormat:@"%@/api/v1/staff/mobile/%@",APIDOMAIN,dataDic[@"phone"]];
        //NSString *url = [NSString stringWithFormat:@"http://cnliutao1.chinacloudapp.cn:8080/api/v1/staff/mobile/%@",@"15995876379"];
        [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [SVProgressHUD dismiss];
            NSDictionary *locationdic = responseObject[@"project"];
            NSDictionary *picdic = responseObject[@"staff"][@"identy_photos"];
            
            
            if (!picdic|!locationdic) {
                
                [SVProgressHUD showErrorWithStatus:@"对不起，您的账号出现异常，请联系4008957957"];
                return;
            }
            [self signInData:dataDic password:nil];
            
//            if (!picdic.count) {
//                uploadPicViewController *up = [[uploadPicViewController alloc]init];
//                up.locationDic = locationdic;
//                [self.navigationController pushViewController:up animated:YES];
//            }else{
//                [self getLocation:locationdic[@"locationCode"]];
//            }
            
            if (!picdic.count) {
                shouldPush = YES;
                up = [[uploadPicViewController alloc]init];
                up.advStr = self.advStr;
                up.locationDic = locationdic;
                
            }else{
                shouldPush = NO;
              
            }
            [self getLocation:locationdic[@"locationCode"]];
/*            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            
            if(authStatus==AVAuthorizationStatusRestricted||authStatus ==AVAuthorizationStatusDenied){
                
                //无权限
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请先开启相机权限" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                    
                }]];
                [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                [self presentViewController:alert animated:YES completion:^{
                    
                }];
            }else{
                [self signInData:dataDic password:nil];
                //                uploadPicViewController *up = [[uploadPicViewController alloc]init];
                //                up.locationDic = locationdic;
                //                [self.navigationController pushViewController:up animated:YES];
                if (!picdic.count) {
                    uploadPicViewController *up = [[uploadPicViewController alloc]init];
                    up.locationDic = locationdic;
                    [self.navigationController pushViewController:up animated:YES];
                }else{
                    [self getLocation:locationdic[@"locationCode"]];
                }
            }
            */
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVProgressHUD dismiss];
        }];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
    }];
}
- (void)getLocation:(NSString*)locationCode
{
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"index" tp:@"getmallid"] parameters:@{@"locationCode":locationCode} target:self success:^(NSDictionary *dic) {
        
        if ([dic[@"result"]integerValue]) {
            MallInfoModel *model = [[MallInfoModel alloc] initWithDictionary:dic[@"data"][@"mallinfo"] error:nil ];
            [self popData:model];
        }
    } failue:^(NSDictionary *dic) {
        
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.hidden=YES;
    bgView = [[UIImageView alloc]initWithFrame:SCREEN_FRAME];
    bgView.image = [UIImage imageNamed:@"bg"];
    bgView.userInteractionEnabled=YES;
    [self.view addSubview: bgView];
    [self createView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    if (![Util isNull:[Global sharedClient].member_id]){
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
}

-(void)createView{
    
        UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, M_WIDTH(30), M_WIDTH(30))];
        backBtn.titleLabel.font=COMMON_FONT;
        [backBtn setImage:[UIImage imageNamed:@"AR_back"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:backBtn];
    if (self.advStr ==nil) {
        backBtn.hidden = YES;
    }
    UIButton *dengluBtn=[[UIButton alloc]initWithFrame:CGRectMake(M_WIDTH(270),STATUS_BAR_HEIGHT,WIN_WIDTH-M_WIDTH(270),M_WIDTH(30))];
    dengluBtn.titleLabel.font=COMMON_FONT;
    [dengluBtn setTitle:@"登录" forState:UIControlStateNormal];
    [dengluBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [dengluBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:dengluBtn];

    UIImageView * headImg=[[UIImageView alloc]initWithFrame:CGRectMake(M_WIDTH(17),CGRectGetMaxY(dengluBtn.frame)+40,65,65)];
    [headImg setImage:[UIImage imageNamed:@"logo"]];
    [bgView addSubview:headImg];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(17), CGRectGetMaxY(headImg.frame)+M_WIDTH(30), WIN_WIDTH, 30)];
    lab.font = [UIFont systemFontOfSize:16];
    lab.text = @"欢迎加入凯德星";
    lab.textColor = [UIColor whiteColor];
    [bgView addSubview:lab];
    
    UIButton *wechat=[[UIButton alloc]initWithFrame:CGRectMake(M_WIDTH(17),CGRectGetMaxY(lab.frame)+M_WIDTH(40),WIN_WIDTH-M_WIDTH(34),M_WIDTH(43))];
    wechat.titleLabel.font=COMMON_FONT;
    wechat.backgroundColor = [UIColor whiteColor];
    wechat.layer.cornerRadius = M_WIDTH(43)/2;
    [wechat setTitle:@"使用微信账号登录" forState:UIControlStateNormal];
    [wechat setTitleColor:UIColorFromRGB(0x007F87) forState:UIControlStateNormal];
    [wechat addTarget:self action:@selector(wechatLogin:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:wechat];
    
    UIButton *zhuceBtn=[[UIButton alloc]initWithFrame:CGRectMake(M_WIDTH(17),CGRectGetMaxY(wechat.frame)+M_WIDTH(11),WIN_WIDTH-M_WIDTH(34),M_WIDTH(43))];
    zhuceBtn.titleLabel.font=COMMON_FONT;
    zhuceBtn.layer.cornerRadius = M_WIDTH(43)/2;
    zhuceBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    zhuceBtn.layer.borderWidth = 1;
    [zhuceBtn setTitle:@"注册" forState:UIControlStateNormal];
    [zhuceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [zhuceBtn addTarget:self action:@selector(pushToRegisterViewController:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:zhuceBtn];
    
    UIButton *la = [[UIButton alloc]initWithFrame:CGRectMake(M_WIDTH(17), CGRectGetMaxY(zhuceBtn.frame)+M_WIDTH(41), WIN_WIDTH, 20)];
    [la.titleLabel setTextAlignment:NSTextAlignmentLeft];
    la.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    la.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"继续操作视为同意《用户注册协议》"];
    NSRange strRange = {0,[str length]};
    NSRange strRangeUnder= {8,8};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRangeUnder];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:strRange];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:strRange];
    [la setAttributedTitle:str forState:UIControlStateNormal];
    [la setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [la addTarget:self action:@selector(showRegisterProtocol:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:la];
}
- (void)showRegisterProtocol:(UIButton *)sender
{
    GoViewController *go = [[GoViewController alloc]init];
    go.path = PROTOCOLURL;
    [self.navigationController pushViewController:go animated:YES];
}
-(void)backAction:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)loginAction:(UIButton*)sender{
    
    LogininputViewController *vc=[[LogininputViewController alloc]init];

    vc.type = pwd;
    vc.advStr = self.advStr;
    [self.delegate.navigationController pushViewController:vc animated:YES];
}


- (void)pushToRegisterViewController:(UIButton*)sender {
    //点击我要注册
    

//    WXCamerasViewViewController *vc = [[WXCamerasViewViewController alloc]init];
    inputInfoViewController *vc = [[inputInfoViewController alloc]init];
    vc.advStr = self.advStr;
        [self.navigationController pushViewController:vc animated:YES];
}
- (void)wechatLogin:(UIButton*)sender
{
    
    [WXApiManager sharedManager].delegate = self;
    [WXApiRequestHandler sendAuthRequestScope:@"snsapi_userinfo" State:@"123" OpenID:nil InViewController:self];
//    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
//        if (error) {
//            
//        } else {
//            UMSocialUserInfoResponse *resp = result;
//            
//            // 授权信息
//            NSLog(@"Wechat uid: %@", resp.uid);
//            NSLog(@"Wechat openid: %@", resp.openid);
//            
//            NSLog(@"Wechat accessToken: %@", resp.accessToken);
//            NSLog(@"Wechat refreshToken: %@", resp.refreshToken);
//            NSLog(@"Wechat expiration: %@", resp.expiration);
//            
//            // 用户信息
//            NSLog(@"Wechat name: %@", resp.name);
//            NSLog(@"Wechat iconurl: %@", resp.iconurl);
//            NSLog(@"Wechat gender: %@", resp.gender);
//            
//            // 第三方平台SDK源数据
//            NSLog(@"Wechat originalResponse: %@", resp.originalResponse);
//            
//            NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys: numTf.text, @"vilaCode", [RSA encryptString:pwdTf.text publicKey:PublicKey], @"pass_word",self.phonenum,@"phone_num",@"1000", @"source", nil];
//            
//            [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"member" tp:@"wxlogin"] parameters:params target:self success:^(NSDictionary *dic) {
//                
//                [SVProgressHUD showSuccessWithStatus:@"请重新登录"];
//                [self clean];
//            } failue:^(NSDictionary *dic) {
//                [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
//            }];
//        }
//    }];
}
#pragma mark @"定位"
-(void) afterLoc:(NSString *)city loc:(CLLocation *)loca{
    if(loca.coordinate.latitude == 0 && loca.coordinate.longitude == 0){
        return;
    }
    //    if(_cllocation2 != nil){
    //        return;
    //    }
    //    _cllocation2=loc;
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString* lng = [NSString stringWithFormat:@"%f",loca.coordinate.longitude];
    NSString* lat = [NSString stringWithFormat:@"%f",loca.coordinate.latitude];
    [userDefaults setValue:lng forKey:@"cllocation_lng"];
    [userDefaults setValue:lat forKey:@"cllocation_lat"];
    LocationModel* locModel = [[LocationModel alloc] init];
    locModel.lat = lat;
    locModel.lng = lng;
    [self getMallList:locModel];
    
}

-(void) getMallList:(LocationModel*) locModel{
    IndexMallVM* indexMallVM = [[IndexMallVM alloc]init];
    [indexMallVM getMallList:locModel];
    [indexMallVM.successObject subscribeNext:^(id data) {
        MallInfoModel* mallInfo = indexMallVM.nearMall;
        //没有最近商城则要进入选择列表页
        if(mallInfo == nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                MalllistViewController *vc = [[MalllistViewController alloc]init];
                [self.delegate.navigationController pushViewController:vc animated:YES];
                
            });
        }else{
            [self popData:mallInfo];
        }
    }];
}
-(void)popData:(MallInfoModel*)mallInfo{
    [SVProgressHUD dismiss];
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
    
    if (shouldPush) {
        [self.delegate.navigationController pushViewController:up animated:YES];
        
    }else{
        [Global sharedClient].pushLoadData = @"1";
        [Global sharedClient].isLoginPush = @"1";
        
       
     [self backToAdv];
        
     
}
}
//获取定位
-(void)  location{
    [SVProgressHUD showWithStatus:@"正在努力定位中"];
    loc=  [[LocationUtil alloc] init];
    loc.locDelegate = self;
    [loc isLocate];
}

//用户代理选择
-(void)userLocChoice:(int)type{
    if (type == 5 || type == 6) {
        
    }else{
        if (type == 1) {
            
        }else{
            //用户不开定位
            dispatch_async(dispatch_get_main_queue(), ^{
                MalllistViewController *vc = [[MalllistViewController alloc]init];
                [self.delegate.navigationController pushViewController:vc animated:YES];
                
            });
        }
    }
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    // 禁用 iOS7 返回手势
//    if ([self.delegate.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.delegate.navigationController.interactivePopGestureRecognizer.enabled = NO;
//    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.advStr = nil;
    // 开启
//    if ([self.delegate.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.delegate.navigationController.interactivePopGestureRecognizer.enabled = YES;
//    }
}


@end
