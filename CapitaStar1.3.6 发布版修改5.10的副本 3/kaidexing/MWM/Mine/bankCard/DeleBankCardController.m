//
//  DeleBankCardController.m
//  kaidexing
//
//  Created by companycn on 2018/3/15.
//  Copyright © 2018年 dwolf. All rights reserved.
//

#import "DeleBankCardController.h"
#import "BankCardView.h"

@interface DeleBankCardController ()<UIGestureRecognizerDelegate>
@property (nonatomic,strong)BankCardView *bankCardView;
@property (nonatomic,strong)UITextField *moneyField1;
@property (nonatomic,strong)UITextField *moneyField2;
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)UIView *alertView;
@property (nonatomic,strong)UITextField *changeField;
@end

@implementation DeleBankCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarTitleLabel.text = @"银行卡详情";
    self.navigationBarTitleLabel.textColor =[UIColor whiteColor];
    self.navigationBar.backgroundColor = RGBCOLOR(0, 135, 140);
    [self createView];
}
-(void)redefineBackBtn{
    [self redefineBackBtn:[UIImage imageNamed:@"AR_back"] :CGRectMake(0, 0, 44,44)];
}
- (void)createView
{
    _bankCardView = [[BankCardView alloc]initWithFrame:CGRectMake(15, NAV_HEIGHT+15, WIN_WIDTH-30, 110)];
    _bankCardView.cardStyle = _cardType;
    _bankCardView.bankName = _bankName;
    _bankCardView.cardNo = _cardNo;
    _bankCardView.bankImageUrl = _bankImageUrl;
    [self.view addSubview:_bankCardView];
    for (NSInteger i=0; i<3; i++) {
        UIView *line =[[UIView alloc ]initWithFrame:CGRectMake(15, CGRectGetMaxY(_bankCardView.frame)+15+i*44, WIN_WIDTH-30, 1)];
        line.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.view addSubview:line];
    }
    UILabel *leftLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(_bankCardView.frame)+15, 130, 44)];
    leftLabel1.font = COMMON_FONT;
    leftLabel1.text = @"单日累计交易限额";
    UILabel *leftLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(leftLabel1.frame), 130, 44)];
    leftLabel2.font = COMMON_FONT;
    leftLabel2.text = @"单笔免密支付限额";
    [self.view addSubview:leftLabel1];
    [self.view addSubview:leftLabel2];
    
    for (NSInteger i=0; i<2; i++) {
        UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH-95, CGRectGetMaxY(_bankCardView.frame)+20+44*i, 80, 34)];
        rightBtn.tag =1000+i;
        [rightBtn setTitle:@"修改" forState:UIControlStateNormal];
        rightBtn.titleLabel.font = COMMON_FONT;
        [rightBtn setTitleColor:RGBCOLOR(0, 135, 140) forState:UIControlStateNormal];
        rightBtn.layer.borderWidth = 1;
        rightBtn.layer.cornerRadius = 3;
        rightBtn.layer.masksToBounds = YES;
        rightBtn.layer.borderColor = RGBCOLOR(0, 135, 140).CGColor;
        [rightBtn addTarget: self action:@selector(clickToChange:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:rightBtn];
        
      
    }
    _moneyField1 = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(leftLabel1.frame), CGRectGetMaxY(_bankCardView.frame)+25, WIN_WIDTH-95-leftLabel1.width, 30)];
    _moneyField1.textColor = [UIColor lightGrayColor];
    _moneyField1.borderStyle = UITextBorderStyleNone;
    _moneyField1.keyboardType = UIKeyboardTypeNumberPad;
    _moneyField1.text = _dayAmount;
    _moneyField1.enabled = NO;
    [self.view addSubview:_moneyField1];
    
    _moneyField2 = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(leftLabel1.frame), CGRectGetMaxY(_bankCardView.frame)+25+44, WIN_WIDTH-95-leftLabel1.width, 30)];
    _moneyField2.textColor = [UIColor lightGrayColor];
    _moneyField2.borderStyle = UITextBorderStyleNone;
    _moneyField2.keyboardType = UIKeyboardTypeNumberPad;
    _moneyField2.placeholder= @"请输入金额";
    _moneyField2.text = _timeAmount;
    _moneyField2.enabled = NO;
    [self.view addSubview:_moneyField2];
    
    UIButton *deleBtn = [[UIButton alloc]initWithFrame:CGRectMake(15,CGRectGetMaxY(leftLabel2.frame)+20, WIN_WIDTH-30, 40)];
    [self.view addSubview:deleBtn];
    [deleBtn setTitle:@"解除绑定" forState:UIControlStateNormal];
    [deleBtn setTitleColor:RGBCOLOR(221, 81, 87) forState:UIControlStateNormal];
    [deleBtn addTarget: self action:@selector(clickToDele:) forControlEvents:UIControlEventTouchUpInside];
    deleBtn.layer.borderWidth = 1;
    deleBtn.layer.cornerRadius = 5;
    deleBtn.layer.masksToBounds = YES;
    deleBtn.layer.borderColor = [UIColor colorWithRed:221/255.0 green:81/255.0 blue:87/255.0 alpha:1].CGColor;
}
- (void)clickToDele:(UIButton *)sender
{
    NSDictionary*diction=[[NSDictionary alloc]initWithObjectsAndKeys:[Global sharedClient].member_id, @"member_id",_ides,@"card_id",nil];
    [SVProgressHUD showWithStatus:@"正在加载中"];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"unionpay/UnionpayBindCard" tp:@"del_member_card_info"] parameters:diction target:self success:^(NSDictionary *dic) {
        NSLog(@"%@",dic);
        [SVProgressHUD showSuccessWithStatus:@"解绑成功"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [NSThread sleepForTimeInterval:1];
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    } failue:^(NSDictionary *dic) {
        NSLog(@"失败%@",dic[@"msg"]);
        [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
        
        
    }];
}

- (void)clickToChange:(UIButton *)sender
{
   
    _bgView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sureTapClick:)];
    tap.delegate = self;
    _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [_bgView addGestureRecognizer:tap];
[[UIApplication sharedApplication].keyWindow addSubview:_bgView];
   
    
    _alertView = [[UIView alloc]initWithFrame:CGRectMake(40, WIN_HEIGHT/2-80, WIN_WIDTH-80, 160)];
    _alertView.backgroundColor = [UIColor whiteColor];
    [_bgView addSubview:_alertView];
    
    _changeField = [[UITextField alloc]initWithFrame:CGRectMake(40, 50, _alertView.width-80, 30)];
    _changeField.layer.borderWidth = 1;
   
    _changeField.keyboardType = UIKeyboardTypeDecimalPad;
    
    _changeField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _changeField.textColor = [UIColor lightGrayColor];
    if (sender.tag-1000==0) {
        _changeField.text = _moneyField1.text;
    }else
    {
         _changeField.text = _moneyField2.text;
    }
    [_alertView addSubview:_changeField];
    
    UIButton *comfileBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, _alertView.height-40, _alertView.width/2, 40)];
    UIButton *cancleBtn =  [[UIButton alloc]initWithFrame:CGRectMake(_alertView.width/2, _alertView.height-40, _alertView.width/2, 40)];
    [_alertView addSubview:comfileBtn];
    [_alertView addSubview:cancleBtn];
    [comfileBtn setTitle:@"确定" forState:UIControlStateNormal];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    comfileBtn.tag = sender.tag+1000;
    [comfileBtn setBackgroundColor:RGBCOLOR(0, 135, 140)];
    [cancleBtn setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [comfileBtn addTarget:self action:@selector(changeAmount:) forControlEvents:UIControlEventTouchUpInside];
    
    [cancleBtn addTarget: self action:@selector(clickToCancle) forControlEvents:UIControlEventTouchUpInside];
    [cancleBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [comfileBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}
- (void)clickToCancle
{
    [_bgView removeFromSuperview];
    for (UIView *view in _bgView.subviews) {
        [view removeFromSuperview];
    }
}
- (void)sureTapClick:(UITapGestureRecognizer *)sender
{
    [_bgView removeFromSuperview];
    for (UIView *view in _bgView.subviews) {
        [view removeFromSuperview];
    }
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isDescendantOfView:_alertView]) {
        return NO;
    }
    
    return YES;
}
- (void)changeAmount:(UIButton *)sender{
    
    if ([Util isNull: _changeField.text]) {
        [SVProgressHUD showErrorWithStatus:@"金额不能为空"];
        return;
    }
    
    [_bgView removeFromSuperview];
    for (UIView *view in _bgView.subviews) {
        [view removeFromSuperview];
    }
    
    NSInteger tag = sender.tag-2000;
        NSDictionary *diction = [NSDictionary dictionary];
    NSString *amount = _changeField.text;
        if (tag==0) {
            
             diction=[[NSDictionary alloc]initWithObjectsAndKeys:[Global sharedClient].member_id, @"member_id",_ides,@"card_id",@(tag),@"channel_id",amount,@"pay_amount",nil];
        }else{
         
       diction=[[NSDictionary alloc]initWithObjectsAndKeys:[Global sharedClient].member_id, @"member_id",_ides,@"card_id",@(tag),@"channel_id",amount,@"pay_amount",nil];
        }
        [SVProgressHUD showWithStatus:@"修改中"];
        [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"unionpay/UnionpayBindCard" tp:@"modify_check_pay_money"] parameters:diction target:self success:^(NSDictionary *dic) {
            NSLog(@"%@",dic);
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            if (tag ==0) {
                _moneyField1.text = amount;
            }else
            {
                _moneyField2.text = amount;
            }
    
        } failue:^(NSDictionary *dic) {
            NSLog(@"失败%@",dic[@"msg"]);
            [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
            
    
        }];
}

@end
