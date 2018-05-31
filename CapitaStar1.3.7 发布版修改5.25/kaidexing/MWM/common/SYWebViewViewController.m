//
//  SYWebViewViewController.m
//  ShouYi
//
//  Created by Hwang Kunee on 14-2-21.
//  Copyright (c) 2014年 Hwang Kunee. All rights reserved.
//

#import "SYWebViewViewController.h"
#import <Foundation/NSURLCache.h>

@interface SYWebViewViewController ()

@end

@implementation SYWebViewViewController{
    @private
    WebViewJavascriptBridge* bridge;
    UIButton* rightMenButton;
    
}
@synthesize webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 获取 iOS 默认的 UserAgent，可以很巧妙地创建一个空的UIWebView来获取：
   // NSString *userAgent = [[[UIWebView alloc] init] stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    // 获取App名称，我的App有本地化支持，所以是如下的写法
   // NSString *appName = NSLocalizedStringFromTable(@"CFBundleDisplayName", @"InfoPlist", nil);
    // 如果不需要本地化的App名称，可以使用下面这句
   //  NSString * appName = [[NSBundle mainBundle] infoDictionary][@"CFBundleDisplayName"];
    //NSString *version = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    //NSString *customUserAgent = [userAgent stringByAppendingFormat:@" ios%@", version];
    //[[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent":customUserAgent}];
    
    if(_needShare){
        [self createRightMenuButton];
    }
    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_FRAME.size.width, SCREEN_FRAME.size.height - NAV_HEIGHT)];
    webView.delegate = self;
    [self.view addSubview:webView];

    bridge = [WebViewJavascriptBridge bridgeForWebView:webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        

    }];
    
    
    if(_needSizeFilt){
        [webView setScalesPageToFit:YES];
    }
    
    if(_webTitle){
        self.title = _webTitle;
    }else{
        self.title = APP_NAME;
    }
    
    
    
    NSLog(@"webview url:%@",_url);
    
    if(_url){
        [webView loadRequest:[[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:_url]]];
    }else{
        [webView loadHTMLString:_content baseURL:[[NSURL alloc] initWithString:IMG_HOST]];
    }
    

    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
    NSString* data = request.URL.absoluteString;
    if([data rangeOfString:@"invoke"].location != NSNotFound){
        
        NSArray* names = [data componentsSeparatedByString:@":"];
        
        NSString* loginname  = [names objectAtIndex:2];
        [Global sharedClient].action = ACT_REG;
        [Global sharedClient].syncObj = loginname;
        [self.delegate.navigationController popViewControllerAnimated:YES];
    }
    return YES;
}

//设置右侧菜单按钮
-(void) createRightMenuButton{
    
    rightMenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightMenButton setImage:[UIImage imageNamed:@"icon_share"] forState:UIControlStateNormal];
    
    [rightMenButton setFrame:CGRectMake(0,0, 18, 20)];
    rightMenButton.tag = NAVIGATOR_BAR_RIGHT_MENU_BTN;
    
    [rightMenButton addTarget:self action:@selector(onShareTap:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [UIUtil makeBarButtonItem:rightMenButton];
}
//
//-(void) onShareTap:(id)sender{
//    
//    
//    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
//    [UMSocialData defaultData].extConfig.wechatSessionData.url = _url;
//    [UMSocialData defaultData].extConfig.wechatTimelineData.url = _url;
//    
//    [UMSocialData defaultData].extConfig.title = APP_NAME;
//    
//    UIImage* img = nil;
//    if(!img){
//        img = [UIImage imageNamed:@"icon120"];
//    }
//    
//    [UMSocialSnsService presentSnsIconSheetView:self
//                                         appKey:UMENG_APPKEY
//                                      shareText:(_webTitle == nil ? APP_NAME: _webTitle)
//                                     shareImage:img
//                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToSms,UMShareToEmail,nil]
//                                       delegate:self];
//    
//
//}
//
//-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
//{
//}
//
//-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData
//{
//    
//    if ([platformName isEqualToString:UMShareToSina]) {
//        socialData.shareText = [NSString stringWithFormat:@"%@ %@",(_webTitle == nil ? APP_NAME: _webTitle),_url];
//    }else if([platformName isEqualToString:UMShareToSms]){
//        socialData.shareText = [NSString stringWithFormat:@"%@ %@",(_webTitle == nil ? APP_NAME: _webTitle),_url];
//    }else if([platformName isEqualToString:UMShareToEmail]){
//        socialData.shareText = [NSString stringWithFormat:@"%@ %@",(_webTitle == nil ? APP_NAME: _webTitle),_url];
//    }
//}





-(void)loadUrl:(NSString*) url{
    
    [webView loadRequest:[[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:url]]];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [SVProgressHUD showWithStatus:@"精彩加载中"];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    NSLog(@"UserAgent = %@", [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"]);
    [SVProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
