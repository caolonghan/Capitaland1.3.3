//
//  PayDetailPopView.h
//  kaidexing
//
//  Created by companycn on 2018/3/8.
//  Copyright © 2018年 dwolf. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PayDetailPopViewDelegate<NSObject>
- (void)cancel;
- (void)chooseBank;
- (void)makeSurePay;
@end
@interface PayDetailPopView : UIView
@property (weak, nonatomic) IBOutlet UILabel *orderLabel;
@property (weak, nonatomic) IBOutlet UIButton *bankBtn;
@property (weak, nonatomic) IBOutlet UILabel *cutLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (nonatomic,strong)NSString *bankStyle;
@property (nonatomic,strong)NSString *bankName;
@property (nonatomic,strong)NSString *couponInfo;
@property (nonatomic,strong)NSString *money;
@property (nonatomic,weak)id<PayDetailPopViewDelegate>delegate;
+(instancetype)createView;
@end
