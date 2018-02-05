//
//  SearchModle.m
//  kaidexing
//
//  Created by 朱巩拓 on 16/5/17.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "SearchModle.h"

@implementation SearchModle



+(NSArray *)searchFoodModelArray:(NSDictionary *)searDic
{
    NSMutableArray *dataArray=[[NSMutableArray alloc]init];
    
    NSArray *array=searDic[@"data"][@"foodlist"];
    for (NSDictionary *dic in array) {
       SearchModle *model   =[[SearchModle alloc]init];
        model.logoStr       =dic[@"logo_img_url"];
        model.shop_name     =dic[@"shop_name"];
        model.type_name     =dic[@"type_name"];
        model.shop_id       =dic[@"shop_id"];
        model.queue_status  =dic[@"queue_status"];
        model.sale_status   =dic[@"sale_status"];
        model.coupon_status =dic[@"coupon_status"];
        model.floor_name    =dic[@"floor_name"];
        [dataArray addObject:model];
        
    }
    return dataArray;
}

@end
