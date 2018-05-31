//
//  PFUIKit.h
//  HNGant-HaoLan
//
//  Created by jsyuchi on 15/6/29.
//  Copyright (c) 2015年 jsyuci. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface PFUIKit : NSObject

//有坐标，背景是张图片，有点击事件的btn
+(UIButton *)buttonWithFrame:(CGRect)frame image:(UIImage *)image target:(id)target acdaction:(SEL)action;

//圆角为5，有背景颜色，有字体颜色，有字体大小，有坐标，有点击事件的btn
+(UIButton *)buttonWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont*)font backgroundColor:(UIColor *)color textColor:(UIColor *)textColor target:(id)target acdaction:(SEL)action;

//有背景颜色，有字体颜色，有字体大小，有坐标,有text，有对齐方式 1为左，2为右，3居中
+(UILabel *)labelWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont*)font textColor:(UIColor *)color textAlignment:(int)type;

//btn 上面是图片 下面是文字，定义文字大小，文字内容，文字颜色，背景颜色，点击事件，tag值及点击效果
+(UIButton *)buttonWithFrame:(CGRect)frame titlt:(NSString *)title image:(UIImage *)image bColor:(UIColor*)bColor tag:(NSInteger)tag  tColor:(UIColor*)tColor font:(UIFont*)font target:(id)target acdaction:(SEL)action;

//btn 外面是图片 里面是文字，背景图片，选中背景图片，定义文字大小，文字内容，文字颜色，选中文字颜色，背景颜色，点击事件，tag值及点击效果
+(UIButton *)buttonWithFrame_2:(CGRect)frame titlt:(NSString *)title image:(UIImage *)image selectImage:(UIImage *)selectImage bColor:(UIColor*)bColor tag:(NSInteger)tag tColor:(UIColor *)tColor stateTColor:(UIColor *)stateTColor font:(UIFont *)font target:(id)target acdaction:(SEL)action;


+(UITextField *)textFiledWithFrame:(CGRect)frame placeholder:(NSString *)placeholder;

+(UIButton*)buttonWithFrame:(CGRect)frame title:(NSString*)title tColors:(NSArray*)tColors images:(NSArray*)images tag:(NSInteger)tag target:(id)target action:(SEL)action;

@end
