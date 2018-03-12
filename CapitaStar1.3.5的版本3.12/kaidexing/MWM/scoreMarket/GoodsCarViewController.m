//
//  GoodsDetailViewController.m
//  kaidexing
//
//  Created by dwolf on 16/5/13.
//  Copyright (c) 2016年 dwolf. All rights reserved.
//

#import "GoodsCarViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "LoginViewController.h"
#import "GoodsRootController.h"
#import "PhoneInputViewController.h"
#import <Pingpp/Pingpp.h>
#import "GoViewController.h"

@interface GoodsCarViewController ()

@end

@implementation GoodsCarViewController{
    @private
    NSTimer* myTimer;
    int loginCount;
    NSDictionary *orderDic;
    NSString* orderId;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _topHeight.constant = NAV_HEIGHT;
    self.leftBarItemView.hidden=YES;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    for (NSHTTPCookie* cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
    _path = [NSString stringWithFormat:@"%@://%@/integral_mall/integral_cart",[Global sharedClient].HTTP_S, [Global sharedClient].Shopping_Mall];

    
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString* domian = [@"." stringByAppendingString:[Global sharedClient].API_DOMAIN ];
    NSMutableArray *cookies = [[NSMutableArray alloc] init];
    NSURL *url=[NSURL URLWithString:_path];
    if(![Util isNull:[Global sharedClient].userCookies]){
        
        NSDictionary *properties = [[NSMutableDictionary alloc] init];
        [properties setValue:[Global sharedClient].userCookies forKey:NSHTTPCookieValue];
        [properties setValue:@"0799C3B5EA3898E6E72A08A5557D16EA03D5E30B7DF6FECD" forKey:NSHTTPCookieName];
        [properties setValue:domian forKey:NSHTTPCookieDomain];
        [properties setValue:[NSDate dateWithTimeIntervalSinceNow:60*60] forKey:NSHTTPCookieExpires];
        [properties setValue:@"/" forKey:NSHTTPCookiePath];
        
        NSHTTPCookie *cookie = [[NSHTTPCookie alloc] initWithProperties:properties];
        [cookies addObject:cookie];
    }else{
        if(loginCount > 0){
            [self.delegate.navigationController popViewControllerAnimated:YES];
            return;
        }else{
            loginCount = 0;
        }
    }
    if(![Util isNull:[Global sharedClient].markCookies]){
        NSDictionary *properties1 = [[NSMutableDictionary alloc] init];
        [properties1 setValue:[Global sharedClient].markCookies forKey:NSHTTPCookieValue];
        [properties1 setValue:@"4CA043AA7659441F0468007AD296A053" forKey:NSHTTPCookieName];
        [properties1 setValue:domian forKey:NSHTTPCookieDomain];
        [properties1 setValue:[NSDate dateWithTimeIntervalSinceNow:60*60] forKey:NSHTTPCookieExpires];
        [properties1 setValue:@"/" forKey:NSHTTPCookiePath];
        
        NSHTTPCookie *cookie1 = [[NSHTTPCookie alloc] initWithProperties:properties1];
        [cookies addObject:cookie1];
    }
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    
    if(cookies.count > 0){
       [[NSHTTPCookieStorage sharedHTTPCookieStorage]setCookies:cookies forURL:url mainDocumentURL:nil];
    }
    
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
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        
    };
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

- (void)webViewDidStartLoad:(UIWebView *)webView {
    self.webView.hidden = YES;
    [self displayLoading];
}

- (void)webViewDidFinishLoad:(UIWebView *)web{
    myTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timer) userInfo:nil repeats:NO];
    NSString *delete=[NSString stringWithFormat:@"var nava = document.getElementById('nav');"
                      "nava.parentNode.removeChild(nava)"];
    [self.webView stringByEvaluatingJavaScriptFromString:delete];
    delete=[NSString stringWithFormat:@"var header = document.getElementById('header');"
            "header.parentNode.removeChild(header)"];
    [self.webView stringByEvaluatingJavaScriptFromString:delete];
    self.navigationBarTitleLabel.text = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    NSString *goFun=[NSString stringWithFormat:@"history.go = function (i){onBackT(i);}"];
    [self.webView stringByEvaluatingJavaScriptFromString:goFun];
    [self setupJsContent];
    [self removeLoading];
}

-(void) timer{
    self.webView.hidden = NO;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    // 说明协议头是ios
    if ([ request.URL.absoluteString rangeOfString: @"Login" ].location != NSNotFound) {
        
        GoViewController* vc = [[GoViewController alloc] init];
        vc.advStr =_path;
        [self.delegate.navigationController pushViewController:vc animated:YES];
        [self timer];
        return NO;
    }else if([ request.URL.absoluteString rangeOfString: @"integral_mall/integral_index"].location != NSNotFound){
        GoodsRootController* rootVc = (GoodsRootController*) self.delegate;
        [rootVc.tabBar showIndex:1];
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
    // Dispose of any resources that can be recreated.
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
  //  self.navigationController.navigationBarHidden = FALSE;
    
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
