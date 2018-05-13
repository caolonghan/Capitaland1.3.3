//
//  SetNewPDController.m
//  kaidexing
//
//  Created by 朱巩拓 on 2016/12/16.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "SetNewPDController.h"
#import "MLabel.h"
#import "NotLoggedInController.h"

@interface SetNewPDController ()<UITextFieldDelegate>

@end

@implementation SetNewPDController{
    UITextField *passWordTF;
    UIButton *dengluBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.hidden=YES;
    self.view.backgroundColor=[UIColor whiteColor];
    [self createView];
}

-(void)createView{
    
    UIButton* backButton = [[UIButton alloc]initWithFrame:CGRectMake(8,20,57,44)];
    [backButton setImage:[UIImage imageNamed:@"mineback"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(popTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    UILabel * headLab= [[UILabel alloc]initWithFrame:CGRectMake(0,102,WIN_WIDTH,33)];
    headLab.text=@"手机号注册";
    headLab.textAlignment=NSTextAlignmentCenter;
    headLab.font=[UIFont systemFontOfSize:24.0f];
    [self.view addSubview:headLab];
    
    UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(0,259,WIN_WIDTH,M_WIDTH(45))];
    passWordTF=[[UITextField alloc]init];
    passWordTF.keyboardType = UIKeyboardTypeNumberPad;
    [self chuliTextField:view1 :passWordTF textf_title:@"密码不少于7位" lab_W:0 lab_text:@"新密码"];
    [passWordTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:view1];
    
    dengluBtn=[[UIButton alloc]initWithFrame:CGRectMake(30,CGRectGetMaxY(view1.frame)+22,WIN_WIDTH-60,46)];
    dengluBtn.layer.masksToBounds=YES;
    dengluBtn.layer.cornerRadius=5;
    dengluBtn.backgroundColor=APP_BTN_COLOR;
    dengluBtn.titleLabel.font=COMMON_FONT;
    [dengluBtn setTitle:@"完成并登陆" forState:UIControlStateNormal];
    [dengluBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [dengluBtn addTarget:self action:@selector(okBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dengluBtn];
}

#pragma mark ---点击事件---
//返回
-(void)popTouch:(UIButton*)sender{
    [self.delegate.navigationController popViewControllerAnimated:YES];
}

#pragma mark ---网络请求---
//点击注册成功事件
-(void)okBtnTouch:(UIButton*)sender{
    [passWordTF resignFirstResponder];
    dengluBtn.enabled=NO;
    NSString * path = [Util makeRequestUrl:@"member" tp:@"reset"];
    
    NSString * pass_word = [RSA encryptString:passWordTF.text publicKey:PublicKey];
    
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:_codeStr,@"vilaCode",_phoneStr,@"phone_num",pass_word, @"pass_word", @"1000", @"source", nil];
    [HttpClient requestWithMethod:@"POST" path:path parameters:params target:self success:^(NSDictionary *dic) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //弹窗提示密码重置成功
            [SVProgressHUD showSuccessWithStatus:dic[@"data"]];
            [self performSelector:@selector(setIn) withObject:nil afterDelay:1.0f];
        });
    } failue:^(NSDictionary *dic) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            dengluBtn.enabled=YES;
            //弹窗提示错误信息
            [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
        });
    }];
}

//登录请求
-(void)setIn{
    dengluBtn.enabled=NO;
    NSString*  password = [RSA encryptString:passWordTF.text publicKey:PublicKey];
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:_phoneStr, @"phone_num", password, @"pass_word", @"1000", @"source", nil];
    [SVProgressHUD showWithStatus:@"登录中"];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"member" tp:@"login"] parameters:params target:self success:^(NSDictionary *dic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            NSDictionary * dataDic = dic[@"data"];
            
            [self signInData:dataDic password:passWordTF.text];
            dengluBtn.enabled=YES;
            NotLoggedInController *vc = [[NotLoggedInController alloc]init];
            [self.delegate.navigationController pushViewController:vc animated:YES];
        
        });
    } failue:^(NSDictionary *dic) {
        dengluBtn.enabled=YES;
    }];
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [passWordTF resignFirstResponder];
}


-(void)textFieldDidChange :(UITextField *)theTextField{
    if (passWordTF.text.length > 14) {
        passWordTF.text = [passWordTF.text substringToIndex:15];
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
}


@end
