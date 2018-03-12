//
//  FeedbackViewController.m
//  sgSalerReport
//
//  Created by YaoHuiQiu on 16/5/5.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()<UITextFieldDelegate,UITextViewDelegate>

@end

@implementation FeedbackViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationBarTitleLabel.text= @"帮助与反馈";
    
    _contentTV.layer.borderWidth = 1;
    _contentTV.layer.borderColor = COLOR_LINE.CGColor;
    _contentTV.delegate = self;
    _nameTF.delegate = self;
    _phoneNumTF.delegate = self;
    self.keyboardContainer =  self.scrollView;
}

- (IBAction)commitAction:(id)sender {
    
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:[Global sharedClient].member_id, @"member_id", _phoneNumTF.text, @"phone_num", _nameTF.text, @"name", _contentTV.text, @"contents", nil];
    
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"usercenter" tp:@"feedback"] parameters:params target:self success:^(NSDictionary *dic) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.delegate.navigationController popViewControllerAnimated:YES];
            //弹窗提示信息
            [SVProgressHUD showSuccessWithStatus:@"提交成功"];
            
            
        });
    } failue:^(NSDictionary *dic) {
        
    }];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"最多500个字"]) {
        textView.textColor = COLOR_FONT_BLACK;
        textView.text = @"";
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length<1) {
        textView.text = @"最多500个字";
        textView.textColor = COLOR_FONT_SECOND;
    }
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    if(!self.scrollView){
        return;
    }
    NSDictionary *info = [notification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    NSValue *keyboardBoundsValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardBounds = [keyboardBoundsValue CGRectValue].size;
    self.scrollViewConstBot.constant =  keyboardBounds.height;
    [self.view setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
        
    }];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    if(!self.scrollView){
        return;
    }
    NSDictionary *info = [notification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    
    NSValue *keyboardBoundsValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardBounds = [keyboardBoundsValue CGRectValue].size;
    
    self.scrollViewConstBot.constant =  keyboardBounds.height;
    [self.view setNeedsUpdateConstraints];
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
        [self.scrollView setContentOffset:CGPointMake(0, 80) animated:YES];
    }];
    
}


- (void)keyboardWillHide:(NSNotification *)notification {
    if(!self.scrollView){
        return;
    }
    NSDictionary *info = [notification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    self.scrollViewConstBot.constant =  0;
    [self.view setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码]
        [_contentTV resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [_contentTV resignFirstResponder];
    [_nameTF resignFirstResponder];
    [_phoneNumTF resignFirstResponder];
    
    return YES;
}
- (void)scrollViewDidScroll:(UIScrollView *)vScrollView{
    
    [_contentTV resignFirstResponder];
    [_nameTF resignFirstResponder];
    [_phoneNumTF resignFirstResponder];
    
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
