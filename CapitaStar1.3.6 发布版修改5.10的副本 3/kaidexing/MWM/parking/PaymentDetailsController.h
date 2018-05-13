//
//  PaymentDetailsController.h
//  kaidexing
//
//  Created by 朱巩拓 on 16/7/2.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "BaseViewController.h"
#import "AliManager.h"

@interface PaymentDetailsController : BaseViewController<AlimsgDelegata>

@property (strong,nonatomic)NSString  *car_no;
@property (strong,nonatomic)NSString  *mall_id;
@property (strong,nonatomic)NSString  *parkID;

@end
