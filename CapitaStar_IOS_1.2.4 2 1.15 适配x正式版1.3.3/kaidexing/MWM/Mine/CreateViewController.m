//
//  CreateViewController.m
//  kaidexing
//
//  Created by YaoHuiQiu on 16/5/18.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "CreateViewController.h"

#import "MaleView.h"
#import "FemaleView.h"

@interface CreateViewController ()
{
    UIScrollView * scrollView;
    
    NSArray * createTitles;
}
@end

@implementation CreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitleLabel.text= @"创建星宝贝";
    
    createTitles = @[@"星宝贝名", @"出生日期", @"性别"];
    
    [self createSubviews];
}

- (void)createSubviews {
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, WIN_WIDTH, WIN_HEIGHT - NAV_HEIGHT - 1)];
    scrollView.contentSize = CGSizeMake(WIN_WIDTH, WIN_WIDTH);
    
    [self.view addSubview:scrollView];
    [self setKeyboardContainer:scrollView];
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 1)];
    view.backgroundColor = COLOR_LINE;
    
    [scrollView addSubview:view];
    
    
    UIView * grayView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(view.frame), WIN_WIDTH, 42)];
    grayView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    
    [scrollView addSubview:grayView];
    
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(14, 17, WIN_WIDTH - 14 - 14, 13)];
    label.font = COMMON_FONT;
    label.textColor = COLOR_FONT_SECOND;
    label.text = @"会员您好, 请提供以下资料为您的宝贝完成绑定";
    
    [grayView addSubview:label];
    
    
    UIView * whiteView = [self createRelevantInfomationViewWithView:grayView];
    whiteView.tag = 700;
    
    
    UILabel * remindLab = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(whiteView.frame) + 71, WIN_WIDTH-30, 13)];
    remindLab.font = COMMON_FONT;
    remindLab.textColor = COLOR_FONT_SECOND;
    remindLab.text = @"※提醒您, 您最多可绑定两位星宝贝!";
    
    [scrollView addSubview:remindLab];
    
    
    UIButton * confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(15, CGRectGetMaxY(remindLab.frame) + 15, WIN_WIDTH - 14 - 15, 44);
    confirmBtn.backgroundColor = APP_BTN_COLOR;
    confirmBtn.layer.cornerRadius = DEFAULT_BUTTON_RADIUS;
    confirmBtn.layer.masksToBounds = YES;
    confirmBtn.titleLabel.font = COMMON_FONT;
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmToCreateStarBaby:) forControlEvents:UIControlEventTouchUpInside];
    
    [scrollView addSubview:confirmBtn];
}

- (void)confirmToCreateStarBaby:(UIButton *)sender {
    
    NSString * path = [Util makeRequestUrl:@"usercenter" tp:@"addspark"];
    
    NSString * spark_name;
    
    NSString * birth;
    
    NSString * sex;
    
    NSString * location_code;
    
    //NSString *
    
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:[Global sharedClient].member_id, @"member_id", spark_name, @"spark_name", birth, @"birth", sex, @"sex", location_code, @"location_code", @"1000",  @"source", nil];
    
    [SVProgressHUD showWithStatus:@"数据加载中"];
    [HttpClient requestWithMethod:@"POST" path:path parameters:params target:self success:^(NSDictionary *dic) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            /*
             
             */
            
            
            [SVProgressHUD dismiss];
        });
        
    } failue:^(NSDictionary *dic) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [SVProgressHUD dismiss];
            
            NSLog(@"Faliue-dic===%@", dic);
            //弹窗提示错误信息
            [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
        });
    }];
}

- (UIView *)createRelevantInfomationViewWithView:(UIView *)view {
    
    UIView * whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(view.frame), WIN_WIDTH, 137)];
    whiteView.backgroundColor = [UIColor whiteColor];
    
    [scrollView addSubview:whiteView];
    
    for (int i = 0; i < 3; i++) {
        
        UIView * littleWhiteView = [[UIView alloc] initWithFrame:CGRectMake(0, (45 + 1) * i, WIN_WIDTH, 45)];
        littleWhiteView.backgroundColor = [UIColor whiteColor];
        
        [whiteView addSubview:littleWhiteView];
        
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(15, 14,80, 13)];
        label.font = COMMON_FONT;
        label.textColor = COLOR_FONT_SECOND;
        label.text = createTitles[i];
        
        [littleWhiteView addSubview:label];
        
        if (i == 2) {
            
            for (int j = 0; j < 2; j++) {
                //灰色分隔线
                CGFloat y = 45 + j * (45 +1);
                UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, y, WIN_WIDTH, 1)];
                view.backgroundColor = COLOR_LINE;
                
                [whiteView addSubview:view];
            }
            //CGRectGetMaxX(maleView.frame) + 21, 12, 35, 15
            MaleView * maleView = [[MaleView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame) + 34, 10, 50, 20)];
            
            [littleWhiteView addSubview:maleView];
            
            //CGRectGetMaxX(maleView.frame) + 21, 12, 35, 15
            FemaleView * femaleView = [[FemaleView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(maleView.frame) + 16, 10, 50, 20)];
            
            [littleWhiteView addSubview:femaleView];
            
        } else {
            UITextField * textField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame) + 27, 6, 150, 30)];
            textField.font = COMMON_FONT;
            textField.textColor = COLOR_FONT_BLACK;
            textField.placeholder = @"请填写";
            
            [littleWhiteView addSubview:textField];
        }
    }
    return whiteView;
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
