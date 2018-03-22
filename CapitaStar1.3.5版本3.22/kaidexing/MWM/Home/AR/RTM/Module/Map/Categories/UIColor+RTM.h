//
//  UIColor+RTM.h
//  Rtlbs3DMapDemo
//

//  Copyright © 2017年 wang jinchang. All rights reserved.
//

#import <UIKit/UIKit.h>

// 十六进制转换RGB
#define UIColorFromHex(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface UIColor (RTM)

+ (UIColor *)colorFor333333;
+ (UIColor *)colorForEEEEEE;
+ (UIColor *)colorForD7D9DA;
+ (UIColor *)colorForFF5252;
+ (UIColor *)colorForDBDBDB;
@end
