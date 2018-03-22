//
//  ConfirmPaymentView.h
//  kaidexing
//
//  Created by 朱巩拓 on 2016/12/25.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ConfirmPayDelegate <NSObject>

-(void)paymentEvent:(id)vul; //vul为nil时，是关闭支付界面


@end

@interface ConfirmPaymentView : UIView

@property(assign,nonatomic)id<ConfirmPayDelegate>cDelegate;

-(instancetype)initWithFrame:(CGRect)frame data:(NSDictionary*)dataDic;

@end
