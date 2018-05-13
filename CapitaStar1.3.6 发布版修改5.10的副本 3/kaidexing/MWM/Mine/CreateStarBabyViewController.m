//
//  CreateStarBabyViewController.m
//  kaidexing
//
//  Created by YaoHuiQiu on 16/5/13.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "CreateStarBabyViewController.h"

#import "MaleView.h"
#import "FemaleView.h"
#import "CreateViewController.h"
#import "KKDatePickerView.h"
#import "RootViewController.h"

@interface CreateStarBabyViewController ()<timeDelegate,UITextFieldDelegate>
{
    UIScrollView * scrollView;
    
    NSArray * createTitles;
    
    NSArray * showTitles;
    
    UILabel * remindLab;
    
    UIButton * confirmBtn;
    
    BOOL isAdd;
    
    NSMutableArray * dataArr;
    
    BOOL isHaveStarBaby;
    UIView *timeView;
    UIActionSheet* pickerViewPopup;
    UIAlertController* pickerViewPopupVC;
    UIDatePicker* datePicker;
    
    //正在编辑的TF
    NSMutableArray* editTFArr;
}
@end

@implementation CreateStarBabyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    editTFArr = [[NSMutableArray alloc] init];
    
    self.navigationBarTitleLabel.text= @"我的星宝贝";
    
    createTitles = @[@"星宝贝名", @"出生日期", @"性别"];
    showTitles = @[@"星宝贝名", @"出生日期", @"性别", @"星币余额"];
  
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    dataArr = [[NSMutableArray alloc] init];
    if(_isSecond){
        isHaveStarBaby = NO;
        [self createSubviews];
        
    }else{
        [self networkRequest];
    }
    
    [self setKeyboardContainer:scrollView];
    if ([self.delegate.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.delegate.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)networkRequest {
    
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:[Global sharedClient].member_id, @"member_id", @"1000",  @"source", nil];
    
    [SVProgressHUD showWithStatus:@"数据加载中"];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"usercenter" tp:@"sparks"] parameters:params target:self success:^(NSDictionary *dic) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
    
            NSArray * array = dic[@"data"];
            
            if (array.count) {
                
                isHaveStarBaby = YES;
                
                for (NSDictionary * dic_1 in array) {
                    
                    NSMutableArray * tempArr = [[NSMutableArray alloc] init];
                    
                    [tempArr addObject:dic_1[@"spark_name"]];
                    if([dic_1[@"birth"] length] > 10){
                        [tempArr addObject:[dic_1[@"birth"] substringToIndex:10]];
                    }else{
                        [tempArr addObject:dic_1[@"birth"]];
                    }
                    
                    if ([dic_1[@"sex"] integerValue] ==  1) {
                        
                        [tempArr addObject:@"男"];
                    } else if ([dic_1[@"sex"] integerValue] ==  2) {
                        [tempArr addObject:@"女"];
                    }
                    [tempArr addObject:[NSString stringWithFormat:@"%@", dic_1[@"profile_token"] ]];
                    
                    [dataArr addObject:tempArr];
                    
                    tempArr = nil;
                }
                
            } else {
                isHaveStarBaby = NO;
            }
            [self createSubviews];
            
            [SVProgressHUD dismiss];
        });
        
    } failue:^(NSDictionary *dic) {
        
    }];
}

- (void)createSubviews {
    if(scrollView != nil){
        [scrollView removeFromSuperview];
    }
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, WIN_WIDTH, WIN_HEIGHT - NAV_HEIGHT - 1)];
    scrollView.contentSize = CGSizeMake(WIN_WIDTH, WIN_WIDTH + 10);
    
    [self.view addSubview:scrollView];
    
    //判断是否有星宝贝
    if (isHaveStarBaby) { //有
        [self showStarBabyWithCount:dataArr.count]; //测试
        
    } else {
        self.navigationBarTitleLabel.text = @"创建星宝贝";
        [self createStarBaby];
    }
}

- (void)showStarBabyWithCount:(NSInteger)count {
    
    for (int m = 0; m < count; m++) {
        
        NSArray * array = dataArr[m];
        
        CGFloat y;
        
        switch (m) {
                
            case 0:
                y = 0;
                break;
                
            case 1:
                y = 163 + 20;
                break;
                
            default:
                break;
        }
        
        UIView * grayView = [[UIView alloc] initWithFrame:CGRectMake(0, y, WIN_WIDTH, 163+20)];
        grayView.backgroundColor = UIColorFromRGB(0xf9f9f9);
        
        [scrollView addSubview:grayView];
        
        UIView * whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 1, WIN_WIDTH, 163)];
        whiteView.backgroundColor = [UIColor whiteColor];
        
        [grayView addSubview:whiteView];
        
        
        for (int i = 0; i < 4; i++) {
            
            UIView * littleWhiteView = [[UIView alloc] initWithFrame:CGRectMake(0, i * (40 + 1), CGRectGetWidth(whiteView.frame), 40)];
            littleWhiteView.backgroundColor = [UIColor whiteColor];
            
            [whiteView addSubview:littleWhiteView];
            
            
            UILabel * leftLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0,80, 40)];
            leftLab.font = COMMON_FONT;
            leftLab.textColor = COLOR_FONT_SECOND;
            leftLab.text = showTitles[i];
            
            [littleWhiteView addSubview:leftLab];
            
            
            UILabel * rightLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftLab.frame) + 27, 0, 150, 40)];
            rightLab.font = COMMON_FONT;
            rightLab.textColor = COLOR_FONT_BLACK; //COLOR_FONT_BLACK
            rightLab.text = array[i];
            
            [littleWhiteView addSubview:rightLab];
            
            
            if (i == 0) {
                
                for (int j=0; j<3; j++) {
                    //灰色分割线
                    CGFloat y = 40 + (40 + 1) * j;
                    UIView * lowView = [[UIView alloc] initWithFrame:CGRectMake(8, y, WIN_WIDTH - 8, 1)];
                    lowView.backgroundColor = COLOR_LINE;
                    
                    [whiteView addSubview:lowView];
                }
            }
        }
        if (count < 2) {
            
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            
            btn.frame = CGRectMake(WIN_WIDTH - 6 - 40, CGRectGetMaxY(grayView.frame) + 6,40, 40);
            [btn setBackgroundImage:[UIImage imageNamed:@"r_plus"] forState:UIControlStateNormal];
            btn.layer.cornerRadius = DEFAULT_BUTTON_RADIUS;
            btn.layer.masksToBounds = YES;
            [btn addTarget:self action:@selector(addStarBaby:) forControlEvents:UIControlEventTouchUpInside];
            
            [scrollView addSubview:btn];
        }
    }
}

- (void)addStarBaby:(UIButton *)sender {
    
    CreateStarBabyViewController * csVC = [[CreateStarBabyViewController alloc] init];
    csVC.isSecond  = YES;
    [self.delegate.navigationController pushViewController:csVC animated:YES];
}

- (void)createStarBaby {
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 1)];
    view.backgroundColor = COLOR_LINE;
    
    [scrollView addSubview:view];
    
    
    UIView * grayView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(view.frame), WIN_WIDTH, 42)];
    grayView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    
    [scrollView addSubview:grayView];
    
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(12.5, 17, WIN_WIDTH - 14 - 14, 13)];
    label.font = COMMON_FONT;
    label.textColor = COLOR_FONT_SECOND;
    label.text = @"会员您好, 请提供以下资料为您的宝贝完成绑定";
    
    [grayView addSubview:label];
    
    
    UIView * whiteView = [self createRelevantInfomationViewWithView:grayView];
    whiteView.tag = 700;
    if(!_isSecond){
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(WIN_WIDTH - 14 - 36, CGRectGetMaxY(whiteView.frame) + 12, 36, 36);
        btn.layer.cornerRadius = 18;
        btn.layer.masksToBounds = YES;
        [btn setBackgroundImage:[UIImage imageNamed:@"r_plus"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(addMoreStarBaby:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:btn];
        remindLab = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(btn.frame) + 23, WIN_WIDTH - 15*2, 13)];
    }else{
        remindLab = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(whiteView.frame) + 23, WIN_WIDTH - 15*2, 13)];
    }
    remindLab.font = COMMON_FONT;
    remindLab.textColor = COLOR_FONT_SECOND;
    remindLab.text = @"※提醒您, 您最多可绑定两位星宝贝!";
    
    [scrollView addSubview:remindLab];
    
    
    confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(15, CGRectGetMaxY(remindLab.frame) + 15, WIN_WIDTH - 14 - 15, 44);
    confirmBtn.backgroundColor = UIColorFromRGB(0xe0292b);
    confirmBtn.layer.cornerRadius = DEFAULT_BUTTON_RADIUS;
    confirmBtn.layer.masksToBounds = YES;
    confirmBtn.titleLabel.font = COMMON_FONT;
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmToCreateStarBaby:) forControlEvents:UIControlEventTouchUpInside];
    
    [scrollView addSubview:confirmBtn];
    
    isAdd = YES;
}

- (void)addMoreStarBaby:(UIButton *)sender {
    self.ishaveStar = YES;
    if (isAdd) {
        
        isAdd = NO;
        
        CGFloat y = CGRectGetMinY(sender.frame) - 12;
        
        UIView * grayView = [[UIView alloc] initWithFrame:CGRectMake(0, y, WIN_WIDTH, 12)];
        
        [scrollView addSubview:grayView];
        
        
        UIView * whiteView_1 = [self createRelevantInfomationViewWithView:grayView];
        whiteView_1.tag = 800;
        
        CGRect senderFrame = sender.frame;
        senderFrame.origin.y = CGRectGetMaxY(whiteView_1.frame) + 12;
        
        sender.frame = senderFrame;
        
        
        CGRect remindLabFrame = remindLab.frame;
        remindLabFrame.origin.y = CGRectGetMaxY(sender.frame) + 23;
        
        remindLab.frame = remindLabFrame;
        
        
        CGRect confirmBtnFrame = confirmBtn.frame;
        confirmBtnFrame.origin.y = CGRectGetMaxY(remindLab.frame) + 15;
        
        confirmBtn.frame = confirmBtnFrame;
        
        
        [sender setBackgroundImage:[UIImage imageNamed:@"r_minus"] forState:UIControlStateNormal];
        
    } else {
        
        isAdd = YES;
        
        UIView * whiteView_1 = [scrollView viewWithTag:800];
        [whiteView_1 removeFromSuperview];
        whiteView_1 = nil;
        
        
        UIView * whiteView = [scrollView viewWithTag:700];
        
        CGRect senderFrame = sender.frame;
        senderFrame.origin.y = CGRectGetMaxY(whiteView.frame) + 12;
        
        sender.frame = senderFrame;
        
        
        CGRect remindLabFrame = remindLab.frame;
        remindLabFrame.origin.y = CGRectGetMaxY(sender.frame) + 23;
        
        remindLab.frame = remindLabFrame;
        
        
        CGRect confirmBtnFrame = confirmBtn.frame;
        confirmBtnFrame.origin.y = CGRectGetMaxY(remindLab.frame) + 15;
        
        confirmBtn.frame = confirmBtnFrame;
        
        
        [sender setBackgroundImage:[UIImage imageNamed:@"r_plus"] forState:UIControlStateNormal];
    }
}


-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    //获取可见cells
    for(UITextField* item in editTFArr){
        [item resignFirstResponder];
    }
    [editTFArr removeAllObjects];
    [editTFArr addObject:textField];
    if (textField.tag == 301) {
        
        [self createTimeView];
        
        return false;
    }
   
    return true;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    [textField resignFirstResponder];
}

//创建选择时间的view
-(void)createTimeView{
    
    timeView =[[UIView alloc]initWithFrame:self.view.bounds];
    timeView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    
    KKDatePickerView* kkTimeView=[[KKDatePickerView alloc]initWithFrame:CGRectMake(0,WIN_HEIGHT-M_WIDTH(197),WIN_WIDTH,M_WIDTH(197))];
    kkTimeView.tDetegate=self;
    kkTimeView.backgroundColor=[UIColor whiteColor];
    
    [timeView addSubview:kkTimeView];
    [self.view addSubview:timeView];
}
-(void)setTime_pick:(id)time{
    [timeView removeFromSuperview];
    NSString *timestr=[NSString stringWithFormat:@"%@-%@-%@",time[0],time[1],time[2]];
    UITextField* tf = editTFArr[0];
    tf.text = timestr;
}
-(void)setdeleteView{
    [timeView removeFromSuperview];
}

-(BOOL)pickYear:(id)sender{
    
    if(IS_IOS_8){
        [pickerViewPopupVC dismissViewControllerAnimated:YES completion:^{
            
        }];
    }else{
        [pickerViewPopup dismissWithClickedButtonIndex:0 animated:YES];
    }
    
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    NSString * pickBirthday = [formatter stringFromDate:datePicker.date];
    
//    birthdayTextField.text = pickBirthday;
//    
//    birth = pickBirthday;
    
    return  YES;
}

-(BOOL)closePicker:(id)sender
{
    if(IS_IOS_8){
        [pickerViewPopupVC dismissViewControllerAnimated:YES completion:^{
            
        }];
    }else{
        [pickerViewPopup dismissWithClickedButtonIndex:0 animated:YES];
    }
    
    return  YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}

-(void) creatStarBaby:(UIButton *)sender parentView:(UIView*) parentView{
    NSString * path = [Util makeRequestUrl:@"usercenter" tp:@"addspark"];
    UITextField* tf = (UITextField*)[parentView viewWithTag:300];
    NSString * spark_name = tf.text;
    if([Util isNull:spark_name]){
        [SVProgressHUD showErrorWithStatus:@"请输入星宝贝的姓名"];
        sender.enabled = YES;
        return;
    }
    tf = (UITextField*)[parentView viewWithTag:301];
    
    NSString * birth = tf.text;
    if([Util isNull:spark_name]){
        [SVProgressHUD showErrorWithStatus:@"请输入星宝贝的出生日期"];
        sender.enabled = YES;
        return;
    }
    
    MaleView* maleView = (MaleView*)[parentView viewWithTag:401];
    NSString * sex = maleView.isSelect ? @"1" : @"2";
    
    NSString * location_code = @"ESITE";
    
    //NSString *
    
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:[Global sharedClient].member_id, @"member_id", spark_name, @"spark_name", birth, @"birth", sex, @"sex", location_code, @"location_code", @"1000",  @"source", nil];
    
    [SVProgressHUD showWithStatus:@"数据加载中"];
    [HttpClient requestWithMethod:@"POST" path:path parameters:params target:self success:^(NSDictionary *dic) {
        UIView* parent1View = [self.view viewWithTag:800];
        if(parent1View != nil && parent1View != parentView){
            [self creatStarBaby:sender parentView:parent1View];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [SVProgressHUD showSuccessWithStatus:dic[@"data"]];
                sender.enabled = YES;
                if(_isSecond){
                    [self.navigationController popViewControllerAnimated:YES];
                    return ;
                }
                CreateStarBabyViewController *create = [[CreateStarBabyViewController alloc]init];
                [self.navigationController pushViewController:create animated:YES];
                //[self networkRequest];
                
            });
        }
        
        
    } failue:^(NSDictionary *dic) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //弹窗提示错误信息
            [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
            sender.enabled = YES;
        });
    }];

}

- (void)confirmToCreateStarBaby:(UIButton *)sender {
    sender.enabled = NO;
    
    UIView* parentView = [self.view viewWithTag:700];
    [self creatStarBaby:sender parentView:parentView];
}

- (UIView *)createRelevantInfomationViewWithView:(UIView *)view {
    
    UIView * whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(view.frame), WIN_WIDTH, 137)];
    whiteView.backgroundColor = [UIColor whiteColor];
    
    [scrollView addSubview:whiteView];
    
    for (int i = 0; i < 3; i++) {
        
        UIView * littleWhiteView = [[UIView alloc] initWithFrame:CGRectMake(0, (45 + 1) * i, WIN_WIDTH, 45)];
        littleWhiteView.backgroundColor = [UIColor whiteColor];
        
        [whiteView addSubview:littleWhiteView];
        
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(15, 14, 70, 13)];
        label.font = COMMON_FONT;
        label.textColor = COLOR_FONT_SECOND;
        label.text = createTitles[i];
        
        [littleWhiteView addSubview:label];
        
        if (i == 2) {
            
            for (int j = 0; j < 2; j++) {
                //灰色分隔线
                CGFloat y = 45 + j * (45 +1);
                UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, y, WIN_WIDTH, 1)];
                view.backgroundColor = COLOR_LINE;
                
                [whiteView addSubview:view];
            }
            //CGRectGetMaxX(maleView.frame) + 21, 12, 35, 15
            int randGroup = arc4random() ;
            MaleView * maleView = [[MaleView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame) + 34, 10, 40, 20)];
            maleView.tag = 401;
            maleView.group =[ NSString stringWithFormat:@"%d",randGroup ];
            maleView.isSelect = YES;
            
            [littleWhiteView addSubview:maleView];
            
            //CGRectGetMaxX(maleView.frame) + 21, 12, 35, 15
            FemaleView * femaleView = [[FemaleView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(maleView.frame) + 16, 10, 40, 20)];
            femaleView.tag = 402;
            femaleView.group = maleView.group;
            [littleWhiteView addSubview:femaleView];
            
        } else {
            UITextField * textField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame) + 27, 6, 150, 30)];
            textField.font = COMMON_FONT;
            textField.textColor = COLOR_FONT_BLACK;
            textField.placeholder = @"请填写";
            textField.tag = 300+i;
            textField.delegate = self;
            
            [littleWhiteView addSubview:textField];
        }
    }
    return whiteView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backBtnOnClicked:(id)sender
{
    if (_ishaveStar) {
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[RootViewController class]]) {
                RootViewController *root = (RootViewController *)controller;
                root.haveRemotemsg = YES;
                [self.navigationController popToViewController:root animated:YES];
            }
        }
}
}

@end
