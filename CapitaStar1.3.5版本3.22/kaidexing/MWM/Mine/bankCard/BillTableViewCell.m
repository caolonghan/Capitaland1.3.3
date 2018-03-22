//
//  BillTableViewCell.m
//  kaidexing
//
//  Created by companycn on 2018/3/8.
//  Copyright © 2018年 dwolf. All rights reserved.
//

#import "BillTableViewCell.h"

@implementation BillTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
   
}
//- (void)setBillDic:(NSDictionary *)billDic
//{
//    _billDic = billDic;
//    self.payLabel.text = [NSString stringWithFormat:@"支出%@  收入%@",_billDic[@"origTxnAmt"],_billDic[@""]];
//    
//    NSString *shopStr = _billDic[@"shopName"];
//    NSArray *shopArr = [shopStr componentsSeparatedByString:@"|"];
//    self.companyLabel.text =shopArr.lastObject;
//    
//    self.timeLabel.text = _billDic[@"add_time"];
//    
//    self.moneyLabel.text =_billDic[@"origTxnAmt"];
//    
//    self.saleLabel.text = _billDic[@""];
//    if ([_billDic[@"respMsg"] isEqualToString:@"成功"]) {
//        self.payStyleLabel.text = @"支付成功";
//        self.payStyleLabel.textColor = [UIColor colorWithRed:0 green:135/255.0 blue:140/255.0 alpha:1];
//        
//    }else
//    {
//        self.payStyleLabel.textColor = [UIColor redColor];
//        self.payStyleLabel.text = @"支付失败";
//    }
//    
//}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
