//
//  UserCenterTFV.m
//  sgSalerReport
//
//  Created by YaoHuiQiu on 16/5/4.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "UserCenterTFV.h"

#import "Const.h"
#import "UserCenterViewController.h"
#import "EditInfomationViewController.h"

@implementation UserCenterTFV

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    UIButton * editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    editBtn.frame = CGRectMake(16, 24, (WIN_WIDTH - 16 * 2 - 10) / 2, 40);
    editBtn.layer.cornerRadius = DEFAULT_BUTTON_RADIUS;
    editBtn.layer.masksToBounds = YES;
    editBtn.backgroundColor = APP_BTN_COLOR;
    editBtn.titleLabel.font = COMMON_FONT;
    [editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [editBtn setTitle:@"编辑信息" forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(editInformation:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:editBtn];
    
    
    UIButton * exitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    exitBtn.frame = CGRectMake(CGRectGetMaxX(editBtn.frame)+10, 24, CGRectGetWidth(editBtn.bounds), 40);
    exitBtn.layer.cornerRadius = DEFAULT_BUTTON_RADIUS;
    exitBtn.layer.masksToBounds = YES;
    exitBtn.backgroundColor = APP_BTN_COLOR;
    exitBtn.titleLabel.font = COMMON_FONT;
    [exitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [exitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [exitBtn addTarget:self action:@selector(exitLogin:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:exitBtn];
}

- (void)editInformation:(UIButton *)sender {
    
    EditInfomationViewController * eiVC = [[EditInfomationViewController alloc] init];
    
    eiVC.section0_Data = _section0_Data;
    eiVC.section1_Data = _section1_Data;
    
    [self.viewC.delegate.navigationController pushViewController:eiVC animated:YES];
}

- (void)exitLogin:(UIButton *)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:nil andMessage:@"您确认退出登录吗？"];
        [alertView addButtonWithTitle:@"取消"
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alertView) {
                                  
                              }];
        [alertView addButtonWithTitle:@"确定"
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alertView) {
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
                                  [userDefaults setObject:nil forKey:@"firstSetIn"];
                                  [userDefaults setValue:nil
                                     forKey:@"tipFisrt"];
                                  
                                  [userDefaults setValue:nil
                                                  forKey:@"is_send"];
                                  
                                  [JPUSHService setTags:[[NSSet alloc] initWithObjects:@"public",nil] alias:nil callbackSelector:@selector(tagsAliasCallback:tags:alias:)  object:self];
//                                  [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
//
//                                  } seq:0];
                                 // [JPUSHService setAlias:nil completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                                      
                                 // } seq:0];
                                  [self.viewC  popToViewController:1];
                              }];
        alertView.transitionStyle = SIAlertViewTransitionStyleDropDown;
        alertView.backgroundStyle = SIAlertViewBackgroundStyleSolid;
        [alertView show];
    });
}

- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
