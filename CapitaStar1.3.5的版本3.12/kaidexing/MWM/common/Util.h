//
//  Util.h
//  SurfingShare
//
//  Created by Hwang Kunee on 13-6-27.
//  Copyright (c) 2013年 Hwang Kunee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "Const.h"
#import <CommonCrypto/CommonDigest.h> 


@interface Util : NSObject
+ (NSDictionary*) logConfigDicFromPlist:(NSString*)name;

+ (NSDictionary* ) logInitConfig;
//计算积分
+(void) markScore:(NSString*) type;

+(NSDate*) getTheFirstDayOfMon:(NSDate*) date;

+(int) getWeekDay:(NSDate*) date;
+(NSString*) getDayOfMonth:(NSDate*) date;
+(NSString*) getMonth:(NSDate*) date;

+(int) getNumberOfDaysOneMonth:(NSDate*)date;

+ (NSString *)filterHtmlTag:(NSString *)originHtmlStr;

+ (NSString*) filterSpaceAndEnter:(NSString *)originStr;

+ (void)playSound:(NSString*) path;

+ (BOOL)isPureInt:(NSString *)string;

+ (BOOL)isCurrentWeek:(NSDate *)date;

+ (NSString *)isTodayOrYesterday:(NSDate *)date;

+ (NSInteger)diffDate:(NSDate *)startDate endDate:(NSDate *)endDate;

+ (NSString*)UnicodeToISO88591:(NSString *)src;

+ (NSString*) makeImgUrl:(NSString*) imgUrl;

+(BOOL) isMobileNumber:(NSString*) str;

+(BOOL) isMoneyNumber:(NSString*) str;

+ (BOOL)isPureNumandCharacters:(NSString *)string;

+(BOOL) judgeSuccess:(id) data showError:(BOOL) showError param:(id)param delegate:(id) delegate;

+ (NSString*) makeErrorMsg:(NSString*) jsonDic;

//将浮点数金额转换成带千分位的字符串
+ (NSString*) getMoneyStr:(NSNumber*) moneyValue;

+(NSString*) getMoneyStrNoDoll:(NSNumber*)moneyValue digits:(int)digits;

+(NSString*) makeMoneyStrWithStrDoll: (NSString*) str digits:(int)digits backStr:(NSString*) backStr;

+(NSString*) makeMoneyStrWithStrNoDoll: (NSString*) str digits:(int)digits backStr:(NSString*) backStr;

//判断对象是否为空，或者为 null值
+(NSDictionary *)nullDic:(NSDictionary *)myDic;
+(BOOL) isNull:(NSObject*) object;
//判断对象是否为空，是的话传@“”
+(NSString *) isNil:(NSString*)str;

+(NSString*) formartBankStr : (NSString *) inStr addStr:(NSString*)addStr  cutLength:(int)length;

//将大额金额转为较小额的数目
+(NSString*) makeMoneyShort:(NSString*) money;

+(NSString*) makeNumShort:(NSString*) num;

+(BOOL)isContainsEmoji:(NSString *)string;

//强制转换无nil字符串
+(NSString*) noNilString:(NSString*) str;

+(NSString*) stringForKey:(NSDictionary*) dic key:(NSString*) key;

+(NSString*) beautifyTime:(NSString*) timeStr;

+(NSString*) beautifyTime:(NSString*) timeStr onlyDate:(BOOL) onlyDate;

+(NSString*) appVersion;

+ (NSString *)md5:(NSString *)str;

+(NSString*) makeMoneyStrWithStr: (NSString*) str backStr:(NSString*) backStr;

+(void)reloadLoaclNotification;

//利用正则表达式验证
+(BOOL)isValidateEmail:(NSString *)email;

//生成json字符串
+(NSString*) jsonToString:(NSDictionary*) dic;

//生成加密串
+(NSString*) makeSn;

//判断请求是否成功
+(BOOL) judgeSuccess:(id) data showError:(BOOL) showError;
+(NSString*) dealPrice:(NSString*) priceStr digits:(int)digits;

+(NSString*) dealPriceNoUnit:(NSString*) priceStr digits:(int)digits;

+(NSString*) dealCustCountNoUnit:(NSString*) priceStr digits:(int)digits;

+(NSString*) dealCustCount:(NSString*) priceStr digits:(int)digits;

+(NSMutableAttributedString*) getAttrFont:(NSString*) str begin:(int) begin end:(int)length font:(UIFont*) size1;

//设置属性文字颜色
+(NSMutableAttributedString*) getAttrColor:(NSString*) str begin:(int) begin end:(int)length color:(UIColor*) color;
+(NSMutableAttributedString*) getQianY:(UIFont*) size1;

+(NSMutableAttributedString*) getQianYNoJ:(UIFont*) size1;

+(NSMutableAttributedString*) getQianB:(UIFont*) size1;
+(NSMutableAttributedString*) getY:(UIFont*) size1;
+(NSMutableAttributedString*) getYHasJ:(UIFont*) size1;
+(NSMutableAttributedString*) getB:(UIFont*) size1;

+(NSMutableAttributedString*) getCustPrice:(UIFont*) size1;

+(NSMutableAttributedString*) getZhouZ:(UIFont*) size1;

+(NSMutableAttributedString*) getMaoll:(UIFont*) size1;
+(NSMutableAttributedString*) getNLTB:(UIFont*) size1;

+(NSMutableAttributedString*) getMaol:(UIFont*) size1;

+(NSMutableAttributedString*) formartStr:(NSString*) beginStr  backStr:(NSString*) backStr backSize:(UIFont*) size2;

//获取传入时间的小时
+(NSString*) getHour:(NSDate*) date;

+(NSDate*) addDay:(NSDate*) date addDay:(int) addDay;

//获取即时销售的时间
+(NSDate*) getIntimeDate;

+(void) uploadLog:(NSString*) type;


+(CGFloat) getMinY:(NSArray*) data1 array2:(NSArray*) data2 key:(NSString*) key;

+(CGFloat) getMaxY:(NSArray*) data1 array2:(NSArray*) data2 key:(NSString*) key;
+(CGFloat) getMinY:(NSArray*) data1 array2:(NSArray*) data2;

+(CGFloat) getMaxY:(NSArray*) data1 array2:(NSArray*) data2;

//判断应用是否是第一次启动
+(BOOL) isFirstLuanch;

//将DIC 转换成url的参数后缀
+(NSString*) makeUrlParamStr:(NSDictionary*) dic;

//凯德创建请求字符串
+(NSString*) makeRequestUrl:(NSString*) requestUrl tp:(NSString*) tpStr;

+(NSURL *)makeUIImageViewUrlWithString:(NSString *)string;

+ (NSString *)getSha1String:(NSString *)srcString;

+(NSDictionary*) getRequestUrlParam:(NSString*) requestUrl ;

@end
