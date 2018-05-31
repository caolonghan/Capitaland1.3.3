//
//  MyVoucherViewController.h
//  sgSalerReport
//
//  Created by YaoHuiQiu on 16/5/7.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "BaseViewController.h"


//我的卡券
@interface MyVoucherViewController : BaseViewController

@property(nonatomic, copy)NSString* coupon_type; //卡券类型（-1.查全部，0.代金券，1.抵用券，2.停车券）。
@property(nonatomic, copy)NSString * is_his; //是否过期（1.查已过期已使用，0查当前可用）。
@property(nonatomic, copy)NSString * pageSize;
@property(nonatomic, retain)UIView * tableFooterView;
@property(nonatomic, assign)BOOL isLookLast;

-(void) loadData:(NSString*) type;

@end
