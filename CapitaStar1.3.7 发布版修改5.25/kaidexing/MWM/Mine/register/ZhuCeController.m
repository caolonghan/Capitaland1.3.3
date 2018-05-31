//
//  ZhuCeController.m
//  kaidexing
//
//  Created by 朱巩拓 on 2016/12/10.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "ZhuCeController.h"
#import "MyApplicationViewController.h"
#import "LocationUtil.h"
#import "NotLoggedInController.h"
#import "MLabel.h"
#import "SetNewPDController.h"

@interface ZhuCeController ()<UITextFieldDelegate,LocationDelegate>
@property (nonatomic)       CLLocation      *cllocation2;

@end

@implementation ZhuCeController{
    UITextField *codeTextF;
    UIButton *codeBtn;
    UIButton *dengluBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.hidden=YES;
    self.view.backgroundColor=[UIColor whiteColor];
    [self createView];
}

-(void)createView{
    
    UIButton* backButton = [[UIButton alloc]initWithFrame:CGRectMake(0,20,44,44)];
    [backButton setImage:[UIImage imageNamed:@"heiblack36"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(popTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    UILabel * headLab= [[UILabel alloc]initWithFrame:CGRectMake(0,M_WIDTH(85),WIN_WIDTH,M_WIDTH(16))];
    headLab.text=@"短信验证码已发送至";
    headLab.textAlignment=NSTextAlignmentCenter;
    headLab.font=[UIFont systemFontOfSize:15.0f];
    [self.view addSubview:headLab];
    
    MLabel *phoneLab = [[MLabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(headLab.frame), WIN_WIDTH,M_WIDTH(40))];
    phoneLab.text=[NSString stringWithFormat:@"+86 %@",_phoneStr];
    phoneLab.textAlignment=NSTextAlignmentCenter;
    phoneLab.font=BIG_FONT;
    [phoneLab setAttrFont:0 end:3 font:DESC_FONT];
    [self.view addSubview:phoneLab];
    
    UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(0,259,WIN_WIDTH,M_WIDTH(45))];
    codeTextF=[[UITextField alloc]init];
    codeTextF.keyboardType = UIKeyboardTypeNumberPad;
    [self chuliTextField:view1 :codeTextF textf_title:@"请输入校验码" lab_W:0 lab_text:@"校验码"];
    [codeTextF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:view1];
    
    
    dengluBtn=[[UIButton alloc]initWithFrame:CGRectMake(30,CGRectGetMaxY(view1.frame)+22,WIN_WIDTH-60,46)];
    dengluBtn.layer.masksToBounds=YES;
    dengluBtn.layer.cornerRadius=5;
    dengluBtn.backgroundColor=APP_BTN_COLOR;
    dengluBtn.titleLabel.font=COMMON_FONT;
    [dengluBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [dengluBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [dengluBtn addTarget:self action:@selector(okBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dengluBtn];
    
    codeBtn=[[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH/4,CGRectGetMaxY(dengluBtn.frame),WIN_WIDTH/2,40)];
    codeBtn.titleLabel.font=DESC_FONT;
    [codeBtn setTitle:@"重新获取校验码" forState:UIControlStateNormal];
    [codeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [codeBtn addTarget:self action:@selector(codeBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:codeBtn];
    
}

-(void)codeBtnTouch:(UIButton*)sender{
    //获取验证码
    sender.enabled=NO;
    NSString *tpStr = [_viewType isEqualToString:@"0"] ? @"getregistcode":@"getresetcode";
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:_phoneStr, @"phone_num", @"1000", @"source", nil];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"member" tp:tpStr] parameters:params target:self success:^(NSDictionary *dic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            sender.enabled=YES;
        });
    } failue:^(NSDictionary *dic) {
        sender.enabled=YES;
    }];
}


#pragma mark ---点击事件---
//返回
-(void)popTouch:(UIButton*)sender{
    [self.delegate.navigationController popViewControllerAnimated:YES];
}

-(void) afterLoc:(NSString *)city loc:(CLLocation *)loc{
    if(loc.coordinate.latitude == 0 && loc.coordinate.longitude == 0){
        return;
    }
    if(_cllocation2 != nil){
        return;
    }
    _cllocation2=loc;
}


#pragma mark ---网络请求---
//点击注册成功事件
-(void)okBtnTouch:(UIButton*)sender{
    [codeTextF resignFirstResponder];
    
    if ([_viewType isEqualToString:@"0"]) {
        [self zhuceLoaddata];
    }else{
        NSString *code = codeTextF.text;
        if ([Util isNull:code]) {
            [SVProgressHUD showErrorWithStatus:@"请输入短信验证码"];
            return;
        }else if(code.length != 6){
            [SVProgressHUD showErrorWithStatus:@"请输入正确的短信验证码"];
            return;
        }else{
            SetNewPDController *vc =[[SetNewPDController alloc]init];
            vc.phoneStr=_phoneStr;
            vc.codeStr = code;
            [self.delegate.navigationController pushViewController:vc animated:YES];
        }
    }
}

-(void)zhuceLoaddata{
    //获取验证码
    codeBtn.enabled=NO;
    dengluBtn.enabled=NO;
    NSString*  password = [RSA encryptString:_passWordStr publicKey:PublicKey];
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:codeTextF.text,@"vilaCode",_phoneStr,@"phone_num",password,@"pass_word",nil];
    NSLog(@"params===%@", params);
    
    [SVProgressHUD showWithStatus:@"注册中"];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"member" tp:@"regist"] parameters:params target:self success:^(NSDictionary *dic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            codeBtn.enabled=YES;
            dengluBtn.enabled=YES;
            [self setIn:password];
        });
    } failue:^(NSDictionary *dic) {
        codeBtn.enabled=YES;
        dengluBtn.enabled=YES;
    }];
}

//登录请求
-(void)setIn:(NSString*)password{
    codeBtn.enabled=NO;
    dengluBtn.enabled=NO;
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:_phoneStr, @"phone_num", password, @"pass_word", @"1000", @"source", nil];
    [SVProgressHUD showWithStatus:@"登录中"];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"member" tp:@"login"] parameters:params target:self success:^(NSDictionary *dic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            codeBtn.enabled=YES;
            dengluBtn.enabled=YES;
            [SVProgressHUD dismiss];
            [self signInData:dic[@"data"] password:_passWordStr];
            //MyApplicationViewController *vc = [[MyApplicationViewController alloc]init];
            NotLoggedInController *vc = [[NotLoggedInController alloc]init];
            [self.delegate.navigationController pushViewController:vc animated:YES];
        });
    } failue:^(NSDictionary *dic) {
        codeBtn.enabled=YES;
        dengluBtn.enabled=YES;
    }];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [codeTextF resignFirstResponder];
}


-(void)textFieldDidChange :(UITextField *)theTextField{
    if (codeTextF.text.length > 5) {
        codeTextF.text = [codeTextF.text substringToIndex:6];
    }
    NSLog( @"text changed: %@", theTextField.text);
}

//对输入框做处理
-(void)chuliTextField:(UIView*)view :(UITextField*)textf textf_title:(NSString*)title lab_W:(int)type  lab_text:(NSString*)labText{
    
    view.backgroundColor=[UIColor whiteColor];
    
    CGFloat tf_w=M_WIDTH(50);
    
    UILabel *lab =[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(17),0,tf_w,view.frame.size.height)];
    lab.text=labText;
    lab.font=DESC_FONT;
    lab.textAlignment=NSTextAlignmentLeft;
    [view addSubview:lab];
    
    textf.frame=CGRectMake(M_WIDTH(76),0,WIN_WIDTH-M_WIDTH(100),view.frame.size.height);
    textf.placeholder=title;
    textf.font=DESC_FONT;
    textf.delegate=self;
    [view addSubview:textf];
    
    UIView *lineView2=[[UIView alloc]initWithFrame:CGRectMake(M_WIDTH(17),view.frame.size.height-1,WIN_WIDTH-M_WIDTH(17),1)];
    lineView2.backgroundColor=COLOR_LINE;
    [view addSubview:lineView2];
}






@end
