//
//  SPARUtil.m
//  EasyAR3D
//
//  Created by Qinsi on 9/21/16.
//
//

#import "SPARUtil.h"

@implementation SPARUtil

+ (NSString *)getSupportDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    return [paths firstObject];
}

+ (NSError *)ensureDirectory:(NSString *)path {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error;
    [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    return error;
}

+ (bool)pathExists:(NSString *)path {
    NSFileManager *fm = [NSFileManager defaultManager];
    return [fm fileExistsAtPath:path];
}

+ (void)deleteQuietly:(NSString *)path {
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm removeItemAtPath:path error:nil];
}

+ (NSString *)urlEncode:(id)object {
    NSString *str = [NSString stringWithFormat:@"%@", object];
    return [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

+ (NSString *)addQueryParam:(NSDictionary *)params toURL:(NSString *)endPoint {
    NSURLComponents *components = [NSURLComponents componentsWithString:endPoint];
    NSMutableArray *queryItems = [NSMutableArray new];
    for (NSString *key in params) {
        NSString *part = [NSString stringWithFormat:@"%@=%@",
                          [SPARUtil urlEncode:key], [SPARUtil urlEncode:params[key]]];
        [queryItems addObject:part];
    }
    NSString *queryString = [queryItems componentsJoinedByString:@"&"];
    components.query = queryString;
    NSURL *url = components.URL;
    return [url absoluteString];
}

+ (NSDictionary *)jsonFromData:(NSData *)jsonData {
    if (!jsonData) return nil;

    NSError *error;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    if (error) {
        NSLog(@"Error: %@", error);
    }
    return res;
}

+ (NSDictionary *)jsonFromFile:(NSString *)fileName {
    NSData *jsonData = [NSData dataWithContentsOfFile:fileName];
    return [SPARUtil jsonFromData:jsonData];
}

+ (NSDictionary *)jsonFromString:(NSString *)jsonStr {
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    return [SPARUtil jsonFromData:jsonData];
}

+ (NSData *)dataFromJson:(NSDictionary *)dict {
    NSError *error;
    NSData *res = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:&error];
    if (error) {
        NSLog(@"Error: %@", error);
    }
    return res;
}

+ (NSString *)stringFromJson:(NSDictionary *)dict {
    NSData *data = [SPARUtil dataFromJson:dict];
    if (!data) return nil;
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

+ (void)writeToFile:(NSString *)fileName fromJson:(NSDictionary *)dict {
    NSData *data = [SPARUtil dataFromJson:dict];
    if (!data) return;
    [data writeToFile:fileName atomically:YES];
}

@end
