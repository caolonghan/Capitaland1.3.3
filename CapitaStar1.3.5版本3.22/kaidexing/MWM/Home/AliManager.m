//
//  AliManager.m
//  meirile
//
//  Created by 朱巩拓 on 16/9/1.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "AliManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "UIUtil.h"
#import "Util.h"
@implementation AliManager

+(instancetype)aliMsgOpenURL:(NSURL *)url{
    static AliManager *instance;
    
    if (![Util isNull:url]) {
        [instance setAlidata :url];
    }
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
          instance = [[AliManager alloc] init];
        });
    return instance;
}
-(void)setAlidata:(NSURL *)url{
    // 支付跳转支付宝钱包进行支付，处理支付结果
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        NSLog(@"result = %@",resultDic);
        NSInteger orderState=[resultDic[@"resultStatus"] integerValue];
        
        if (orderState==9000) {
            
            if (_aiDelegate && [_aiDelegate respondsToSelector:@selector(setAliMsg:)]) {
                [_aiDelegate setAliMsg:@"9000"];
            }
        }else{
            NSString *returnStr;
            switch (orderState) {
                case 8000:
                    returnStr=@"订单正在处理中";
                    if (_aiDelegate && [_aiDelegate respondsToSelector:@selector(setAliMsg:)]) {
                        [_aiDelegate setAliMsg:@"8000"];
                    }
                    break;
                case 4000:
                    returnStr=@"订单支付失败";
                    if (_aiDelegate && [_aiDelegate respondsToSelector:@selector(setAliMsg:)]) {
                        [_aiDelegate setAliMsg:@"4000"];
                    }
                    break;
                case 6001:
                    returnStr=@"订单取消";
                    if (_aiDelegate && [_aiDelegate respondsToSelector:@selector(setAliMsg:)]) {
                        [_aiDelegate setAliMsg:@"6001"];
                    }
                    break;
                case 6002:
                    returnStr=@"网络连接出错";
                    if (_aiDelegate && [_aiDelegate respondsToSelector:@selector(setAliMsg:)]) {
                        [_aiDelegate setAliMsg:@"6002"];
                    }
                    break;
                    
                default:
                    break;
            }
        }
    }];
    
    // 授权跳转支付宝钱包进行支付，处理支付结果
    [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
        NSLog(@"result = %@",resultDic);
        NSInteger orderState=[resultDic[@"resultStatus"] integerValue];
        
        if (orderState==9000) {
            if (_aiDelegate && [_aiDelegate respondsToSelector:@selector(setAliMsg:)]) {
                [_aiDelegate setAliMsg:@"9000"];
            }
        }else{
            NSString *returnStr;
            switch (orderState) {
                case 8000:
                    returnStr=@"订单正在处理中";
                    if (_aiDelegate && [_aiDelegate respondsToSelector:@selector(setAliMsg:)]) {
                        [_aiDelegate setAliMsg:@"8000"];
                    }
                    break;
                case 4000:
                    returnStr=@"订单支付失败";
                    if (_aiDelegate && [_aiDelegate respondsToSelector:@selector(setAliMsg:)]) {
                        [_aiDelegate setAliMsg:@"4000"];
                    }
                    break;
                case 6001:
                    returnStr=@"订单取消";
                    if (_aiDelegate && [_aiDelegate respondsToSelector:@selector(setAliMsg:)]) {
                        [_aiDelegate setAliMsg:@"6001"];
                    }
                    break;
                case 6002:
                    returnStr=@"网络连接出错";
                    if (_aiDelegate && [_aiDelegate respondsToSelector:@selector(setAliMsg:)]) {
                        [_aiDelegate setAliMsg:@"6002"];
                    }
                    break;
                    
                default:
                    break;
            }
        }
    }];
}



@end
