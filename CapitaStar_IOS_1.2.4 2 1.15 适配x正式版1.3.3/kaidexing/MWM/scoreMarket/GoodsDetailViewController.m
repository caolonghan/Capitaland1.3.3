//
//  GoodsDetailViewController.m
//  kaidexing
//
//  Created by dwolf on 16/5/13.
//  Copyright (c) 2016年 dwolf. All rights reserved.
//

#import "GoodsDetailViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "LoginViewController.h"
#import "MyMsgViewController.h"
#import "GoViewController.h"
#import "ConfirmPaymentView.h"
#import <AlipaySDK/AlipaySDK.h>
#import "AliManager.h"
#import "LoginViewController.h"
#import "PhoneInputViewController.h"
#import <Pingpp/Pingpp.h>

@interface GoodsDetailViewController ()<UIWebViewDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>

@end

@implementation GoodsDetailViewController{
    @private
    UIView* statusBarView;
    NSTimer* myTimer;
    int loginCount;
    NSString* orderId;
    UIView  *confirmPayView;
    NSDictionary *orderDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _topHeight.constant = STATUS_BAR_HEIGHT;
    _bottomHeight.constant = BAR_HEIGHT;
    
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie* cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
    _path = [NSString stringWithFormat:@"%@://%@/integral_mall/integral_index?mall_id=%@",[Global sharedClient].HTTP_S,[Global sharedClient].Shopping_Mall,[Global sharedClient].markID];

    //PV环境
//    _path=@"http://mallpv.companycn.net/integral_mall/integral_index";
    
    UISwipeGestureRecognizer  *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
    swipeRight.delegate = self;
    swipeRight.direction=UISwipeGestureRecognizerDirectionRight;
    [_webView addGestureRecognizer:swipeRight];
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

-(void)back
{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
}
-(UIView*)viewForZoomingInScrollView:(UIScrollView*)scrollView{
    return nil;
}


-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

    self.navigationBar.hidden = YES;
    NSString* domian = [@"." stringByAppendingString:[Global sharedClient].API_DOMAIN ];
    statusBarView = [[UIView alloc] init];
    statusBarView.frame = CGRectMake(0, 0, SCREEN_FRAME.size.width, 20);
    
    statusBarView.backgroundColor= [UIColor whiteColor];
    
    [self.view addSubview:statusBarView];
    
    self.navigationController.navigationBarHidden = TRUE;

     NSURL *url=[NSURL URLWithString:_path];
    
    NSMutableArray *cookies = [[NSMutableArray alloc] init];
    if(![Util isNull:[Global sharedClient].userCookies]){

        NSDictionary *properties = [[NSMutableDictionary alloc] init];
        [properties setValue:[Global sharedClient].userCookies forKey:NSHTTPCookieValue];
        [properties setValue:@"0799C3B5EA3898E6E72A08A5557D16EA03D5E30B7DF6FECD" forKey:NSHTTPCookieName];
        [properties setValue:domian forKey:NSHTTPCookieDomain];
        [properties setValue:[NSDate dateWithTimeIntervalSinceNow:60*60] forKey:NSHTTPCookieExpires];
        [properties setValue:@"/" forKey:NSHTTPCookiePath];

        NSHTTPCookie *cookie = [[NSHTTPCookie alloc] initWithProperties:properties];
        [cookies addObject:cookie];
//    }else{
//        if(loginCount > 0){
//            [self.delegate.navigationController popViewControllerAnimated:YES];
//            return;
//        }else{
//            loginCount = 0;
//        }
//    }
//    if(![Util isNull:[Global sharedClient].markCookies]){
//        NSDictionary *properties1 = [[NSMutableDictionary alloc] init];
//        [properties1 setValue:[Global sharedClient].markCookies forKey:NSHTTPCookieValue];
//        [properties1 setValue:@"4CA043AA7659441F0468007AD296A053" forKey:NSHTTPCookieName];
//        [properties1 setValue:domian forKey:NSHTTPCookieDomain];
//        [properties1 setValue:[NSDate dateWithTimeIntervalSinceNow:60*60] forKey:NSHTTPCookieExpires];
//        [properties1 setValue:@"/" forKey:NSHTTPCookiePath];
//
//        NSHTTPCookie *cookie1 = [[NSHTTPCookie alloc] initWithProperties:properties1];
//        [cookies addObject:cookie1];
    }

    if(cookies.count > 0){
       [[NSHTTPCookieStorage sharedHTTPCookieStorage]setCookies:cookies forURL:url mainDocumentURL:nil];
    }
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    self.webView.scrollView.delegate=self;
    self.webView.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag; // 当拖动时移除键盘
    [self.webView loadRequest:request];
    self.webView.delegate = self;

}

- (void)setupJsContent
{
    
    
    JSContext *context=[_webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"onBackT"] = ^() {
        if([self.webView canGoBack]){
            [self.webView goBack];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate.navigationController popViewControllerAnimated:YES];
            });
        }
        
    };
   /* context[@"SureOrderSuc"] = ^() {
        
        [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"integralmall" tp:@"alipaycashgoods"] parameters:[[NSDictionary alloc]initWithObjectsAndKeys:orderId,@"order_id",nil ] target:self success:^(NSDictionary *dic){dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"%@",dic);
                orderDic = dic;
                [confirmPayView removeFromSuperview];
                confirmPayView =[[UIView alloc]initWithFrame:self.view.bounds];
                confirmPayView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
                ConfirmPaymentView *conView=[[ConfirmPaymentView alloc]initWithFrame:CGRectMake((WIN_WIDTH-M_WIDTH(250))/2,WIN_HEIGHT/4,M_WIDTH(250),M_WIDTH(210)) data:dic];
                conView.backgroundColor=[UIColor whiteColor];
                conView.cDelegate=self;
                conView.layer.masksToBounds=YES;
                conView.layer.cornerRadius=8;
                [confirmPayView addSubview:conView];
                [self.view addSubview:confirmPayView];

            });
        }failue:^(NSDictionary *dic){
            NSLog(@"%@",dic);
        }];
//        [self showMsg: orderId];
    };*/
    
    context[@"wap_pay"] = ^(NSString* method) {
        NSLog(@"%@",method);
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
        NSMutableSet* acctSet = [[NSMutableSet alloc] initWithSet:[HttpClient sharedClient].responseSerializer.acceptableContentTypes];
        [acctSet addObject:@"text/html"];
        manager.responseSerializer.acceptableContentTypes = acctSet;
        [manager POST:[NSString stringWithFormat:@"%@://%@/pingplusplus/CreateOrders",[Global sharedClient].HTTP_S,[Global sharedClient].Shopping_Mall] parameters:[[NSDictionary alloc]initWithObjectsAndKeys:orderId,@"order_id",@"global",@"type",method,@"channel",@"ios",@"userAgent",nil ] progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  NSDictionary *dic = responseObject;
                  {dispatch_async(dispatch_get_main_queue(), ^{
                      NSLog(@"%@",dic);
                      orderDic = dic;
                      
                      [Pingpp createPayment:dic
                             viewController:self
                               appURLScheme:@"capitalandApp"
                             withCompletion:^(NSString *result, PingppError *error) {
                                 if ([result isEqualToString:@"success"]) {
                                     GoViewController *vc = [[GoViewController alloc]init];
                                     vc.path=[NSString stringWithFormat:@"%@://%@/integral_mall/global_sale/pay_success?payable=0&rn=%@",[Global sharedClient].HTTP_S,[Global sharedClient].Shopping_Mall,orderId];
                                     NSLog(@"======%@",vc.path);
                                     [self.delegate.navigationController pushViewController:vc animated:YES];
                                 } else {
                                     // 支付失败或取消
                                     NSLog(@"Error: code=%lu msg=%@", error.code, [error getMsg]);
                                     
                                     
                                     
                                 }
                             }];
                      
                  });
                  }
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  
              }];
        
        
    };
}
 
 -(void)paymentEvent:(id)vul{
     [confirmPayView removeFromSuperview];
     if (![Util isNull:vul]) {
         NSLog(@"生成预付单返回-%@",orderDic);
         NSString *appScheme   =ALI_APPBack;
         NSString *orderString =orderDic[@"data"][@"returnStr"];
         [AliManager aliMsgOpenURL:nil].aiDelegate=self;
         [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
             NSLog(@"reslut = %@",resultDic);
         }];
     }
}

-(void)setAliMsg:(id)vul{
    if ([vul isEqualToString:@"9000"]) {
        NSLog(@"支付成功，跳转支付成功界面");
        GoViewController *vc = [[GoViewController alloc]init];
        vc.path=[NSString stringWithFormat:@"%@://%@/integral_mall/global_sale/pay_success?rn=%@",[Global sharedClient].HTTP_S,[Global sharedClient].Shopping_Mall,orderId];
        [self.delegate.navigationController pushViewController:vc animated:YES];
    }
}


- (void)webViewDidStartLoad:(UIWebView *)webView{
    self.webView.hidden = YES;
    [self displayLoading];
}

- (void)webViewDidFinishLoad:(UIWebView *)web{
    myTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timer) userInfo:nil repeats:NO];
    if([web.request.URL.absoluteString rangeOfString:@"integral_mall/integral_index"].location != NSNotFound){
        statusBarView.backgroundColor= [UIColor whiteColor];
    }else{
        statusBarView.backgroundColor= [UIColor whiteColor];
    }

    NSString *delete=[NSString stringWithFormat:@"var nava = document.getElementById('nav');"
                      "nava.parentNode.removeChild(nava)"];
    [self.webView stringByEvaluatingJavaScriptFromString:delete];
    self.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    NSString *goFun=[NSString stringWithFormat:@"history.go = function (i){onBackT(i);}"];
    [self.webView stringByEvaluatingJavaScriptFromString:goFun];
//    NSString* sureOrderSuc = @" function SureOrderSuc(){}";
    [self setupJsContent];
    [self removeLoading];
}

-(void) timer{
    self.webView.hidden = NO;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    // 说明协议头是ios
    if ([ request.URL.absoluteString rangeOfString: @"Login" ].location != NSNotFound) {
        
        LoginViewController  * vc = [[LoginViewController alloc] init];
        vc.advStr = _path;
        [self.delegate.navigationController pushViewController:vc animated:YES];
        [self timer];
        return NO;
    }else if([ request.URL.absoluteString rangeOfString: @"TitleNav/userMessageList"].location != NSNotFound){
        MyMsgViewController* vc = [[MyMsgViewController alloc] init];
        [self.delegate.navigationController pushViewController:vc animated:YES];
        [self timer];
        return NO;
    }else if([ request.URL.absoluteString rangeOfString: @"pay?rn="].location != NSNotFound){
        NSURL *url = request.URL;
//        request.URL.absoluteString =
//        @"订单号";https://mallpv.companycn.net/integral_mall/global_sale/pay_newly?rn=
        //orderId =
        NSRange range = [request.URL.absoluteString rangeOfString:@"?rn="];
        orderId = [request.URL.absoluteString substringFromIndex:(range.location + 4 )];
        if([orderId rangeOfString:@"&"].location != NSNotFound){
            orderId = [orderId substringToIndex:[orderId rangeOfString:@"&"].location];
        }
        NSLog(@"%@",request.URL.absoluteString);
        NSString *newUrlString =  [request.URL.absoluteString stringByReplacingOccurrencesOfString:@"/pay?" withString:@"/pay_newly2?"] ;
       
        url = [NSURL URLWithString:newUrlString];
        [webView loadRequest:[NSURLRequest requestWithURL:url]];
            return NO;
            }

    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
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
