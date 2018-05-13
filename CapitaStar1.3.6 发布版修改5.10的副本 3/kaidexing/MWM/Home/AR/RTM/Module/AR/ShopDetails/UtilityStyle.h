//
//  Utilities.h
//  RtmapCustomer
//
//  Created by 李凯 on 15/1/16.
//  Copyright (c) 2015年 ZhaoChenHong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
@interface UtilityStyle : NSObject


/**
 *  去掉列表多余的分割线
 *
 *  @param tableView 要设置的tableView
 */
+(void)cutExtraSeparator:(UITableView *)tableView;

/*!
@method
@abstract  TextField 添加圆角
@discussion null。
@result void
*/
+(void) setTextFieldBorder:(UITextField *)filed;
/*!
 @method
 @abstract  代码适配界面
 @discussion null。
 @result void
 */
+(void) scaleUIView:(UIView *) view FromDesignModel:(NSString *) model;
/*!
 @method
 @abstract  获取设备型号
 @discussion null。
 @result void
 */
+(NSString *)currentDeviceModel;


+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

// 判断手机电话号 是否正确
+(BOOL)compareIphoneNumber:(NSString*)iphone;

/*!
 @method
 @abstract  时间戳转换时间格式
 @discussion null。
 @result void
 */
+ (NSString *)transformDateToTimeStringWithDate:(NSInteger)date WithFormat:(NSString *)formatString;


+ (NSString *)transformTimeStringFormatWithdateString:(NSString *)dateString WithOriginalFormat:(NSString *)oriFormat  withTargetFormat:(NSString *)tarFormat;


// 计算两个时间的差
+ (BOOL)CalculationTimeDifferenceStartTime:(NSString*)startTime;

// 计算亮点间的距离
+ (float) calculationDistanceFirstPoint:(CGPoint)point1 secondPoint:(CGPoint)point2;

//对图片尺寸进行压缩--
+(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

+ (void)callPhone:(NSString *) phoneNumber;
@end
