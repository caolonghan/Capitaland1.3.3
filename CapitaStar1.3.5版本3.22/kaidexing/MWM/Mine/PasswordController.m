//
//  PasswordController.m
//  kaidexing
//
//  Created by 朱巩拓 on 16/6/6.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "PasswordController.h"

@interface PasswordController ()<UITextFieldDelegate>

@property (strong,nonatomic)UITextField     *oldtext;
@property (strong,nonatomic)UITextField     *newtextF;
@property (strong,nonatomic)UITextField     *newtextF2;
@end

@implementation PasswordController
{
    UIButton *querenBtn;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarTitleLabel.text=@"修改密码";
    self.view.backgroundColor=[UIColor whiteColor];
    [self initTextView];
}


-(void)initTextView
{
    CGFloat  lab_H=M_WIDTH(41);//lable的距离 加1是线的宽度
    CGFloat  lab_W=M_WIDTH(80);//lable的长度
    CGFloat  text_left=M_WIDTH(90);//文本距左
    CGFloat  text_top=NAV_HEIGHT+M_WIDTH(10);//文本距上
    CGFloat  text_W=WIN_WIDTH-text_left-M_WIDTH(20);//文本长度
    
    NSArray  *titltAry=[[NSArray alloc]initWithObjects:@"原密码",@"新密码",@"确认密码", nil];
    for (int i = 0; i<3; i++) {
        
        UILabel  *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(10),NAV_HEIGHT+M_WIDTH(10)+(i*lab_H),lab_W,lab_H-1)];
        titleLab.textAlignment=NSTextAlignmentLeft;
        titleLab.font=COMMON_FONT;
        titleLab.text=titltAry[i];
        
        UIView  *lineView=[[UIView alloc]initWithFrame:CGRectMake(M_WIDTH(10), CGRectGetMaxY(titleLab.frame), WIN_WIDTH-M_WIDTH(10), 1)];
        lineView.backgroundColor=COLOR_LINE;
        
        [self.view addSubview:titleLab];
        [self.view addSubview:lineView];
    }
   
    
    
    self.oldtext=[[UITextField alloc]initWithFrame:CGRectMake(text_left, text_top, text_W, lab_H-1)];
    self.oldtext.textAlignment=NSTextAlignmentLeft;
    self.oldtext.font=COMMON_FONT;
    self.oldtext.placeholder=@"原密码";
    self.oldtext.secureTextEntry = YES;
    [self.view addSubview:self.oldtext];
    text_top=text_top+lab_H;
    
    self.newtextF=[[UITextField alloc]initWithFrame:CGRectMake(text_left, text_top, text_W, lab_H-1)];
    self.newtextF.textAlignment=NSTextAlignmentLeft;
    self.newtextF.font=COMMON_FONT;
    self.newtextF.placeholder=@"请输入6-20位新密码";
    self.newtextF.secureTextEntry = YES;
    [self.view addSubview:self.newtextF];
    text_top=text_top+lab_H;
    
    self.newtextF2=[[UITextField alloc]initWithFrame:CGRectMake(text_left, text_top, text_W, lab_H-1)];
    self.newtextF2.textAlignment=NSTextAlignmentLeft;
    self.newtextF2.font=COMMON_FONT;
    self.newtextF2.placeholder=@"请输入确认密码";
    self.newtextF2.secureTextEntry = YES;
    [self.view addSubview:self.newtextF2];
    text_top=text_top+M_WIDTH(30)+lab_H;
    
    
    querenBtn=[[UIButton alloc]initWithFrame:CGRectMake(M_WIDTH(10), text_top, WIN_WIDTH-M_WIDTH(20), 45)];
    querenBtn.backgroundColor=APP_BTN_COLOR;
    [querenBtn setTitle:@"确定修改" forState:UIControlStateNormal];
    [querenBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    querenBtn.titleLabel.font=COMMON_FONT;
    querenBtn.layer.masksToBounds=YES;
    querenBtn.layer.cornerRadius=5;
    [querenBtn addTarget:self action:@selector(querenTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:querenBtn];
    
    
}
-(void)querenTouch:(UIButton*)sender
{
    [_oldtext   resignFirstResponder];
    [_newtextF  resignFirstResponder];
    [_newtextF2 resignFirstResponder];
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *pass=[userDefaults objectForKey:@"passWord"];
    NSLog(@"%@",pass);
    querenBtn.enabled=NO;
    if (![_oldtext.text isEqualToString:pass]) {
        [SVProgressHUD showErrorWithStatus:@"原密码错误"];
         querenBtn.enabled=YES;
        return;
    }else if(_newtextF.text.length<6){
        [SVProgressHUD showErrorWithStatus:@"请输入6-20位新密码"];
        querenBtn.enabled=YES;
        return;
    }if(![_newtextF2.text isEqualToString:_newtextF.text]){
        [SVProgressHUD showErrorWithStatus:@"新密码不一致"];
        querenBtn.enabled=YES;
        return;
    }
    NSString *newStr=_newtextF.text;
    NSString * pass_word   =[RSA encryptString:newStr publicKey:PublicKey];
    NSString * oldpaddword =[RSA encryptString:pass   publicKey:PublicKey];
    [SVProgressHUD showWithStatus:@"正在努力修改中"];
    NSDictionary *dicton=[[NSDictionary alloc]initWithObjectsAndKeys:[Global sharedClient].phone ,@"phone_num",oldpaddword,@"pass_word",pass_word,@"new_pass",@"1000",@"source",nil];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"member" tp:@"uppass"] parameters:dicton  target:self success:^(NSDictionary *dic){
        dispatch_async(dispatch_get_main_queue(), ^{
            querenBtn.enabled=YES;
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            [self.delegate.navigationController popViewControllerAnimated:YES];
        });
    }failue:^(NSDictionary *dic){
        querenBtn.enabled=YES;
        NSLog(@"%@",dic);
    }];
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
