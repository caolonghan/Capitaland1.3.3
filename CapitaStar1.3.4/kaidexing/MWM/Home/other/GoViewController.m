//
//  FloorViewController.m
//  kaidexing
//
//  Created by dwolf on 16/5/18.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "GoViewController.h"
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
#import "RootViewController.h"
#import <UShareUI/UShareUI.h>

@interface GoViewController ()<UIWebViewDelegate,UIScrollViewDelegate>

@end

@implementation GoViewController{
    @private
    int loginCount;
    NSTimer* myTimer;
    NSString* orderId;
    UIView  *confirmPayView;
    NSDictionary *orderDic;
    UIButton    *shareBtn;
    UIView      *_shareView;
    UIView *menuview;
    UIView *_blankView;
  
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    loginCount= 0;
   
    self.title = @"";
    
//分享
    if ([_path rangeOfString:@"is_share=1"].location != NSNotFound) {
        [self createNavUMShare];
    }
    if ([_path rangeOfString:@"is_adv=1"].location!=NSNotFound) {
        [Global sharedClient].advUrlStr = _path;
    }
    
    [self loadHtmlByPath:_path];
    [self createWebView];
    
}
- (void)addCookies
{
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie* cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
    NSString* domian = [@"." stringByAppendingString:[Global sharedClient].API_DOMAIN ];
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
        
    }
    else{
        if(loginCount > 0){
            [self.delegate.navigationController popViewControllerAnimated:YES];
            return;
        }else{
            loginCount = 0;
        }
    }
    
    if ([_path rangeOfString:@"is_adv=1"].location!=NSNotFound) {
        NSLog(@"这是广告页");//_path=nil也成立
    }
    else{
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
    }
    
    if(cookies.count > 0){
        [[NSHTTPCookieStorage sharedHTTPCookieStorage]setCookies:cookies forURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@://%@",[Global sharedClient].HTTP_S,domian]]  mainDocumentURL:nil];
        
    }
}
- (void)createWebView
{
    NSString *strUrl = [_path stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSURL *url=[NSURL URLWithString:strUrl];
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    self.webView.scrollView.delegate=self;
    self.webView.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag; // 当拖动时移除键盘
   
    
    [self.webView loadRequest:request];
    self.webView.delegate = self;
    
    if ([self.delegate.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.delegate.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}
#pragma mark  ------  顶部分享  ------
-(void)createNavUMShare{
    shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setFrame:CGRectMake(0, 0, 44, 44)];
    [shareBtn setImage:[UIImage imageNamed:@"StoreDetailsShare"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.rigthBarItemView addSubview:shareBtn];
    self.rigthBarItemView.hidden = FALSE;
}

- (void)showMenu
{
    
    _shareView = [[UIView alloc]initWithFrame:CGRectMake(0, WIN_HEIGHT-170-BAR_HEIGHT, WIN_WIDTH, 170)];
    _shareView.backgroundColor = [UIColor whiteColor
                                  ];
    SKCommonButton *friends = [[SKCommonButton alloc]initWithButtonFrame:CGRectMake(0, 0,120,120) andImageFrame:CGRectMake(25, 10, 50,60) andTitleFrame:CGRectMake(0, 50, 100, 60)];
    
    SKCommonButton  *friendsGroup = [[SKCommonButton alloc]initWithButtonFrame:CGRectMake(120, 0, 120, 120) andImageFrame:CGRectMake(25, 10, 50, 60) andTitleFrame:CGRectMake(0, 50, 100, 60)];
    
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 120, WIN_WIDTH, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    lineView.alpha = 0.5;
    UIButton *cancle = [UIButton buttonWithType:UIButtonTypeCustom];
    cancle.frame = CGRectMake(0, 121, WIN_WIDTH, 49);
    
    
    [friends setImage:[UIImage imageNamed:@"wechat_img"] forState:UIControlStateNormal];
    [friendsGroup setImage:[UIImage imageNamed:@"friend_img"] forState:UIControlStateNormal];
    [friends setTitle:@"分享好友" forState:UIControlStateNormal];
    friends.tag = 77;
    [friends addTarget:self action:@selector(shareTouch:) forControlEvents:UIControlEventTouchUpInside];
    [friendsGroup addTarget:self action:@selector(shareTouch:) forControlEvents:UIControlEventTouchUpInside];
    [friendsGroup setTitle:@"分享朋友圈" forState:UIControlStateNormal];
    [cancle setTitle:@"取消" forState:UIControlStateNormal];
    [cancle addTarget:self action:@selector(cancle:) forControlEvents:UIControlEventTouchUpInside];
    cancle.backgroundColor = [UIColor whiteColor];
    [cancle setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [friends setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, friends.titleLabel.frame.size.width)];
    [friends setTitleEdgeInsets:UIEdgeInsetsMake(friends.frame.size.height, friends.frame.size.width, 0, 0)];
    [friendsGroup setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, friendsGroup.titleLabel.frame.size.width)];
    [friendsGroup setTitleEdgeInsets:UIEdgeInsetsMake(friendsGroup.frame.size.height, friendsGroup.frame.size.width, 0, 0)];
    
    [self.view addSubview:_shareView];
    [_shareView addSubview:friends];
    [_shareView addSubview:friendsGroup];
    [_shareView addSubview:lineView];
    [_shareView addSubview:cancle];
    
    _blankView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, WIN_HEIGHT-170-BAR_HEIGHT)];
    _blankView.backgroundColor = [UIColor blackColor];
    _blankView.alpha = 0.5;
    [self.view addSubview:_blankView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
    [_blankView addGestureRecognizer:tap];
    [tap addTarget:self action:@selector(shareViewHidden)];
    

}
- (void)shareViewHidden{
    [_shareView removeFromSuperview];
    [_blankView removeFromSuperview];
}
- (void)cancle:(UIButton *)sender
{
    [_shareView removeFromSuperview];
    [_blankView removeFromSuperview];
}


-(void)shareTouch:(UIButton*)sender{
    [_blankView removeFromSuperview];
    NSString *share_type ;
    UMSocialPlatformType type;
    if (sender.tag == 77) {
        type = UMSocialPlatformType_WechatSession;
        share_type = @"0";
    }else{
        type = UMSocialPlatformType_WechatTimeLine;
        share_type = @"1";
    }
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
    //UMShareWebpageObject *shareObject = [[UMShareWebpageObject alloc]init];
    
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.navigationBarTitleLabel.text descr:@"" thumImage:nil];
    //设置网页地址
    shareObject.webpageUrl =[_path stringByReplacingOccurrencesOfString:@" " withString:@""];
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    [[UMSocialManager defaultManager] shareToPlatform:type messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }
        else{
            
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
           }
     else{
                UMSocialLogInfo(@"response data is %@",data);
            }
            [_shareView removeFromSuperview];
        }
   
    }];
    
    [_shareView removeFromSuperview];
}

-(UIView*)viewForZoomingInScrollView:(UIScrollView*)scrollView{
    return nil;
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self addCookies];
    [self.webView reload];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"web加载开始");
    //self.webView.hidden = YES;
    //[self displayLoading];
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
    
    context[@"goBack"] = ^() {
        [self backBtnOnClicked:nil];
    };
    context.exceptionHandler = ^(JSContext *con, JSValue *exception) {
        NSLog(@"%@", exception);
        con.exception = exception;
    };
//    context[@"SureOrderSuc"] = ^() {
//
//        [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"integralmall" tp:@"alipaycashgoods"] parameters:[[NSDictionary alloc]initWithObjectsAndKeys:orderId,@"order_id",nil ] target:self success:^(NSDictionary *dic){dispatch_async(dispatch_get_main_queue(), ^{
//            NSLog(@"%@",dic);
//            orderDic = dic;
//            [confirmPayView removeFromSuperview];
//            confirmPayView =[[UIView alloc]initWithFrame:self.view.bounds];
//            confirmPayView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
//            ConfirmPaymentView *conView=[[ConfirmPaymentView alloc]initWithFrame:CGRectMake((WIN_WIDTH-M_WIDTH(250))/2,WIN_HEIGHT/4,M_WIDTH(250),M_WIDTH(210)) data:dic];
//            conView.backgroundColor=[UIColor whiteColor];
//            conView.cDelegate=self;
//            conView.layer.masksToBounds=YES;
//            conView.layer.cornerRadius=8;
//            [confirmPayView addSubview:conView];
//            [self.view addSubview:confirmPayView];
//
//        });
//        }failue:^(NSDictionary *dic){
//            NSLog(@"%@",dic);
//        }];
//        //        [self showMsg: orderId];
//    };
//
   
    context[@"wap_pay"] = ^(NSString* method) {
        [SVProgressHUD show];
        NSLog(@"%@",method);
        NSString *hostStr;
        NSDictionary *params = [NSDictionary new];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
        NSMutableSet* acctSet = [[NSMutableSet alloc] initWithSet:[HttpClient sharedClient].responseSerializer.acceptableContentTypes];
        [acctSet addObject:@"text/html"];
        manager.responseSerializer.acceptableContentTypes = acctSet;
        
        if([self.type isEqualToString:@"9"]){
            hostStr = [NSString stringWithFormat:@"%@://%@/pingplusplus/ParkCreateOrder",[Global sharedClient].HTTP_S,[Global sharedClient].Shopping_Mall];
            params = [self dictionaryWithJsonString:method];
            [params setValue:@"ios" forKey:@"userAgent"];
           
        
        }else{
            hostStr =[NSString stringWithFormat:@"%@://%@/pingplusplus/CreateOrders",[Global sharedClient].HTTP_S,[Global sharedClient].Shopping_Mall];
            params =[[NSDictionary alloc]initWithObjectsAndKeys:orderId,@"order_id",@"global",@"type",method,@"channel",@"ios",@"userAgent",nil ];
        }
        __block UIWebView *weakWeb = self.webView;
        [manager POST:hostStr parameters:params progress:nil
        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *dic = responseObject;
            {dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                NSLog(@"%@",dic);
                orderDic = dic;
                
                [Pingpp createPayment:dic
                       viewController:self
                         appURLScheme:@"capitalandApp"
                       withCompletion:^(NSString *result, PingppError *error) {
                           if ([result isEqualToString:@"success"]) {
                             
                               if ([_type isEqualToString:@"9"]) {
                                   
                               NSString  *path=[NSString stringWithFormat:@"%@/car_park_normal/pay_success?payable=0&car_no=%@&ping_orderid=%@&fee=%@&integral=%@&reduce=%@&couponreduce=%@",[Global sharedClient].HTTP_VIP,orderDic[@"carNo"],orderDic[@"id"],params[@"feeAmount"],params[@"integralToReduce"],params[@"actReduce"],params[@"couponAmount"]];
                                   [weakWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:path]]];
                                   
                               }else{
                                 GoViewController *vc = [[GoViewController alloc]init];
                                   vc.path=[NSString stringWithFormat:@"%@://%@/integral_mall/global_sale/pay_success?payable=0&rn=%@",[Global sharedClient].HTTP_S,[Global sharedClient].Shopping_Mall,orderId]; NSLog(@"======%@",vc.path);
                                   [self.delegate.navigationController pushViewController:vc animated:YES];}
                              
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
    context[@"goUserCenter"] = ^(){
        dispatch_async(dispatch_get_main_queue(), ^{
        RootViewController *root = [[RootViewController alloc]init];
        root.haveRemotemsg =YES;
        [self.delegate.navigationController pushViewController:root animated:YES];
        });
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
        NSLog(@"======%@",vc.path);
        [self.delegate.navigationController pushViewController:vc animated:YES];
    }
}


- (void)webViewDidFinishLoad:(UIWebView *)web{
    [self removeLoading];
     NSLog(@"web加载完成");
     if ([web.request.URL.absoluteString rangeOfString:@"is_adv=1"].location !=NSNotFound){
        [self timer2];
        return ;
    }
    [self timer];
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
   
    [self.webView stringByEvaluatingJavaScriptFromString:goFun];
    [self setupJsContent];

}
-(void) timer2{
    self.webView.hidden = NO;
    NSString *delete=[NSString stringWithFormat:@"var nava = document.getElementById('nav');"
                      "nava.parentNode.removeChild(nava)"];
    [self.webView stringByEvaluatingJavaScriptFromString:delete];
//    delete=[NSString stringWithFormat:@"var header = document.getElementById('header');"
//            "header.parentNode.removeChild(header);$('#mapContainer').css('padding','0');$('.mapField').css('top',0);"];
//    [self.webView stringByEvaluatingJavaScriptFromString:delete];
    self.navigationBarTitleLabel.text = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    NSString *goFun=[NSString stringWithFormat:@"var history = new Object(); history.go = function(page){goBack();}"];
    
    [self.webView stringByEvaluatingJavaScriptFromString:goFun];
    [self setupJsContent];
}

-(void) backBtnOnClicked:(id)sender{
    
    if (![_path isEqualToString:PROTOCOLURL]) {
        [Global sharedClient].advUrlStr = nil;
    }
   
    if([self.webView canGoBack]){
        [self.webView goBack];
    }else{
        //[super backBtnOnClicked:nil];
        if ([Util isNull:[Global sharedClient].member_id]){
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            if ([_path rangeOfString: @"is_adv=1"].location != NSNotFound) {
                
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            else{
                [self.navigationController popViewControllerAnimated:YES];
            }
            }
    }
    
    
}


- (void)addCardToWXCardPackage:(NSString*) cardId time:(NSString*)time sing:(NSString*) sign {
    WXCardItem* cardItem = [[WXCardItem alloc] init];
    
    cardItem.cardId = @"502020";
    cardItem.extMsg = [NSString stringWithFormat:@"{\"code\": \"\", \"openid\": \"\", \"timestamp\": \"%@\", \"signature\":\"%@\"}",time,sign];
    [WXApiRequestHandler addCardsToCardPackage:[NSArray arrayWithObject:cardItem]];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"web加载准备开始");
    // 说明协议头是ios
    _path = request.URL.absoluteString;

    if ([ request.URL.absoluteString rangeOfString: @"Login" ].location != NSNotFound) {
       // loginCount ++;
//        if(loginCount > 1){
//            [self.delegate.navigationController popViewControllerAnimated:YES];
//            return NO;
//        }
//        PhoneInputViewController* vc = [[PhoneInputViewController alloc] init];
//        vc.advStr = _path;

        LoginViewController *vc = [[LoginViewController alloc]init];
         vc.advStr = _path;
        [self.delegate.navigationController pushViewController:vc animated:YES];
        [self timer];
        _path=nil;
        return NO;
    }else if([ request.URL.absoluteString rangeOfString: @"quan/coupon_list" ].location != NSNotFound){
        MyVoucherViewController* vc = [[MyVoucherViewController alloc] init];
            [self.delegate.navigationController pushViewController:vc animated:YES];
            [self timer];
        _path=nil;
        return NO;

    }else if([request.URL.absoluteString rangeOfString: @"pay?rn="].location != NSNotFound){
        NSURL *url = request.URL;
        //        request.URL.absoluteString =
        //        @"订单号";http://mallpv.companycn.net/integral_mall/global_sale/pay_newly?rn=
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
    else if([request.URL.absoluteString rangeOfString: @"/pay?car_no"].location != NSNotFound){
        NSString *newUrlString =  [request.URL.absoluteString stringByReplacingOccurrencesOfString:@"/pay?car_no" withString:@"/app_pay?car_no"] ;
        NSLog(@"%@",newUrlString);
        NSURL *url = [NSURL URLWithString:newUrlString];
        [webView loadRequest:[NSURLRequest requestWithURL:url]];
        return NO;
    }
//    else if([request.URL.absoluteString rangeOfString: @"merchant/shop_detail"].location != NSNotFound){
//        NSDictionary* dic = [Util getRequestUrlParam:request.URL.absoluteString];
//        if([Util isNull:dic[@"id"]]){
//            return NO;
//        }else{
//            self
//        }
//    [self.navigationController popViewControllerAnimated:YES];
//    }

    return YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [menuview removeFromSuperview];
}
//字典转json字符串
-(NSString *)convertToJsonData:(NSDictionary *)dict
{
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
    
}
//json字符串转字典
-(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
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
