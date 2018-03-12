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
@interface AddBankCardController ()
@property (nonatomic,strong)UITextField *textField;
@property (nonatomic,strong)NSString *cardName;
@property (nonatomic,strong)NSString *cardNum;

@end

@implementation AddBankCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarTitleLabel.text = @"添加银行卡";
    [self createView];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}
- (void)createView
{
    
        UILabel *titleLabel= [[UILabel alloc]initWithFrame:CGRectMake(20, NAV_HEIGHT, WIN_WIDTH-10, 44)];
        [self.view addSubview:titleLabel];
        titleLabel.text = @"为保证您的资金安全，请绑定账号本人的银行卡";
        titleLabel.font = COMMON_FONT;
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame), WIN_WIDTH, 44)];
        bgView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:bgView];
    if (_isfirstBindCard == YES) {
    
        UILabel *cardLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, bgView.height/2-10, 60, 21)];
        cardLabel.text = @"卡 号";
        [bgView addSubview:cardLabel];
        
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(cardLabel.frame), CGRectGetMinY(cardLabel.frame), WIN_WIDTH-cardLabel.width, cardLabel.height)];
        
        [bgView addSubview:_textField];
        NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
        attrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
        _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"无需网银/免手续费" attributes:attrs];
    }else{
        bgView.frame = CGRectMake(0, CGRectGetMaxY(titleLabel.frame), WIN_WIDTH, 88) ;
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, bgView.height/4-10, 60, 21)];
        nameLabel.text = _cardholderName;
        [bgView addSubview:nameLabel];
        UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame), CGRectGetMinY(nameLabel.frame), WIN_WIDTH-nameLabel.width, nameLabel.height)];
        name.text = @"";
        [bgView addSubview:name];
        
        UILabel *cardLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(nameLabel.frame)+10, 60, 21)];
        cardLabel.text = @"卡 号";
        [bgView addSubview:cardLabel];
        
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(cardLabel.frame), CGRectGetMinY(cardLabel.frame), WIN_WIDTH-cardLabel.width, cardLabel.height)];
        
        [bgView addSubview:_textField];
        NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
        attrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
        _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"无需网银/免手续费" attributes:attrs];
    }
        UIButton *nextBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 300, WIN_WIDTH-20, 44)];
        [self.view addSubview:nextBtn];
        [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [nextBtn setBackgroundColor:[UIColor colorWithRed:114/255.0 green:220/255.0 blue:213/255.0 alpha:1]];
        nextBtn.layer.masksToBounds = YES;
        nextBtn.layer.cornerRadius = 3;
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
    NSDictionary*diction=[[NSDictionary alloc]initWithObjectsAndKeys:[Global sharedClient].member_id, @"member_id",DESCard,@"card_no",nil];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"unionpay/UnionpayBindCard" tp:@"is_member_card_bind"] parameters:diction target:self success:^(NSDictionary *dic) {
        NSLog(@"%@",dic);
        dispatch_async(dispatch_get_main_queue(), ^{
           
            
       });
        
    } failue:^(NSDictionary *dic) {
        NSLog(@"失败%@",dic[@"msg"]);
       
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
            if (_isfirstBindCard) {
                _cardName = dic[@"data"][@"bankName"];
                CardInfoViewController *cardInfoVc = [[CardInfoViewController alloc]init];
                cardInfoVc.cardName = _cardName;
                cardInfoVc.cardNum = _cardNum;
                cardInfoVc.customerInfo = dic[@"data"][@"customerInfo"];
                [self.navigationController pushViewController:cardInfoVc animated:YES];
            }else{
            _cardName = dic[@"data"][@"bankName"];
            NotFirstBankInfoController *cardInfoVc = [[NotFirstBankInfoController alloc]init];
            cardInfoVc.cardName = _cardName;
            cardInfoVc.cardNum = _cardNum;
            cardInfoVc.cardType = _cardType;
            cardInfoVc.customerInfo = dic[@"data"][@"customerInfo"];
            cardInfoVc.cardHolderId = _cardHolderId;
            [self.navigationController pushViewController:cardInfoVc animated:YES];
            }
        });
        
    } failue:^(NSDictionary *dic) {
        NSLog(@"失败%@",dic[@"data"][@"respMsg"]);
       
    }];
}



@end
