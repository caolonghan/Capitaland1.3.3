//
//  HeXiaoViewController.m
//  sgSalerReport
//
//  Created by YaoHuiQiu on 16/5/4.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "HeXiaoViewController.h"

@interface HeXiaoViewController ()
{
    UIScrollView * scrollView;
}
@end

@implementation HeXiaoViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitleLabel.text= @" 核销";
    
    
    
    [self createSubviews];
}

- (void)createSubviews {
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT + 1, WIN_WIDTH, WIN_HEIGHT - NAV_HEIGHT - 1)];
    
    [self.view addSubview:scrollView];
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 17, WIN_WIDTH, 88)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIImageView * imgV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 40, 40)];
    imgV.layer.cornerRadius = 20;
    imgV.layer.masksToBounds = YES;
    imgV.backgroundColor = [UIColor cyanColor];
    
    [view addSubview:imgV];
    
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgV.frame)+5, 15, 100, 17)];
    label.font = COMMON_FONT;
    label.textColor = COLOR_FONT_SECOND;
    label.text = @"大创10元现金券";
    
    [view addSubview:label];
    
    
    UILabel * label1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(label.frame), CGRectGetMaxY(label.frame) + 2, 150, 15)];
    label1.font = DESC_FONT;
    label1.textColor = UIColorFromRGB(0xff4609);
    label1.text = @"2015-09-30~2015-12-31";
    
    [view addSubview:label1];
    
    
    UILabel * label_2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(label1.frame), CGRectGetMaxY(label1.frame) + 6, 40, 21)];
    label_2.font = DESC_FONT;
    label_2.textColor = COLOR_FONT_SECOND;
    label_2.text = @"券号：";
    
    [view addSubview:label_2];
    
    
    UILabel * label2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label_2.frame), CGRectGetMinY(label_2.frame), 173, 21)];
    label2.font = COMMON_FONT;
    label2.textColor = COLOR_FONT_BLACK;
    label2.text = @"0052 4196 5536";
    
    [view addSubview:label2];
    
    
    [scrollView addSubview:view];
    
    
    UIView * view1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(view.frame)+17, WIN_WIDTH, 91)];
    view1.backgroundColor = [UIColor whiteColor];
    
    
    UILabel * label3 = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 45, 16)];
    label3.font = COMMON_FONT;
    label3.textColor = COLOR_FONT_SECOND;
    label3.text = @"88888";
    
    [view1 addSubview:label3];
    
    
    UIView * view2 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label3.frame)+15, 15, 1, 20)];
    view2.backgroundColor = COLOR_LINE;
    
    [view1 addSubview:view2];
    
    
    UITextField * textF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(view2.frame)+15, 7, 165, 35)];
    textF.font = COMMON_FONT;
    textF.textColor = COLOR_FONT_BLACK;
    textF.placeholder = @"请输入商户编号的后四位";
    
    [view1 addSubview:textF];
    
    
    UIView * view3 = [[UIView alloc] initWithFrame:CGRectMake(0, 46, WIN_WIDTH, 1)];
    view3.backgroundColor = UIColorFromRGB(0xfcfcfc);
    
    [view1 addSubview:view3];
    
    
    UITextField * pswdTF = [[UITextField alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(view3.frame) + 5, 100, 33)];
    pswdTF.font = COMMON_FONT;
    pswdTF.textColor = COLOR_FONT_BLACK;
    pswdTF.placeholder = @"请输入核销密码";
    
    [view1 addSubview:pswdTF];
    
    
    [scrollView addSubview:view1];
    
    
    UIButton * heXiaoBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    heXiaoBtn.frame = CGRectMake(16, CGRectGetMaxY(view1.frame)+25, 290, 43);
    heXiaoBtn.backgroundColor = UIColorFromRGB(0xe0292b);
    heXiaoBtn.layer.cornerRadius = DEFAULT_BUTTON_RADIUS;
    heXiaoBtn.layer.masksToBounds = YES;
    [heXiaoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    heXiaoBtn.titleLabel.font = COMMON_FONT;
    [heXiaoBtn setTitle:@"核销" forState:UIControlStateNormal];
    [heXiaoBtn addTarget:self action:@selector(confirmHeXiao:) forControlEvents:UIControlEventTouchUpInside];
    
    [scrollView addSubview:heXiaoBtn];
    // + CGRectGetHeight(heXiaoBtn.bounds)
    scrollView.contentSize = CGSizeMake(WIN_WIDTH, WIN_HEIGHT);
}

- (void)confirmHeXiao:(UIButton *)sender {
    
    
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
