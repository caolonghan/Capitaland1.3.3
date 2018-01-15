//
//  MJSONModel.m
//  EAM
//
//  Created by dwolf on 16/6/27.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "MJSONModel.h"

@implementation MJSONModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"description": @"desc",@"id":@"ids"}];
}
@end
