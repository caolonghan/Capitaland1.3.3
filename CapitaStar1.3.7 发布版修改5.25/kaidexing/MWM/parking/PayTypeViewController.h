//
//  PayTypeViewController.h
//  kaidexing
//
//  Created by 朱巩拓 on 2016/10/19.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "BaseViewController.h"
#import "AliManager.h"

@protocol payDelegate <NSObject>

-(void)setPayDelegateValue:(id)vul;

@end

@interface PayTypeViewController : BaseViewController<AlimsgDelegata>

@property (strong,nonatomic)NSString     *viewType;//那个界面进来的  0 返回上一层，1进入下一层
@property (strong,nonatomic)NSString     *park_id;
@property (strong,nonatomic)NSString     *car_no;
@property (strong,nonatomic)NSString     *moneyStr;//金额 分

@property (strong,nonatomic)NSString     *mall_id;//商场id
@property (strong,nonatomic)NSString     *payNo;//停车完成支付，校验时需要参数

@property (strong,nonatomic)NSDictionary *dataDic;//支付数据

@property (assign,nonatomic)id<payDelegate>pDelegate;

@end
