//
//  Auth.m
//  EasyAR3D
//
//  Created by Qinsi on 9/21/16.
//
//

#import "Auth.h"
#import <CommonCrypto/CommonDigest.h>

@implementation Auth

static NSString *kDate = @"date";
static NSString *kAppKey = @"appKey";
static NSString *kSignature = @"signature";

+ (NSString *)sha1Hex:(NSString *)str {
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];

    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);

    NSMutableString *res = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH*2];
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [res appendFormat:@"%02x", digest[i]];
    }
    return res;
}

+ (NSString *)generateSignature:(NSDictionary *)param withSecret:(NSString *)secret {
    NSArray *keys = [[param allKeys] sortedArrayUsingSelector:@selector(compare:)];

    NSMutableString *paramStr = [NSMutableString new];
    for (NSString *key in keys) {
        [paramStr appendString:key];
        [paramStr appendString:[param objectForKey:key]];
    }

    [paramStr appendString:secret];

    return [Auth sha1Hex:paramStr];
}

+ (NSDictionary *)signParam:(NSDictionary *)param withKey:(NSString *)key andSecret:(NSString *)secret {
    NSMutableDictionary *res = [NSMutableDictionary dictionaryWithDictionary:param];

    NSDateFormatter *df = [NSDateFormatter new];
    df.timeZone = [NSTimeZone timeZoneWithAbbreviation: @"UTC"];
    [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    NSString *dateStr = [df stringFromDate:[NSDate date]];

    [res setObject:dateStr forKey:kDate];
    [res setObject:key forKey:kAppKey];
    [res setObject:[Auth generateSignature:res withSecret:secret] forKey:kSignature];

    return res;
}

@end
