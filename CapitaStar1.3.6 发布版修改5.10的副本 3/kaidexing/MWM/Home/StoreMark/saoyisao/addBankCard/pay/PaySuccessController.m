//
//  PaySuccessController.m
//  kaidexing
//
//  Created by companycn on 2018/3/8.
//  Copyright © 2018年 dwolf. All rights reserved.
//

#import "PaySuccessController.h"

@interface PaySuccessController ()

@end

@implementation PaySuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarTitleLabel.text = @"向商户付款";
    self.navigationBarTitleLabel.textColor = [UIColor whiteColor];
   
    self.navigationBar.backgroundColor = RGBCOLOR(0, 135, 140);
    [self createView];
}
- (void)createView
{
    [self.moneyLabel setAttributedText: [self changeLabelWithText:[NSString stringWithFormat:@"¥%@",_money]]];
    self.bankLabel.text = _bankName;
    
    if (_conponInfo) {
        _bgViewHeiht.constant = 284;
        UILabel *conponLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, _bgViewHeiht.constant-44, 80, 44)];
        conponLabel.text = @"优惠信息";
        conponLabel.textAlignment = NSTextAlignmentCenter;
        conponLabel.font = [UIFont systemFontOfSize:15];
        conponLabel.textColor = [UIColor lightGrayColor];
        [_bgView addSubview:conponLabel];
        
        UILabel *infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, _bgViewHeiht.constant-44, WIN_WIDTH-100, 44)];
        infoLabel.text = _conponInfo;
        infoLabel.font =[UIFont systemFontOfSize:15];
        infoLabel.textColor = [UIColor darkTextColor];
        infoLabel.textAlignment = NSTextAlignmentRight;
        [_bgView addSubview:infoLabel];
    }
}

-(NSMutableAttributedString*) changeLabelWithText:(NSString*)needText
{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:needText];
    UIFont *font = [UIFont systemFontOfSize:30];
    [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0,needText.length)];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:24] range:NSMakeRange(0,1)];
    
    return attrString;
}
-(void)redefineBackBtn{
    [self redefineBackBtn:[UIImage imageNamed:@"AR_back"] :CGRectMake(0, 0, 44,44)];
}
- (void)backBtnOnClicked:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
