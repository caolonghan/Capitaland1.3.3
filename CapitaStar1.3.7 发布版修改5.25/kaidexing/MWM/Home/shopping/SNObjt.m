//
//  SNObjt.m
//  sgSalerReport
//
//  Created by 朱巩拓 on 16/5/5.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "SNObjt.h"
#import <CommonCrypto/CommonDigest.h>
@implementation SNObjt


+(NSString *)initSN1_SN6:(NSString *)dateStr :(NSString *)suijiStr :(NSString *)tpStr
{
    NSArray *ary=[[NSArray alloc]initWithObjects:dateStr,suijiStr,tpStr, nil];
    NSArray *array= [ary sortedArrayUsingSelector:@selector(compare:)];//排序
    NSString  *string1=[NSString stringWithFormat:@"%@^%@^%@",array[0],array[1],array[2]];
    NSLog(@"str--------------------%@",string1);

    
    const char *cStr1 = [string1 UTF8String];
    unsigned char result1[16];
    CC_MD5(cStr1, (CC_LONG)strlen(cStr1), result1);
    // 小写 x 表示输出的是小写 MD5 ，大写 X 表示输出的是大写 MD5
    NSString *string2= [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",result1[0], result1[1], result1[2], result1[3],
            result1[4], result1[5], result1[6], result1[7],
            result1[8], result1[9], result1[10], result1[11],
            result1[12], result1[13], result1[14], result1[15]
            ];
    
    NSMutableString *string3=[[NSMutableString alloc]initWithString:string2];
    [string3 insertString:@"Companycn" atIndex:10];
    
    
    const char *cStr = [string3 UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    // 小写 x 表示输出的是小写 MD5 ，大写 X 表示输出的是大写 MD5
    NSString *string4= [NSString stringWithFormat:
                        @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                        result[0], result[1], result[2], result[3],
                        result[4], result[5], result[6], result[7],
                        result[8], result[9], result[10], result[11],
                        result[12], result[13], result[14], result[15]
                        ];
    
    
    
    NSString *str=string4;
    NSLog(@"str--------------------%@",str);
    return str;
}



@end
