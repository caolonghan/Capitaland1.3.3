//
//  AddBankCardController.m
//  kaidexing
//
//  Created by companycn on 2018/3/7.
//  Copyright © 2018年 dwolf. All rights reserved.
//

#import "AddBankCardController.h"
#import "CardInfoViewController.h"
#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"
#import "DES.h"
#import "NotFirstBankInfoController.h"
#import "BindCardWebViewController.h"
#import "BankCardViewController.h"


@interface AddBankCardController ()
@property (nonatomic,strong)UITextField *textField;
@property (nonatomic,strong)NSString *cardName;
@property (nonatomic,strong)NSString *cardNum;

@end

@implementation AddBankCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarTitleLabel.text = @"添加银行卡";
    self.navigationBarTitleLabel.textColor = [UIColor whiteColor];
    [self createView];
    self.navigationBar.backgroundColor = RGBCOLOR(0, 135, 140);
}
-(void)redefineBackBtn{
    [self redefineBackBtn:[UIImage imageNamed:@"AR_back"] :CGRectMake(0, 0, 44,44)];
}
- (void)createView
{
    
        UILabel *titleLabel= [[UILabel alloc]initWithFrame:CGRectMake(20, NAV_HEIGHT, WIN_WIDTH-10, 44)];
        [self.view addSubview:titleLabel];
        titleLabel.text = @"请绑定持卡人本人的银行卡";
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = [UIColor lightGrayColor];
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame), WIN_WIDTH, 44)];
        bgView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:bgView];
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(20, 0, WIN_WIDTH-40, 1)];
    line1.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(20, bgView.height-1, WIN_WIDTH-40, 1)];
     line2.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [bgView addSubview:line1];
    [bgView addSubview:line2];
        UILabel *cardLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, bgView.height/2-10, 60, 21)];
        cardLabel.text = @"卡 号";
        [bgView addSubview:cardLabel];
        
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(cardLabel.frame), CGRectGetMinY(cardLabel.frame), WIN_WIDTH-cardLabel.width, cardLabel.height)];
        
        [bgView addSubview:_textField];
        NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
        attrs[NSForegroundColorAttributeName] = [UIColor groupTableViewBackgroundColor];
        _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"无需网银/免手续费" attributes:attrs];
    _textField.font = [UIFont systemFontOfSize:14];
    _textField.keyboardType = UIKeyboardTypeNumberPad;
   
        UIButton *nextBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 300, WIN_WIDTH-20, 44)];
        [self.view addSubview:nextBtn];
        [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [nextBtn setBackgroundColor:[UIColor colorWithRed:167/255.0 green:220/255.0 blue:220/255.0 alpha:1]];
        nextBtn.layer.masksToBounds = YES;
        nextBtn.layer.cornerRadius = 5;
        [nextBtn addTarget:self action:@selector(clickToNext) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)clickToNext
{
    _cardNum = _textField.text;
    NSLog(@"%@",_textField.text);
    
    if ([Util isNull: _cardNum]) {
        [SVProgressHUD showErrorWithStatus:@"卡号不能为空" duration:2];

        return;
    }
    [self loadData];
    

}
//判断卡是否绑定过
- (void)loadData
{

   
    NSString *DESCard = [DES encryptUseDES:_cardNum ];
    [SVProgressHUD show];
    NSDictionary*diction=[[NSDictionary alloc]initWithObjectsAndKeys:[Global sharedClient].member_id, @"member_id",DESCard,@"card_no",nil];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"unionpay/UnionpayBindCard" tp:@"is_member_card_bind"] parameters:diction target:self success:^(NSDictionary *dic) {
        NSLog(@"%@",dic);
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [SVProgressHUD showErrorWithStatus:@"该卡已绑定"];
       });
        
    } failue:^(NSDictionary *dic) {
        NSLog(@"失败%@",dic[@"msg"]);
        [SVProgressHUD dismiss];
            [self judgeCardInfo];
    }];
}
//获取卡信息
- (void)judgeCardInfo{
    
    NSString *DESCard = [DES encryptUseDES:_cardNum ];
    NSDictionary*diction=[[NSDictionary alloc]initWithObjectsAndKeys:[Global sharedClient].member_id, @"member_id",DESCard,@"card_no",nil];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"unionpay/UnionpayBindCard" tp:@"get_unionpay_card_info"] parameters:diction target:self success:^(NSDictionary *dic) {
        NSLog(@"%@",dic);
        dispatch_async(dispatch_get_main_queue(), ^{
 
                
                [self goToBindCard:dic[@"data"][@"phone"]];
          
        });
        
    } failue:^(NSDictionary *dic) {
        NSLog(@"失败%@",dic[@"data"][@"respMsg"]);
        [SVProgressHUD showErrorWithStatus:dic[@"data"][@"respMsg"]];
    }];
}

- (void)goToBindCard:(NSString *)phone{
    NSString *DESCard = [DES encryptUseDES:_cardNum ];
    NSDictionary*diction=[[NSDictionary alloc]initWithObjectsAndKeys:[Global sharedClient].member_id, @"member_id",DESCard,@"card_no",[DES encryptUseDES:phone ],@"cardholder_phone",nil];
    [SVProgressHUD show];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"unionpay/UnionpayBindCard" tp:@"bind_unionpay_card_lkink"] parameters:diction target:self success:^(NSDictionary *dic) {
        NSLog(@"%@",dic);
        [SVProgressHUD dismiss];
        dispatch_async(dispatch_get_main_queue(), ^{
            BindCardWebViewController *bindVc = [[BindCardWebViewController alloc]init];
            bindVc.BindHtmlStr = dic[@"data"];
            [self.navigationController pushViewController:bindVc animated:YES];
            
        });
        
    } failue:^(NSDictionary *dic) {
        [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
        NSLog(@"失败%@",dic[@"msg"]);
        
    }];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_textField resignFirstResponder];
}
@end
