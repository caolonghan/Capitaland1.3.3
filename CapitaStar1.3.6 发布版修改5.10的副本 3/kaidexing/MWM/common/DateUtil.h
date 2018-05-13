//
//  DateUtil.h
//  ABAS
//
//  Created by dwolf on 16/6/13.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DF_1 @"yyyyMMdd"
#define DF_2 @"yyyyMMddHHmmss"
#define DF_3 @"yyyy-MM-dd HH:mm:ss"
#define DF_4 @"yyyy/MM/dd HH:mm:ss"
#define DF_5 @"yyyy-MM-dd"
#define DF_6 @"yyyy/MM/dd"
#define DF_7 @"yyyy-MM-dd HH:mm:ss.SSS"
#define DF_8 @"yyyy/M/d HH:mm:ss"

@interface DateUtil : NSObject
//将日期转换成指定的格式字符串
+(NSString*) stringFromDate:(NSDate*) date format:(NSString*) format;
//将日期字符串转换成另外一种格式日期字符串
+(NSString*) stringDateFromString:(NSString *)dateStr format:(NSString *)format toFormat:(NSString *)toFormat;
//将指定的格式字符串日期转换成日期
+(NSDate*) dateFromstring:(NSString*) dateStr format:(NSString*) format;
//获取当前时间并且转换成指定格式字符串
+(NSString*) getNowStr:(NSString*) format;

//获取指定时间所在月的第一天
+(NSDate*) getTheFirstDayOfMon:(NSDate*) date;

//计算某天为星期几
+(int) getWeekDay:(NSDate*) date;

//获取某天为星期几，中文 格式为：周六
+ (NSString*) getWeekdayFromDate:(NSDate*)date;

//计算指定日期所在月的天数
+(int) getNumberOfDaysOneMonth:(NSDate*)date;

//判断某天是否是这个星期
+ (BOOL)isCurrentWeek:(NSDate *)date;

//计算某个时间是今天或者昨天 返回为中文：今天 昨天，如果都不是返回Nil
+ (NSString *)isTodayOrYesterday:(NSDate *)date;

//两个日期相差多少毫秒
+ (NSInteger)diffDate:(NSDate *)startDate endDate:(NSDate *)endDate;

//美化时间 得到刚刚，3分钟前等格式
+(NSString*) beautifyTime:(NSString*) timeStr;

//美化时间 得到刚刚，3分钟前等格式 如果onlyDate = true 则只会返回日期
+(NSString*) beautifyTime:(NSString*) timeStr onlyDate:(BOOL) onlyDate;
+(NSString *) compareCurrentTime:(NSDate*) compareDate;

@end
