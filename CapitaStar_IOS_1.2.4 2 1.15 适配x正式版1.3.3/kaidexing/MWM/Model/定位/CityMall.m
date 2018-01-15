//
//  CityMall.m
//  kaidexing
//
//  Created by dwolf on 2017/5/27.
//  Copyright © 2017年 dwolf. All rights reserved.
//

#import "CityMall.h"

@implementation CityMall
+ (Class)classForCollectionProperty:(NSString *)propertyName{
    if([propertyName isEqualToString:@"mall_list"]){
        return [MallInfoModel class];
    }
    return nil;
}
@end
