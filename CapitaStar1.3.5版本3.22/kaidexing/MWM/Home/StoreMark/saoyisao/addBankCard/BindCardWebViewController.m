//
//  BindCardWebViewController.m
//  kaidexing
//
//  Created by companycn on 2018/3/13.
//  Copyright © 2018年 dwolf. All rights reserved.
//

#import "BindCardWebViewController.h"
#import "ShowPayViewController.h"
#import "PayPasswordViewController.h"
#import "TeleInfoController.h"
#import "SaoMaPayController.h"
#import "BankCardViewController.h"

@interface BindCardWebViewController ()<UIWebViewDelegate>

@end

@implementation BindCardWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadWebView];
}
- (void)loadWebView
{
    [self.webView loadHTMLString:_BindHtmlStr baseURL:nil];
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if ([ request.URL.absoluteString rangeOfString: @"https://mall.capitaland.com.cn"].location != NSNotFound){
        [NSThread sleepForTimeInterval:1];
        [self judgeBindCard];
       
        return NO;
    }
    return YES;
}
- (void)judgeBindCard{
   
    if([Global sharedClient].hasBankCard){
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
            }else if ([Global sharedClient].bindCardBackWhere ==2){
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
            
        }else {
       
            PayPasswordViewController *payVc= [[PayPasswordViewController alloc]init];
            payVc.type = 0;
            [self.navigationController pushViewController:payVc animated:YES];
        }

}

@end
