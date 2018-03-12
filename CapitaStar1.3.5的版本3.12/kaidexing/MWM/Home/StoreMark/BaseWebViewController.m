//
//  BaseWebViewController.m
//  kaidexing
//
//  Created by dwolf on 16/5/18.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "BaseWebViewController.h"

@interface BaseWebViewController ()<UIWebViewDelegate>

@end

@implementation BaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _webView = [[UIWebView alloc] init];
    _webView.frame = CGRectMake(0, NAV_HEIGHT, SCREEN_FRAME.size.width, SCREEN_FRAME.size.height - NAV_HEIGHT-BAR_HEIGHT);
    [self.view addSubview:_webView];
    _webView.scrollView.bounces=NO;
    self.webView.scrollView.bouncesZoom=NO;
    self.webView.scalesPageToFit = YES;
    _webView.delegate = self;
    if (IS_IOS_7) {
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)web{
    [self removeLoading];
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
