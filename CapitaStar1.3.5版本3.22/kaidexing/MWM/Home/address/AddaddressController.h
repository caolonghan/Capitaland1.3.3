//
//  AddaddressController.h
//  kaidexing
//
//  Created by 朱巩拓 on 16/5/14.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "BaseViewController.h"
#import "ExpressView.h"

@interface AddaddressController : BaseViewController<expressViewTouch>

@property (strong,nonatomic)NSString               *nameStr;
@property (strong,nonatomic)NSString               *shengfenidStr;//省份
@property (strong,nonatomic)NSString               *chengshiidStr;//城市
@property (strong,nonatomic)NSString               *diquidStr;//地区
@property (strong,nonatomic)NSString               *xiangxiStr;//详细地址
@property (strong,nonatomic)NSString               *youzhengStr;//邮编
@property (strong,nonatomic)NSString               *shoujihaoStr;//手机号
@property (strong,nonatomic)NSString               *youxiang_str;//邮箱
@property (strong,nonatomic)NSString               *is_jieshouStr;//是否接受订单信息
@property (strong,nonatomic)NSString               *is_morenStr;//是否为默认
@property (strong,nonatomic)NSString               *typeStr;//id

@end
