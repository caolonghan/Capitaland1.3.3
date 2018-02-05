//
//  Request.m
//  TestGameDemo
//
//  Created by 樊金龙 on 2017/3/6.
//  Copyright © 2017年 jinchangwang. All rights reserved.


#define shopDetails @"http://lbsapi.rtmap.com/rtmap_lbs_api/v1/rtmap/get_poi_attr"
#define preferentialShop @"http://lbsapi.rtmap.com/rtmap_lbs_api/v1/rtmap/get_recommendedstore"
#define buryingPoint @"http://lbsapi.rtmap.com/rtmap_lbs_api/v1/rtmap/burying_Point"
#define basicclassification @"http://lbsapi.rtmap.com/rtmap_lbs_api/v1/rtmap/build_basicclassification"
#define classification @"https://lbsapi.rtmap.com/rtmap_lbs_api/v1/search_classification"
#define buided_tours @"http://lbsapi.rtmap.com/rtmap_lbs_api/v1/rtmap/guided_tours"

#import "RTMARRequest.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@implementation RTMARRequest
+(void)POSTWithParameters:(NSDictionary *) parameters
         AndRequestPolicy:(RTMARRequestPolicy) policy AndBlock:(void(^)(id result, NSError * error)) block{
    NSURL * url = [NSURL URLWithString:[RTMARRequest urlWithPolicy:policy]];
    NSMutableURLRequest *requst = [[NSMutableURLRequest alloc]initWithURL:url];
    requst.HTTPMethod = @"POST";
    NSData * data = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    requst.HTTPBody = data;
    requst.timeoutInterval = 5;
    
    [NSURLConnection sendAsynchronousRequest:requst queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError) {
            block(nil,connectionError);
        }else{
            id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&connectionError];
            
            if (connectionError) {
                block(nil,connectionError);
            }else {
                block(object,nil);
            }
        }
    }];
}

+(void)POSTWithData:(NSData *) data
   AndRequestPolicy:(RTMARRequestPolicy) policy AndBlock:(void(^)(id result, NSError * error)) block {
    NSURL * url = [NSURL URLWithString:[RTMARRequest urlWithPolicy:policy]];
    NSMutableURLRequest *requst = [[NSMutableURLRequest alloc]initWithURL:url];
    requst.HTTPMethod = @"POST";
    requst.HTTPBody = data;
    requst.timeoutInterval = 5;
    
    [NSURLConnection sendAsynchronousRequest:requst queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError) {
            block(nil,connectionError);
        }else{
            id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&connectionError];
            
            if (connectionError) {
                block(nil,connectionError);
            }else {
                block(object,nil);
            }
        }
    }];
}


+(NSString *)urlWithPolicy:(RTMARRequestPolicy)policy{
    NSString * urlStr = @"";
    switch (policy) {
        case RequestShopDetails:
            return shopDetails;
        case RequestPreferentialShop:
            return preferentialShop;
        case RequestBuryingPoint:
            return buryingPoint;
        case RequestBasicclassification:
            return basicclassification;
        case RequestClassification:
            return classification;
        case RequestNavigationRoute:
            return buided_tours;
        default:
            break;
    }
    return urlStr;
}





@end
