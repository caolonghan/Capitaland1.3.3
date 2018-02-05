//
//  ScreenViewController.h
//  kaidexing
//
//  Created by 朱巩拓 on 2016/10/26.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "BaseViewController.h"
@protocol screeViewDelegate <NSObject>

-(void)setScreeViewValue:(id)val;

@end

@interface ScreenViewController : BaseViewController{
}

@property (strong,nonatomic)NSString  *typeStr;//进入的是那种类型  0 是没有商场id进入的筛选  2 是美食筛选  3 是商城筛选 4优惠券筛选  5搜索未选择商城的
@property (strong,nonatomic)NSString  *vul_1;
@property (strong,nonatomic)NSString  *vul_2;
@property (strong,nonatomic)NSString  *vul_3;

@property (strong,nonatomic)NSString  *markID;//商场id

@property(assign,nonatomic)id<screeViewDelegate>screeDelegate;

@end
