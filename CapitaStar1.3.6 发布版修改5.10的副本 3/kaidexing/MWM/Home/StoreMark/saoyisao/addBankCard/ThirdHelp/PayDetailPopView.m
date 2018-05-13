//
//  PayDetailPopView.m
//  kaidexing
//
//  Created by companycn on 2018/3/8.
//  Copyright © 2018年 dwolf. All rights reserved.
//

#import "PayDetailPopView.h"

@implementation PayDetailPopView

+(instancetype)createView{
    return [[NSBundle mainBundle]loadNibNamed:@"PayDetailPopView" owner:self options:nil][0];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.orderLabel.text = _bankStyle;
    self.moneyLabel.text = [NSString stringWithFormat:@"%@元",_money];
    [self.bankBtn setTitle:_bankName forState:UIControlStateNormal];
    self.cutLabel.text = _couponInfo;
    self.backgroundColor = [UIColor whiteColor];
}

//- (void)setBankStyle:(NSString *)bankStyle
//{
//    _bankStyle = bankStyle;
//     self.orderLabel.text = _bankStyle;
//}
//- (void)setMoney:(NSString *)money{
//    _money = money;
//    self.moneyLabel.text = _money;
//    
//}
//- (void)setBankName:(NSString *)bankName
//{
//    _bankName = bankName;
//     [self.bankBtn setTitle:_bankName forState:UIControlStateNormal];
//}
//- (void)setCouponInfo:(NSString *)couponInfo{
//    _couponInfo = couponInfo;
//     self.cutLabel.text = _couponInfo;
//}
- (IBAction)payTouch:(id)sender {
    [self.delegate makeSurePay];
}
- (IBAction)chooseBankTouch:(id)sender {
    [self.delegate chooseBank];
}
- (IBAction)cancelTouch:(id)sender {
    [self.delegate cancel];
    
}

@end
