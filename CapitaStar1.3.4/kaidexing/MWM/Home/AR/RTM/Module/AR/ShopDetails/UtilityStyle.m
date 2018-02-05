//
//  Utilities.m
//  RtmapCustomer
//
//  Created by 李凯 on 15/1/16.
//  Copyright (c) 2015年 ZhaoChenHong. All rights reserved.
//
#include <sys/types.h>
#include <sys/sysctl.h>
#import "UtilityStyle.h"
// 设备判断
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size))  : NO)
#define iPhone6P ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)
// 当前屏幕Frame
#define KDEVICE_FRAME [[UIScreen mainScreen] bounds]
#define KDEVICE_WIDTH [[UIScreen mainScreen] bounds].size.width
#define KDEVICE_HEIGH [[UIScreen mainScreen] bounds].size.height
static int const iPhone6Width = 375;
static int const iPhone6Height = 667;
static int const iPhone6PWidth = 414;
static int const iPhone6PHeight = 736;

@implementation UtilityStyle


+(void)cutExtraSeparator:(UITableView *)tableView{
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    tableView.tableFooterView = view;
}

+(void) setTextFieldBorder:(UITextField *)filed
{
    filed.borderStyle=UITextBorderStyleNone;
    filed.layer.masksToBounds=YES;
//    filed.layer.borderColor=[TEXTFILED_BORDER_COLOR CGColor];
//    filed.layer.borderWidth= 1.0f;
//    [filed setValue:PLACEHOLDER_COLOR forKeyPath:@"_placeholderLabel.textColor"];
}
+(void) scaleUIView:(UIView *) view FromDesignModel:(NSString *) model
{
    view.translatesAutoresizingMaskIntoConstraints = YES;
    CGRect frame = view.frame;
    if ([model isEqualToString:@"iPhone6P"]) {
        
        float scaleX = frame.origin.x/iPhone6PWidth;
        float scaleY = frame.origin.y/iPhone6PHeight;
        if(frame.size.width>1){
        double scaleW = frame.size.width/iPhone6PWidth;
        frame.size.width =(KDEVICE_WIDTH*scaleW);
        }
        
        if(frame.size.height>1){
        float scaleH = frame.size.height/iPhone6PHeight;
        frame.size.height = (int)(KDEVICE_HEIGH*scaleH);
        }
       
        frame.origin.x = (KDEVICE_WIDTH *scaleX);
        frame.origin.y = (int)(KDEVICE_HEIGH *scaleY);
        view.frame = frame;
    }
    if ([model isEqualToString:@"iPhone6"]) {
        
        
        if(frame.size.width>1){
        double scaleW = frame.size.width/iPhone6Width;
        frame.size.width =(KDEVICE_WIDTH*scaleW);
        }
        
        if(frame.size.height>1){
        float scaleH = frame.size.height/iPhone6Height;
        frame.size.height = (float)(KDEVICE_HEIGH*scaleH);
        }
        
        float scaleX = frame.origin.x/iPhone6Width;
        float scaleY = frame.origin.y/iPhone6Height;
        frame.origin.x = (KDEVICE_WIDTH *scaleX);
        frame.origin.y = (float)(KDEVICE_HEIGH *scaleY);
        view.frame = frame;
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *) view;
            UIFont * font = label.font;
            CGFloat fontSize = font.pointSize;
            if (iPhone5) {
                fontSize -= 2;
            }
            label.font = [UIFont systemFontOfSize:fontSize];
        }
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *) view;
            UIFont * font = button.titleLabel.font;
            CGFloat fontSize = font.pointSize;
            if (iPhone5) {
                fontSize -= 1;
            }
            button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        }
    }
}
+(NSString *)currentDeviceModel{
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]||[platform isEqualToString:@"iPhone3,2"]||[platform isEqualToString:@"iPhone3,3"])
        return @"iPhone4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone4S";
    if ([platform isEqualToString:@"iPhone5,1"]||[platform isEqualToString:@"iPhone5,2"]||[platform isEqualToString:@"iPhone5,3"]||[platform isEqualToString:@"iPhone5,4"]||[platform isEqualToString:@"iPhone6,1"]||[platform isEqualToString:@"iPhone6,2"])
        return @"iPhone5";
    if ([platform isEqualToString:@"iPhone5,3"]||[platform isEqualToString:@"iPhone5,4"])
    if ([platform isEqualToString:@"iPhone6,1"]||[platform isEqualToString:@"iPhone6,2"])
        
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone6Plus";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone6";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G (A1219/A1337)";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490)";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}

+(BOOL)compareIphoneNumber:(NSString*)iphone {
    if ([iphone length] == 0) {
        
        return NO;
    }
    NSString *regex = @"^1(3|5|7|8|4)\\d{9}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:iphone];
    return YES;
}


+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
        CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
   return image;
}

+ (NSString *)transformDateToTimeStringWithDate:(NSInteger)date WithFormat:(NSString *)formatString{
    NSDate * transDate = [NSDate dateWithTimeIntervalSince1970:(double)date/1000];
    NSDateFormatter * format = [[NSDateFormatter alloc] init];
    format.dateFormat = formatString;
    NSString * timeString = [format stringFromDate:transDate];
    return timeString;
}

+ (NSString *)transformTimeStringFormatWithdateString:(NSString *)dateString WithOriginalFormat:(NSString *)oriFormat  withTargetFormat:(NSString *)tarFormat{
    NSDateFormatter * format = [[NSDateFormatter alloc] init];
    [format setDateFormat:oriFormat];
    NSDate * date = [format dateFromString:dateString];
    [format setDateFormat:tarFormat];
    NSString * targetDateString = [format stringFromDate:date];
    return targetDateString;
}

+ (BOOL)CalculationTimeDifferenceStartTime:(NSString*)startTime {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *flydate = [dateFormatter dateFromString:startTime];
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *d = [cal components:unitFlags  fromDate:flydate toDate:dat options:0];
    NSLog(@"%ld %ld %ld",(long)[d day],(long)[d month],(long)[d year]);
    if([d day]>7 || [d month]>0 || [d year]>0){
        return YES;
    }else {
        return NO;
    }

}


+ (float) calculationDistanceFirstPoint:(CGPoint)point1 secondPoint:(CGPoint)point2 {
    float x = fabs( point1.x-point2.x);
    float y = fabs(fabs(point1.y)-fabs(point2.y));
    float dis = sqrt(x*x+y*y);
    return dis;
}

+(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;

}

+ (void)callPhone:(NSString *)phoneNumber {
    NSString *phoneUrl = [[NSString alloc] initWithFormat:@"telprompt://%@",phoneNumber]; //而这个方法则打电话前先弹框  是否打电话 然后打完电话之后回到程序中 网上说这个方法可能不合法 无法通过审核
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneUrl]]; //拨号
}

@end
