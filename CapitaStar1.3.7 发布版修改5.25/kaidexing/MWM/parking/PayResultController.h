//
//  PayResultController.h
//  kaidexing
//
//  Created by 朱巩拓 on 16/7/2.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "BaseViewController.h"

@interface PayResultController : BaseViewController

@property (strong ,nonatomic)NSString   *typeStr;//0是现金    1是支付宝
@property (strong ,nonatomic)NSString   *couponreduce;//优惠减少
@property (strong ,nonatomic)NSString   *totalReduce;//折扣减少
@property (strong ,nonatomic)NSString   *fee;//剩余金额
@property (strong ,nonatomic)NSString   *car_no;//车牌

@property (strong ,nonatomic)NSString   *parkID;//车位预定ID

@end
