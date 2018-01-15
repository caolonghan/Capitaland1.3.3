//
//  PFUIKit.m
//  HNGant-HaoLan
//
//  Created by jsyuchi on 15/6/29.
//  Copyright (c) 2015年 jsyuci. All rights reserved.
//

#import "PFUIKit.h"
#import "MenuButton.h"
#import "shaixuanButton.h"
// 把16进制的颜色转成UIColor对象
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@implementation PFUIKit
//有坐标，背景是张图片，有点击事件的btn
+(UIButton *)buttonWithFrame:(CGRect)frame image:(UIImage *)image target:(id)target acdaction:(SEL)action{
    UIButton * button = [UIButton buttonWithType: UIButtonTypeCustom];
    button.frame = frame;
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}
//圆角为5，有背景颜色，有字体颜色，有字体大小，有坐标，有点击事件的btn
+(UIButton *)buttonWithFrame:(CGRect)frame text:(NSString *)title font:(UIFont*)font backgroundColor:(UIColor *)color textColor:(UIColor *)textColor target:(id)target acdaction:(SEL)action{
    UIButton * button = [UIButton buttonWithType: UIButtonTypeCustom];
    button.frame = frame;
    button.layer.masksToBounds=YES;
    button.layer.cornerRadius = 5;
    button.backgroundColor = color;
    button.titleLabel.font=font;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:textColor forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;

}
//有背景颜色，有字体颜色，有字体大小，有坐标,有text，有对齐方式 1为左，2为右，3居中
+(UILabel *)labelWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont *)font textColor:(UIColor *)color textAlignment:(int)type{
    UILabel * label = [[UILabel alloc]initWithFrame:frame];
    label.text = text;
    label.font = font;
    if (type==1) {
        label.textAlignment = NSTextAlignmentLeft;
    }else if (type==2){
        label.textAlignment = NSTextAlignmentRight;
    }else if (type==3){
        label.textAlignment = NSTextAlignmentCenter;
    }
    label.textColor= color;
    return label;
}

+(UITextField *)textFiledWithFrame:(CGRect)frame placeholder:(NSString *)placeholder{
    UITextField * textField = [[UITextField alloc]initWithFrame:frame];
    textField.placeholder = placeholder;
    textField.font = [UIFont systemFontOfSize:14];
    textField.borderStyle = UITextBorderStyleNone;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    return textField;
}

//btn 上面是图片 下面是文字，定义文字大小，文字内容，文字颜色，背景颜色，点击事件，tag值及点击效果
+(UIButton *)buttonWithFrame:(CGRect)frame titlt:(NSString *)title image:(UIImage *)image bColor:(UIColor*)bColor tag:(NSInteger)tag tColor:(UIColor *)tColor font:(UIFont *)font target:(id)target acdaction:(SEL)action {
    MenuButton * button = [[MenuButton alloc]init];;
    [button setFrame:frame];
    [button setTag:tag];
     button.titleLabel.font=font;
    [button setTitleColor:tColor forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundColor:bColor];
    [button setTitleColor:UIColorFromRGB(0xededed) forState:UIControlStateHighlighted];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

//btn 外面是图片 里面是文字，定义文字大小，文字内容，文字颜色，背景颜色，点击事件，tag值及点击效果
+(UIButton *)buttonWithFrame_2:(CGRect)frame titlt:(NSString *)title image:(UIImage *)image selectImage:(UIImage *)selectImage bColor:(UIColor*)bColor tag:(NSInteger)tag tColor:(UIColor *)tColor stateTColor:(UIColor *)stateTColor font:(UIFont *)font target:(id)target acdaction:(SEL)action {
    shaixuanButton * button = [[shaixuanButton alloc]init];;
    [button setFrame:frame];
    [button setTag:tag];
    button.titleLabel.font=font;
    [button setTitleColor:tColor forState:UIControlStateNormal];
    [button setTitleColor:stateTColor forState:UIControlStateSelected];
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundColor:bColor];
    [button setTitleColor:UIColorFromRGB(0xededed) forState:UIControlStateHighlighted];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:selectImage forState:UIControlStateSelected];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

@end
