//
//  LuanchAdvViewController.m
//  kaidexing
//
//  Created by dwolf on 2017/6/8.
//  Copyright © 2017年 dwolf. All rights reserved.
//

#import "LuanchAdvViewController.h"
#import "GoViewController.h"
#import "HttpClient.h"

@interface LuanchAdvViewController ()

@end

@implementation LuanchAdvViewController{
    int secondsCountDown;
    NSTimer* countDownTimer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _imgHeight.constant = 0.9*WIN_HEIGHT;
    
    
    self.navigationBar.hidden = YES;
    _skipView.layer.cornerRadius = CGRectGetHeight(_skipView.frame)/2;
    
    //绑定点击事件
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [_imgView addGestureRecognizer: tap];
    
    //绑定点击事件
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSkipTap:)];
    [_skipView addGestureRecognizer: tap];
    _skipView.hidden = YES;
    
    [self judgeVersionUpdate];
    
}

-(void) loadAdv{
   // int zz=[[Global sharedClient].markID intValue];
  //  NSDictionary*diction=[[NSDictionary alloc]initWithObjectsAndKeys:@(zz),@"mall_id",[Global sharedClient].member_id,@"member_id", nil];
    NSDictionary*diction=@{};
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"index" tp:@"getadvert"] parameters:diction  target:self success:^(NSDictionary *dic){
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary* data = dic[@"data"];
            if([Util isNull:data]){
                [self dismissViewControllerAnimated:NO completion:^{
                }];
                return;
            }
            self.url =dic[@"data"][@"img_url"];
            
            self.goUrl = dic[@"data"][@"link_url"];
            _skipView.hidden = NO;
            
            secondsCountDown = 6;
            [self timeFireMethod];
            
            [_imgView setImageWithString:_url];
            NSLog(@"广告图%@",_url);
        });
        [Global sharedClient].showAdv = true;
    }failue:^(NSDictionary *dic){
        [self dismissViewControllerAnimated:NO completion:^{
        }];
        
    }];
}


-(void)onSkipTap:(UITapGestureRecognizer*) tap{
    [self dismissViewControllerAnimated:NO completion:^{
    }];
}

-(void) onTap:(UITapGestureRecognizer*) tap{
    if(![Util isNull:_goUrl]){
        GoViewController* vc = [[GoViewController alloc] init];
        vc.path = _goUrl;
        
        [self dismissViewControllerAnimated:NO completion:^{
                    }];
        UINavigationController* navigationController = self.adViewdelegate;
        vc.delegate =  [navigationController viewControllers][0];
        [navigationController pushViewController:vc animated:NO ];
    }
}

-(void)timeFireMethod{
    //倒计时-1
//    secondsCountDown--;
//    
//    _timeLabel.text = [NSString stringWithFormat:@"%d",secondsCountDown ];
//    
//    if(secondsCountDown<=0){
//        [countDownTimer invalidate];
//        [self dismissViewControllerAnimated:NO completion:^{
////            [_adViewdelegate dismiss];
//        }];
//    }
    
    //倒计时时间
    __block NSInteger timeOut = secondsCountDown;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //每秒执行一次
    
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        timeOut--;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            _timeLabel.text = [NSString stringWithFormat:@"%ld",(long)timeOut];
        });
        //倒计时结束，关闭
        if (timeOut <= 0) {
            dispatch_source_cancel(_timer);
                    [self dismissViewControllerAnimated:NO completion:^{
                        
                    }];
        }
    });
    dispatch_resume(_timer);
}
- (void)judgeVersionUpdate
{
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"1.3.0",@"version_no",@"ios",@"tag_code", nil];
//    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"index" tp:@"addversion"] parameters:dic target:self success:^(NSDictionary *dic) {
//        NSLog(@"修改版本号成功%@",dic);
//    } failue:^(NSDictionary *dic) {
//        
//    }];
    
    secondsCountDown = 6;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"ios",@"tag_code", nil];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"index" tp:@"getversion"] parameters:params target:nil success:^(NSDictionary *dic) {
        NSLog(@"请求成功");
        NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
        NSString *currentVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
        NSString *updateVersion1 =dic[@"data"][@"version_no"];
        NSArray *updateArr = [updateVersion1 componentsSeparatedByString:@"."];
        NSString *updateVersion2 = [updateArr componentsJoinedByString:@""];
        NSLog(@"updateVersion2=%@",updateVersion2);
        
        
        NSArray *currentArr = [currentVersion componentsSeparatedByString:@"."];
        NSString *currentVersion1 = [currentArr componentsJoinedByString:@""];
        NSLog(@"currentVersion1=%@",currentVersion1);
        
        if ([updateVersion2 integerValue] <=[currentVersion1 integerValue]) {
            [self loadAdv];
        }else{
            [self showAlertView];
        }
    } failue:^(NSDictionary *dic) {
        NSLog(@"更新失败=%@",dic);
        [self loadAdv];
    }];
}
- (void)showAlertView
{
    
    NSString *str=  @"凯德星APP最新版已上架，本版本可能无法使用某些最新功能，为了保证您的使用体验，请更新至最新版";
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:str  preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:NO completion:nil];
        
        [self loadAdv];
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *str = @"https://itunes.apple.com/cn/app/%E5%87%AF%E5%BE%B7%E6%98%9F/id1209888610?mt=8";
        NSURL *url = [NSURL URLWithString:str];
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
            [alert dismissViewControllerAnimated:YES completion:nil];
            
            [[NSNotificationCenter defaultCenter]addObserverForName:UIApplicationWillEnterForegroundNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
                [self loadAdv];
                
            }
             ];
        }];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
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
