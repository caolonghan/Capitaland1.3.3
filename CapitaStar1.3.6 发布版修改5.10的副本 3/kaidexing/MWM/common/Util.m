//
//  Util.m
//  SurfingShare
//
//  Created by Hwang Kunee on 13-6-27.
//  Copyright (c) 2013年 Hwang Kunee. All rights reserved.
//

#import "Util.h"
#import "BaseViewController.h"
#import "XmlUtil.h"


@implementation Util

+ (NSDictionary*) logConfigDicFromPlist:(NSString*)name {
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:name ofType:@"plist"];
    NSDictionary *config = [NSDictionary dictionaryWithContentsOfFile:path];
    
    NSLog(@"%@配置数据--%@",name,config);
    return config;
}

+ (NSDictionary*) logInitConfig {
//    NSBundle *bundle = [NSBundle mainBundle];
//    NSString *path = [bundle pathForResource:@"config" ofType:@"plist"];
//    NSDictionary *config = [NSDictionary dictionaryWithContentsOfFile:path];
    
    //正式
NSDictionary * config = @{@"API_HOST":@"https://api.capitaland.com.cn/APP_API/",@"API_DOMAIN":@"capitaland.com.cn",@"Shopping_Mall":@"mall.capitaland.com.cn",@"HTTP_VIP":@"https://vip.capitaland.com.cn/",@"HTTP_S":@"https"};
    
    //PV测试
//NSDictionary * config = @{@"API_HOST":@"http://kdmallapipv.companycn.net/APP_API/",@"API_DOMAIN":@"companycn.net",@"Shopping_Mall":@"mallpv.companycn.net",@"HTTP_VIP":@"http://vippv.companycn.net/",@"HTTP_S":@"http"};
  // 测试
    //NSDictionary * config = @{@"API_HOST":@"http://kdmallapi.companycn.net/APP_API/",@"API_DOMAIN":@"companycn.net",@"Shopping_Mall":@"mallpv.companycn.net",@"HTTP_VIP":@"http://vippv.companycn.net/",@"HTTP_S":@"http"};
    
    return config;
 
}

+(void) markScore:(NSString*) type{
    if(![Util isNull:[Global sharedClient].sessionId]){
        NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
        [params setObject: type forKey:@"type"];
        [HttpClient requestWithMethodXML:@"POST" path:@"User_markScore.do" parameters:params target:nil success:^(GDataXMLElement *doc){
                NSString* scoreMsg = [XmlUtil getStringWithName:doc withName:@"//scoreMsg"];
                if(![Util isNull:scoreMsg]){
                  //  [SVProgressHUD showSuccessWithStatus:scoreMsg duration:1];
                }
            }
            failue:nil];
    }
    
}

+(NSString*) getDayOfMonth:(NSDate*) date{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"d";
    return [formatter stringFromDate:date];
}

+(NSString*) getMonth:(NSDate*) date{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM";
    return [formatter stringFromDate:date];
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
    int weekday = [weekdayComponents weekday];
    NSLog(@"%d",weekday);
    return weekday;
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
        
    return range.length;
}

+ (NSString *)filterHtmlTag:(NSString *)originHtmlStr{
    NSString *result = nil;
    NSRange arrowTagStartRange = [originHtmlStr rangeOfString:@"<"];
    if (arrowTagStartRange.location != NSNotFound) { //如果找到
        NSRange arrowTagEndRange = [originHtmlStr rangeOfString:@">"];
        //        NSLog(@"start-> %d   end-> %d", arrowTagStartRange.location, arrowTagEndRange.location);
        //        NSString *arrowSubString = [originHtmlStr substringWithRange:NSMakeRange(arrowTagStartRange.location, arrowTagEndRange.location - arrowTagStartRange.location)];
        result = [originHtmlStr stringByReplacingCharactersInRange:NSMakeRange(arrowTagStartRange.location, arrowTagEndRange.location - arrowTagStartRange.location + 1) withString:@""];
        // NSLog(@"Result--->%@", result);
        return [self filterHtmlTag:result];    //递归，过滤下一个标签
    }else{
        result = [originHtmlStr stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];  // 过滤&nbsp等标签
        //result = [originHtmlStr stringByReplacingOccurrencesOf  ........
    }
    return result;
}

+(NSString*) UnicodeToISO88591:(NSString *)src{
    return [[NSString alloc] initWithCString:[src UTF8String] encoding:NSISOLatin1StringEncoding];
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
    NSLog(@"weekday:%d",weekday);
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
    return [Util compareCurrentTime:date];
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


+ (NSString*) filterSpaceAndEnter:(NSString *)originStr{
    if(originStr == nil){
        return @"";
    }
    originStr = [originStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    originStr = [originStr stringByReplacingOccurrencesOfString:@"  " withString:@""];
    
    return [originStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
}

+(void) playSound:(NSString *)path{
    NSURL* fileURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:path ofType:nil]];
    SystemSoundID soundId;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileURL, &soundId);
    AudioServicesPlaySystemSound(soundId);
}

+ (BOOL)isPureInt:(NSString *)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    int val;
    
    return [scan scanInt:&val] && [scan isAtEnd];
    
}

+ (NSString*) makeImgUrl:(NSString*) imgUrl{
    if([Util isNull:imgUrl]){
        return @"";
    }
    if([imgUrl rangeOfString:@"http://"].location != NSNotFound){
        return imgUrl;
    }
    
    return [NSString stringWithFormat:@"%@%@",IMG_HOST,imgUrl];
}

+ (NSString*) makeErrorMsg:(NSString*) jsonDic{
    NSString* code = [jsonDic valueForKey:@"code"];
    if([API_RESP_SYS_ERROR isEqualToString:code]){
        NSLog(@"远程服务器系统异常:%@",[jsonDic valueForKey:@"msg"]);
        return API_MSG_SYS_ERROR;
    }
    return [Util isNull:[jsonDic valueForKey:@"msg"]]?API_MSG_SYS_ERROR:[jsonDic valueForKey:@"msg"];
}

+(BOOL) isMobileNumber:(NSString*) str{
    //NSString *regex = @"^((13[0-9])|(14[5,7])|(17[^4,\\D])|(15[^4,\\D])|(18[0-9]))\\d{8}$";
    NSString *regex = @"1[3|5|7|8|][0-9]{9}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:str];
}

+(BOOL) isMoneyNumber:(NSString*) str{
    NSString* regex = @"^([0-9]+|[0-9]{0,9}\\.[0-9]{1,2})$";
    
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:str];
}

+(NSString*) getMoneyStr:(NSNumber*)moneyValue{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = kCFNumberFormatterCurrencyStyle;
    //[numberFormatter setPositiveFormat:@"###,##0.00;"];
    NSString *formattedNumberString = [numberFormatter stringFromNumber:moneyValue];
    NSLog(@"formattedNumberString:%@", formattedNumberString);
    return [NSString stringWithFormat:@"￥%@",[formattedNumberString substringFromIndex:1]];
}
+(NSString*) getMoneyStrNoDoll:(NSNumber*)moneyValue digits:(int)digits{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];

    numberFormatter.numberStyle = kCFNumberFormatterCurrencyStyle;
    //[numberFormatter setPositiveFormat:@"###,##0.00;"];
   
    [numberFormatter setMinimumFractionDigits:digits];
    [numberFormatter setMaximumFractionDigits:digits];

    NSString *formattedNumberString = [numberFormatter stringFromNumber:moneyValue];
    formattedNumberString = [NSString stringWithFormat:@"%@",[formattedNumberString substringFromIndex:1]];

    return [formattedNumberString stringByReplacingOccurrencesOfString:@" " withString:@""];
}

+(NSString*) makeMoneyStrWithStrDoll: (NSString*) str digits:(int)digits backStr:(NSString*) backStr{
    NSNumber* moneyValue;
    int a = 1;
    if([str doubleValue] < 0){
        moneyValue = [NSNumber numberWithDouble:[str doubleValue]*-1];
    }else{
        moneyValue = [NSNumber numberWithDouble:[str doubleValue]];
    }
    NSString * price = [Util getMoneyStrNoDoll:moneyValue digits:digits];
    if([str doubleValue] < 0){
        price = [NSString stringWithFormat:@"￥%@%@", @"-", price];
    }
    if(backStr != nil){
        return [NSString stringWithFormat:@"￥%@%@",price, backStr];
    }else{
        return [NSString stringWithFormat:@"￥%@",price];
    }
}


+(NSString*) makeMoneyStrWithStrNoDoll: (NSString*) str digits:(int)digits backStr:(NSString*) backStr{
    NSNumber* moneyValue;
    int a = 1;
    if([str doubleValue] < 0){
        moneyValue = [NSNumber numberWithDouble:[str doubleValue]*-1];
    }else{
        moneyValue = [NSNumber numberWithDouble:[str doubleValue]];
    }
    NSString * price = [Util getMoneyStrNoDoll:moneyValue digits:digits];
    if([str doubleValue] < 0){
        price = [NSString stringWithFormat:@"%@%@", @"-", price];
    }
    if(backStr != nil){
        return [NSString stringWithFormat:@"%@%@",price, backStr];
    }else{
        return [NSString stringWithFormat:@"%@",price];
    }
    
}

+(NSString*) dealPrice:(NSString*) priceStr digits:(int)digits{
    double priceDouble = [priceStr doubleValue];
    priceDouble = priceDouble/1000;
    if(priceDouble < 0){
        //priceDouble = 0;
    }
    return [Util makeMoneyStrWithStrNoDoll:[NSString stringWithFormat:@"%f",priceDouble] digits:digits backStr:@"千元"];
}

+(NSString*) dealPriceNoUnit:(NSString*) priceStr digits:(int)digits{
    double priceDouble = [priceStr doubleValue];
    priceDouble = priceDouble/1000;
    if(priceDouble < 0){
        //priceDouble = 0;
    }
    return [Util makeMoneyStrWithStrNoDoll:[NSString stringWithFormat:@"%f",priceDouble] digits:digits backStr:nil];
}

+(NSString*) dealCustCount:(NSString*) priceStr digits:(int)digits{
    double priceDouble = [priceStr doubleValue];
    priceDouble = priceDouble/1000;
    if(priceDouble < 0){
        priceDouble = 0;
    }
    return [Util makeMoneyStrWithStrNoDoll:[NSString stringWithFormat:@"%f",priceDouble] digits:digits backStr:@"千笔"];
}

+(NSString*) dealCustCountNoUnit:(NSString*) priceStr digits:(int)digits{
    double priceDouble = [priceStr doubleValue];
    priceDouble = priceDouble/1000;
    if(priceDouble < 0){
        priceDouble = 0;
    }
    return [Util makeMoneyStrWithStrNoDoll:[NSString stringWithFormat:@"%f",priceDouble] digits:digits backStr:nil];

}

+(NSString*) makeMoneyStrWithStr: (NSString*) str backStr:(NSString*) backStr{
    
    NSString * price = [Util getMoneyStr:[NSNumber numberWithFloat:[str floatValue]]];
    if(backStr != nil){
        return [NSString stringWithFormat:@"%@%@",price, backStr];
    }else{
        return [NSString stringWithFormat:@"%@",price];
    }
    
}
+(NSDictionary *)nullDic:(NSDictionary *)myDic
{
    NSArray *keyArr = [myDic allKeys];
    NSMutableDictionary *resDic = [[NSMutableDictionary alloc]init];
    for (int i = 0; i < keyArr.count; i ++)
    {
        id obj = [myDic objectForKey:keyArr[i]];
        
        obj = [self changeType:obj];
        
        [resDic setObject:obj forKey:keyArr[i]];
    }
    return resDic;
}
+(id)changeType:(id)myObj
{
//    if([myObj isKindOfClass:[NSString class]])
//    {
//        return @"";
//    }
//    if ([myObj isKindOfClass:[NSDictionary class]])
//    {
//        return [self nullDic:myObj];
//    }
//    else if([myObj isKindOfClass:[NSArray class]])
//    {
//        return [self nullArr:myObj];
//    }
//    else if([myObj isKindOfClass:[NSString class]])
//    {
//        return [self stringToString:myObj];
//    }
    if([myObj isKindOfClass:[NSNull class]])
    {
        return @"";
    }
    else
    {
        return myObj;
    }
}

+(BOOL) isNull:(NSObject *) object{
    if(object == nil || [object isEqual:[NSNull null]] || [object  isEqual: @""]){
        return YES;
    }else{
        return NO;
    }
}

+(NSString *)isNil:(NSString *)str
{
    if(str == nil || [str isEqual:[NSNull null]] || [str  isEqual: @""]){
        return @"";
    }else {
        return str;
    }
    
}

+ (BOOL)isPureNumandCharacters:(NSString *)string
{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(string.length > 0)
    {
        return NO;
    }
    return YES;
}

+(BOOL)isContainsEmoji:(NSString *)string {
    
    
    
    __block BOOL isEomji = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         const unichar hs = [substring characterAtIndex:0];
         
         // surrogate pair
         
         if (0xd800 <= hs && hs <= 0xdbff) {
             
             if (substring.length > 1) {
                 
                 const unichar ls = [substring characterAtIndex:1];
                 
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     
                     isEomji = YES;
                     
                 }
                 
             }
             
         } else if (substring.length > 1) {
             
             const unichar ls = [substring characterAtIndex:1];
             
             if (ls == 0x20e3) {
                 
                 isEomji = YES;
                 
             }
             
             
             
         } else {
             
             // non surrogate
             
             if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                 
                 isEomji = YES;
                 
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 
                 isEomji = YES;
                 
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 
                 isEomji = YES;
                 
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 
                 isEomji = YES;
                 
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
                 
                 isEomji = YES;
                 
             }
             
         }
         
     }];
    
    return isEomji;
    
}

+(NSString*) formartBankStr : (NSString *) inStr addStr:(NSString*)addStr  cutLength:(int)length{
    
    NSString* retStr = [[NSString alloc] init];
    while([inStr length] > 0) {
        if ([inStr length] <= length) {
            retStr = [retStr stringByAppendingString:inStr];
            break;
        }
        int index = length;
        NSString *subStr = [inStr substringToIndex:index];
        inStr = [inStr substringFromIndex:index];

        retStr = [retStr stringByAppendingString:subStr];
        retStr = [retStr stringByAppendingString: addStr];
    }
    
    return retStr;
}

+(NSString*) stringForKey:(NSDictionary*) dic key:(NSString*) key{
    return [Util noNilString:[dic valueForKey:key]];
}
//将大额转为较小额的数目
+(NSString*) makeNumShort:(NSString*) num{
    if([num intValue] < 10000){
        return num;
    }else if([num intValue] < 100000000){
        return [NSString stringWithFormat:@"%.1f万",[num floatValue]/10000];
    }else{
        return [NSString stringWithFormat:@"%.1f亿",[num floatValue]/10000000];
    }
}

//将大额金额转为较小额的数目
+(NSString*) makeMoneyShort:(NSString*) money{
    float m = [money floatValue];
    
    if(m < 10000){
        return [NSString stringWithFormat:@"%d",(int)m ];
    }else if(m < 100000000){
        return [NSString stringWithFormat:@"%.0f万",m/10000];
    }else{
        return [NSString stringWithFormat:@"%.1f亿",m/10000000];
    }
}

+(NSString*) appVersion{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *build = [infoDictionary objectForKey:@"CFBundleVersion"];
    return version;
}

+(NSString*) noNilString:(NSString*) str{
    if([Util isNull:str]){
        return @"";
    }
    return str;
}

+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ]; 
}

+(NSMutableAttributedString*) getQianY:(UIFont*) size1{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"销售净额(千元)"];
    //    [str addAttribute:NSForegroundColorAttributeName value:DEFAULT_MAIN_TEXT_COLOR range:NSMakeRange(3,4)];
    [str addAttribute:NSFontAttributeName value:size1 range:NSMakeRange(4,4)];
    return str;
}

+(NSMutableAttributedString*) getAttrFont:(NSString*) str begin:(int) begin end:(int)length font:(UIFont*) size1{
    NSMutableAttributedString *strAttr = [[NSMutableAttributedString alloc] initWithString:str];

    [strAttr addAttribute:NSFontAttributeName value:size1 range:NSMakeRange(begin,length)];
    return strAttr;
}

+(void)reloadLoaclNotification{
    UIApplication *app = [UIApplication sharedApplication];
    
    [app cancelAllLocalNotifications];
}

//利用正则表达式验证
+(BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+(NSString*) jsonToString:(NSDictionary*) dict{
    NSError* error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    if(error){
        return nil;
    }
    return[[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
}

+(NSString*) makeSn{
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    NSDate* date = [[NSDate alloc] init];
    
    return [Util md5:[formatter stringFromDate:date]];
}

+(BOOL) judgeSuccess:(id) data showError:(BOOL) showError{
    
    
    if([[data valueForKey:@"success"] intValue] != 1){
        if(showError && [data valueForKey:@"info"]){
            [SVProgressHUD showErrorWithStatus:[data valueForKey:@"info"]];
        }
        return NO;
    }
    return YES;
}

+(BOOL) judgeSuccess:(id) data showError:(BOOL) showError param:(id)param delegate:(id) delegate{
    
    if([[data valueForKey:@"success"] intValue] != 1){
//        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//        pasteboard.string = [NSString stringWithFormat:@"请求参数:%@", param];
        if(showError && [data valueForKey:@"info"]){
            if([[data valueForKey:@"errorcode"] intValue ] != 104  && [[data valueForKey:@"errorcode"] intValue ] != 41){
                [SVProgressHUD showErrorWithStatus:[data valueForKey:@"info"]];
            }else{
                [SVProgressHUD showErrorWithStatus:@"投标需绑定账户，请至网页www.zhujc.com进行操作" duration:3];
            }
        }
        
        return NO;
    }
    return YES;
}


+(NSMutableAttributedString*) getAttrColor:(NSString*) str begin:(int) begin end:(int)length color:(UIColor*) color{
    NSMutableAttributedString *strAttr = [[NSMutableAttributedString alloc] initWithString:str];
    
    [strAttr addAttribute:NSForegroundColorAttributeName  value:color range:NSMakeRange(begin,length)];
    return strAttr;
}
+(CGFloat) getMinY:(NSArray*) data1 array2:(NSArray*) data2 {
    float minY = [[data1 objectAtIndex:0] floatValue];
    for(int i = 0;i< [data1 count];i++){
        float val = [[data1 objectAtIndex:i]  floatValue];
        if(val < minY){
            minY = val;
        }
    }
    for(int i = 0;i< [data2 count];i++){
        float val = [[data2 objectAtIndex:i] floatValue];
        if(val < minY){
            minY = val;
        }
    }
    
    return minY;
}

+(CGFloat) getMaxY:(NSArray*) data1 array2:(NSArray*) data2{
    float maxY = [[data1 objectAtIndex:0] floatValue];
    for(int i = 0;i< [data1 count];i++){
        float val = [[data1 objectAtIndex:i] floatValue];
        if(val > maxY){
            maxY = val;
        }
    }
    for(int i = 0;i< [data2 count];i++){
        float val = [[data2 objectAtIndex:i] floatValue];
        if(val > maxY){
            maxY = val;
        }
    }
    return maxY;
}

+(BOOL) isFirstLuanch{
    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* value = [userDefaults valueForKey:@"installed"];
    if([Util isNull:value]){
        [userDefaults setValue:@"Y" forKey:@"installed"];
        [userDefaults synchronize];
        return YES;
    }
    return NO;
}

+(NSString*) makeUrlParamStr:(NSDictionary*) dic{
    if(dic == NULL || dic.allKeys.count == 0){
        return @"";
    }
    NSMutableString* retStr = [[NSMutableString alloc] init];
    [retStr appendString: @"?"];
    for(NSString* key in dic.allKeys){
        [retStr appendString:key];
        [retStr appendString:@"="];
        [retStr appendString:[dic valueForKey:key]];
        [retStr appendString:@"&"];
    }
    return retStr;
}

//分析参数
+(NSDictionary*) getRequestUrlParam:(NSString*) requestUrl {
    NSArray* arr = [requestUrl componentsSeparatedByString:@"?"];
    if(arr.count > 2 || arr.count == 0){
        return nil;
    }
    arr =[arr[1] componentsSeparatedByString:@"&"];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    for(NSString* str in arr){
        arr =[str componentsSeparatedByString:@"="];
        if(arr.count != 2){
            continue;
        }
        dic[arr[0]] = arr[1];
    }
    
    return dic;
}

+(NSString*) makeRequestUrl:(NSString*) requestUrl tp:(NSString*) tpStr{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    long long int date = (long long int)time;
    
    NSString *strRandom = @"";
    
    for(int i=0; i<6; i++){
        int numbera = arc4random_uniform(1000000);
        strRandom = [ strRandom stringByAppendingFormat:@"%i",(numbera % 9)];
    }
    NSLog(@"%d",strRandom);
    NSString *dateStr   =[NSString stringWithFormat:@"%lld",date];
    NSString *suijiStr  =strRandom;
    
    NSString *str=[SNObjt initSN1_SN6:dateStr :suijiStr :tpStr];
    
    NSString *string=[NSString stringWithFormat:@"%@?%@=%@&%@=%@&%@=%@&%@=%@",requestUrl,@"tp",tpStr,@"timestamp",dateStr,@"nonce",suijiStr,@"sn",str];
    return string;

}

+(NSURL *)makeUIImageViewUrlWithString:(NSString *)string {
    
    NSString * temp = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return [NSURL URLWithString:temp];
}

//sha1加密方式
+ (NSString *)getSha1String:(NSString *)srcString{
    const char *cstr = [srcString cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:srcString.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* result = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH *2];
    
    for(int i =0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    
    return result;
}

@end
