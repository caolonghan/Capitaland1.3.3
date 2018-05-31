//
//  SuccessLockingController.h
//  kaidexing
//
//  Created by 朱巩拓 on 16/7/9.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "BaseViewController.h"
#import "WXApiManager.h"
#import "AliManager.h"

@interface SuccessLockingController : BaseViewController<WXApiManagerDelegate,AlimsgDelegata>

@property (strong,nonatomic)NSString   *park_id;//id?
@property (strong,nonatomic)NSString   *car_no;
@end
