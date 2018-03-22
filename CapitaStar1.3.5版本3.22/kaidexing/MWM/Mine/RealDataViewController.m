//
//  RealDataViewController.m
//  sgSalerReport
//
//  Created by YaoHuiQiu on 16/5/6.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "RealDataViewController.h"

//#include <Security/Security.h>
#import "PhoneInputViewController.h"
#import "MyToolbar.h"

@interface RealDataViewController ()<UITextFieldDelegate>
{
    NSString * sex;  //性别 1：男 2：女
    NSString * birth;
    
    UIActionSheet* pickerViewPopup;
    UIAlertController* pickerViewPopupVC;
    UIDatePicker* datePicker;
}
@end

@implementation RealDataViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedGender:) name:@"CancelFemale" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedGender:) name:@"CancelMale" object:nil];
        
        self.nameTF.delegate = self;
        self.birthdayTF.delegate = self;
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedGender:) name:@"CancelFemale" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedGender:) name:@"CancelMale" object:nil];
        
        self.nameTF.delegate = self;
        self.birthdayTF.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationBarTitleLabel.text= @"真实资料填写";
    self.birthdayTF.delegate = self;
    self.nameTF.delegate = self;
}

- (void)selectedGender:(NSNotification *)notification {
    
    NSString * name = [notification valueForKey:@"name"];
    if ([name isEqualToString:@"CancelFemale"]) {
        sex = @"1"; //男
    } else {
        sex = @"2"; //女
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if(textField == self.birthdayTF){
        [self.nameTF resignFirstResponder];
        [self showBirthPicker];
        return NO;
    }
    [self closePicker:nil];
    return YES;
    
}


- (void)showBirthPicker {
    
    if(pickerViewPopup){
        [pickerViewPopup removeFromSuperview];
        pickerViewPopup = nil;
    }
    
    CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
    if(IS_IOS_8){
        pickerViewPopupVC = [UIAlertController alertControllerWithTitle:nil message:@"\n\n\n\n\n\n\n\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleActionSheet];
    }else{
        pickerViewPopup = [[UIActionSheet alloc] initWithTitle:@""
                                                      delegate:nil
                                             cancelButtonTitle:nil
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:nil];
    }
    
    // Add the picker
    datePicker = [[UIDatePicker alloc] initWithFrame: CGRectMake(0.0f, 44.0f, 0.0f, 0.0f)];
    
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow: -(24*60*60) ];
    
    MyToolbar* pickerToolbar = [[MyToolbar alloc] init];
    // Add the ToolBar
    if(IS_IOS_8){
        pickerToolbar.frame = CGRectMake(0, 3,pickerViewPopupVC.view.frame.size.width -20 , 47);
    }else{
        pickerToolbar.frame = CGRectMake(0, 0, screenFrame.size.width, 50);
    }
    
    [pickerToolbar setBackgroundColor:DEFAULT_BG_COLOR];
    // [pickerToolbar sizeToFit];
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    
    
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"    取消"
                                                                  style: UIBarButtonSystemItemCancel
                                  
                                                                 target: self
                                                                 action: @selector(closePicker:)];
    [barItems addObject:cancelBtn];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"确定    "
                                                                style:UIBarButtonItemStyleDone
                                                               target: self
                                                               action: @selector(pickYear:)];
    [barItems addObject:doneBtn];
    
    
    [pickerToolbar setItems:barItems animated:YES];
    
    if(IS_IOS_8){
        [pickerViewPopupVC.view addSubview:pickerToolbar];
        
        [pickerViewPopupVC.view  addSubview:datePicker];
        
        
        [pickerViewPopupVC.view  setBounds:CGRectMake(0,0,screenFrame.size.width, 464)];
        
        [pickerViewPopupVC.view  setBackgroundColor:DEFAULT_BG_COLOR];
        
        [self presentViewController:pickerViewPopupVC animated:YES completion:nil];
    }else{
        [pickerViewPopup addSubview:pickerToolbar];
        
        [pickerViewPopup addSubview:datePicker];
        [pickerViewPopup showInView:self.view];
        
        [pickerViewPopup setBounds:CGRectMake(0,0,screenFrame.size.width, 464)];
        
        [pickerViewPopup setBackgroundColor:DEFAULT_BG_COLOR];
    }
}

-(BOOL)pickYear:(id)sender{
    
    if(IS_IOS_8){
        [pickerViewPopupVC dismissViewControllerAnimated:YES completion:^{
            
        }];
    }else{
        [pickerViewPopup dismissWithClickedButtonIndex:0 animated:YES];
    }
    //数据处理
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    //2015-05-22
    formatter.dateFormat = @"yyyy-MM-dd";
    
    self.birthdayTF.text = [formatter stringFromDate:datePicker.date];
    
    return  YES;
}

- (BOOL)closePicker:(id)sender {
    
    if(IS_IOS_8){
        [pickerViewPopupVC dismissViewControllerAnimated:YES completion:^{
            
        }];
    }else{
        [pickerViewPopup dismissWithClickedButtonIndex:0 animated:YES];
    }
    
    return  YES;
}

- (BOOL)isBlankString:(NSString *)string{
    
    if (string == nil) {
        return YES;
    }
    if (string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        return YES;
    }
    return NO;
}

- (IBAction)finishReister:(id)sender {
    _wanchengBtn.enabled=NO;
    //判断有没有填写真实姓名&性别生日
    if ([self isBlankString:self.nameTF.text]) {
        _wanchengBtn.enabled=YES;
        [SVProgressHUD showErrorWithStatus:@"请输入真实姓名"];
        return;
    }
    if (!sex) {
        _wanchengBtn.enabled=YES;
        [SVProgressHUD showErrorWithStatus:@"请选择性别"];
        return;
    }
    if ([self isBlankString:self.birthdayTF.text]) {
        _wanchengBtn.enabled=YES;
        [SVProgressHUD showErrorWithStatus:@"请选择生日"];
        return;
    }
    [SVProgressHUD showWithStatus:@"正在努力注册中"];
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:@"22", @"shop_id", _vilaCode, @"vilaCode", _phone_num, @"phone_num", _pass_word, @"pass_word", sex, @"sex", self.birthdayTF.text, @"birth", _nameTF.text, @"truthName", @"1000", @"source", nil];
    NSLog(@"params===%@", params);
    
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"member" tp:@"regist2"] parameters:params target:self success:^(NSDictionary *dic) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"Success-dic===%@", dic);
            //提示注册成功
            [SVProgressHUD showSuccessWithStatus:dic[@"data"]]; //@"注册成功"
            //找出要跳回的登录视图控制器
            NSArray * viewControllers = self.delegate.navigationController.viewControllers;
            for (UIViewController * viewC in viewControllers) {
                
                if ([viewC isMemberOfClass:[PhoneInputViewController class]]) {
                    
                    [Global sharedClient].xjf_Cq_Xx=nil;
                    [Global sharedClient].phone=nil;
                    [Global sharedClient].member_id=nil;
                    [Global sharedClient].nick_name=nil;
                    [Global sharedClient].img_url=nil;
                    
                    PhoneInputViewController * loginVC = (PhoneInputViewController *)viewC;
//                    PhoneInputViewController.phone_num.text = _phone_num;
//                    loginVC.pass_word.text = _password;
                    _wanchengBtn.enabled=YES;
                    [SVProgressHUD dismiss];
                    [self.delegate.navigationController popToViewController:loginVC animated:YES];
                }
            }
        });
        
    } failue:^(NSDictionary *dic) {
        _wanchengBtn.enabled=YES;
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.nameTF resignFirstResponder];
    [self.birthdayTF resignFirstResponder];
    
    return YES;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
