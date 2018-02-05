//
//  SuccessViewController.m
//  kaidexing
//
//  Created by 朱巩拓 on 2016/10/21.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "SuccessViewController.h"
#import "LoginViewController.h"
#import "MembershipCardViewController.h"
#import "GoodsRootController.h"


@interface SuccessViewController ()

@end

@implementation SuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarTitleLabel.text=@"注册成功";
    self.view.backgroundColor=UIColorFromRGB(0xf5f5f5);
    [self setUp];
   
}
-(void)setUp{
    //执行退出登录的操作
    [Global sharedClient].member_id = nil;
    [Global sharedClient].img_url = nil;
    [Global sharedClient].nick_name = nil;
    
    [Global sharedClient].xjf_Cq_Xx = nil;
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:nil forKey:@"member_id"];
    [userDefaults setValue:nil forKey:@"img_url"];
    [userDefaults setValue:nil forKey:@"nick_name"];
    [userDefaults setValue:nil forKey:@"xjf_kq_xx"];
    [Global sharedClient].userCookies = nil;
    [userDefaults setValue:nil forKey:@"userCookies"];
    [Global sharedClient].sessionId  =nil;
    [userDefaults setValue:nil forKey:@"sessionId"];
    [userDefaults setValue:nil forKey:@"mall_id"];
    [userDefaults setValue:nil forKey:@"mall_name"];
    [userDefaults setValue:nil forKey:@"mall_url_prefix"];
    [userDefaults setValue:nil forKey:@"mall_id_des"];
    
    [JPUSHService setTags:[[NSSet alloc] initWithObjects:@"public",nil] alias:nil callbackSelector:@selector(tagsAliasCallback:tags:alias:)  object:self];
   
    //执行登录操作

   NSString *password = [RSA encryptString:_passWord publicKey:PublicKey];
    //
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:_phone, @"phone_num", password, @"pass_word", @"1000", @"source", nil];
    
    [SVProgressHUD showWithStatus:@"登录中"];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"member" tp:@"login"] parameters:params target:self success:^(NSDictionary *dic) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [SVProgressHUD dismiss];
            NSDictionary * dataDic = dic[@"data"];

            [userDefaults setValue:_passWord forKey:@"passWord"];
            
            [Global sharedClient].member_id = dataDic[@"id"];
            [userDefaults setValue:dataDic[@"id"] forKey:@"member_id"];
            
            [Global sharedClient].img_url = dataDic[@"img_url"];
            [userDefaults setValue:dataDic[@"img_url"] forKey:@"img_url"];
            
            [Global sharedClient].nick_name = dataDic[@"nick_name"];
            [userDefaults setValue:dataDic[@"nick_name"] forKey:@"nick_name"];
            
            [Global sharedClient].phone = dataDic[@"phone"];
            [userDefaults setValue:dataDic[@"phone"] forKey:@"phone"];
            
            NSMutableArray * xjf_kq_xx = [[NSMutableArray alloc] init];
            [xjf_kq_xx addObject:dataDic[@"integralcount"]];
            [xjf_kq_xx addObject:dataDic[@"couponcount"]];
            [xjf_kq_xx addObject:dataDic[@"message"]];
            [Global sharedClient].userCookies = dataDic[@"member_id_des"];
            [userDefaults setValue:dataDic[@"member_id_des"] forKey:@"userCookies"];
            [Global sharedClient].xjf_Cq_Xx = xjf_kq_xx;
            [userDefaults setValue:xjf_kq_xx forKey:@"xjf_kq_xx"];
            
            [self createRootView];
            
        });
        
    } failue:^(NSDictionary *dic) {
        [self.delegate.navigationController popToRootViewControllerAnimated:YES];
    }];
}
- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}
-(void)createRootView{
    UIImageView *headView=[[UIImageView alloc]initWithFrame:CGRectMake((WIN_WIDTH-M_WIDTH(45))/2,NAV_HEIGHT+M_WIDTH(47),M_WIDTH(45),M_WIDTH(45))];
    [headView setImage:[UIImage imageNamed:@"duigou_red"]];
    [self.view addSubview:headView];
    
    UILabel *lab1=[[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(headView.frame)+M_WIDTH(20),WIN_WIDTH,M_WIDTH(27))];
    lab1.text=@"注册成功";
    lab1.textColor=[UIColor redColor];
    lab1.textAlignment=NSTextAlignmentCenter;
    lab1.font=[UIFont systemFontOfSize:20];
    [self.view addSubview:lab1];
    
    UILabel *lab2=[[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(lab1.frame),WIN_WIDTH,M_WIDTH(31))];
    lab2.text=@"恭喜您的注册，您已成功注册";
    lab2.textColor=COLOR_FONT_SECOND;;
    lab2.textAlignment=NSTextAlignmentCenter;
    lab2.font=DESC_FONT;
    [self.view addSubview:lab2];
    
    UIButton *btn1=[[UIButton alloc]initWithFrame:CGRectMake(M_WIDTH(27),CGRectGetMaxY(lab2.frame)+M_WIDTH(32),WIN_WIDTH-M_WIDTH(54),M_WIDTH(45))];
    btn1.layer.masksToBounds=YES;
    btn1.layer.cornerRadius=3;
    btn1.backgroundColor=UIColorFromRGB(0xe22a2c);
    [btn1 setTitle:@"查看我的会员卡" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn1.titleLabel.font=COOL_FONT;
    btn1.tag=0;
    [btn1 addTarget:self action:@selector(btnTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton *btn3=[[UIButton alloc]initWithFrame:CGRectMake(M_WIDTH(27),CGRectGetMaxY(btn1.frame)+M_WIDTH(16),WIN_WIDTH-M_WIDTH(54),M_WIDTH(45))];
    btn3.layer.masksToBounds=YES;
    btn3.layer.cornerRadius=3;
    btn3.backgroundColor=UIColorFromRGB(0xe22a2c);
    [btn3 setTitle:@"回到注册界面" forState:UIControlStateNormal];
    [btn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn3.titleLabel.font=COOL_FONT;
    btn3.tag=1;
    [btn3 addTarget:self action:@selector(btnTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
    
    
    
    UIButton *btn2=[[UIButton alloc]initWithFrame:CGRectMake(M_WIDTH(27),CGRectGetMaxY(btn3.frame)+M_WIDTH(16),WIN_WIDTH-M_WIDTH(54),M_WIDTH(45))];
    btn2.layer.masksToBounds=YES;
    btn2.layer.cornerRadius=3;
    btn2.layer.borderColor=UIColorFromRGB(0xe22a2c).CGColor;
    btn2.layer.borderWidth=1;
    btn2.backgroundColor=[UIColor whiteColor];
    [btn2 setTitle:@"查看积分商城" forState:UIControlStateNormal];
    [btn2 setTitleColor:UIColorFromRGB(0xe22a2c) forState:UIControlStateNormal];
    btn2.titleLabel.font=COOL_FONT;
    btn2.tag=2;
    [btn2 addTarget:self action:@selector(btnTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
}

-(void)btnTouch:(UIButton*)sender{
    //我的会员卡
    if (sender.tag==0) {
        MembershipCardViewController * mcVC = [[MembershipCardViewController alloc] init];
        [self.delegate.navigationController pushViewController:mcVC animated:YES];
    }else if(sender.tag==1){
        [self.delegate.navigationController popToRootViewControllerAnimated:YES];
    }else if(sender.tag==2){
        //需要在上级界面加COOKIE
        GoodsRootController *vc=[[GoodsRootController alloc]init];
        [self.delegate.navigationController pushViewController:vc animated:YES];
    }
    
}
//返回按钮触发事件，可重写
- (void)backBtnOnClicked:(id)sender{
    [self.delegate.navigationController popToRootViewControllerAnimated:YES];
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
