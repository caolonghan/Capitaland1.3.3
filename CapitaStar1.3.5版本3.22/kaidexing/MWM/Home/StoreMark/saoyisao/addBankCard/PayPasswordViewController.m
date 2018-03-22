//
//  PayPasswordViewController.m
//  kaidexing
//
//  Created by companycn on 2018/3/7.
//  Copyright © 2018年 dwolf. All rights reserved.
//

#import "PayPasswordViewController.h"
#import "BJPasswordView.h"
#import "ShowPayViewController.h"
#import "SaoMaPayController.h"
#import "TeleInfoController.h"
#import "DES.h"
#import "BankCardViewController.h"
@interface PayPasswordViewController ()<BJPasswordViewDelegate>

@end

@implementation PayPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarTitleLabel.text = @"身份验证";
    self.navigationBarTitleLabel.textColor = [UIColor whiteColor];
    [self createViewWithType:_type];
    self.navigationBar.backgroundColor = RGBCOLOR(0, 135, 140);
}
-(void)redefineBackBtn{
    [self redefineBackBtn:[UIImage imageNamed:@"AR_back"] :CGRectMake(0, 0, 44,44)];
}
- (void)createViewWithType:(NSInteger )type
{
    
    
    UILabel *titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(WIN_WIDTH/2-90, 150, 180, 44)];
    titlelabel.textColor = [UIColor lightGrayColor];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titlelabel];
    
    titlelabel.font = COMMON_FONT;
    BJPasswordView * bjPass = [[BJPasswordView alloc]initWithFrame:CGRectMake(10, 200, self.view.frame.size.width-20, 45)];
    bjPass.delegate = self;
    bjPass.layer.cornerRadius = 3;
    bjPass.layer.masksToBounds = YES;
    bjPass.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:bjPass];
    if (_type ==0) {
        titlelabel.text = @"请设置支付密码";
    }else{
        titlelabel.text = @"请再次输入支付密码";
    }

}
- (void)validatePass:(NSString *)pass{
    if (_type ==0) {
    
    PayPasswordViewController *pavVc = [[PayPasswordViewController alloc]init];
    pavVc.type=1;
    pavVc.code = pass;
    [self.navigationController pushViewController:pavVc animated:YES];
    }else{
    if ([pass isEqualToString:_code]) {
        
        [self loadDataWithPass:pass];
       
    }else{
        [SVProgressHUD showErrorWithStatus:@"您输入的密码不正确"];
    }
    }
}
- (void)loadDataWithPass:(NSString *)pass
{
    NSString *padPwd = [DES encryptUseDES:pass];
    NSDictionary*diction=[[NSDictionary alloc]initWithObjectsAndKeys:[Global sharedClient].member_id, @"member_id",padPwd,@"pay_pwd",nil];
    [SVProgressHUD show];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"unionpay/UnionpayBindCard" tp:@"set_unionpay_card_pwd"] parameters:diction target:self success:^(NSDictionary *dic) {
        NSLog(@"%@",dic);
        
        [SVProgressHUD showSuccessWithStatus:@"密码设置成功"];
        [NSThread sleepForTimeInterval:1];
        dispatch_async(dispatch_get_main_queue(), ^{
       
            if ([Global sharedClient].bindCardBackWhere ==0) {
                for (UIViewController *viewController in self.navigationController.viewControllers) {
                    
                    if ([viewController isKindOfClass:[SaoMaPayController class]]) {
                        [self.navigationController popToViewController:viewController animated:YES];
                    }
                    
                }
            }else if([Global sharedClient].bindCardBackWhere ==1){
                for (UIViewController *viewController in self.navigationController.viewControllers) {
                    
                    if ([viewController isKindOfClass:[ShowPayViewController class]]) {
                        [self.navigationController popToViewController:viewController animated:YES];
                    }
                    
                }
            }else if ([Global sharedClient].bindCardBackWhere ==2){
                for (UIViewController *viewController in self.navigationController.viewControllers) {
                    
                    if ([viewController isKindOfClass:[BankCardViewController class]]) {
                        [self.navigationController popToViewController:viewController animated:YES];
                    }
                    
                }
            }else if ([Global sharedClient].bindCardBackWhere ==3){
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
        });
        
    } failue:^(NSDictionary *dic) {
        NSLog(@"失败%@",dic[@"data"][@"respMsg"]);
        [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
        
    }];
}
@end
