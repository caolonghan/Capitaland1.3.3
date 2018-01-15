//
//  DateUtil.m
//  ABAS
//
//  Created by dwolf on 16/6/13.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "DateUtil.h"

@implementation DateUtil

+(NSString*) stringFromDate:(NSDate *)date format:(NSString *)format{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:date];
}

+(NSString*) stringDateFromString:(NSString *)dateStr format:(NSString *)format toFormat:(NSString *)toFormat{
    NSDate* date = [DateUtil dateFromstring:dateStr format:format];

    return [DateUtil stringFromDate:date format:toFormat];
}

+(NSDate*) dateFromstring:(NSString *)dateStr format:(NSString *)format{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter dateFromString:dateStr];
}

+(NSString*) getNowStr:(NSString *)format{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:[NSDate new]];
}

+(NSDate*) getTheFirstDayOfMon:(NSDate*) date{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *dateOut = [NSDate date];
    [cal rangeOfUnit:NSMonthCalendarUnit startDate:&dateOut interval:nil forDate:date];
    return dateOut;
}

+(int) getWeekDay:(NSDate*) date{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *weekdayComponents =
    [gregorian components:NSWeekdayCalendarUnit fromDate:date];
    int weekday = [[NSNumber numberWithInteger:[weekdayComponents weekday]] intValue];
    NSLog(@"%d",weekday);
    return weekday;
}

+ (NSString*) getWeekdayFromDate:(NSDate*)date
{
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents* components = [[NSDateComponents alloc] init];
    
    NSInteger unitFlags = NSYearCalendarUnit |
    
    NSMonthCalendarUnit |
    
    NSDayCalendarUnit |
    
    NSWeekdayCalendarUnit |
    
    NSHourCalendarUnit |
    
    NSMinuteCalendarUnit |
    
    NSSecondCalendarUnit;
    
    
    components = [calendar components:unitFlags fromDate:date];
    
    NSUInteger weekday = [components weekday];
    switch (weekday) {
        case 1:
            return @"周日";
        case 2:
            return @"周一";
        case 3:
            return @"周二";
        case 4:
            return @"周三";
        case 5:
            return @"周四";
        case 6:
            return @"周五";
        case 7:
            return @"周六";
        default:
            return @"";
            break;
    }
    
}


+(NSString *)isTodayOrYesterday:(NSDate *)date{
    
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:[NSDate date]];
    NSDate *today = [cal dateFromComponents:components];
    components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:date];
    NSDate *otherDate = [cal dateFromComponents:components];
    if([today isEqualToDate:otherDate]) {
        return @"今天";
    }
    
    today = [NSDate date];
    NSDate * yesterday = [NSDate dateWithTimeIntervalSinceNow:-86400];
    NSDate * refDate = date;
    
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    NSString * refDateString = [[refDate description] substringToIndex:10];
    
    if ([refDateString isEqualToString:todayString])
    {
        return @"今天";
    } else if ([refDateString isEqualToString:yesterdayString])
    {
        return @"昨天";
    }
    return nil;
}


+(int) getNumberOfDaysOneMonth:(NSDate*)date{
    NSDate* calDate;
    if(date == nil){
        calDate = [[NSDate alloc] init];
    }else{
        calDate = date;
    }
    NSCalendar *calender = [NSCalendar currentCalendar];
    
    
    
    NSDateComponents *comps =[calender components:(NSYearCalendarUnit | NSMonthCalendarUnit |NSDayCalendarUnit | NSWeekCalendarUnit)
                              
                                         fromDate:calDate];
    
    [comps setMonth:[comps month]];
    
    NSRange range = [calender rangeOfUnit:NSDayCalendarUnit
                     
                                   inUnit: NSMonthCalendarUnit
                     
                                  forDate: [calender dateFromComponents:comps]];
    
    return [[NSNumber numberWithUnsignedInteger: range.length] intValue];
}


+(BOOL)isCurrentWeek:(NSDate *)date{
    
    
    NSDate *start;
    
    NSTimeInterval extends;
    
    NSCalendar *cal=[NSCalendar autoupdatingCurrentCalendar];
    
    [cal setFirstWeekday:2];//一周的第一天设置为周一
    
    NSDate *today=[NSDate date];
    
    BOOL success= [cal rangeOfUnit:NSWeekCalendarUnit startDate:&start interval: &extends forDate:today];
    
    if(!success)
        return NO;
    NSTimeInterval dateInSecs = [date timeIntervalSinceReferenceDate];
    
    NSTimeInterval dayStartInSecs= [start timeIntervalSinceReferenceDate];
    
    
    
    if(dateInSecs >= dayStartInSecs && dateInSecs < (dayStartInSecs+extends)){
        
        return YES;
    }else {
        return NO;
        
    }
}

+(NSString*) beautifyTime:(NSString*) timeStr{
    return [self beautifyTime:timeStr onlyDate:NO];
}
+(NSString*) beautifyTime:(NSString*) timeStr onlyDate:(BOOL) onlyDate{
    if(!timeStr){
        return @"";
    }
    
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    
    
    
    NSDate* date = [formater dateFromString:timeStr];
    if(onlyDate){
        [formater setDateFormat:@"yyyy-MM-dd"];
        return [formater stringFromDate:date];
    }
    return [DateUtil compareCurrentTime:date];
}

/**
 * 计算指定时间与当前的时间差
 * @param compareDate   某一指定时间
 * @return 多少(秒or分or天or月or年)+前 (比如，3天前、10分钟前)
 */
+(NSString *) compareCurrentTime:(NSDate*) compareDate
//
{
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    int temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%d分钟前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%d小时前",temp];
    }
    
    else if((temp = temp/24) < 7){
        result = [NSString stringWithFormat:@"%d天前",temp];
    }else{
        NSDateFormatter* formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyy-MM-dd"];
        result = [formater stringFromDate:compareDate];
    }
    
    return  result;
}

+ (NSInteger)diffDate:(NSDate *)startDate endDate:(NSDate *)endDate
{
    
    return (startDate.timeIntervalSince1970 - endDate.timeIntervalSince1970) / 60 /60 /24;
}


@end
