//
//  Request.h
//  TestGameDemo
//
//  Created by 樊金龙 on 2017/3/6.
//  Copyright © 2017年 jinchangwang. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum :NSInteger{
    RequestShopDetails = 0,
    RequestPreferentialShop,
    RequestBuryingPoint,
    RequestBasicclassification,
    RequestClassification,
    RequestNavigationRoute
}RTMARRequestPolicy;

@interface RTMARRequest : NSObject
+(void)POSTWithParameters:(NSDictionary *) parameters
         AndRequestPolicy:(RTMARRequestPolicy) policy AndBlock:(void(^)(id result, NSError * error)) block;

+(void)POSTWithData:(NSData *) data
         AndRequestPolicy:(RTMARRequestPolicy) policy AndBlock:(void(^)(id result, NSError * error)) block;


@end
