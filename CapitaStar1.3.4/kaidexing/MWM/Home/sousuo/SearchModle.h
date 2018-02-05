//
//  SearchModle.h
//  kaidexing
//
//  Created by 朱巩拓 on 16/5/17.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchModle : NSObject


@property (nonatomic,copy)NSString          *logoStr;//图
@property (nonatomic,copy)NSString          *shop_name;//名字
@property (nonatomic,copy)NSString          *type_name;//类型名
@property (nonatomic,copy)NSString          *shop_id;//id
@property (nonatomic,copy)NSString          *queue_status;//排
@property (nonatomic,copy)NSString          *sale_status;//促
@property (nonatomic,copy)NSString          *coupon_status;//券
@property (nonatomic,copy)NSString          *floor_name;//地址




+(NSMutableArray *)searchFoodModelArray:(NSDictionary *)searDic;//食物解析


@end
