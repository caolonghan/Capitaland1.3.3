//
//  ThirdRegisterController.m
//  kaidexing
//
//  Created by 朱巩拓 on 2016/11/7.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "ThirdRegisterController.h"
#import "KKDatePickerView.h"
#import "LoginViewController.h"
#import "GoViewController.h"
#import "SuccessViewController.h"


@interface ThirdRegisterController ()<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

@end

@implementation ThirdRegisterController{
    UITextField  *textF_1;
    UITextField  *textF_2;
    UITextField  *textF_3;
    UITextField  *textF_4;
    UITextField  *textF_5;
    UIPickerView *pickView;
    UIView       *timeView;
    UIView       *genderView;
    NSArray      *xingbieAry;
    NSString     *xingbieStr;
    UIButton     *yanzhengBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=UIColorFromRGB(0xf5f5f5);
    self.navigationBarTitleLabel.text=@"完善信息";
    [self createView];
}

-(void)createView{
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(17),NAV_HEIGHT,M_WIDTH(300),M_WIDTH(39)-0.5)];
    titleLab.text=@"请完善一下信息, 完成注册。";
    titleLab.textColor=COLOR_FONT_SECOND;
    titleLab.font=DESC_FONT;
    [self.view addSubview:titleLab];
    UIView *headLine=[[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(titleLab.frame),WIN_WIDTH,0.5)];
    headLine.backgroundColor=COLOR_LINE;
    [self.view addSubview:headLine];
    
    UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(headLine.frame),WIN_WIDTH,M_WIDTH(45))];
    textF_1=[[UITextField alloc]init];
    textF_1.keyboardType = UIKeyboardTypeNumberPad;
    [self chuliTextField:view1 :textF_1 textf_title:@"请输入注册手机号码" lab_W:0 textf_top_line:YES lab_text:@"手机号" isIconImage:NO];
    [textF_1 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    
    yanzhengBtn=[[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(96),M_WIDTH(12),M_WIDTH(83),M_WIDTH(23))];
    yanzhengBtn.layer.masksToBounds=YES;
    yanzhengBtn.layer.cornerRadius=yanzhengBtn.frame.size.height/2;
    [yanzhengBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [yanzhengBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    yanzhengBtn.backgroundColor=UIColorFromRGB(0x498fd8);
    yanzhengBtn.titleLabel.font=DESC_FONT;
    [yanzhengBtn addTarget:self action:@selector(yanzhenNet:) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:yanzhengBtn];
    [self.view addSubview:view1];

    
    UIView *view2=[[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(view1.frame),WIN_WIDTH,M_WIDTH(45))];
    textF_2=[[UITextField alloc]init];
    [self chuliTextField:view2 :textF_2 textf_title:@"请输入手机短信验证码" lab_W:0 textf_top_line:NO lab_text:@"验证码" isIconImage:NO];
    [self.view addSubview:view2];
    
    
    UIView *view3=[[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(view2.frame),WIN_WIDTH,M_WIDTH(45))];
    textF_3=[[UITextField alloc]init];
    [self chuliTextField:view3 :textF_3 textf_title:@"请输入您的姓名" lab_W:0 textf_top_line:NO lab_text:@"姓名" isIconImage:NO];
    [self.view addSubview:view3];

    UIView *view4=[[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(view3.frame),WIN_WIDTH,M_WIDTH(45))];
    textF_4=[[UITextField alloc]init];
    [self chuliTextField:view4 :textF_4 textf_title:@"请选择您的性别" lab_W:0 textf_top_line:NO lab_text:@"性别" isIconImage:YES];
    [self.view addSubview:view4];
    
    UIView *view5=[[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(view4.frame),WIN_WIDTH,M_WIDTH(45))];
    textF_5=[[UITextField alloc]init];
    [self chuliTextField:view5 :textF_5 textf_title:@"请选择您的生日" lab_W:1 textf_top_line:NO lab_text:@"生日" isIconImage:YES];
    [self.view addSubview:view5];
    
    UIButton *dengluBtn=[[UIButton alloc]initWithFrame:CGRectMake(M_WIDTH(17),CGRectGetMaxY(view5.frame)+M_WIDTH(19),WIN_WIDTH-M_WIDTH(34),M_WIDTH(43))];
    dengluBtn.layer.masksToBounds=YES;
    dengluBtn.layer.cornerRadius=5;
    dengluBtn.backgroundColor=UIColorFromRGB(0xf15152);
    dengluBtn.titleLabel.font=BIG_FONT;
    [dengluBtn setTitle:@"提交" forState:UIControlStateNormal];
    [dengluBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [dengluBtn addTarget:self action:@selector(tijiaoTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dengluBtn];
    
}

-(void)tijiaoTouch:(UIButton*)sender{
    
    
    
}


//发送验证码
-(void)yanzhenNet:(UIButton*)sender{
    //获取验证码
    yanzhengBtn.enabled=NO;
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:@"", @"phone_num", @"1000", @"source", nil];
    NSLog(@"params===%@", params);

    [SVProgressHUD showWithStatus:@"发送中"];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"member" tp:@"getregistcode"] parameters:params target:self success:^(NSDictionary *dic) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            yanzhengBtn.enabled=YES;
            [SVProgressHUD dismiss];
            //弹窗提示短信验证码发送成功
            [SVProgressHUD showSuccessWithStatus:dic[@"data"]];
        });
        
    } failue:^(NSDictionary *dic) {
        yanzhengBtn.enabled=YES;
        [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
    }];
}
-(void)textFieldDidChange :(UITextField *)theTextField{
    if (textF_1.text.length > 10) {
        textF_1.text = [textF_1.text substringToIndex:11];
    }
    if (textF_2.text.length > 5) {
        textF_2.text = [textF_2.text substringToIndex:6];
    }

    if (textF_3.text.length > 5) {
        textF_3.text = [textF_3.text substringToIndex:6];
    }
    NSLog( @"text changed: %@", theTextField.text);
}
#pragma mark ---delegate---
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField==textF_4) {
        [self men_and_womenView];
        return NO;
    }else if (textField==textF_5) {
        [self createTimeView];
        return NO;
    }
    return YES;
}
//创建选择时间的view
-(void)createTimeView{
    [textF_1 resignFirstResponder];
    [textF_2 resignFirstResponder];
    
    timeView =[[UIView alloc]initWithFrame:self.view.bounds];
    timeView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    
    KKDatePickerView* kkTimeView=[[KKDatePickerView alloc]initWithFrame:CGRectMake(0,WIN_HEIGHT-M_WIDTH(197),WIN_WIDTH,M_WIDTH(197))];
    kkTimeView.tDetegate=self;
    kkTimeView.backgroundColor=[UIColor whiteColor];
    
    [timeView addSubview:kkTimeView];
    [self.view addSubview:timeView];
}
-(void)setdeleteView{
    [timeView removeFromSuperview];
}

//选择性别View
-(void)men_and_womenView{
    [textF_1 resignFirstResponder];
    [textF_2 resignFirstResponder];
    
    genderView =[[UIView alloc]initWithFrame:self.view.bounds];
    genderView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    
    UIView *buttomView=[[UIView alloc]initWithFrame:CGRectMake(0,WIN_HEIGHT-M_WIDTH(171),WIN_WIDTH,M_WIDTH(171))];
    buttomView.backgroundColor=[UIColor whiteColor];
    UIButton * cancleBtn =[[UIButton alloc] initWithFrame:CGRectMake(WIN_WIDTH/2 -M_WIDTH(60),0,M_WIDTH(120),M_WIDTH(46))];
    [cancleBtn setTitle:@"选择生日" forState:0];
    [cancleBtn setTitleColor:[UIColor blackColor] forState:0];
    cancleBtn.titleLabel.font =BIG_FONT;
    [buttomView addSubview:cancleBtn];
    
    UIButton * sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(60),0,M_WIDTH(60),M_WIDTH(46))];
    [sureBtn setTitle:@"确定" forState:0];
    sureBtn.titleLabel.font = COMMON_FONT;
    [sureBtn setTitleColor:APP_BTN_COLOR forState:0];
    [sureBtn addTarget:self action:@selector(queTouch:) forControlEvents:UIControlEventTouchUpInside];
    [buttomView addSubview:sureBtn];
    
    UIView*lineView=[[UIView alloc]initWithFrame:CGRectMake(0,M_WIDTH(46)-1,WIN_WIDTH,1)];
    lineView.backgroundColor=COLOR_LINE;
    [buttomView addSubview:lineView];
    
    xingbieAry=[[NSArray alloc]initWithObjects:@"男",@"女",nil];
    pickView =[[UIPickerView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(lineView.frame),WIN_WIDTH,M_WIDTH(125))];
    pickView.delegate=self;
    pickView.dataSource=self;
    pickView.backgroundColor=[UIColor whiteColor];
    [buttomView addSubview:pickView];
    [self clearSeparatorWithView:pickView];
    [genderView addSubview:buttomView];
    [self.view addSubview:genderView];
}

//选择性别的确定时间
-(void)queTouch:(UIButton*)sender{
    [genderView removeFromSuperview];
    textF_4.text=xingbieStr;
}

//选择时间事件
-(void)setTime_pick:(id)time{
    NSLog(@"%@",time);
    NSString *timestr=[NSString stringWithFormat:@"%@%@%@%@%@",time[0],@"-",time[1],@"-",time[2]];
    textF_5.text=timestr;
    [timeView removeFromSuperview];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 2;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return M_WIDTH(30);
}
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return WIN_WIDTH;
}

-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    if (!view) {
        view=[[UIView alloc]init];
    }
    UILabel *text=[[UILabel alloc]initWithFrame:CGRectMake(0,0,WIN_WIDTH,M_WIDTH(30))];
    text.textAlignment=NSTextAlignmentCenter;
    text.text=xingbieAry[row];
    xingbieStr=xingbieAry[0];
    [view addSubview:text];
    
    return view;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    xingbieStr=xingbieAry[row];
}

#pragma mark ---对控件做处理---
//让分割线背景颜色为透明
- (void)clearSeparatorWithView:(UIView * )view
{
    if(view.subviews != 0  )
    {
        //分割线很薄的😊
        if(view.bounds.size.height < 5)
        {
            view.backgroundColor = [UIColor clearColor];
        }
        
        [view.subviews enumerateObjectsUsingBlock:^( UIView *  obj, NSUInteger idx, BOOL *  stop) {
            [self clearSeparatorWithView:obj];
        }];
    }
}

//对按钮做处理
-(void)chuliBtn:(UIButton*)btn :(NSString*)str{
    btn.layer.masksToBounds=YES;
    btn.layer.cornerRadius=5;
    btn.backgroundColor=[UIColor redColor];
    [btn setTitle:str forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font=BIG_FONT;
}

//对输入框做处理
-(void)chuliTextField:(UIView*)view :(UITextField*)textf textf_title:(NSString*)title lab_W:(int)type textf_top_line:(BOOL)lineBool lab_text:(NSString*)labText isIconImage:(BOOL)isImg{
    
    view.backgroundColor=[UIColor whiteColor];
    
    CGFloat tf_w=M_WIDTH(60);
    
    if (lineBool==YES) {
        UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(0,0,WIN_WIDTH,1)];
        lineView1.backgroundColor=COLOR_LINE;
        [view addSubview:lineView1];
    }
    
    UILabel *lab =[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(17),0,tf_w,view.frame.size.height)];
    lab.text=labText;
    lab.font=DESC_FONT;
    lab.textAlignment=NSTextAlignmentLeft;
    [view addSubview:lab];
    
    textf.frame=CGRectMake(CGRectGetMaxX(lab.frame),0,WIN_WIDTH-M_WIDTH(25)-tf_w,view.frame.size.height);
    textf.placeholder=title;
    textf.font=DESC_FONT;
    textf.delegate=self;
    [view addSubview:textf];
    
    if (isImg==YES) {
        UIImageView *iconImg=[[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(29),(view.frame.size.height-M_WIDTH(8))/2,M_WIDTH(16),M_WIDTH(8))];
        [iconImg setImage:[UIImage imageNamed:@"down"]];
        iconImg.contentMode=UIViewContentModeScaleAspectFit;
        [view addSubview:iconImg];
    }
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
