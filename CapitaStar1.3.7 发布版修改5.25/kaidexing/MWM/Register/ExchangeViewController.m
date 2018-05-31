//
//  ExchangeViewController.m
//  sgSalerReport
//
//  Created by YaoHuiQiu on 16/5/4.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "ExchangeViewController.h"

@interface ExchangeViewController ()<UITextFieldDelegate>
{
    UIScrollView * scrollView;
    UITextField * exchangeCountTF;
    UILabel  * noticeLab;
    float margin;
}
@end

@implementation ExchangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitleLabel.text= @"兑换星币";
    margin = 10;
    [self networkRequest];
    
    [self createSubviews];
    
    
}

- (void)networkRequest {
    
    
}

- (void)createSubviews {
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT + 1, WIN_WIDTH, WIN_HEIGHT - NAV_HEIGHT - 1)];
    
    [self.view addSubview:scrollView];
    
    UIView * introView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 98)];
    introView.backgroundColor = [UIColor whiteColor];
    
    UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(margin, 8, 200, 21)];
    lab.font = COMMON_FONT;
    lab.textColor = COLOR_FONT_BLACK;
    lab.text = @"会员您好";
    
    [introView addSubview:lab];
    
    
    UILabel * starScoreL = [[UILabel alloc] initWithFrame:CGRectMake(margin, 29, 170, 21)];
    starScoreL.font = DESC_FONT;
    starScoreL.textColor = COLOR_FONT_SECOND;
    int shengjifen=[_dataAry[0]intValue];
    NSString * starScoreStr = [NSString stringWithFormat:@"您目前剩余：%d星积分", shengjifen];
    starScoreL.text = starScoreStr;
    
    [introView addSubview:starScoreL];
    
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(5, 59, 314, 1)];
    view.backgroundColor = UIColorFromRGB(0xf3f3f3);
    
    [introView addSubview:view];
    
    
    UILabel * overdueL = [[UILabel alloc] initWithFrame:CGRectMake(margin, 68, SCREEN_FRAME.size.width -  2*margin, 21)];
    overdueL.font = DESC_FONT;
    overdueL.textColor = COLOR_FONT_SECOND;
//    overdueL.text = @"2015/6/30过期星积分共500";
    NSString* expiry_date = [DateUtil stringDateFromString:_dataAry[1] format:DF_8 toFormat:DF_6];
    int  guoqijifen=[_dataAry[2]intValue];
    overdueL.text=[NSString stringWithFormat:@"%@过期星积分共%d",expiry_date,guoqijifen];
    
    [introView addSubview:overdueL];
    
    
    [scrollView addSubview:introView];
    
    UIView * exchangeBgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(introView.frame), WIN_WIDTH, 105)];
    exchangeBgView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    
    
    UIView * exchangeView = [[UIView alloc] initWithFrame:CGRectMake(0, 14, WIN_WIDTH, 50)];
    exchangeView.backgroundColor = [UIColor whiteColor];
    
    [exchangeBgView addSubview:exchangeView];
    
    UILabel * exchangeLab = [[UILabel alloc] initWithFrame:CGRectMake(margin, 14, 100, 21)];
    exchangeLab.font = COMMON_FONT;
    exchangeLab.textColor = COLOR_FONT_BLACK;
    exchangeLab.text = @"兑换星币";
    
    [exchangeView addSubview:exchangeLab];
    
    
    UIButton * addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(WIN_WIDTH-12-28, 11, 28, 28);
    [addBtn setBackgroundImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addOne:) forControlEvents:UIControlEventTouchUpInside];
    
    [exchangeView addSubview:addBtn];
    
    
    exchangeCountTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(addBtn.frame) - margin - 47, 11, 47, 28)];
    exchangeCountTF.font = COMMON_FONT;
    exchangeCountTF.textAlignment = NSTextAlignmentCenter;
    exchangeCountTF.layer.borderWidth = 1;
    exchangeCountTF.delegate=self;
    exchangeCountTF.keyboardType = UIKeyboardTypeNumberPad;
    exchangeCountTF.layer.borderColor = UIColorFromRGB(0xdddddd).CGColor;
    exchangeCountTF.text = @"1";
    
    [exchangeView addSubview:exchangeCountTF];
    
    
    UIButton * reduceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    reduceBtn.frame = CGRectMake(CGRectGetMinX(exchangeCountTF.frame) - margin - 28, 11, 28, 28);
    [reduceBtn setImage:[UIImage imageNamed:@"minus"] forState:UIControlStateNormal];
    [reduceBtn addTarget:self action:@selector(reduceOne:) forControlEvents:UIControlEventTouchUpInside];
    
    [exchangeView addSubview:reduceBtn];
    
    
    noticeLab = [[UILabel alloc] initWithFrame:CGRectMake(margin, CGRectGetMaxY(exchangeView.frame)+9, SCREEN_FRAME.size.width - 2*margin, 21)];
    noticeLab.font = COMMON_FONT;
    noticeLab.textColor = COLOR_FONT_SECOND;
    noticeLab.textAlignment = NSTextAlignmentRight;
    noticeLab.text = [NSString stringWithFormat:@"您确认兑换%@个星币", @"1"];
    //noticeLab.attributedText = [];
    
    [exchangeBgView addSubview:noticeLab];
    
    
    [scrollView addSubview:exchangeBgView];
    
    UIView * remindView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(exchangeBgView.frame), WIN_WIDTH, 136)];
    remindView.backgroundColor = [UIColor whiteColor];
    
    [scrollView addSubview:remindView];
    
    
    UILabel * remindLab = [[UILabel alloc] initWithFrame:CGRectMake(margin, 0, WIN_WIDTH - 20, 136)];
    //remindLab.backgroundColor = color_white;
    remindLab.font = DESC_FONT;
    remindLab.textColor = COLOR_FONT_SECOND;
    remindLab.numberOfLines = 0;
    remindLab.text = @"提醒您\n1.星积分一旦兑换成星币则不可再转换成星积分\n2.在一个日历年内所换取的星币将会在该日历年的12/31到期，到期后你将获得六个月的宽限期以兑换您的星币\n3.每个关联的星宝贝账户每日最多可累积10,000星币\n*以上内容均适用于星宝贝奖励计划之条款条件，更新更完整智信息请至www.capitastar.com.cn查看";
    
    [remindView addSubview:remindLab];
    
    
    UIView * bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(remindView.frame), WIN_WIDTH, 149)];
    bottomView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    
    
    UIButton * confirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    confirmBtn.frame = CGRectMake(12, 25, WIN_WIDTH - 2 * 10, 44);
    confirmBtn.backgroundColor = UIColorFromRGB(0xe0292b);
    confirmBtn.titleLabel.font = COMMON_FONT;
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn setTitle:@"确认兑换" forState:UIControlStateNormal];
    confirmBtn.layer.cornerRadius = DEFAULT_BUTTON_RADIUS;
    confirmBtn.layer.masksToBounds = YES;
    [confirmBtn addTarget:self action:@selector(confirmToExchange:) forControlEvents:UIControlEventTouchUpInside];
    
    [bottomView addSubview:confirmBtn];
    
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    backBtn.frame = CGRectMake(12, CGRectGetMaxY(confirmBtn.frame) + 12, WIN_WIDTH - 2 * 10, 44);
    backBtn.backgroundColor = UIColorFromRGB(0x48cc80);
    backBtn.titleLabel.font = COMMON_FONT;
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn setTitle:@"返回查看我的星积分" forState:UIControlStateNormal];
    backBtn.layer.cornerRadius = DEFAULT_BUTTON_RADIUS;
    backBtn.layer.masksToBounds = YES;
    [backBtn addTarget:self action:@selector(backToCheckMyStarScore:) forControlEvents:UIControlEventTouchUpInside];
    
    [bottomView addSubview:backBtn];
    
    
    [scrollView addSubview:bottomView];
    scrollView.contentSize = CGSizeMake(WIN_WIDTH, CGRectGetMaxY(bottomView.frame) + 20);
}

- (void)backToCheckMyStarScore:(UIButton *)sender {
    
    [self.delegate.navigationController popViewControllerAnimated:YES];
}

- (void)confirmToExchange:(UIButton *)sender {
    
    [self confirm:@"确定兑换？" afterOK:^{
        [SVProgressHUD showWithStatus:@"努力兑换中"];
        int jifen=[exchangeCountTF.text intValue];
        NSDictionary   *diction=[[NSDictionary alloc]initWithObjectsAndKeys:[Global sharedClient].member_id,@"member_id",_xingBBId,@"tp",@"1000",@"source",@(jifen),@"amount",@"SIN001",@"location_id", nil];
        [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"usercenter" tp:@"changeintegral"] parameters:diction  target:self success:^(NSDictionary *dic){
            dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                [SVProgressHUD showErrorWithStatus:@"兑换成功"];
                
            
            });
        }failue:^(NSDictionary *dic){
            
        }];
        
        
    }];
    

    
    
    
}

-(void)textFieldDidChange:(id)sender
{
    
    noticeLab.text= [NSString stringWithFormat:@"您确认兑换%@个星币",exchangeCountTF.text];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [exchangeCountTF resignFirstResponder];
    return YES;
}


- (void)addOne:(UIButton *)sender {
    
    NSInteger currentCount = exchangeCountTF.text.integerValue;
    
    currentCount++;
    
    exchangeCountTF.text = [NSString stringWithFormat:@"%ld", currentCount];
    noticeLab.text = [NSString stringWithFormat:@"您确认兑换%@个星币", exchangeCountTF.text ];
}

- (void)reduceOne:(UIButton *)sender {
    
    NSInteger currentCount = exchangeCountTF.text.integerValue;
    
    currentCount--;
    
    if (currentCount < 0) return;
    
    exchangeCountTF.text = [NSString stringWithFormat:@"%ld", currentCount];
    noticeLab.text = [NSString stringWithFormat:@"您确认兑换%@个星币", exchangeCountTF.text ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [exchangeCountTF resignFirstResponder];
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
