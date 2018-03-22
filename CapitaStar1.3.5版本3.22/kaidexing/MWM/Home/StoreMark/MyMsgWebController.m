//
//  MyMsgWebController.m
//  kaidexing
//
//  Created by 朱巩拓 on 2016/12/19.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "MyMsgWebController.h"
#import "LoginViewController.h"
#import "MyVoucherViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

#import "WXApi.h"
#import "WXApiResponseHandler.h"
#import "WXApiRequestHandler.h"
#import "PhoneInputViewController.h"


@interface MyMsgWebController ()<UIWebViewDelegate>
@property (strong,nonatomic)UIWebView   *webView;
@end

@implementation MyMsgWebController{
@private
    int loginCount;
    NSTimer* myTimer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.leftBarItemView.hidden=YES;
    self.view.backgroundColor=[UIColor whiteColor];
    _webView = [[UIWebView alloc] init];
    _webView.frame = CGRectMake(0, NAV_HEIGHT, SCREEN_FRAME.size.width, SCREEN_FRAME.size.height - NAV_HEIGHT-BAR_HEIGHT);
    [self.view addSubview:_webView];
    _webView.scrollView.bounces=NO;
    self.webView.scrollView.bouncesZoom=NO;
    self.webView.scalesPageToFit = YES;
    self.webView.backgroundColor=[UIColor whiteColor];
    _webView.delegate = self;
    if (IS_IOS_7) {
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
    loginCount= 0;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie* cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
    self.title = @"";
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString* domian = [@"." stringByAppendingString:[Global sharedClient].API_DOMAIN];
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
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    
    if(cookies.count > 0){
        [[NSHTTPCookieStorage sharedHTTPCookieStorage]setCookies:cookies forURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@://%@",[Global sharedClient].HTTP_S,domian]]  mainDocumentURL:nil];
    }
    
    
    [self.webView loadRequest:request];
    self.webView.delegate = self;
    
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    self.webView.hidden = YES;
    [self displayLoading];
}

- (void)setupJsContent
{
    JSContext *context=[self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    context[@"onDraw"] = ^() {
        NSArray *args = [JSContext currentArguments];
        for (id obj in args) {
            NSLog(@"%@",obj);
        }
        NSArray* arr = @[@"502020" ,[args[1] toString],@"5d79c61cf65b8de7a1101468e14a16a3"];
        
        arr = [arr sortedArrayUsingSelector:@selector(compare:)];
        NSLog(@"%@",[arr componentsJoinedByString:@""]);
        NSLog(@"%@",[Util getSha1String:[arr componentsJoinedByString:@""]]);
        [self addCardToWXCardPackage:[args[0] toString]  time:[args[1] toString] sing:[Util getSha1String:[arr componentsJoinedByString:@""]]];
    };
    context.exceptionHandler = ^(JSContext *con, JSValue *exception) {
        NSLog(@"%@", exception);
        con.exception = exception;
    };
    
}

- (void)webViewDidFinishLoad:(UIWebView *)web{
    [self removeLoading];
    myTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timer) userInfo:nil repeats:NO];
    NSString *delete=[NSString stringWithFormat:@"var nava = document.getElementById('nav');"
                      "nava.parentNode.removeChild(nava)"];
    [self.webView stringByEvaluatingJavaScriptFromString:delete];
    delete=[NSString stringWithFormat:@"var header = document.getElementById('header');"
            "header.parentNode.removeChild(header);$('#mapContainer').css('padding','0');$('.mapField').css('top',0);"];
    [self.webView stringByEvaluatingJavaScriptFromString:delete];
    self.navigationBarTitleLabel.text = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

-(void) timer{
    self.webView.hidden = NO;
}

-(void) backBtnOnClicked:(id)sender{
    if([self.webView canGoBack]){
        [self.webView goBack];
    }else{
        [super backBtnOnClicked:nil];
    }
}

- (void)addCardToWXCardPackage:(NSString*) cardId time:(NSString*)time sing:(NSString*) sign {
    WXCardItem* cardItem = [[WXCardItem alloc] init];
    cardItem.cardId = @"502020";
    cardItem.extMsg = [NSString stringWithFormat:@"{\"code\": \"\", \"openid\": \"\", \"timestamp\": \"%@\", \"signature\":\"%@\"}",time,sign];
    [WXApiRequestHandler addCardsToCardPackage:[NSArray arrayWithObject:cardItem]];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    // 说明协议头是ios
    if ([ request.URL.absoluteString rangeOfString: @"Login" ].location != NSNotFound) {
        loginCount ++;
        if(loginCount > 1){
            [self.delegate.navigationController popViewControllerAnimated:YES];
            return NO;
        }
        PhoneInputViewController* vc = [[PhoneInputViewController alloc] init];
        [self.delegate.navigationController pushViewController:vc animated:YES];
        [self timer];
        return NO;
    }else if([ request.URL.absoluteString rangeOfString: @"quan/coupon_list" ].location != NSNotFound){
        MyVoucherViewController* vc = [[MyVoucherViewController alloc] init];
        [self.delegate.navigationController pushViewController:vc animated:YES];
        [self timer];
        return NO;
        
    }
    
    return YES;
}

-(void) loadHtmlByPath:(NSString*) path{
    [self displayLoading];
    NSURL *url = [NSURL URLWithString:path];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
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
