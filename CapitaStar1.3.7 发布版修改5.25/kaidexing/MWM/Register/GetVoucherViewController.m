//
//  GetVoucherViewController.m
//  sgSalerReport
//
//  Created by YaoHuiQiu on 16/5/5.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "GetVoucherViewController.h"

@interface GetVoucherViewController ()
{
    UIScrollView * scrollView;
    
    UITextField * codeTF;
}
@end

@implementation GetVoucherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitleLabel.text= @"兑换码领券";
    
    [self createSubviews];
}

- (void)networkRequest {

    NSString * path = [Util makeRequestUrl:@"usercenter" tp:@"exchangecode"];
    
    NSString * phone_num = [Global sharedClient].phone;
    
    NSString * code = codeTF.text;
    
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:[Global sharedClient].member_id, @"member_id",  code, @"code",phone_num, @"phone_num", nil];
    
    [SVProgressHUD showWithStatus:@"数据加载中"];
    [HttpClient requestWithMethod:@"POST" path:path parameters:params target:self success:^(NSDictionary *dic) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [SVProgressHUD dismiss];

            [SVProgressHUD showSuccessWithStatus:dic[@"data"]];
        });
    } failue:^(NSDictionary *dic) {
       
    }];
}

- (void)createSubviews {
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, WIN_WIDTH, WIN_HEIGHT - NAV_HEIGHT)];
    
    [self.view addSubview:scrollView];
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 26, WIN_WIDTH, 40)];
    view.backgroundColor = [UIColor whiteColor];
    
    [scrollView addSubview:view];
    
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, M_WIDTH(40), view.frame.size.height)];
    label.font = INFO_FONT;
    label.textColor = COLOR_FONT_BLACK;
    label.text = @"兑换码";
    [label sizeToFit];
    label.frame = CGRectMake(10, 0, label.frame.size.width, view.frame.size.height);
    [view addSubview:label];
    
    
    codeTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame)+M_WIDTH(15), 0,
                                                           SCREEN_FRAME.size.width - 10 - CGRectGetMaxX(label.frame) - M_WIDTH(15), view.frame.size.height)];
    codeTF.font = DESC_FONT;
    codeTF.textColor = COLOR_FONT_BLACK;
    codeTF.placeholder = @"请输入由14位数字组成的兑换码";
    codeTF.keyboardType = UIKeyboardTypeNumberPad;
    
    [view addSubview:codeTF];
    
    
    UIButton * getBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    getBtn.frame = CGRectMake(M_WIDTH(10), CGRectGetMaxY(view.frame)+20, WIN_WIDTH - 2 * M_WIDTH(10), 38);
    getBtn.layer.cornerRadius = DEFAULT_BUTTON_RADIUS;
    getBtn.layer.masksToBounds = YES;
    getBtn.backgroundColor = UIColorFromRGB(0xe0292b);
    getBtn.titleLabel.font = COMMON_FONT;
    [getBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [getBtn setTitle:@"领取卡券" forState:UIControlStateNormal];
    [getBtn addTarget:self action:@selector(getCardVoucher:) forControlEvents:UIControlEventTouchUpInside];
    
    [scrollView addSubview:getBtn];
    
    
    UILabel * step1_Lab = [[UILabel alloc] initWithFrame:CGRectMake(58, CGRectGetMaxY(getBtn.frame) + 29, 20, 20)];
    step1_Lab.backgroundColor = UIColorFromRGB(0xc9caca);
    step1_Lab.layer.cornerRadius = 10;
    step1_Lab.layer.masksToBounds = YES;
    step1_Lab.textAlignment = NSTextAlignmentCenter;
    step1_Lab.textColor = UIColorFromRGB(0xfafafa);
    step1_Lab.font = DESC_FONT;
    step1_Lab.text = @"1";
    
    [scrollView addSubview:step1_Lab];
    

    UILabel * title1_Lab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(step1_Lab.frame)+10, CGRectGetMinY(step1_Lab.frame), 100, 21)];

    title1_Lab.font = DESC_FONT;
    title1_Lab.textColor = COLOR_FONT_BLACK;
    title1_Lab.text = @"输入兑换码";
    
    [scrollView addSubview:title1_Lab];
    
    

    UILabel * subtitle1_Lab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(title1_Lab.frame), CGRectGetMaxY(title1_Lab.frame), WIN_WIDTH - 10 - CGRectGetMinX(title1_Lab.frame), 10)];
    subtitle1_Lab.font = INFO_FONT;
    subtitle1_Lab.textColor = COLOR_FONT_SECOND;
    subtitle1_Lab.text = @"在输入框输入兑换码, 点击领取卡券";
    
    [scrollView addSubview:subtitle1_Lab];
    
    UIView * view1 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMidX(step1_Lab.frame), CGRectGetMaxY(step1_Lab.frame) + 1, 1, 44)];
    view1.backgroundColor = COLOR_LINE;
    
    [scrollView addSubview:view1];
    
    
    UILabel * step2_Lab = [[UILabel alloc] initWithFrame:CGRectMake(58, CGRectGetMaxY(view1.frame) + 2, 20, 20)];
    step2_Lab.backgroundColor = UIColorFromRGB(0xc9caca);
    step2_Lab.layer.cornerRadius = 10;
    step2_Lab.layer.masksToBounds = YES;
    step2_Lab.textAlignment = NSTextAlignmentCenter;
    step2_Lab.textColor = UIColorFromRGB(0xfafafa);
    step2_Lab.font = DESC_FONT;
    step2_Lab.text = @"2";
    
    [scrollView addSubview:step2_Lab];
    
    
    UILabel * title2_Lab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(step2_Lab.frame)+10, CGRectGetMinY(step2_Lab.frame), 60, 21)];
    title2_Lab.font = DESC_FONT;
    title2_Lab.textColor = COLOR_FONT_BLACK;
    title2_Lab.text = @"查看卡券";
    
    [scrollView addSubview:title2_Lab];
    
    
    UILabel * subtitle2_Lab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(title2_Lab.frame), CGRectGetMaxY(title2_Lab.frame), WIN_WIDTH - 10 - CGRectGetMinX(title2_Lab.frame), 28)];
    subtitle2_Lab.font = INFO_FONT;
    subtitle2_Lab.textColor = COLOR_FONT_SECOND;
    subtitle2_Lab.numberOfLines = 0;
    subtitle2_Lab.text = @"领取卡券后, 可在会员中心我的卡券中查看卡券";
    [subtitle2_Lab sizeToFit];
    
    [scrollView addSubview:subtitle2_Lab];
    scrollView.contentSize = CGSizeMake(WIN_WIDTH, WIN_HEIGHT);
}

- (void)getCardVoucher:(UIButton *)sender {
    
    [self networkRequest];
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
