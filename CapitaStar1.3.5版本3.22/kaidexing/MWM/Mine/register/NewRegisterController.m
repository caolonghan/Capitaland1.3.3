//
//  NewRegisterController.m
//  kaidexing
//
//  Created by 朱巩拓 on 2016/10/19.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "NewRegisterController.h"
#import "KKDatePickerView.h"
#import "LoginViewController.h"
#import "GoViewController.h"
#import "SuccessViewController.h"
#import "MLabel.h"
#import "ZhuCeController.h"

@interface NewRegisterController ()<UITextFieldDelegate,UIAlertViewDelegate>

@property(strong,nonatomic)UIView *rootView;

@end

@implementation NewRegisterController{
    UITextField *phone_num;
    UITextField *pass_word;
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
    
    UILabel * headLab= [[UILabel alloc]initWithFrame:CGRectMake(0,102,WIN_WIDTH,33)];
    headLab.text=@"手机号注册";
    headLab.textAlignment=NSTextAlignmentCenter;
    headLab.font=[UIFont systemFontOfSize:24.0f];
    [self.view addSubview:headLab];
    
    UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(headLab.frame)+104,WIN_WIDTH,M_WIDTH(44))];
    phone_num=[[UITextField alloc]init];
    phone_num.keyboardType = UIKeyboardTypeNumberPad;
    [self chuliTextField:view1 :phone_num textf_title:@"手机号将作为唯一账号" lab_W:0 lab_text:@"+86"];
    [phone_num addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:view1];
    
    UIView *view2=[[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(view1.frame),WIN_WIDTH,M_WIDTH(44))];
    pass_word=[[UITextField alloc]init];
    pass_word.secureTextEntry = YES;
    [self chuliTextField:view2 :pass_word textf_title:@"密码不少于7位" lab_W:0 lab_text:@"密码"];
    [self.view addSubview:view2];
    
//    MLabel *xieyiLab = [[MLabel alloc]initWithFrame:CGRectMake(M_WIDTH(17),CGRectGetMaxY(view2.frame)+M_WIDTH(17),WIN_WIDTH-M_WIDTH(34),10)];
//    xieyiLab.text=@"点击注册即视为同意《凯德微商城用户注册协议》";
//    xieyiLab.font=DESC_FONT;
//    xieyiLab.textColor=UIColorFromRGB(0xe22a2c);
//    [xieyiLab setAttrColor:0 end:9 color:UIColorFromRGB(0x666666)];
//    xieyiLab.maxHeight=100;
//    [xieyiLab autoHeight];
//    [self.view addSubview:xieyiLab];

//    UIButton *xieyiBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(view2.frame)+M_WIDTH(10),WIN_WIDTH,xieyiLab.frame.size.height+M_WIDTH(20))];
//    [xieyiBtn addTarget:self action:@selector(xieyiTouch:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:xieyiBtn];

    UIButton *dengluBtn=[[UIButton alloc]initWithFrame:CGRectMake(M_WIDTH(17),CGRectGetMaxY(view2.frame)+43,WIN_WIDTH-M_WIDTH(34),M_WIDTH(43))];
    dengluBtn.layer.masksToBounds=YES;
    dengluBtn.layer.cornerRadius=5;
    dengluBtn.backgroundColor=APP_BTN_COLOR;
    dengluBtn.titleLabel.font=COMMON_FONT;
    [dengluBtn setTitle:@"注册" forState:UIControlStateNormal];
    [dengluBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [dengluBtn addTarget:self action:@selector(okBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dengluBtn];

    
}




#pragma mark ---点击事件---
//返回
-(void)popTouch:(UIButton*)sender{
    [self.delegate.navigationController popViewControllerAnimated:YES];
}

//点击用户协议
-(void)xieyiTouch:(UIButton*)sender{
    GoViewController *oVC=[[GoViewController alloc]init];
    oVC.path=[NSString stringWithFormat:@"%@://passport.capitaland.com.cn/registerAgreement?vip_mall_id=10",[Global sharedClient].HTTP_S];
    [self.delegate.navigationController pushViewController:oVC animated:YES];
}


#pragma mark ---网络请求---
//发送验证码
-(void)okBtnTouch:(UIButton*)sender{
    [phone_num resignFirstResponder];
    NSString *phoneStr = phone_num.text;
    NSString *password = pass_word.text;
    
    if ([Util isNull:phoneStr]) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号码"];
        return;
    }else if (phoneStr.length!=11) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
        return;
    }
    
    if ([Util isNull:password]) {
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return;
    }else if (password.length<6) {
        [SVProgressHUD showErrorWithStatus:@"请输入6位以上的密码"];
        return;
    }
    
    NSString *title = [NSString stringWithFormat:@"短信验证码将发送到你的手机 \n +86 %@",phone_num.text];
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"确认手机号" message:title delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self fasongCode];
    }
}


-(void)fasongCode{
    //获取验证码
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:phone_num.text, @"phone_num", @"1000", @"source", nil];
    NSLog(@"params===%@", params);
    
    [SVProgressHUD showWithStatus:@"发送中"];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"member" tp:@"getregistcode"] parameters:params target:self success:^(NSDictionary *dic) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            //弹窗提示短信验证码发送成功
            ZhuCeController *vc = [[ZhuCeController alloc]init];
            vc.viewType    = @"0";
            vc.passWordStr = pass_word.text;
            vc.phoneStr    = phone_num.text;
            [self.delegate.navigationController pushViewController:vc animated:YES];
        });
    } failue:^(NSDictionary *dic) {
    }];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [phone_num resignFirstResponder];
    [pass_word resignFirstResponder];
}


-(void)textFieldDidChange :(UITextField *)theTextField{
    if (phone_num.text.length > 10) {
        phone_num.text = [phone_num.text substringToIndex:11];
    }
    if (pass_word.text.length > 5) {
        NSString *passd = pass_word.text;
        if (passd.length>5) {
            pass_word.text = [passd substringToIndex:5];
        }
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
    UIView *lineView2=[[UIView alloc]init];
//    if (type == 0){
        lineView2.frame=CGRectMake(M_WIDTH(17),view.frame.size.height-1,WIN_WIDTH-M_WIDTH(17),1);
//    }
//    else{
//        lineView2.frame=CGRectMake(0,view.frame.size.height-1,WIN_WIDTH,1);
//    }
    lineView2.backgroundColor=COLOR_LINE;
    [view addSubview:lineView2];
    
}



@end
