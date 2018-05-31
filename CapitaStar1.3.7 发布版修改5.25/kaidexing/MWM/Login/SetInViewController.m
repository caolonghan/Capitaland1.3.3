//
//  SetInViewController.m
//  kaidexing
//
//  Created by 朱巩拓 on 2016/12/10.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "SetInViewController.h"
#import "NewRegisterController.h"
#import "NotLoggedInController.h"
#import "PDRetrievePhoneController.h"

@interface SetInViewController ()<UITextFieldDelegate>

@end

@implementation SetInViewController{
    UITextField *phone_num;
    UITextField *pass_word;
    UIButton    *zhuceBtn;
    UIButton    *dengluBtn;
    UIButton    *wangjiBtn;
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
    
    UIImageView * headImg= [[UIImageView alloc]initWithFrame:CGRectMake((WIN_WIDTH-202)/2,55,202,149)];
    [headImg setImage:[UIImage imageNamed:@"setinimg"]];
    [self.view addSubview:headImg];
    
    UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(headImg.frame)+54,WIN_WIDTH,M_WIDTH(44))];
    phone_num=[[UITextField alloc]init];
    phone_num.keyboardType = UIKeyboardTypeNumberPad;
    [self chuliTextField:view1 :phone_num textf_title:@"请输入手机号码" lab_W:0 lab_text:@"账号"];
    [phone_num addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:view1];
    
    UIView *view2=[[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(view1.frame),WIN_WIDTH,M_WIDTH(44))];
    pass_word=[[UITextField alloc]init];
    pass_word.secureTextEntry = YES;
    [self chuliTextField:view2 :pass_word textf_title:@"密码不少于7位" lab_W:0 lab_text:@"密码"];
    [self.view addSubview:view2];
    
    
    dengluBtn=[[UIButton alloc]initWithFrame:CGRectMake(M_WIDTH(17),CGRectGetMaxY(view2.frame)+M_WIDTH(17),WIN_WIDTH-M_WIDTH(34),M_WIDTH(43))];
    dengluBtn.layer.masksToBounds=YES;
    dengluBtn.layer.cornerRadius=5;
    dengluBtn.backgroundColor=APP_BTN_COLOR;
    dengluBtn.titleLabel.font=COMMON_FONT;
    [dengluBtn setTitle:@"登录" forState:UIControlStateNormal];
    [dengluBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [dengluBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dengluBtn];
    
    
    wangjiBtn=[[UIButton alloc]initWithFrame:CGRectMake(M_WIDTH(17),CGRectGetMaxY(dengluBtn.frame)+M_WIDTH(11),WIN_WIDTH-M_WIDTH(34),M_WIDTH(43))];
    wangjiBtn.titleLabel.font=COMMON_FONT;
    [wangjiBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [wangjiBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [wangjiBtn addTarget:self action:@selector(pushToRegisterViewController:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:wangjiBtn];
    
    zhuceBtn=[[UIButton alloc]initWithFrame:CGRectMake(M_WIDTH(17),WIN_HEIGHT-M_WIDTH(59),WIN_WIDTH-M_WIDTH(34),M_WIDTH(43))];
    zhuceBtn.titleLabel.font=COMMON_FONT;
    zhuceBtn.layer.masksToBounds = YES;
    zhuceBtn.layer.cornerRadius=5;
    zhuceBtn.layer.borderColor=APP_BTN_COLOR.CGColor;
    zhuceBtn.layer.borderWidth=1;
    [zhuceBtn setTitle:@"还没注册? 我要注册" forState:UIControlStateNormal];
    [zhuceBtn setTitleColor:APP_BTN_COLOR forState:UIControlStateNormal];
    [zhuceBtn addTarget:self action:@selector(zhuceTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:zhuceBtn];
    
}

//返回
-(void)popTouch:(UIButton*)sender{
    [self.delegate.navigationController popViewControllerAnimated:YES];
}

//登录
-(void)loginAction:(UIButton*)sender{
    
    NSString*  password = [RSA encryptString:pass_word.text publicKey:PublicKey];
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:phone_num.text, @"phone_num", password, @"pass_word", @"1000", @"source", nil];
    wangjiBtn.enabled=NO;
    zhuceBtn.enabled =NO;
    dengluBtn.enabled=NO;
    
    [SVProgressHUD showWithStatus:@"登录中"];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"member" tp:@"login"] parameters:params target:self success:^(NSDictionary *dic) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [SVProgressHUD dismiss];
            NSDictionary * dataDic = dic[@"data"];
            
            [self signInData:dataDic password:pass_word.text];
            
            wangjiBtn.enabled=YES;
            zhuceBtn.enabled =YES;
            dengluBtn.enabled=YES;
            NotLoggedInController *vc = [[NotLoggedInController alloc]init];
            [self.delegate.navigationController pushViewController:vc animated:YES];
        });
    } failue:^(NSDictionary *dic) {
        wangjiBtn.enabled=YES;
        zhuceBtn.enabled=YES;
        dengluBtn.enabled=YES;
    }];
}


//忘记密码
-(void)pushToRegisterViewController:(UIButton*)sender{
    PDRetrievePhoneController *vc=[[PDRetrievePhoneController alloc]init];

    [self.delegate.navigationController pushViewController:vc animated:YES];
}

//注册
-(void)zhuceTouch:(UIButton*)sender{
    NewRegisterController *vc= [[NewRegisterController alloc]init];
    [self.delegate.navigationController pushViewController:vc animated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [phone_num resignFirstResponder];
    [pass_word resignFirstResponder];
}


-(void)textFieldDidChange :(UITextField *)theTextField{
    if (phone_num.text.length > 10) {
        phone_num.text = [phone_num.text substringToIndex:11];
    }
    if (pass_word.text.length > 14) {
        pass_word.text = [pass_word.text substringToIndex:15];
    }
    NSLog( @"text changed: %@", theTextField.text);
}

//对输入框做处理
-(void)chuliTextField:(UIView*)view :(UITextField*)textf textf_title:(NSString*)title lab_W:(int)type  lab_text:(NSString*)labText{
    
    view.backgroundColor=[UIColor whiteColor];
    
    CGFloat tf_w=M_WIDTH(0);
    
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
    if (type == 0){
        lineView2.frame=CGRectMake(M_WIDTH(17),view.frame.size.height-1,WIN_WIDTH-M_WIDTH(17),1);
    }else{
        lineView2.frame=CGRectMake(0,view.frame.size.height-1,WIN_WIDTH,1);
    }
    lineView2.backgroundColor=COLOR_LINE;
    [view addSubview:lineView2];
    
}

@end
