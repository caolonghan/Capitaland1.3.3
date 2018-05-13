//
//  BankCardViewController.m
//  kaidexing
//
//  Created by companycn on 2018/3/15.
//  Copyright © 2018年 dwolf. All rights reserved.
//

#import "BankCardViewController.h"
#import "BankCardView.h"
#import "DeleBankCardController.h"
#import "AddBankCardController.h"
#import "ResetPasswordViewController.h"

@interface BankCardViewController ()
@property (nonatomic,strong)NSArray *bankListArray;
@property (nonatomic,strong)BankCardView *bankCardView;
@property (nonatomic,strong)UIButton *addBtn;
@property (nonatomic,strong)UIScrollView *bgScrollView;
@property (nonatomic,strong)NSString *result;

@end

@implementation BankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarTitleLabel.text = @"我的银行卡";
    self.navigationBarTitleLabel.textColor =[UIColor whiteColor];
    self.navigationBar.backgroundColor = RGBCOLOR(0, 135, 140);
    [self loadData];
    [Global sharedClient].bindCardBackWhere = 2;
}
-(void)redefineBackBtn{
    [self redefineBackBtn:[UIImage imageNamed:@"AR_back"] :CGRectMake(0, 0, 44,44)];
}
- (void)viewWillAppear:(BOOL)animated
{
    [NSThread sleepForTimeInterval:1];
    [super viewWillAppear:animated];
    if (_isMinePush == NO) {
        [self loadData];
    }
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _isMinePush = NO;
    [self clearView];
}

-(void)clearView{
    _bankListArray  = nil;
    [_bgScrollView removeFromSuperview];
    for (UIView *view in _bgScrollView.subviews) {
        [view removeFromSuperview];
       
    }
    [_addBtn removeFromSuperview];
}
- (NSArray *)bankListArray
{
    if (!_bankListArray) {
        _bankListArray = [NSArray array];
    }
    return _bankListArray;
}
- (void)loadData{
    NSDictionary*diction=[[NSDictionary alloc]initWithObjectsAndKeys:[Global sharedClient].member_id, @"member_id",nil];
    [SVProgressHUD showWithStatus:@"正在加载中"];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"unionpay/UnionpayBindCard" tp:@"get_member_card_list"] parameters:diction target:self success:^(NSDictionary *dic) {
        NSLog(@"%@",dic);
        [SVProgressHUD dismiss];
        _bankListArray = dic[@"data"];
        [Global sharedClient].hasBankCard = YES;
        _result = [NSString stringWithFormat:@"%@",dic[@"result"]];
        dispatch_async(dispatch_get_main_queue(), ^{
           [self createView];
        });
       
        
    } failue:^(NSDictionary *dic) {
        NSLog(@"失败%@",dic[@"msg"]);
      
        [self createView];
       _result = [NSString stringWithFormat:@"%@",dic[@"result"]];
        if ([_result isEqualToString:@"-1"]) {
            [SVProgressHUD dismiss];
            [Global sharedClient].hasBankCard = NO;
        }else{
            [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
        }
        
    }];
}
- (void)createView
{
    _bgScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, WIN_WIDTH, WIN_HEIGHT-NAV_HEIGHT)];
    
    [self.view addSubview:_bgScrollView];
    _bgScrollView.showsVerticalScrollIndicator = NO;
    _bgScrollView.contentSize = CGSizeMake(WIN_WIDTH, _bankListArray.count*130+50);
    _bgScrollView.bounces = NO;
    if (_bankListArray.count ==0) {
        
        _addBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 80, WIN_WIDTH-30, 40)];
    }else{
    for (NSInteger i=0; i<_bankListArray.count; i++) {
       BankCardView *bankCardView = [[BankCardView alloc]initWithFrame:CGRectMake(15, 15+i*125, WIN_WIDTH-30, 110)];
        bankCardView.tag = i+2000;
       
        bankCardView.cardStyle = _bankListArray[i][@"card_type"];
        bankCardView.bankName = _bankListArray[i][@"card_name"];
         bankCardView.cardNo = _bankListArray[i][@"card_no"];
    
       bankCardView.bankImageUrl = _bankListArray[i][@"logo_url"];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToDeleteCard:)];
        [bankCardView addGestureRecognizer:tap];
        [_bgScrollView addSubview:bankCardView];
    }
    
    _addBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 15+_bankListArray.count*125, WIN_WIDTH-30, 40)];
    }
    [_addBtn setTitle:@"添加银行卡" forState:UIControlStateNormal];
    [_addBtn setTitleColor:RGBCOLOR(0, 135, 140) forState:UIControlStateNormal];
    [_addBtn addTarget: self action:@selector(clickToAdd:) forControlEvents:UIControlEventTouchUpInside];
    _addBtn.layer.borderWidth = 1;
    _addBtn.layer.cornerRadius = 5;
    _addBtn.layer.masksToBounds = YES;
    _addBtn.layer.borderColor = [UIColor colorWithRed:0 green:135/255.0 blue:140/255.0 alpha:1].CGColor;
    [_bgScrollView addSubview:_addBtn];
    
}
- (void)clickToDeleteCard:(UIGestureRecognizer *)tap
{
   
    BankCardView *bankCardView = (BankCardView *)tap.view;
    NSInteger num = bankCardView.tag-2000;
    DeleBankCardController *delVc = [[DeleBankCardController alloc]init];
    delVc.bankName = _bankListArray[num][@"card_name"];
    delVc.bankImageUrl = _bankListArray[num][@"logo_url"];
    delVc.cardType = _bankListArray[num][@"card_type"];
    delVc.cardNo = _bankListArray[num][@"card_no"];
    delVc.ides = _bankListArray[num][@"ides"];
    delVc.dayAmount = [NSString stringWithFormat:@"%@",_bankListArray[num][@"day_pay_limit"]] ;
    delVc.timeAmount =[NSString stringWithFormat:@"%@",_bankListArray[num][@"limit_without_password"]] ;
    [self.navigationController pushViewController:delVc animated:YES];
    
}
- (void)clickToAdd:(UIButton *)sender{
   
    if ([_result isEqualToString:@"-1"]) {
        AddBankCardController *addVc = [[AddBankCardController alloc]init];
        [self.navigationController pushViewController:addVc animated:YES];
      
    }else{
      ResetPasswordViewController *resetVc= [[ResetPasswordViewController alloc]init];
        resetVc.type = 2;
        [self.navigationController pushViewController:resetVc animated:YES];
    }
   
}


@end
