//
//  LogininputViewController.m
//  kaidexing
//
//  Created by company on 2017/8/30.
//  Copyright © 2017年 dwolf. All rights reserved.
//

#import "LogininputViewController.h"
#import "LocationUtil.h"
#import "LocationModel.h"
#import "IndexMallVM.h"
#import "MalllistViewController.h"
#import "inputInfoViewController.h"
#import "StoreDetailsController.h"

#import "GoViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "uploadPicViewController.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>

@interface LogininputViewController ()<UITextFieldDelegate,LocationDelegate>
{
    UIImageView *imaView;
    UITextField *numTf;
    UITextField *pwdTf;
    
    UILabel* numlab;
    UILabel * tittleLab;
    UILabel *typeTittlelab;
    
    UIButton *next;
    UIButton *skip;
    
    NSTimer *countDownTimer;
    NSInteger secondsCountDown;
    
    BOOL havePhone;
    BOOL havePwd;
    LocationUtil* loc;
    
    NSString *token;
    
    UIScrollView *bgView;
    UIView *line;
    UIButton *eye;
    UIButton* shareBtn;
    
    UIImageView *ima;
    
    NSDictionary *userInfo;
    
    BOOL shouldPush;//记录商场信息在跳转
    uploadPicViewController *up;
}
@end

@implementation LogininputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //登录页面
    // Do any additional setup after loading the view.
    [self setNavigationBarcolor:[UIColor clearColor]];
    self.navigationBarLine.hidden = YES;
    [self redefineBackBtn:[UIImage imageNamed:@"iconBack"] :CGRectMake(10, 10, 24, 24)];
    
    imaView = [[UIImageView alloc]initWithFrame:SCREEN_FRAME];
    imaView.image = [UIImage imageNamed:@"bg"];
    imaView.userInteractionEnabled = YES;
    [self.view addSubview:imaView];
    
    bgView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, WIN_WIDTH, WIN_HEIGHT-NAV_HEIGHT)];
    bgView.contentSize = bgView.frame.size;
    [imaView addSubview: bgView];
    
    tittleLab = [[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(17), 80, WIN_WIDTH-M_WIDTH(17), 40)];
    tittleLab.text = @"登录";
    tittleLab.font = [UIFont systemFontOfSize:32];
    tittleLab.textColor = [UIColor whiteColor];
    [bgView addSubview:tittleLab];
    
    numlab = [[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(17), CGRectGetMaxY(tittleLab.frame)+50, WIN_WIDTH-M_WIDTH(17), 20)];
    numlab.textColor = [UIColor whiteColor];
    numlab.font = DESC_FONT;
    numlab.text = @"手机号码";
    [bgView addSubview:numlab];
    
    numTf = [[UITextField alloc]initWithFrame:CGRectMake(M_WIDTH(17)+10, CGRectGetMaxY(numlab.frame)+5, WIN_WIDTH-M_WIDTH(17)*2-20, 40)];
    numTf.textColor = [UIColor whiteColor];
    numTf.tintColor = [UIColor whiteColor];
    numTf.delegate = self;
    numTf.keyboardType = UIKeyboardTypePhonePad;
    [bgView addSubview:numTf];
    [numTf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    line = [[UIView alloc]initWithFrame:CGRectMake(M_WIDTH(17), CGRectGetMaxY(numTf.frame)+5, WIN_WIDTH-M_WIDTH(17)*2, 1)];
    line.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:line];
    
    typeTittlelab = [[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(17), CGRectGetMaxY(line.frame)+10, WIN_WIDTH-100, 20)];
    typeTittlelab.textColor = [UIColor whiteColor];
    typeTittlelab.font = DESC_FONT;
    [bgView addSubview:typeTittlelab];
    
    pwdTf = [[UITextField alloc]initWithFrame:CGRectMake(M_WIDTH(17)+10, CGRectGetMaxY(typeTittlelab.frame)+5, WIN_WIDTH-M_WIDTH(17)*2-20, 40)];
    pwdTf.textColor = [UIColor whiteColor];
    pwdTf.tintColor = [UIColor whiteColor];
    pwdTf.delegate = self;
    [bgView addSubview:pwdTf];
    [pwdTf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(M_WIDTH(17), CGRectGetMaxY(pwdTf.frame)+5, WIN_WIDTH-M_WIDTH(17)*2, 1)];
    line2.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:line2];
    
    next = [[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(17)-40, WIN_HEIGHT-M_WIDTH(17)-40, 40, 40)];
    [next setImage:[UIImage imageNamed:@"iconArrowLeftCircle"] forState:UIControlStateNormal];
    [imaView addSubview:next];
    [next addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    
    skip = [[UIButton alloc]initWithFrame:CGRectMake(M_WIDTH(17), WIN_HEIGHT-M_WIDTH(17)-40+5, 150, 30)];
    [imaView addSubview:skip];
    skip.titleLabel.font =DESC_FONT;
    [skip setTintColor:[UIColor whiteColor]];
    [skip setBackgroundColor:[UIColor clearColor]];
    skip.layer.cornerRadius = 15;
    skip.layer.borderColor =[UIColor whiteColor].CGColor;
    skip.layer.borderWidth = 1;
    [skip addTarget:self action:@selector(skipclick) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.keyboardContainer = bgView;
    [self changUI];
}
- (void)changUI
{
    if (self.type == code) {
        
        if (self.unionid) {
            tittleLab.text = @"账户绑定";
            UILabel* noti = [[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(17), CGRectGetMaxY(tittleLab.frame), WIN_WIDTH-M_WIDTH(17), 50)];
            noti.textColor = [UIColor whiteColor];
            noti.font = DESC_FONT;
            noti.text = @"您的账户尚未绑定，请先绑定您的账户";
            [bgView addSubview:noti];
        }
        typeTittlelab.text = @"短信验证码";
        [skip setTitle:@"发送验证码" forState:UIControlStateNormal];
        pwdTf.keyboardType = UIKeyboardTypePhonePad;
        [eye removeFromSuperview];
        [shareBtn removeFromSuperview];
        
    }else if(self.type == pwd){
        
        if (self.phonenum) {
            numTf.text = self.phonenum;
            if (!ima) {
                ima = [[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH-40-M_WIDTH(17)-10, CGRectGetMinY(numTf.frame)+10, 30, 20)];
                
                ima.image =[UIImage imageNamed:@"iconRightWhite"];
            }
            [bgView addSubview:ima];
            havePhone = YES;
        }
        typeTittlelab.text = @"密码";
        pwdTf.secureTextEntry = YES;
        [skip setTitle:@"使用短信验证码登录" forState:UIControlStateNormal];
        
        eye = [[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH-40-M_WIDTH(17)-10, CGRectGetMaxY(line.frame)+10, 40, 20)];
        [bgView addSubview:eye];
        [eye setImage:[UIImage imageNamed:@"iconEye"] forState:UIControlStateNormal];
        [eye addTarget:self action:@selector(showPWD:) forControlEvents:UIControlEventTouchUpInside];
        [self createNavUMShare];
    }else{
        tittleLab.text = @"请输入验证码与新密码";
        tittleLab.font = [UIFont systemFontOfSize:20];
        numlab.text = @"6位验证码";
        typeTittlelab.text = @"新密码";
        pwdTf.secureTextEntry = YES;
        
        countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
        secondsCountDown = 60;
        skip.enabled = NO;
        [skip setTitle:[NSString stringWithFormat:@"%ld",(long)secondsCountDown ] forState:UIControlStateNormal];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH-40-M_WIDTH(17)-10, CGRectGetMaxY(line.frame)+10, 40, 20)];
        [bgView addSubview:btn];
        [btn setImage:[UIImage imageNamed:@"iconEye"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(showPWD:) forControlEvents:UIControlEventTouchUpInside];
        
        /*UIView *progress = [[UIView alloc]init];
         progress.frame = CGRectMake(0, 20, _type*WIN_WIDTH/3, 2);
         progress.backgroundColor = [UIColor blackColor];
         [imaView addSubview:progress];
         */
    }
}
-(void)createNavUMShare{
    
    shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setFrame:CGRectMake(-50, 0, 80, 44)];
    [shareBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(forgetPwd) forControlEvents:UIControlEventTouchUpInside];
    [self.rigthBarItemView addSubview:shareBtn];
    self.rigthBarItemView.hidden = FALSE;
}
-(void)forgetPwd
{
    inputInfoViewController *vc = [[inputInfoViewController alloc]init];
    vc.isForgetpwd = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)textFieldDidChange:(UITextField *)tf
{
    if (tf == numTf) {
        //static UIImageView *ima;
        
        NSInteger len;
        if (_type==forgetpwd) {
            len = 6;
        }else{
            len = 11;
        }
        
        if (tf.text.length == len) {
            if (!ima) {
                ima = [[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH-40-M_WIDTH(17)-10, CGRectGetMinY(numTf.frame)+10, 30, 20)];
                
                ima.image =[UIImage imageNamed:@"iconRightWhite"];
            }
            [bgView addSubview:ima];
            havePhone = YES;
        }else{
            [ima removeFromSuperview];
            havePhone = NO;
        }
        
    }else{
        
        static UIImageView *ima1;
        if (tf.text.length >5) {
            if (!ima1) {
                ima1 = [[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH-40-M_WIDTH(17)-10, CGRectGetMinY(pwdTf.frame)+10, 30, 20)];
                
                ima1.image =[UIImage imageNamed:@"iconRightWhite"];
            }
            [bgView addSubview:ima1];
            havePwd = YES;
        }else{
            [ima1 removeFromSuperview];
            havePwd = NO;
        }
    }
}
- (void)next
{
    StoreDetailsController *store = [[StoreDetailsController alloc]init];
    store.is_login_enter = @"1";
    if (!havePhone||!havePwd) {
        [SVProgressHUD showErrorWithStatus:@"请填写信息！"];
        return;
    }
    
    [self.view endEditing:YES];
    
    [SVProgressHUD showWithStatus:@"获取数据中"];
    if (self.type == pwd) {
        
        [self pwdlogin];
    }else if(self.type == code){
        
        [self codelogin];
    }else{
        //忘记密码
        [self resetPwd];
    }
    
}
-(void)resetPwd
{
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys: numTf.text, @"vilaCode", [RSA encryptString:pwdTf.text publicKey:PublicKey], @"pass_word",self.phonenum,@"phone_num",@"1000", @"source", nil];
    
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"member" tp:@"reset"] parameters:params target:self success:^(NSDictionary *dic) {
        
        [SVProgressHUD showSuccessWithStatus:@"密码重置成功,请重新登录"];
        [self performSelector:@selector(clean) withObject:nil afterDelay:1];
    } failue:^(NSDictionary *dic) {
        [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
    }];
}
- (void)pwdlogin
{
//    [self vip];
//    return;
//    13739280837
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys: numTf.text, @"phone_num", [RSA encryptString:pwdTf.text publicKey:PublicKey], @"pass_word",@"1000", @"source", nil];
   //13739280837
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"member" tp:@"login"] parameters:params target:self success:^(NSDictionary *dic) {
        [SVProgressHUD dismiss];
        NSDictionary * dataDic = dic[@"data"];
        
        if (self.unionid) {
            //微信绑定
            [self bindWX:dataDic];
        }else{
            userInfo = dataDic;
            //[self signInData:dataDic password:nil];
            
            if ([dataDic[@"is_office"] intValue]) {
                //办公楼会员
                [self vip];
            }else{

                [self location];
            }
        }
    } failue:^(NSDictionary *dic) {
        next.enabled = YES;
        
        if ([dic[@"msg"] containsString:@"未注册"]) {
            
            
            inputInfoViewController *registerVC = [[inputInfoViewController alloc]init];
            [NSTimer scheduledTimerWithTimeInterval:2 repeats:NO block:^(NSTimer * _Nonnull timer) {
                [self.navigationController pushViewController:registerVC animated:YES];
            }];
            
        }else{
            [self showInfo];
        }
        
    }];
}
- (void)codelogin
{
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys: numTf.text, @"phone_num", pwdTf.text, @"vilaCode",@"APP",@"tag_code",@"1000", @"source", nil];
    
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"member" tp:@"nopwdlogin"] parameters:params target:self success:^(NSDictionary *dic) {
        [SVProgressHUD dismiss];
        NSDictionary * dataDic = dic[@"data"];
        
        if (self.unionid) {
            //微信绑定
            [self bindWX:dataDic];
        }else{
            userInfo = dataDic;
            //[self signInData:dataDic password:nil];
            if ([dataDic[@"is_office"] intValue]) {
                //办公楼会员
                [self vip];
            }else{
                
                [self location];
            }
        }
        
        
    } failue:^(NSDictionary *dic) {
        next.enabled = YES;
        
        if ([dic[@"msg"] containsString:@"未注册"]) {
            
            inputInfoViewController *registerVC = [[inputInfoViewController alloc]init];
            
            [NSTimer scheduledTimerWithTimeInterval:2 repeats:NO block:^(NSTimer * _Nonnull timer) {
                [self.navigationController pushViewController:registerVC animated:YES];
            }];
        }else{
         [self showInfo];
        }
       
    }];
}
- (void)vip
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", nil];
    //NSString *accessUrlStr = @"http://cnliutao1.chinacloudapp.cn:8080/api/v1/token";
    NSString *accessUrlStr = [NSString stringWithFormat:@"%@/api/v1/token",APIDOMAIN];
   
    [SVProgressHUD showWithStatus:@"获取数据中"];
    [manager POST:accessUrlStr parameters:TOKENPARAMS progress:^(NSProgress * _Nonnull uploadProgress) {
            
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
        token = responseObject[@"token"];
        [[NSUserDefaults standardUserDefaults]setObject:responseObject[@"token"] forKey:@"token"];
        
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
        NSString *url = [NSString stringWithFormat:@"%@/api/v1/staff/mobile/%@",APIDOMAIN,userInfo[@"phone"]];
        //NSString *url = [NSString stringWithFormat:@"http://cnliutao1.chinacloudapp.cn:8080/api/v1/staff/mobile/%@",@"15995876379"];
        [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [SVProgressHUD dismiss];
            NSDictionary *locationdic = responseObject[@"project"];
            NSDictionary *picdic = responseObject[@"staff"][@"identy_photos"];
            NSLog(@"locationdic = %@", locationdic);
            NSLog(@"picdic=%@",picdic);
            
            if (!picdic|!locationdic) {
                
                [SVProgressHUD showErrorWithStatus:@"对不起，您的账号出现异常，请联系4008957957"];
                return;
            }
            
            [self signInData:userInfo password:nil];
            
//                            uploadPicViewController *up = [[uploadPicViewController alloc]init];
//                            up.locationDic = locationdic;
//                            [self.navigationController pushViewController:up animated:YES];
//            return;
            if (!picdic.count) {
                shouldPush = YES;
                up = [[uploadPicViewController alloc]init];
                up.locationDic = locationdic;
             //   [self.navigationController pushViewController:up animated:YES];
            }else{
                shouldPush = NO;
                //[self getLocation:locationdic[@"locationCode"]];
            }
            [self getLocation:locationdic[@"locationCode"]];
            


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

- (void)bindWX:(NSDictionary *)data
{
    [SVProgressHUD showWithStatus:@"正在绑定中"];
    NSString *memberid = data[@"id"];
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys: memberid, @"member_id", self.unionid, @"unionid", nil];
    
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"member" tp:@"bindwx"] parameters:params target:self success:^(NSDictionary *dic) {
        [SVProgressHUD dismiss];
        //[self signInData:data password:nil];
        userInfo = data;
        if ([data[@"is_office"] intValue]) {
            //办公楼会员
            [self vip];
        }else{
            
            [self location];
        }
        
    } failue:^(NSDictionary *dic) {
        
    }];
}
- (void)showInfo
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMinY(next.frame), WIN_WIDTH, WIN_HEIGHT-40-M_WIDTH(17))];
    view.tag = 66;
    [bgView addSubview:view];
    
    
    UILabel *la = [[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(17), 20, 200, 20)];
    [view addSubview:la];
    NSString *str;
    
    
    if (self.type == forgetpwd) {
        view.backgroundColor = [UIColor greenColor];
        str = @"密码修改成功，请重新登录";
        la.text = str;
    }else{
        imaView.image = nil;
        imaView.backgroundColor = RGBCOLOR(206, 36, 6);
        
        view.backgroundColor = [UIColor whiteColor];
        if (self.type==code) {
            
            str = @"错误 验证码不正确，请重试";
        }else{
            str = @"错误 密码不正确，请重试";
        }
        NSMutableAttributedString *string =[[NSMutableAttributedString alloc]initWithString:str];
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 2)];
        la.font = DESC_FONT;
        la.attributedText = string;
    }
    
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(17)-40, M_WIDTH(17)/2, 40, 40)];
    [btn setImage:[UIImage imageNamed:@"zhifuclose"] forState:UIControlStateNormal];
    [view addSubview:btn];
    [btn addTarget:self action:@selector(clean) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self performSelector:@selector(clean) withObject:nil afterDelay:2];
}
- (void)clean
{
    [[bgView viewWithTag:66] removeFromSuperview];
    if (self.type==forgetpwd) {
        
        NSArray<UIViewController*> *arr = [self.navigationController viewControllers];
        
        [self.navigationController popToViewController:[arr objectAtIndex:arr.count-1-2] animated:NO];
    }
}
- (void)skipclick
{
    if (self.type == pwd) {
        [self.view endEditing:YES];
        
        if (havePhone) {
            [self getCode:nil back:^{
                self.type = code;
                [self changUI];
            }];
        }else{
            self.type = code;
            [self changUI];
        }
        
//        LogininputViewController *codev = [[LogininputViewController alloc]init];
//        codev.type = code;
//        [self.navigationController pushViewController:codev animated:YES];
    }else{
        [self getCode:nil back:^{
            
        }];
    }
}
- (void)showPWD:(UIButton*)btn
{
    btn.selected = !btn.selected;
    pwdTf.secureTextEntry = !pwdTf.secureTextEntry;
}
- (void)keyboardWillShow:(NSNotification *)notification {
    
    NSDictionary *info = [notification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    
    NSValue *keyboardBoundsValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardBounds;
    [keyboardBoundsValue getValue:&keyboardBounds];
    
    [UIView animateWithDuration:duration animations:^{
        
        CGRect frame = CGRectMake(WIN_WIDTH-M_WIDTH(17)-40, WIN_HEIGHT-M_WIDTH(17)-40, 40, 40);
        
        frame.origin.y = frame.origin.y - keyboardBounds.size.height;
        
        next.frame = frame;
        
        if (skip) {
            frame = CGRectMake(M_WIDTH(17), WIN_HEIGHT-M_WIDTH(17)-40+5, 150, 30);
            
            frame.origin.y = frame.origin.y - keyboardBounds.size.height;
            
            skip.frame = frame;
        }
    }];
    
}


- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary *info = [notification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:duration animations:^{
        
        next.frame = CGRectMake(WIN_WIDTH-M_WIDTH(17)-40, WIN_HEIGHT-M_WIDTH(17)-40, 40, 40);
        
        bgView.frame = CGRectMake(0, NAV_HEIGHT, WIN_WIDTH, WIN_HEIGHT-NAV_HEIGHT);
        if (skip) {
            skip.frame = CGRectMake(M_WIDTH(17), WIN_HEIGHT-M_WIDTH(17)-40+5, 150, 30);
        }
    }];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [self.view endEditing:YES];
    [super viewWillDisappear:animated];
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.length == 1 && string.length == 0) {
        return YES;
    }
    if(textField == numTf){
    
//        static UIImageView *ima;
//        if (numTf.text.length==11) {
//            if (!ima) {
//                ima = [[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH-40-M_WIDTH(17)-10, CGRectGetMinY(numTf.frame), 40, 40)];
//                [bgView addSubview:ima];
//                ima.image =[UIImage imageNamed:@"iconRightWhite"];
//            }
//            
//        }else{
//            [ima removeFromSuperview];
//        }
        if (_type==forgetpwd) {
            
            return textField.text.length>5?NO:YES;
        }
        return textField.text.length>10?NO:YES;
    }
    
//    if (textField == pwdTf) {
//        static UIImageView *ima;
//        if (pwdTf.text.length >5) {
//            if (!ima) {
//                ima = [[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH-40-M_WIDTH(17)-10, CGRectGetMinY(pwdTf.frame), 40, 40)];
//                [bgView addSubview:ima];
//                ima.image =[UIImage imageNamed:@"iconRightWhite"];
//            }
//            
//        }else{
//            [ima removeFromSuperview];
//        }
//    }
    
    return YES;
}

-(void)getCode:(id)sender back:(void(^)(void))back{
    
    NSString *num;
    if (self.type != forgetpwd) {
        
        if (!havePhone) {
            [SVProgressHUD showErrorWithStatus:@"手机号码不正确！"];
            return;
        }
        
        num = numTf.text;
    }else{
        num = self.phonenum;
    }
    
    skip.enabled = NO;
    
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys: num, @"phone_num", @"1000", @"source",@"APP",@"tag_code", nil];
    [SVProgressHUD showWithStatus:@"正在获取验证码"];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"member" tp:@"getlogincode"] parameters:params target:self success:^(NSDictionary *dic) {
        [SVProgressHUD showSuccessWithStatus:@"验证码发送成功" duration:1];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (back) {
                back();
            }
            countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
            
            secondsCountDown = 60;
            
            
            [skip setTitle:[NSString stringWithFormat:@"已发送，%ld秒后重新发送",(long)secondsCountDown ] forState:UIControlStateNormal];
            
        });
    } failue:^(NSDictionary *dic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            skip.enabled = YES;
        });
    }];
}
-(void)timeFireMethod{
    //倒计时-1
    secondsCountDown--;
    
    [skip setTitle:[NSString stringWithFormat:@"%ld",(long)secondsCountDown ] forState:UIControlStateNormal];
    
    if(secondsCountDown==0){
        [countDownTimer invalidate];
        
        [skip setTitle:@"重新发送" forState:UIControlStateNormal];
        skip.enabled = YES;
    }
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
- (void)locError:(NSString *)city
{
    [SVProgressHUD dismiss];
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
    [JPUSHService setAlias:userInfo[@"id"] completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        
    } seq:0];
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
    [self signInData:userInfo password:nil];
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
