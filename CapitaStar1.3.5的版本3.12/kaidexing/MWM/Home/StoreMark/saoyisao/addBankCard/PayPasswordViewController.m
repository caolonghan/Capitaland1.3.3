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
#import "DES.h"

@interface PayPasswordViewController ()<BJPasswordViewDelegate>

@end

@implementation PayPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarTitleLabel.text = @"身份验证";
    self.view.backgroundColor = [UIColor lightGrayColor];
   
    
    [self createViewWithType:_type];
}
- (void)createViewWithType:(NSInteger )type
{
    
    
    UILabel *titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(WIN_WIDTH/2-22, 150, 120, 44)];
    [self.view addSubview:titlelabel];
    
    titlelabel.font = COMMON_FONT;
    BJPasswordView * bjPass = [[BJPasswordView alloc]initWithFrame:CGRectMake(10, 200, self.view.frame.size.width-20, 45)];
    bjPass.delegate = self;
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
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"unionpay/UnionpayBindCard" tp:@"set_unionpay_card_pwd"] parameters:diction target:self success:^(NSDictionary *dic) {
        NSLog(@"%@",dic);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            for (UIViewController *viewController in self.navigationController.viewControllers) {
                
                if ([viewController isKindOfClass:[ShowPayViewController class]]) {
                    [self.navigationController popToViewController:viewController animated:YES];
                }
                
            }
            
        });
        
    } failue:^(NSDictionary *dic) {
        NSLog(@"失败%@",dic[@"data"][@"respMsg"]);
        
    }];
}
@end
