//
//  ARWebViewController.m
//  ARRisoDemo
//
//  Created by Iverson Luo on 2017/6/5.
//  Copyright © 2017年 VisionStar Information Technology (Shanghai) Co., Ltd. All rights reserved.
//

#import "ARWebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <UMSocialCore/UMSocialCore.h>
#import "SKCommonButton.h"
@interface ARWebViewController ()<UIWebViewDelegate>
@property(nonatomic,strong)UIView *shareView;
@property(nonatomic, strong) UIWebView* webView;
@property (nonatomic,assign)NSInteger result;
@property (nonatomic,strong)UIButton *backButton;
@property (nonatomic,strong)NSString *shareUrl;
@property (nonatomic,strong)UIView *blankView;//透明遮挡
@end

@implementation ARWebViewController

- (void)back {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCookies];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:YES animated:nil];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backButton setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
   _backButton.frame = CGRectMake(10, STATUS_BAR_HEIGHT+5, 50, 50);
    _backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    [self.view addSubview:_backButton];
    
    
    self.webView = [[UIWebView alloc] init];
    self.webView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.webView.delegate = self;
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.opaque = NO;
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    
//    self.url = @"http://mall.companycn.net/SpriteActivity/winning";
    NSURL *url = [NSURL URLWithString:self.url];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
    [self.view bringSubviewToFront:_backButton];
}

- (void)setCookies
{
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
    
    if(cookies.count > 0){
        [[NSHTTPCookieStorage sharedHTTPCookieStorage]setCookies:cookies forURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@://%@",[Global sharedClient].HTTP_S,domian]]  mainDocumentURL:nil];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    JSContext *context=[self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"getShareButton"] = ^(NSString *str){
        _shareUrl = str;
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
//    context[@"getShareButton"] = ^() {
//        [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"ar_spirit_activity" tp:@"getShareButton"] parameters:nil target:self success:^(NSDictionary *dic) {
//            NSLog(@"%@",dic );
//        } failue:^(NSDictionary *dic) {
//            NSLog(@"%@",dic);
//        }];
        [self.view addSubview:_shareView];
        [_shareView addSubview:friends];
        [_shareView addSubview:friendsGroup];
        [_shareView addSubview:lineView];
        [_shareView addSubview:cancle];
        
        _blankView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, WIN_HEIGHT-170-BAR_HEIGHT)];
        [self.view addSubview:_blankView];
        _blankView.backgroundColor = [UIColor blackColor];
        _blankView.alpha = 0.5;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
        [_blankView addGestureRecognizer:tap];
        [tap addTarget:self action:@selector(shareViewHidden)];
        
    
    };
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
    UIImage *image = [UIImage imageNamed:@"jingling.png"];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"我刚刚在凯德商场邂逅了梦幻的圣诞精灵，还获得了免费赢取Iphone X的机会，你也赶快来吧？" descr:@"" thumImage:image];
    //设置网页地址
    shareObject.webpageUrl =_shareUrl;
    
    // @"weixin://wx281a422ccc3e8054";//
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    [[UMSocialManager defaultManager] shareToPlatform:type messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            
            
           
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
                NSString *mall_id = [Global sharedClient].markID;
                NSString *member_id = [Global sharedClient].member_id;
                //NSDictionary *parameters =@{mall_id:@"mall_id",@"C0926499561F5BC1":@"member_id",share_type:@"share_type",self.url:@"share_link",@"AR扫一扫抽奖":@"share_title",@"AR扫一扫抽奖":@"share_content"};
                NSDictionary *parameters = @{@"mall_id":mall_id,@"member_id":member_id,@"share_type":share_type,@"share_link":self.url};
//                @"":@"act_id",@"":@"act_name",
                [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"ar_spirit_activity" tp:@"getShareRecord"] parameters:parameters target:self success:^(NSDictionary *dic) {
//                    if ([dic[@"result"] intValue] == 1) {
//                        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://mall.companycn.net/SpriteActivity/share_success"]]];
//                        NSLog(@"分享成功%@",dic);
                    _result = [dic[@"result"] integerValue];
                    NSLog(@"%@",dic);
                    
                    if (_result ==1) {
//                        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://mall.companycn.net/SpriteActivity/share_success"]]];
//
//                        NSLog(@"tioz");
                    }
                    }
                 failue:^(NSDictionary *dic) {
                    NSLog(@"分享失败%@",dic[@"result"]);
                }];
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
            [_shareView removeFromSuperview];
        }
        //        [self alertWithError:error];
    }];
    
    [_shareView removeFromSuperview];
}

@end
