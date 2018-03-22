//
//  inputInfoViewController.m
//  kaidexing
//
//  Created by company on 2017/8/28.
//  Copyright © 2017年 dwolf. All rights reserved.
//

#import "inputInfoViewController.h"
#import "uploadPicViewController.h"
#import "LocationUtil.h"
#import "LocationModel.h"
#import "NotLoggedInController.h"
#import "MalllistViewController.h"
#import "IndexMallVM.h"
#import "LogininputViewController.h"

#define kAlphaNum @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
@interface inputInfoViewController ()<UITextFieldDelegate,LocationDelegate>
{
    UILabel *tittleLab;
    UILabel *typeTittlelab;
    UITextField *input;
    
    UIImageView *imaView;
    UIScrollView *bgView;
    
    UIButton *next;
    UIButton *skip;
    
    UIView* alphaView;
    UIButton *cityBtn;
    
    LocationUtil *loc;
    IndexMallVM* indexMallVM;
    
    UIView *agreeView;
}
@end

@implementation inputInfoViewController
//注册流程:tp=getregistcode（发送短信验证码）——》tp=regist1（验证短信验证码）——》tp=regist2（注册）

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.navigationBar.hidden=YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    indexMallVM = [[IndexMallVM alloc]init];
    [self setNavigationBarcolor:[UIColor clearColor]];
    self.navigationBarLine.hidden = YES;
    [self redefineBackBtn:[UIImage imageNamed:@"iconBack"] :CGRectMake(10, 10, 24, 24)];
    
    imaView = [[UIImageView alloc]initWithFrame:SCREEN_FRAME];
    imaView.image = [UIImage imageNamed:@"bg"];
    imaView.userInteractionEnabled=YES;
    [self.view addSubview: imaView];
    
    bgView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, WIN_WIDTH, WIN_HEIGHT-NAV_HEIGHT)];
    bgView.contentSize = bgView.frame.size;
    [imaView addSubview: bgView];
    
    tittleLab = [[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(17), 80, WIN_WIDTH-M_WIDTH(17), 40)];
    tittleLab.font = [UIFont systemFontOfSize:20];
    tittleLab.textColor = [UIColor whiteColor];
    [bgView addSubview:tittleLab];
    
    typeTittlelab = [[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(17), CGRectGetMaxY(tittleLab.frame)+50, WIN_WIDTH-M_WIDTH(17), 20)];
    typeTittlelab.textColor = [UIColor whiteColor];
    typeTittlelab.font = DESC_FONT;
    [bgView addSubview:typeTittlelab];
    
    input = [[UITextField alloc]initWithFrame:CGRectMake(M_WIDTH(17)+10, CGRectGetMaxY(typeTittlelab.frame)+10, WIN_WIDTH-M_WIDTH(17)*2-20, 40)];
    input.textColor = [UIColor whiteColor];
    input.tintColor = [UIColor whiteColor];

    [bgView addSubview:input];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(M_WIDTH(17), CGRectGetMaxY(input.frame)+10, WIN_WIDTH-M_WIDTH(17)*2, 1)];
    line.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:line];
    
    next = [[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(17)-40, WIN_HEIGHT-M_WIDTH(17)-40, 40, 40)];
    [next setImage:[UIImage imageNamed:@"iconArrowLeftCircle"] forState:UIControlStateNormal];
    [imaView addSubview:next];
    [next addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    
    self.keyboardContainer = bgView;
    [self changeUI];
}
- (void)changeUI
{
    switch (_type) {
        case phoneNum:
        {
            [self changeWords:@"请问您的手机号是多少？" :@"手机号码"];
            _nextType = verificationCode;
            input.keyboardType = UIKeyboardTypePhonePad;
            
            agreeView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(input.frame)+20, WIN_WIDTH, 60)];
            [bgView addSubview:agreeView];
            
            UILabel *la = [[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(17), 0, WIN_WIDTH-100, 60)];
            la.numberOfLines = 0;
            [agreeView addSubview:la];
            la.font = DESC_FONT;
            la.textColor = [UIColor whiteColor];
            la.text = @"我愿意打开订阅按钮，接受会员服务信息，包含商场折扣信息、市场调研信息等。";
            
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH-50-M_WIDTH(17), 10, 50, 30)];
            //btn.selected = YES;
            btn.selected=YES;
            [btn setImage:[UIImage imageNamed:@"iconRadioUnCheck"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"iconRadioCheck"] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(onoff:) forControlEvents:UIControlEventTouchUpInside];
            [agreeView addSubview:btn];
            
            if (IS_IOS_8) { //iOS8以上包含iOS8
                if ([[UIApplication sharedApplication] currentUserNotificationSettings].types  == UIUserNotificationTypeNone) {
                    btn.selected = NO;
                }else{
                    btn.selected = YES;
                }
            }else{ // ios7 一下
                if ([[UIApplication sharedApplication] enabledRemoteNotificationTypes]  == UIRemoteNotificationTypeNone) {
                    btn.selected = NO;
                }else{
                    btn.selected = YES;
                }
            }
            
            break;
        }
        case verificationCode:
        {
            [self changeWords:@"请输入6位验证码" :@"6位验证码"];
            _nextType = PWD;
            input.keyboardType = UIKeyboardTypePhonePad;
            
            UILabel *la = [[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(17), CGRectGetMaxY(tittleLab.frame), WIN_WIDTH-M_WIDTH(17)*2, 60)];
            la.numberOfLines = 0;
            [bgView addSubview:la];
            la.font = COMMON_FONT;
            la.textColor = [UIColor whiteColor];
            
            NSMutableString *str = [[NSMutableString alloc]initWithString:_phonenum];
            [str insertString:@" " atIndex:3];
            [str insertString:@" " atIndex:8];
            la.text = [NSString stringWithFormat:@"我们发送了短信验证码至%@,请输入短信中的验证码",str];
            break;
        }
        case PWD:
        {
            [self changeWords:@"创建密码" :@"密码"];
            _nextType = carNum;
            
            input.secureTextEntry = YES;
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH-40-M_WIDTH(17)-10, input.frame.origin.y+10, 40, 20)];
            [bgView addSubview:btn];
            [btn setImage:[UIImage imageNamed:@"iconEye"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(showPWD:) forControlEvents:UIControlEventTouchUpInside];
            break;
        }
//        case NAME:
//        {
//            [self changeWords:@"请问如何尊称您？" :@"姓名"];
//            _nextType = carNum;
//            break;
//        }
        case carNum:
        {
            [self changeWords:@"请绑定您的车牌号" :@"车牌号"];
            UILabel *la = [[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(17), CGRectGetMaxY(tittleLab.frame), WIN_WIDTH-M_WIDTH(17)*2, 60)];
            la.numberOfLines = 0;
            [bgView addSubview:la];
            la.font = COMMON_FONT;
            la.textColor = [UIColor whiteColor];
            la.text = @"方便您停车缴费";
            
            skip = [[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(17)-40-200, WIN_HEIGHT-M_WIDTH(17)-40+5, 150, 30)];
            [imaView addSubview:skip];
            skip.titleLabel.font =DESC_FONT;
            [skip setTitle:@"跳过，以后在说" forState:UIControlStateNormal];
            [skip setTintColor:[UIColor whiteColor]];
            [skip setBackgroundColor:[UIColor clearColor]];
            skip.layer.cornerRadius = 15;
            skip.layer.borderColor =[UIColor whiteColor].CGColor;
            skip.layer.borderWidth = 1;
            [skip addTarget:self action:@selector(skipclick) forControlEvents:UIControlEventTouchUpInside];
            
            //CGRectMake(M_WIDTH(17)+10, CGRectGetMaxY(typeTittlelab.frame)+10, WIN_WIDTH-M_WIDTH(17)*2-20, 40)
            
            UIImageView *downImg=[[UIImageView alloc]initWithFrame:CGRectMake(M_WIDTH(17), 17, 14, 7)];
            [downImg setImage:[UIImage imageNamed:@"down"]];
            
            cityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            cityBtn.frame=CGRectMake(M_WIDTH(17)+10, CGRectGetMaxY(typeTittlelab.frame)+15,50, 30);
            cityBtn.layer.cornerRadius = 5;
            [bgView addSubview:cityBtn];
            [cityBtn addTarget:self action:@selector(city1Touch:) forControlEvents:UIControlEventTouchUpInside];
            [cityBtn setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
            
            //input.x = input.x + CGRectGetMaxX(cityBtn.frame)+10;
            input.frame = CGRectMake(CGRectGetMaxX(cityBtn.frame)+10, CGRectGetMaxY(typeTittlelab.frame)+10, WIN_WIDTH-M_WIDTH(17)*2-20, 40);
            input.delegate=self;
            input.keyboardType=UIKeyboardTypeASCIICapable;
            input.placeholder=@"请输入车牌号";
            input.font=COMMON_FONT;
            [input setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
            
            break;
        }
        default:
            break;
    }
    
    UIView *progress = [[UIView alloc]init];
    if(_isForgetpwd){
        [agreeView removeFromSuperview];
        //progress.frame =  CGRectMake(0, 20, (_type+1)*WIN_WIDTH/3, 2);
    }else{
        progress.frame = CGRectMake(0, 20, (_type+1)*WIN_WIDTH/4, 2);
        
    }
    
    progress.backgroundColor = [UIColor blackColor];
    [imaView addSubview:progress];
}
-(void)city1Touch:btn
{
    NSArray* _cityArray=[[NSArray alloc]initWithObjects:@"京",@"津",@"冀",@"晋",@"蒙",@"辽",@"吉",
                    @"黑",@"沪",@"苏",@"浙",@"皖",@"闽",@"赣",
                    @"鲁",@"豫",@"鄂",@"湘",@"粤",@"桂",@"琼",
                    @"渝",@"川",@"贵",@"云",@"藏",@"陕",@"甘",
                    @"青",@"宁",@"新",@"港",@"澳",@"台", nil];
    [input resignFirstResponder];
    if (!alphaView) {
        alphaView = [[UIView alloc] initWithFrame:self.view.bounds];
    }
    
    alphaView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    alphaView.userInteractionEnabled  =YES;
    
    [bgView addSubview:alphaView];
    
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelSelect:)];
    
    [alphaView addGestureRecognizer:tap];
    
    
    
    
    int row = 6;    //行
    int column = 6; //列
    
    UIView * lightGrayView = [[UIView alloc] initWithFrame:CGRectMake(0, WIN_HEIGHT - (6*50+10), WIN_WIDTH, (6*50+10))];
    lightGrayView.backgroundColor = COLOR_LINE;
    
    [alphaView addSubview:lightGrayView];
    
    CGFloat width = (WIN_WIDTH - (column + 1) * 10) / row;
    CGFloat height = 40;
    
    for (int r = 0; r < row; r++) {
        
        for (int c = 0; c < column; c++) {
            
            if (c + r * column >= _cityArray.count) {
                
                return;
            }
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            
            btn.frame = CGRectMake(10 + c * (width + 10), 10 + r * (height + 10), width, height);
            btn.backgroundColor = [UIColor whiteColor];
            btn.titleLabel.font = DESC_FONT;
            [btn setTitleColor:COLOR_FONT_BLACK forState:UIControlStateNormal];
            [btn setTitle:_cityArray[c + r * column] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(selectedAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [lightGrayView addSubview:btn];
        }
    }
}
- (void)selectedAction:(UIButton *)sender {
    
    [cityBtn setImage:nil forState:UIControlStateNormal];
    [cityBtn setTitle:sender.titleLabel.text forState:UIControlStateNormal];
    [cityBtn setTitleColor:RGBCOLOR(10,70,85) forState:UIControlStateNormal];
    [cityBtn setBackgroundColor:[UIColor whiteColor]];
    
    [alphaView removeFromSuperview];
}
- (void)cancelSelect:(UITapGestureRecognizer *)tap {
    
    [tap.view removeFromSuperview];
}
- (void)skipclick
{
    [self location];
}
- (void)showPWD:(UIButton*)btn
{
    btn.selected = !btn.selected;
    input.secureTextEntry = !input.secureTextEntry;
}
-(void)getCode:(id)sender{
    
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys: _phonenum, @"phone_num", @"1000", @"source",@"APP",@"tag_code", nil];
    [SVProgressHUD showWithStatus:@"正在获取验证码"];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"member" tp:@"getlogincode"] parameters:params target:self success:^(NSDictionary *dic) {
//        [SVProgressHUD showSuccessWithStatus:@"验证码发送成功" duration:1];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
//            
//            secondsCountDown = 60;
//            
//            _codeView.hidden = NO;
//            _codeLabel.text = [NSString stringWithFormat:@"%d",secondsCountDown ];
//            
//        });
    } failue:^(NSDictionary *dic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //_codeBtn.enabled = YES;
        });
    }];
}
- (void)onoff:(UIButton *)btn
{

    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    
    
    btn.selected=!btn.selected;
}
- (void)changeWords:(NSString *)tittle :(NSString*)typetittle
{
    tittleLab.text = tittle;
    typeTittlelab.text = typetittle;
}
- (void)resetPwd
{
    if(![Util isMobileNumber:input.text]){
        [SVProgressHUD showErrorWithStatus:@"手机号码不正确！"];
        
        return;
    }
    
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:input.text, @"phone_num", @"1000", @"source", nil];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"member" tp:@"getresetcode"] parameters:params target:self success:^(NSDictionary *dic) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //[SVProgressHUD dismiss];
            //弹窗提示短信验证码发送成功
            [SVProgressHUD showSuccessWithStatus:dic[@"data"]];
            
            LogininputViewController *vc = [[LogininputViewController alloc]init];
            vc.type = forgetpwd;
            vc.phonenum = input.text;
            [self.navigationController pushViewController:vc animated:NO];
           
        });
        
    } failue:^(NSDictionary *dic) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //弹窗提示错误信息
            [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
            
        });
        
    }];
}
- (void)next:(UIButton*)sender
{
    if (_isForgetpwd) {
        
        [self resetPwd];
        return;
    }
    
    inputInfoViewController *vc = [[inputInfoViewController alloc]init];
    vc.type = _nextType;
    
    switch (_type) {
        case phoneNum:
        {
            if([Util isNull:input.text]){
                [SVProgressHUD showErrorWithStatus:@"手机号码不能为空！"];
                
                return;
            }
            if(input.text.length!=11){
                [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码！"];
                
                return;
            }
            vc.phonenum = input.text;
            
            [SVProgressHUD showWithStatus:@"数据请求中"];
            
            NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:input.text, @"phone_num", @"1000", @"source", nil];
            [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"member" tp:@"getregistcode"] parameters:params target:self success:^(NSDictionary *dic) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //[SVProgressHUD dismiss];
                    //弹窗提示短信验证码发送成功
                    [SVProgressHUD showSuccessWithStatus:dic[@"data"]];
                    
                    
//                    countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
//                    
//                    secondsCountDown = 60;
//                    
//                    [btn setTitle:@"重新发送60秒" forState:UIControlStateNormal];
//                    //btn.enabled
//                    btn.userInteractionEnabled = NO;
                   [self.navigationController pushViewController:vc animated:NO];
                    
                });
                
            } failue:^(NSDictionary *dic) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //[SVProgressHUD dismiss];
                    //弹窗提示错误信息
                    [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
                    if ([((NSString*)dic[@"msg"]) containsString:@"已经被注册"]) {
                        [self performSelector:@selector(toLogin) withObject:nil afterDelay:1];
                    }
                    
                });
                
            }];
  
            break;
        }
        case verificationCode:
        {
            
            vc.phonenum = _phonenum;
            vc.vilaCode = input.text;
            
            NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:_phonenum, @"phone_num", input.text, @"vilaCode", nil];
            
            //注册手机验证码接口
            [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"member" tp:@"regist1"] parameters:params target:self success:^(NSDictionary *dic) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //[SVProgressHUD dismiss];
                    //弹窗提示短信验证码发送成功
                    //[SVProgressHUD showSuccessWithStatus:dic[@"data"]];
                    [self.navigationController pushViewController:vc animated:NO];
                    
                });
                
            } failue:^(NSDictionary *dic) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //[SVProgressHUD dismiss];
                    //弹窗提示错误信息
                    [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
                    
                });
                
            }];
            
            break;
        }
        case PWD:
        {
            if (input.text.length<6) {
                [SVProgressHUD showErrorWithStatus:@"密码不能小于6位"];
                return;
            }
            [SVProgressHUD showWithStatus:@"数据请求中"];
            NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:_vilaCode, @"vilaCode", _phonenum, @"phone_num", [RSA encryptString:input.text publicKey:PublicKey], @"pass_word",@"1000", @"source",@"APP",@"tag_code", nil];
            //密码注册接口
            [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"member" tp:@"regist2"] parameters:params target:self success:^(NSDictionary *dic) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                   [SVProgressHUD dismiss];
                    //弹窗提示短信验证码发送成功
                    //[SVProgressHUD showSuccessWithStatus:dic[@"data"]];
                    [self.navigationController pushViewController:vc animated:NO];
                    NSDictionary * dataDic = dic[@"data"];
                    dataDic  = [Util nullDic:dataDic];
                    
                    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
                    //    if (pd != nil) {
                    //        [userDefaults setValue:pd forKey:@"passWord"];
                    //    }
                    [JPUSHService setAlias:dic[@"id"] completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                        
                    } seq:0];
                    
                    //[self signInData:dataDic password:nil];
                    [Global sharedClient].member_id = dataDic[@"id"];
                    [userDefaults setValue:dataDic[@"id"] forKey:@"member_id"];
                    
                    [Global sharedClient].img_url = dataDic[@"img_url"];
                    [userDefaults setValue:dataDic[@"img_url"] forKey:@"img_url"];
                    
                    [Global sharedClient].nick_name = dataDic[@"nick_name"];
                    [userDefaults setValue:dataDic[@"nick_name"] forKey:@"nick_name"];
                    
                    [Global sharedClient].phone = dataDic[@"phone"];
                    [userDefaults setValue:dataDic[@"phone"] forKey:@"phone"];
                    [Global sharedClient].isoffice = dataDic[@"is_office"];
                    [userDefaults setValue:dataDic[@"is_office"] forKey:@"isoffice"];
                    
                    [Global sharedClient].userCookies = dataDic[@"member_id_des"];
                    [userDefaults setValue:dataDic[@"member_id_des"] forKey:@"userCookies"];
                    
                   
                    
                });
                
            } failue:^(NSDictionary *dic) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //[SVProgressHUD dismiss];
                    //弹窗提示错误信息
                    [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
                    
                });
                
            }];
            
            break;
        }
//        case NAME:
//        {
//            
//            break;
//        }
        case carNum:
        {
            NSString* carNum = input.text;
            if([Util isNull:carNum]){
                [SVProgressHUD showErrorWithStatus:@"请输入车牌号码"];
                sender.enabled = YES;
                return;
            }
            if(![self judgeCarNum:carNum]){
                [SVProgressHUD showErrorWithStatus:@"车牌只能使用数字和字母"];
                sender.enabled = YES;
                return;
            }
            NSString * path = [Util makeRequestUrl:@"park" tp:@"addcarno"];
            NSString * carno = [NSString stringWithFormat:@"%@%@%@", cityBtn.currentTitle,@"_",input.text];
            
            NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:[Global sharedClient].member_id, @"member_id", carno, @"car_no", @"1000", @"source", nil];
            
            [SVProgressHUD showWithStatus:@"车牌添加中"];
            [HttpClient requestWithMethod:@"POST" path:path parameters:params target:self success:^(NSDictionary *dic) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [SVProgressHUD dismiss];
                    //[SVProgressHUD showSuccessWithStatus:@"添加成功"];
                    [self location];
                    sender.enabled = YES;
                });
                
            } failue:^(NSDictionary *dic) {
                sender.enabled = YES;
            }];
            
//            if ( 1) {
//                
//            }else{
//                uploadPicViewController *vc = [[uploadPicViewController alloc]init];
//                [self.navigationController pushViewController:vc animated:YES];
//            }
            
            return;
            
            break;
        }
        default:
            break;
    }
    
}
-(void)toLogin
{
    LogininputViewController *newVC = [[LogininputViewController alloc] init];
    newVC.phonenum = input.text;
    // 获取当前路由的控制器数组
    NSMutableArray *vcArray = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    
    // 打印当前路由的控制器数组
    NSLog(@"==the vcArray is %@", vcArray);
    
    // 获取档期控制器在路由的位置
    int index = (int)[vcArray indexOfObject:self];
    
    // 移除当前路由器
    [vcArray removeObjectAtIndex:index];
    
    // 添加新控制器
    [vcArray addObject: newVC];
    
    // 打印新增后的控制器数组
    NSLog(@"==the vcArray is %@", vcArray);
    
    // 重新设置当前导航控制器的路由数组
    [self.navigationController setViewControllers:vcArray animated:YES];
    
//    [self.navigationController popViewControllerAnimated:NO];
//    LogininputViewController *vc = [[LogininputViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
//    vc.phonenum = input.text;
}
-(BOOL)judgeCarNum:(NSString *)pass{
    BOOL result = false;
    if ([pass length] >= 1){
        // 判断长度大于8位后再接着判断是否同时包含数字和字符
        NSString * regex = @"[0-9A-Za-z]*";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        result = [pred evaluateWithObject:pass];
    }
    return result;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //[input resignFirstResponder];
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
            frame = CGRectMake(WIN_WIDTH-M_WIDTH(17)-40-200, WIN_HEIGHT-M_WIDTH(17)-40+5, 150, 30);
            
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
            skip.frame = CGRectMake(WIN_WIDTH-M_WIDTH(17)-40-200, WIN_HEIGHT-M_WIDTH(17)-40+5, 150, 30);
        }
    }];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.type == carNum) {
        if (range.length == 1 && string.length == 0) {
            return YES;
        }else{
            NSCharacterSet *cs;
            
            cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum] invertedSet];
            NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
            BOOL canChange = [string isEqualToString:filtered];
            
            return textField.text.length>6?NO: canChange;
        }
    }else if(self.type == phoneNum){
        
        return textField.text.length>10?NO:YES;
    }
    
    return YES;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [input becomeFirstResponder];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [input resignFirstResponder];
    [super viewWillDisappear:animated];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    [self registmall:mall_id];
    
    [Global sharedClient].pushLoadData = @"1";
    [Global sharedClient].isLoginPush = @"1";
    
    [self backToAdv];
   
}
-(void)registmall:(NSString*)mallid
{
    static NSInteger i = 0;
    if (i!=0) {
        return;
    }
    i=1;
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys: [Global sharedClient].member_id, @"member_id",mallid,@"mall_id", nil];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"member" tp:@"memberregistmall"] parameters:para target:self success:^(NSDictionary *dic) {
        
    } failue:^(NSDictionary *dic) {
        
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
        if (type == 1) {
            
        }else{
            //用户不开定位
            dispatch_async(dispatch_get_main_queue(), ^{
                MalllistViewController *vc = [[MalllistViewController alloc]init];
                vc.shouldPost = YES;
                [self.delegate.navigationController pushViewController:vc animated:YES];
                
            });
        }
    }
    
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
