//
//  SmartCacheMgr.m
//  SurfingShare
//
//  Created by Hwang Kunee on 13-7-15.
//  Copyright (c) 2013年 Hwang Kunee. All rights reserved.
//

#import "CacheMgr.h"

@implementation CacheMgr

static NSDateFormatter *dateFormatter = nil;
+ (void)removeFromDiskAll{//清空全部
    NSFileManager *filemgr;
    
    filemgr = [NSFileManager defaultManager];
    
    if ([filemgr removeItemAtPath: [CacheMgr getCachePath:@""] error: NULL]  == YES)
        NSLog (@"Remove successful");
    else
        NSLog (@"Remove failed");
    [filemgr createDirectoryAtPath: [CacheMgr getCachePath:@""] withIntermediateDirectories:NO attributes:nil error:nil];
    
}

+ (void)removeFromDisk:(NSString*) key{
    NSString* dateFile = [CacheMgr getCachePath:[NSString stringWithFormat:@"%@_date",key]];
    [[NSFileManager defaultManager] removeItemAtPath:dateFile error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:[CacheMgr getCachePath:key] error:nil];
}

+ (void) saveToDisk:(NSObject*) value key:(NSString*) key{
    if(value != nil){
        if([value isKindOfClass:[NSArray class]]){
            [(NSArray*)value writeToFile:[CacheMgr getCachePath:key] atomically:YES];
        }else if([value isKindOfClass:[NSDictionary class]]){
            [(NSDictionary*)value writeToFile:[CacheMgr getCachePath:key] atomically:YES];
        }else if([value isKindOfClass:[NSData class]]){
            [(NSData*)value writeToFile:[CacheMgr getCachePath:key] atomically:YES];
        }else if([value isKindOfClass:[NSString class]]){
            [(NSString*)value writeToFile:[CacheMgr getCachePath:key] atomically:YES encoding:NSUTF8StringEncoding error:nil];
        }else{
            NSException *e = [NSException
                              exceptionWithName:@"class support error"
                              reason: [@"Cache class not support:" stringByAppendingFormat:@"%@",[value class]]
                              userInfo: nil];
            @throw e;
        }
    }
}
+ (void)saveToDisk:(NSObject*) value key:(NSString*) key second:(int) second{
    if(value != nil){
        [self saveToDisk:value key:key];
        if(second == 0){
            return;
        }
        //保存到更新时间
        if(dateFormatter == nil){
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        }
        NSDate* date = [[NSDate alloc] init];
        date = [date dateByAddingTimeInterval:second];
        [[dateFormatter stringFromDate:date] writeToFile:[CacheMgr getCachePath:[NSString stringWithFormat:@"%@_date",key]] atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}

+ (NSObject*) readFromDisk:(NSString*) key clazz:(Class) clazz{
    if(dateFormatter == nil){
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    NSString* dateFile = [CacheMgr getCachePath:[NSString stringWithFormat:@"%@_date",key]];
    NSString* dateStr = [NSString stringWithContentsOfFile:dateFile encoding:NSUTF8StringEncoding error:nil];
    if(dateStr != nil && [[dateFormatter dateFromString:dateStr] compare:[[NSDate alloc] init]] == NSOrderedAscending)
    {
        //已过期
        [CacheMgr removeFromDisk:key];
        return nil;
    }
    if([clazz isSubclassOfClass:[NSArray class]]){
        return [NSArray arrayWithContentsOfFile:[CacheMgr getCachePath:key]];
    }else if([clazz isSubclassOfClass:[NSDictionary class]]){
        return [NSDictionary dictionaryWithContentsOfFile:[CacheMgr getCachePath:key]];
    }else if([clazz isSubclassOfClass:[NSString class]]){
        return [NSString stringWithContentsOfFile:[CacheMgr getCachePath:key] encoding:NSUTF8StringEncoding error:nil];
    }else if([clazz isSubclassOfClass:[NSData class]]){
        return [NSData dataWithContentsOfFile:[CacheMgr getCachePath:key]];
    }else{
        NSException *e = [NSException
                          exceptionWithName:@"class support error"
                          reason: [@"Cache class not support:" stringByAppendingFormat:@"%@",clazz]
                          userInfo: nil];
        @throw e;
    }
}

+ (NSString*) getCachePath:(NSString*) key{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingPathComponent:key];
}

@end
