//
//  FloorViewController.m
//  kaidexing
//
//  Created by dwolf on 16/5/18.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "OrderWebViewController.h"
#import "LoginViewController.h"
#import "MyVoucherViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

#import "WXApi.h"
#import "WXApiResponseHandler.h"
#import "WXApiRequestHandler.h"
#import "ConfirmPaymentView.h"
#import <AlipaySDK/AlipaySDK.h>
#import "AliManager.h"
#import "PhoneInputViewController.h"
#import <Pingpp/Pingpp.h>
#import "SKCommonButton.h"

#import <UShareUI/UShareUI.h>

@interface OrderWebViewController ()<UIWebViewDelegate,UIScrollViewDelegate>

@end

@implementation OrderWebViewController{
@private
    
    NSTimer* myTimer;
    int loginCount;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie* cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }

    self.title = @"";
    
   
    [self loadWebView];
}

-(void)loadWebView
{
    
    [self loadHtmlByPath:_path];
    NSString* domian = [@"." stringByAppendingString:[Global sharedClient].API_DOMAIN ];
    NSMutableArray *cookies = [[NSMutableArray alloc] init];
    NSString *strUrl = [_path stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSURL *url=[NSURL URLWithString:strUrl];
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
        
        NSHTTPCookie *cookie1 =
        [[NSHTTPCookie alloc] initWithProperties:properties1];
        [cookies addObject:cookie1];
    }
    
    if(![Util isNull:[Global sharedClient].markCookies]){
        NSDictionary *properties2 = [[NSMutableDictionary alloc] init];
        [properties2 setValue:[Global sharedClient].markCookies forKey:NSHTTPCookieValue];
        [properties2 setValue:@"9536D5BEA279153E3BB79FE5EFD6B3EA" forKey:NSHTTPCookieName];
        [properties2 setValue:domian forKey:NSHTTPCookieDomain];
        [properties2 setValue:[NSDate dateWithTimeIntervalSinceNow:60*60] forKey:NSHTTPCookieExpires];
        [properties2 setValue:@"/" forKey:NSHTTPCookiePath];
        
        NSHTTPCookie *cookie2 =
        [[NSHTTPCookie alloc] initWithProperties:properties2];
        [cookies addObject:cookie2];
    }
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    
    if(cookies.count > 0){
        [[NSHTTPCookieStorage sharedHTTPCookieStorage]setCookies:cookies forURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@://%@",[Global sharedClient].HTTP_S,domian]]  mainDocumentURL:nil];
    }
    self.webView.scrollView.delegate=self;
    self.webView.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag; // 当拖动时移除键盘
    [self.webView loadRequest:request];
    self.webView.delegate = self;
    
    if ([self.delegate.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.delegate.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}








-(UIView*)viewForZoomingInScrollView:(UIScrollView*)scrollView{
    return nil;
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"web加载开始");
    self.webView.hidden = YES;
    [self displayLoading];
}



- (void)webViewDidFinishLoad:(UIWebView *)web{
    [self removeLoading];
    NSLog(@"web加载完成");
    myTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timer) userInfo:nil repeats:NO];
    
}

-(void) timer{
    self.webView.hidden = NO;
    NSString *delete=[NSString stringWithFormat:@"var nava = document.getElementById('nav');"
                      "nava.parentNode.removeChild(nava)"];
    [self.webView stringByEvaluatingJavaScriptFromString:delete];
    delete=[NSString stringWithFormat:@"var header = document.getElementById('header');"
            "header.parentNode.removeChild(header);$('#mapContainer').css('padding','0');$('.mapField').css('top',0);"];
    [self.webView stringByEvaluatingJavaScriptFromString:delete];
    self.navigationBarTitleLabel.text = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    NSString *goFun=[NSString stringWithFormat:@"var history = new Object(); history.go = function(page){goBack();}"];
    //    // onDraw(cardId, timestamp, hidsignature);
    [self.webView stringByEvaluatingJavaScriptFromString:goFun];
    
    //    myTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timer2) userInfo:nil repeats:NO];
}
-(void) timer2{
    self.webView.hidden = NO;
    NSString *delete=[NSString stringWithFormat:@"var nava = document.getElementById('nav');"
                      "nava.parentNode.removeChild(nava)"];
    [self.webView stringByEvaluatingJavaScriptFromString:delete];
    delete=[NSString stringWithFormat:@"var header = document.getElementById('header');"
            "header.parentNode.removeChild(header);$('#mapContainer').css('padding','0');$('.mapField').css('top',0);"];
    [self.webView stringByEvaluatingJavaScriptFromString:delete];
    self.navigationBarTitleLabel.text = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

-(void) backBtnOnClicked:(id)sender{
    if([self.webView canGoBack]){
        [self.webView goBack];
    }else{
        [super backBtnOnClicked:nil];
    }
    
    
}




- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"web加载准备开始");
    // 说明协议头是ios
    _path = request.URL.absoluteString;
    
   
    if([ request.URL.absoluteString rangeOfString: @"quan/coupon_list" ].location != NSNotFound){
        MyVoucherViewController* vc = [[MyVoucherViewController alloc] init];
       [self.delegate.navigationController pushViewController:vc animated:YES];
        [self timer];
        return NO;
        
    }
    
    return YES;
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

