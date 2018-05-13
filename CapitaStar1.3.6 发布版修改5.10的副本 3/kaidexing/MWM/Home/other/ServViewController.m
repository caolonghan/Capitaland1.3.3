//
//  FloorViewController.m
//  kaidexing
//
//  Created by dwolf on 16/5/18.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "ServViewController.h"

@interface ServViewController ()

@end

@implementation ServViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"服务中心";
    
    [self loadHtmlByPath:@"http://mall.companycn.net/sh_rafflescity/service/index"];
}

- (void)webViewDidFinishLoad:(UIWebView *)web{
    [self removeLoading];
    
    NSString *delete=[NSString stringWithFormat:@"var nava = document.getElementById('nav');"
                      "nava.parentNode.removeChild(nava)"];
    [self.webView stringByEvaluatingJavaScriptFromString:delete];
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
